# SOLUCIÓN: Práctica Seguridad LAN 2025

## Información del Examen

| Campo | Valor |
|-------|-------|
| **Asignatura** | Seguridad en las Redes |
| **Máster** | Seguridad Informática |
| **Universidad** | Escuela Politécnica Superior de Jaén |
| **Tipo** | Práctica de laboratorio (Ataque + Defensa) |

---

## Topología de Red

```
                         ┌─────────────────┐
                         │    INTERNET     │
                         └────────┬────────┘
                                  │
                         ┌────────▼────────┐
                         │     ROUTER      │
                         │  192.168.88.1   │
                         │  User: admin    │
                         │  Pass: (vacío)  │
                         └────────┬────────┘
                                  │
                         ┌────────▼────────┐
                         │     SWITCH      │
                         │  192.168.88.XX  │
                         │  User: cisco25  │
                         │  Pass: cisco.25 │
                         └───┬─────────┬───┘
                             │         │
                    ┌────────▼───┐ ┌───▼────────────┐
                    │ PC LINUX/  │ │ PC WINDOWS/    │
                    │ macOS      │ │ macOS          │
                    │ (Atacante) │ │ (Víctima)      │
                    │192.168.88.X│ │ 192.168.88.X   │
                    │  Ettercap  │ │                │
                    └────────────┘ └────────────────┘
```

---

## FASE 0: Configuración Inicial

### Paso 0.1: Reiniciar equipos

1. **Reiniciar Router** (botón reset o desde interfaz)
2. **Reiniciar Switch** (botón reset o desde interfaz)

### Paso 0.2: Iniciar los PCs

- **PC Víctima (Windows/macOS):** Para gestión del router y switch
- **PC Atacante (Linux/macOS):** Para ejecutar ataques con Ettercap

### Paso 0.3: Verificar conectividad

**En PC Víctima (Windows):**
```cmd
ipconfig
ping 192.168.88.1
```

**En PC Víctima (macOS):**
```bash
ifconfig en0
ping 192.168.88.1
```

**En PC Atacante (Linux):**
```bash
ip addr show
ping 192.168.88.1
```

**En PC Atacante (macOS):**
```bash
ifconfig en0
ping 192.168.88.1
```

---

## FASE 1: Reconocimiento

### Paso 1.1: Acceder al Router (desde PC Víctima)

1. Abrir navegador
2. Ir a: `http://192.168.88.1`
3. Login: `admin` / (sin contraseña)

### Paso 1.2: Escanear red desde el Router

1. Navegar a: **IP → ARP** (ver tabla ARP)
2. Navegar a: **TOOLS → IP Scan**
3. Escanear: `192.168.88.0/24`

**Anotar direcciones descubiertas:**

| Equipo | IP | MAC |
|--------|----|----|
| Router | 192.168.88.1 | `__:__:__:__:__:__` |
| Switch | 192.168.88.__ | `__:__:__:__:__:__` |
| PC Víctima | 192.168.88.__ | `__:__:__:__:__:__` |
| PC Atacante | 192.168.88.__ | `__:__:__:__:__:__` |

**Captura de pantalla:** Tabla IP-ARP del router

### Paso 1.3: Acceder al Switch (desde PC Víctima)

1. Abrir navegador
2. Ir a: `http://192.168.88.XX` (IP del switch descubierta)
3. Crear/configurar usuario:
   - **Usuario:** `cisco25`
   - **Password:** `cisco.25`
4. Poner usuario en **modo avanzado**

### Paso 1.4: Analizar menús del Switch

**Explorar:**
- **IPv4 → DHCP Snooping** (para defensa DHCP)
- **Security** (para defensa ARP)

**Captura de pantalla:** Menús de seguridad del switch

### Paso 1.5: Instalar Ettercap en PC Atacante

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install ettercap-graphical -y
```

**macOS:**
```bash
brew install ettercap
```

**Iniciar Ettercap (ambos sistemas):**
```bash
sudo ettercap -G
```

**Captura de pantalla:** Ettercap abierto

---

## FASE 2: ATAQUE ARP (ARP Poisoning / MITM)

### Paso 2.1: Configurar Ettercap

1. Abrir Ettercap: `ettercap -G`
2. Menú: **Sniff → Unified Sniffing**
3. Seleccionar interfaz de red (ej: `eth0` o `ens33`)

### Paso 2.2: Descubrir hosts

1. Menú: **Hosts → Scan for hosts**
2. Esperar a que termine el escaneo
3. Menú: **Hosts → Hosts list**

**Captura de pantalla:** Lista de hosts descubiertos

### Paso 2.3: Definir objetivos (Targets)

1. Seleccionar **IP del PC Víctima** → Click **Add to Target 1**
2. Seleccionar **IP del Router (192.168.88.1)** → Click **Add to Target 2**

**Verificar:** Menú **Targets → Current Targets**

| Target | IP | Descripción |
|--------|----|----|
| Target 1 | 192.168.88.XX | PC Víctima |
| Target 2 | 192.168.88.1 | Router (gateway) |

### Paso 2.4: Iniciar el ataque ARP

1. Menú: **Mitm → ARP poisoning**
2. Marcar: **Sniff remote connections**
3. Click **OK**
4. Menú: **Start → Start sniffing**

**Salida en Ettercap:**
```
ARP poisoning victims:
 GROUP 1 : 192.168.88.XX (PC Víctima)
 GROUP 2 : 192.168.88.1 (Router)
Starting Unified sniffing...
```

**Captura de pantalla:** Ettercap con ataque ARP activo

### Paso 2.5: Verificar el ataque (desde Router)

1. En el Router: **IP → ARP**
2. Observar que la **MAC del PC Víctima** ahora aparece como la **MAC del PC Atacante**

**Tabla ARP envenenada:**

| IP | MAC | Estado |
|----|-----|--------|
| 192.168.88.XX (Víctima) | `AA:BB:CC:DD:EE:FF` | ← MAC del atacante! |
| 192.168.88.XX (Atacante) | `AA:BB:CC:DD:EE:FF` | MAC real del atacante |

**Captura de pantalla:** Tabla ARP del router mostrando envenenamiento

### Paso 2.6: Analizar conexiones en Ettercap

1. En Ettercap: **View → Connections**
2. Observar el tráfico interceptado entre PC Víctima y Router

**Captura de pantalla:** Conexiones capturadas en Ettercap

### Paso 2.7: Detener el ataque

1. Menú: **Mitm → Stop mitm attack(s)**
2. Menú: **Start → Stop sniffing**

---

## FASE 3: DEFENSA ARP (ARP Inspection)

### Paso 3.1: Acceder al Switch

1. Navegador: `http://192.168.88.XX`
2. Login: `cisco25` / `cisco.25`

### Paso 3.2: Habilitar ARP Inspection

**Ruta:** Security → ARP Inspection → Properties

1. **ARP Inspection Status:** Enable ✅
2. Click **Apply**

**Captura de pantalla:** ARP Inspection habilitado

### Paso 3.3: Configurar ARP Packet Validation

**Ruta:** Security → ARP Inspection → Properties

1. Marcar validaciones:
   - [x] **Source MAC**
   - [x] **Destination MAC**
   - [x] **IP Address**
2. Click **Apply**

### Paso 3.4: Configurar puertos de confianza (Trusted)

**Ruta:** Security → ARP Inspection → Interface Settings

| Puerto | Trusted | Descripción |
|--------|---------|-------------|
| Puerto del Router | ✅ Sí | Tráfico legítimo |
| Puerto PC Víctima | ❌ No | Usuario normal |
| Puerto PC Atacante | ❌ No | Posible atacante |

1. Seleccionar puerto del Router
2. Marcar como **Trusted**
3. Click **Apply**

**Captura de pantalla:** Configuración de puertos trusted/untrusted

### Paso 3.5: Configurar reglas ARP Access Control (IP-MAC)

**Ruta:** Security → ARP Inspection → ARP Access Control

Añadir reglas estáticas para equipos conocidos:

| IP | MAC | Acción |
|----|-----|--------|
| 192.168.88.1 | `MAC_real_router` | Permit |
| 192.168.88.XX | `MAC_real_victima` | Permit |

1. Click **Add**
2. Introducir IP y MAC del router
3. Click **Apply**
4. Repetir para PC Víctima

### Paso 3.6: Activar ARP Inspection en VLAN 1

**Ruta:** Security → ARP Inspection → VLAN Settings

1. Seleccionar **VLAN 1**
2. Marcar **ARP Inspection:** Enable
3. Click **Apply**

**Captura de pantalla:** VLAN 1 con ARP Inspection activo

### Paso 3.7: Verificar que la defensa funciona

**Repetir el ataque ARP desde Linux:**

```bash
ettercap -G
# Configurar targets y lanzar ARP poisoning
```

**Resultado esperado:**
- El ataque **NO funciona**
- Los paquetes ARP maliciosos son **descartados** por el switch
- La tabla ARP del router muestra las **MACs correctas**

**Verificar en el switch:**
- **Security → ARP Inspection → Statistics**: Ver paquetes descartados

**Captura de pantalla:** Estadísticas mostrando paquetes ARP bloqueados

---

## FASE 4: ATAQUE DHCP (DHCP Spoofing)

### Paso 4.1: Desactivar las defensas ARP (para probar DHCP)

Temporalmente deshabilitar ARP Inspection para probar el ataque DHCP:
- **Security → ARP Inspection → Properties → Disable**

### Paso 4.2: Configurar ataque DHCP en Ettercap

1. Abrir Ettercap: `sudo ettercap -G`
2. Menú: **Sniff → Unified Sniffing** → Seleccionar interfaz
3. Menú: **Mitm → DHCP Spoofing**
4. Configurar:
   - **IP Pool:** (dejar vacío o poner rango)
   - **Netmask:** `255.255.255.0`
   - **DNS Server IP:** `192.168.88.XX` (IP del PC Atacante)
5. Click **OK**
6. Menú: **Start → Start sniffing**

**Captura de pantalla:** Configuración DHCP Spoofing en Ettercap

### Paso 4.3: Forzar renovación DHCP en PC Víctima

**Windows (CMD como Administrador):**
```cmd
ipconfig /release
ipconfig /renew
```

**macOS (Terminal):**
```bash
sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP
```

### Paso 4.4: Verificar el ataque

**Windows:**
```cmd
ipconfig /all
```

**macOS:**
```bash
ipconfig getpacket en0
```

**Resultado del ataque (si funciona):**
```
Servidor DHCP: 192.168.88.XX      ← IP del atacante!
Puerta de enlace: 192.168.88.XX   ← IP del atacante!
Servidor DNS: 192.168.88.XX       ← IP del atacante!
```

**Verificar en Router:** IP → ARP

**Captura de pantalla:** ipconfig /all mostrando configuración del atacante

### Paso 4.5: Analizar conexiones en Ettercap

**En Ettercap:** View → Connections

El atacante ahora puede ver todo el tráfico porque es el gateway.

**Captura de pantalla:** Conexiones capturadas en Ettercap

### Paso 4.6: Detener el ataque

1. Menú: **Mitm → Stop mitm attack(s)**
2. Renovar IP para obtener configuración del DHCP real:
   - **Windows:** `ipconfig /release` + `ipconfig /renew`
   - **macOS:** `sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP`

---

## FASE 5: DEFENSA DHCP (DHCP Snooping)

### Paso 5.1: Acceder al Switch

1. Navegador: `http://192.168.88.XX`
2. Login: `cisco25` / `cisco.25`

### Paso 5.2: Activar DHCP Snooping

**Ruta:** IPv4 → DHCP Snooping → Properties

1. **DHCP Snooping Status:** Enable ✅
2. Click **Apply**

**Captura de pantalla:** DHCP Snooping habilitado

### Paso 5.3: Configurar DHCP Snooping en VLAN

**Ruta:** IPv4 → DHCP Snooping → VLAN Settings

1. Seleccionar **VLAN 1**
2. **DHCP Snooping:** Enable ✅
3. Click **Apply**

### Paso 5.4: Configurar interfaces de confianza (Trusted)

**Ruta:** IPv4 → DHCP Snooping → Interface Settings

| Puerto | Trusted | Descripción |
|--------|---------|-------------|
| Puerto del Router | ✅ Sí | Servidor DHCP legítimo |
| Puerto PC Víctima | ❌ No | Cliente DHCP |
| Puerto PC Atacante | ❌ No | Posible atacante |

1. Seleccionar puerto donde está conectado el **Router**
2. Marcar como **Trusted**
3. Click **Apply**

**CRÍTICO:** Solo el puerto del servidor DHCP real debe ser Trusted.

**Captura de pantalla:** Configuración de puertos trusted

### Paso 5.5: Ver tabla DHCP Binding Database

**Ruta:** IPv4 → DHCP Snooping → DHCP Snooping Binding Database

Esta tabla muestra las asignaciones DHCP legítimas aprendidas.

**Captura de pantalla:** Binding Database

### Paso 5.6: Verificar que la defensa funciona

**Repetir el ataque DHCP desde Linux:**

```bash
ettercap -G
# Configurar DHCP Spoofing y activar
```

**En PC Víctima (Windows):**
```cmd
ipconfig /release
ipconfig /renew
ipconfig /all
```

**En PC Víctima (macOS):**
```bash
sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP
ipconfig getpacket en0
```

**Resultado esperado:**
- El PC Víctima recibe IP del **Router legítimo** (192.168.88.1)
- **NO** recibe configuración del atacante
- El switch **descarta** los paquetes DHCP del puerto no trusted

**Verificar en el switch:**
- **IPv4 → DHCP Snooping → Statistics**: Ver paquetes descartados

**Captura de pantalla:**
1. ipconfig /all mostrando servidor DHCP correcto
2. Estadísticas del switch mostrando bloqueo

---

## Resumen de Configuración Final

### Router (192.168.88.1)
- Acceso: `http://192.168.88.1`
- Usuario: `admin` / Sin password

### Switch (192.168.88.XX)
- Acceso: `http://192.168.88.XX`
- Usuario: `cisco25` / `cisco.25`

**Defensas configuradas:**

| Defensa | Estado | Ruta |
|---------|--------|------|
| ARP Inspection | ✅ Habilitado | Security → ARP Inspection |
| ARP Packet Validation | ✅ Src MAC, Dst MAC, IP | Security → ARP Inspection → Properties |
| ARP Trusted Ports | Puerto Router | Security → ARP Inspection → Interface Settings |
| ARP Access Control | Reglas IP-MAC | Security → ARP Inspection → ARP Access Control |
| DHCP Snooping | ✅ Habilitado | IPv4 → DHCP Snooping |
| DHCP Trusted Ports | Puerto Router | IPv4 → DHCP Snooping → Interface Settings |

---

## Tabla de Entregables

| Fase | Captura/Evidencia | Descripción |
|------|-------------------|-------------|
| 1 | Tabla IP-ARP Router | IPs y MACs descubiertas |
| 1 | Menús del Switch | DHCP Snooping y Security |
| 2 | Ettercap - Host List | Hosts descubiertos |
| 2 | Ettercap - ARP Attack | Ataque en ejecución |
| 2 | Router IP-ARP | Tabla ARP envenenada |
| 2 | Ettercap - Connections | Tráfico interceptado |
| 3 | Switch - ARP Inspection | Configuración habilitada |
| 3 | Switch - Trusted Ports | Puertos de confianza |
| 3 | Switch - Statistics | Paquetes ARP bloqueados |
| 4 | Ettercap - DHCP Spoofing | Configuración del ataque |
| 4 | Windows ipconfig /all | Config del atacante |
| 5 | Switch - DHCP Snooping | Configuración habilitada |
| 5 | Switch - Binding Database | Asignaciones legítimas |
| 5 | Windows ipconfig /all | Config correcta (defensa OK) |

---

## Comandos Rápidos

### PC Atacante (Linux)

```bash
# Instalar Ettercap
sudo apt-get update
sudo apt-get install ettercap-graphical

# Iniciar Ettercap gráfico
sudo ettercap -G

# Alternativa: Ettercap en terminal
sudo ettercap -T -M arp:remote /192.168.88.1// /192.168.88.XX//
```

### PC Atacante (macOS)

```bash
# Instalar Ettercap
brew install ettercap

# Iniciar Ettercap gráfico
sudo ettercap -G

# Alternativa: Ettercap en terminal
sudo ettercap -T -M arp:remote /192.168.88.1// /192.168.88.XX//

# Ver configuración de red
ifconfig en0

# Ver tabla ARP
arp -a
```

### PC Víctima (Windows)

```cmd
:: Ver configuración de red
ipconfig /all

:: Liberar IP
ipconfig /release

:: Renovar IP
ipconfig /renew

:: Ver tabla ARP
arp -a

:: Limpiar tabla ARP
arp -d *
```

### PC Víctima (macOS)

```bash
# Ver configuración de red
ifconfig en0

# Ver configuración DHCP detallada
ipconfig getpacket en0

# Renovar IP (liberar y obtener nueva)
sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP

# Ver tabla ARP
arp -a

# Limpiar tabla ARP
sudo arp -d -a
```

---

## Troubleshooting

### Ettercap no encuentra hosts
- Verificar que estás en la misma red (192.168.88.0/24)
- Verificar interfaz correcta
- Ejecutar como root: `sudo ettercap -G`

### El ataque ARP no funciona
- Verificar que los targets están bien definidos
- Asegurar que el sniffing está activo
- Comprobar que no hay defensas activas en el switch

### DHCP Spoofing no da IP al atacante
- El servidor DHCP real puede responder más rápido
- Ejecutar `ipconfig /release` antes de iniciar el ataque
- Verificar que DHCP Snooping está deshabilitado

### La defensa no bloquea el ataque
- Verificar que la defensa está habilitada globalmente
- Verificar que está habilitada en VLAN 1
- Comprobar que solo el puerto del Router es Trusted
- Los demás puertos deben ser Untrusted

---

## Navegación

⬅️ [Volver a Prácticas](README.md) | [Índice Wiki](../../INDEX.md)
