# Práctica 5: Rogue DHCP Server (Servidor DHCP Falso)

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Media |
| **Ataque** | DHCP Spoofing (Rogue DHCP Server) |
| **Defensa** | DHCP Snooping con Trusted Ports |
| **Herramientas** | Ettercap o dnsmasq, Wireshark |

## Objetivo

Demostrar cómo un atacante puede desplegar un servidor DHCP falso para convertirse en el gateway de las víctimas (MITM), y cómo DHCP Snooping previene este ataque permitiendo solo servidores DHCP en puertos autorizados.

---

## Roles del Equipo

| Rol | Responsabilidad | Equipo |
|-----|-----------------|--------|
| **🔴 ATACANTE** | Desplegar servidor DHCP falso | PC con Ettercap/dnsmasq |
| **🔵 DEFENSOR** | Configurar DHCP Snooping, actuar como víctima | PC + Switch |

> El defensor también hará de "víctima" para probar que recibe la configuración del servidor correcto.

---

## Conceptos Clave

### ¿Qué es un Rogue DHCP Server?

```
SITUACIÓN NORMAL:
┌────────────┐   DHCP Request    ┌────────────┐
│   Cliente  │ ─────────────────>│   Router   │
│            │ <─────────────────│(DHCP Real) │
└────────────┘   IP: 192.168.1.X └────────────┘
                 GW: 192.168.1.1 (correcto)

ATAQUE ROGUE DHCP:
┌────────────┐   DHCP Request    ┌────────────┐
│   Cliente  │ ─────────────────>│   Router   │ (responde, pero...)
│            │                   └────────────┘
│            │ <─────────────────┌────────────┐
└────────────┘   IP: 192.168.1.X │  Atacante  │ (responde MÁS RÁPIDO)
                 GW: 192.168.1.100│(DHCP Rogue)│
                 ↑                └────────────┘
                 ¡Gateway del atacante!
```

### Impacto del ataque

| Parámetro DHCP | Valor legítimo | Valor malicioso | Consecuencia |
|----------------|----------------|-----------------|--------------|
| Gateway | 192.168.1.1 | IP del atacante | **MITM** - Todo el tráfico pasa por el atacante |
| DNS | 8.8.8.8 | IP del atacante | **DNS Spoofing** - Control de resolución |
| Lease time | 24h | 1min | Renovaciones frecuentes |

---

## Topología

```
                   ┌──────────────────┐
                   │  Router (DHCP)   │
                   │  192.168.1.1     │
                   │  Pool: .100-.200 │
                   └────────┬─────────┘
                            │ GE1 (Trusted)
                   ┌────────┴─────────┐
                   │   Switch SG300   │
                   │   192.168.1.237  │
                   └┬────────┬────────┘
                    │GE2     │GE3
                    │        │
             ┌──────┴────┐ ┌─┴──────────┐
             │🔵DEFENSOR │ │🔴ATACANTE   │
             │(Víctima)  │ │Rogue DHCP  │
             │           │ │192.168.1.50│
             └───────────┘ │Pool: .201+ │
                           └────────────┘
```

---

## FASE 1: Reconocimiento (15 minutos)

### 🔴 ATACANTE: Preparación

#### Paso 1.1: Obtener IP estática

**Importante:** El atacante necesita una IP fija (no DHCP) para poder funcionar como servidor.

```bash
# macOS - Configurar IP estática
sudo ifconfig en0 192.168.1.50 netmask 255.255.255.0

# Linux - Configurar IP estática
sudo ip addr add 192.168.1.50/24 dev eth0
sudo ip link set eth0 up
```

#### Paso 1.2: Verificar conectividad

```bash
ping -c 3 192.168.1.1   # Gateway real
ping -c 3 192.168.1.237 # Switch
```

#### Paso 1.3: Identificar el servidor DHCP legítimo

```bash
# Escanear puerto DHCP
nmap -sU -p 67 192.168.1.1

# Ver tráfico DHCP actual
sudo tcpdump -i en0 -n port 67 or port 68
```

---

### 🔵 DEFENSOR: Verificar estado inicial

#### Paso 1.4: Verificar que DHCP Snooping está DESHABILITADO

1. Accede al switch: `https://192.168.1.237`
2. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**
3. Confirma: **DHCP Snooping Status: Disabled**

**Captura de pantalla:** DHCP Snooping deshabilitado

#### Paso 1.5: Verificar tu configuración DHCP actual

```bash
# macOS - Ver lease DHCP actual
ipconfig getpacket en0

# Linux
cat /var/lib/dhcp/dhclient.leases
```

**Anota:**
- Tu IP actual: `_______________`
- Gateway actual: `_______________`
- DNS actual: `_______________`
- Servidor DHCP: `_______________`

---

## FASE 2: Ataque - Rogue DHCP Server (25 minutos)

### 🔵 DEFENSOR: Preparar captura

#### Paso 2.1: Iniciar Wireshark

```bash
wireshark -k -i en0 -f "port 67 or port 68"
```

Filtro en Wireshark:
```
bootp || dhcp
```

---

### 🔴 ATACANTE: Desplegar servidor DHCP falso

#### Método A: Usando Ettercap (Recomendado)

```bash
# Sintaxis: ettercap -T -M dhcp:IP_POOL/NETMASK/DNS
sudo ettercap -T -M dhcp:192.168.1.201-220/255.255.255.0/192.168.1.50
```

**Explicación:**
- `-T`: Modo texto
- `-M dhcp`: Ataque DHCP
- `192.168.1.201-220`: Pool de IPs a ofrecer (diferente al legítimo para no colisionar)
- `255.255.255.0`: Máscara de red
- `192.168.1.50`: Gateway Y DNS que ofrecerá (¡la IP del atacante!)

**Salida esperada:**
```
DHCP spoofing: starting...
DHCP: [192.168.1.201] offered to aa:bb:cc:dd:ee:ff
DHCP: [192.168.1.202] offered to 11:22:33:44:55:66
```

#### Método B: Usando dnsmasq (Alternativa)

```bash
# Crear archivo de configuración
cat << 'EOF' > /tmp/rogue-dhcp.conf
interface=en0
dhcp-range=192.168.1.201,192.168.1.220,255.255.255.0,1h
dhcp-option=3,192.168.1.50    # Gateway (atacante)
dhcp-option=6,192.168.1.50    # DNS (atacante)
EOF

# Iniciar servidor DHCP falso
sudo dnsmasq -C /tmp/rogue-dhcp.conf -d --log-dhcp
```

---

### 🔵 DEFENSOR: Forzar renovación DHCP

#### Paso 2.2: Liberar y solicitar nueva IP

```bash
# macOS
sudo ipconfig set en0 DHCP

# Linux
sudo dhclient -r eth0    # Liberar
sudo dhclient eth0       # Solicitar nueva
```

#### Paso 2.3: Verificar configuración recibida

```bash
# macOS
ipconfig getpacket en0

# Linux
ip addr show eth0
ip route show
cat /etc/resolv.conf
```

**Resultado posible (ATAQUE EXITOSO):**
```
IP: 192.168.1.201        ← Del rango del atacante
Gateway: 192.168.1.50    ← ¡IP del atacante!
DNS: 192.168.1.50        ← ¡IP del atacante!
```

> **Nota:** El cliente acepta la respuesta DHCP que llegue primero. A veces gana el legítimo, a veces el atacante.

---

### 🔴 ATACANTE: Habilitar IP forwarding

Si el ataque fue exitoso, habilita forwarding para que la víctima tenga conectividad (y poder capturar su tráfico):

```bash
# macOS
sudo sysctl -w net.inet.ip.forwarding=1

# Linux
sudo sysctl -w net.ipv4.ip_forward=1
```

---

### Verificación del ataque

#### En Wireshark

Busca paquetes **DHCP Offer** y compara:

| Campo | Servidor Legítimo | Rogue Server |
|-------|-------------------|--------------|
| Server IP | 192.168.1.1 | 192.168.1.50 |
| Gateway ofrecido | 192.168.1.1 | 192.168.1.50 |
| Pool | .100-.200 | .201-.220 |

**Captura de pantalla:** Dos DHCP Offers diferentes en Wireshark

---

### 🔴 ATACANTE: Detener el ataque

Antes de continuar:

```bash
# Si usas Ettercap: presiona 'q'
# Si usas dnsmasq: Ctrl+C
```

---

## FASE 3: Implementar Defensa (35 minutos)

### 🔵 DEFENSOR: Configurar DHCP Snooping

#### Paso 3.1: Habilitar DHCP Snooping globalmente

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**
2. Marca: **DHCP Snooping Status: Enable**
3. Click **Apply**

#### Paso 3.2: Configurar puerto del router como TRUSTED

**CRÍTICO:** Solo el puerto donde está conectado el servidor DHCP legítimo debe ser Trusted.

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Interface Settings**
2. Selecciona **GE1** (puerto del router)
3. Marca: **Trusted: Yes**
4. Click **Apply**

#### Paso 3.3: Verificar que puertos de usuarios son UNTRUSTED

Los puertos GE2, GE3 (atacante, defensor) deben estar como **Untrusted** (por defecto).

**Tabla de configuración:**

| Puerto | Dispositivo | Trusted | Rate Limit |
|--------|-------------|---------|------------|
| GE1 | Router (DHCP real) | ✅ Sí | Ilimitado |
| GE2 | Defensor | ❌ No | 15 pkt/s |
| GE3 | Atacante | ❌ No | 15 pkt/s |

#### Paso 3.4: Configurar Rate Limiting (opcional pero recomendado)

1. En **Interface Settings**, selecciona GE2 y GE3
2. Configura **DHCP Snooping Rate Limit**: 15
3. Click **Apply**

**Captura de pantalla:** Configuración DHCP Snooping completa

#### Paso 3.5: Guardar configuración

1. Navega a: **Administration → File Management → Copy/Save Configuration**
2. Source: Running Configuration
3. Destination: Startup Configuration
4. Click **Apply**

---

### 🔵 DEFENSOR: Regenerar binding database

#### Paso 3.6: Obtener nueva IP vía DHCP

```bash
# Para que la binding database tenga tu entrada
sudo ipconfig set en0 DHCP    # macOS
sudo dhclient eth0            # Linux
```

#### Paso 3.7: Verificar binding database

1. Navega a: **IP Configuration → DHCP Snooping/Relay → DHCP Snooping Binding Database**
2. Debe aparecer tu MAC y la IP asignada

**Captura de pantalla:** Binding database con tu entrada

---

## FASE 4: Verificar Defensa (20 minutos)

### 🔴 ATACANTE: Re-ejecutar el servidor DHCP falso

#### Paso 4.1: Iniciar Rogue DHCP nuevamente

```bash
sudo ettercap -T -M dhcp:192.168.1.201-220/255.255.255.0/192.168.1.50
```

---

### 🔵 DEFENSOR: Solicitar IP y verificar origen

#### Paso 4.2: Forzar renovación

```bash
sudo ipconfig set en0 DHCP    # macOS
sudo dhclient eth0            # Linux
```

#### Paso 4.3: Verificar que la IP viene del servidor correcto

```bash
ipconfig getpacket en0    # macOS
```

**Resultado esperado (defensa exitosa):**
```
IP: 192.168.1.XXX        ← Del pool del router (.100-.200)
Gateway: 192.168.1.1     ← Router legítimo
DNS: [DNS real]
DHCP Server: 192.168.1.1 ← Router legítimo
```

El servidor DHCP falso NO puede responder porque está en un puerto Untrusted.

---

### 🔵 DEFENSOR: Verificar bloqueo en el switch

#### Paso 4.4: Revisar logs

1. Navega a: **Status and Statistics → View Log → RAM Memory**

**Logs esperados:**
```
DHCP Snooping: DHCP server response dropped on untrusted port GE3
DHCP Snooping: DHCP OFFER dropped, source: 192.168.1.50, port GE3
```

**Captura de pantalla:** Logs de DHCP Snooping bloqueando ofertas

#### Paso 4.5: Ver estadísticas

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Statistics** (si existe)
2. O revisar contadores en **Interface Settings**

---

### En Wireshark

Observa que:
1. El atacante ENVÍA DHCP Offers
2. Pero el cliente SOLO recibe las del servidor legítimo
3. El switch descarta los paquetes del atacante silenciosamente

---

## FASE 5: Documentación (25 minutos)

### 🔴 ATACANTE: Completar plantilla de ataque

```markdown
## Ataque: Rogue DHCP Server

### Información
- **Fecha:** [HOY]
- **Herramienta:** Ettercap / dnsmasq
- **Comando:** `sudo ettercap -T -M dhcp:192.168.1.201-220/255.255.255.0/192.168.1.50`

### Configuración del servidor falso
- IP del atacante: 192.168.1.50
- Pool ofrecido: 192.168.1.201-220
- Gateway falso: 192.168.1.50
- DNS falso: 192.168.1.50

### Resultado SIN defensa
- [x] Ataque exitoso (al menos en algunos intentos)
- Víctima recibió configuración del atacante
- Gateway apuntando a IP del atacante

### Resultado CON defensa
- [x] Ataque bloqueado
- DHCP Offers del atacante descartados
- Víctima recibe configuración del servidor legítimo
```

---

### 🔵 DEFENSOR: Completar plantilla de defensa

```markdown
## Defensa: DHCP Snooping

### Configuración implementada
| Parámetro | Valor |
|-----------|-------|
| DHCP Snooping Global | Habilitado |
| Puerto Trusted | GE1 (Router) |
| Puertos Untrusted | GE2, GE3 |
| Rate Limiting | 15 pkt/s |

### Ruta en el switch
IP Configuration → DHCP Snooping/Relay → Properties

### Binding Database
| MAC | IP | Puerto | VLAN |
|-----|----|----|------|
| [Tu MAC] | 192.168.1.X | GE2 | 1 |

### Efectividad
- Ataque bloqueado: ✅ Sí
- Paquetes DHCP del atacante: Descartados
- Logs generados: ✅ Sí
```

---

### Tabla comparativa

| Aspecto | Sin DHCP Snooping | Con DHCP Snooping |
|---------|-------------------|-------------------|
| Rogue DHCP puede responder | ✅ Sí | ❌ No |
| Víctima recibe config falsa | Posible | Imposible |
| Gateway puede ser suplantado | ✅ Sí | ❌ No |
| DNS puede ser suplantado | ✅ Sí | ❌ No |
| Detección del intento | ❌ No | ✅ Logs |
| Impacto MITM | Alto | Ninguno |

---

### Mapeo NIST Framework

| Función | Acción | Control aplicado |
|---------|--------|------------------|
| **IDENTIFICAR** | Detectar servidor DHCP legítimo | Reconocimiento de red |
| **PROTEGER** | Configurar DHCP Snooping | Trusted/Untrusted ports |
| **DETECTAR** | Revisar logs de intentos | Switch logging |
| **RESPONDER** | Bloqueo automático | DHCP Snooping |
| **RECUPERAR** | Config guardada | Startup Config |

---

## Entregables

### 🔴 ATACANTE
- [ ] Captura: Servidor DHCP falso en ejecución
- [ ] Captura: Wireshark mostrando DHCP Offer del atacante (sin defensa)
- [ ] Captura: Configuración de red de víctima apuntando al atacante
- [ ] Plantilla de ataque completada

### 🔵 DEFENSOR
- [ ] Captura: DHCP Snooping configurado
- [ ] Captura: Puerto trusted configurado
- [ ] Captura: Binding database
- [ ] Captura: Logs de bloqueo
- [ ] Captura: Configuración de red correcta (con defensa)
- [ ] Plantilla de defensa completada

### Ambos
- [ ] Tabla comparativa antes/después
- [ ] Mapeo NIST
- [ ] Wireshark: Comparación de tráfico DHCP con/sin defensa

---

## Troubleshooting

### El servidor DHCP falso no recibe solicitudes
- Verifica que estás en la misma VLAN
- Asegúrate de tener IP estática configurada
- Verifica que la interfaz es correcta en Ettercap

### La víctima siempre recibe IP del servidor legítimo (sin defensa)
- El servidor legítimo responde más rápido
- Intenta ejecutar el ataque ANTES de que la víctima solicite IP
- Prueba con dnsmasq que a veces es más rápido

### No hay logs en el switch
- Verifica que DHCP Snooping está realmente habilitado
- El log puede estar en Flash Memory en lugar de RAM
- Asegúrate de que el atacante está en un puerto Untrusted

### La binding database está vacía
- Los clientes deben renovar DHCP DESPUÉS de habilitar snooping
- Fuerza renovación: `sudo dhclient -r && sudo dhclient`

---

## Comandos de referencia

```bash
# === ATACANTE: IP Estática ===
sudo ifconfig en0 192.168.1.50 netmask 255.255.255.0    # macOS
sudo ip addr add 192.168.1.50/24 dev eth0               # Linux

# === ATACANTE: Rogue DHCP ===
sudo ettercap -T -M dhcp:192.168.1.201-220/255.255.255.0/192.168.1.50

# === ATACANTE: IP Forwarding ===
sudo sysctl -w net.inet.ip.forwarding=1                 # macOS
sudo sysctl -w net.ipv4.ip_forward=1                    # Linux

# === DEFENSOR: Renovar DHCP ===
sudo ipconfig set en0 DHCP                              # macOS
sudo dhclient -r eth0 && sudo dhclient eth0             # Linux

# === DEFENSOR: Ver config DHCP ===
ipconfig getpacket en0                                  # macOS
cat /var/lib/dhcp/dhclient.leases                       # Linux

# === CAPTURA ===
wireshark -k -i en0 -f "port 67 or port 68"
sudo tcpdump -i en0 -n port 67 or port 68
```

---

## Conceptos avanzados (para estudio posterior)

### DHCP Starvation + Rogue DHCP (Combo)

Un atacante sofisticado podría:
1. Primero ejecutar DHCP Starvation para agotar el pool del servidor legítimo
2. Luego desplegar su propio servidor DHCP
3. Todas las nuevas solicitudes irían al servidor falso

**Defensa:** DHCP Snooping + Rate Limiting bloquean ambos ataques.

### DHCP Snooping + DAI (Defensa en profundidad)

- DHCP Snooping protege contra servidores DHCP falsos
- DAI (Dynamic ARP Inspection) usa la binding database de DHCP Snooping
- Juntos protegen contra DHCP Spoofing Y ARP Spoofing

---

## Navegación

⬅️ [Práctica 4: Port Security](practica_04_port_security.md) | [Volver al índice →](../guia_practica.md)
