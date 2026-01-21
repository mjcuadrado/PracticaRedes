# Práctica 8: Hardening Completo del Switch

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Media-Alta |
| **Equipo** | Cisco SG300-10 |
| **Enfoque** | Securización integral según mejores prácticas |
| **Basada en** | Práctica de Diseño de Infraestructura 2025 + NIST/CIS |

## Objetivo

Implementar un hardening completo del switch Cisco SG300 aplicando todas las medidas de seguridad disponibles: Port Security, DHCP Snooping, ARP Inspection, protección STP, y configuración segura de gestión. Verificar con ataques que todas las defensas funcionan.

---

## Roles del Equipo

| Rol | Responsabilidad |
|-----|-----------------|
| **🔵 DEFENSOR** | Configurar todas las defensas, documentar |
| **🔴 ATACANTE** | Probar cada defensa con ataques reales |

---

## Checklist de Hardening

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHECKLIST DE HARDENING - SG300                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  [ ] 1. GESTIÓN SEGURA                                                       │
│      [ ] Cambiar credenciales por defecto                                    │
│      [ ] Deshabilitar HTTP (solo HTTPS)                                      │
│      [ ] Configurar SSH v2                                                   │
│      [ ] Restringir acceso por IP                                            │
│      [ ] Timeout de sesión                                                   │
│                                                                              │
│  [ ] 2. PROTECCIÓN CAPA 2                                                    │
│      [ ] Port Security en puertos de usuario                                 │
│      [ ] DHCP Snooping habilitado                                            │
│      [ ] Dynamic ARP Inspection (DAI)                                        │
│      [ ] Storm Control                                                       │
│                                                                              │
│  [ ] 3. PROTECCIÓN STP                                                       │
│      [ ] BPDU Guard en puertos de acceso                                     │
│      [ ] Root Guard en puertos trunk                                         │
│                                                                              │
│  [ ] 4. VLANs SEGURAS                                                        │
│      [ ] VLAN nativa diferente a VLAN 1                                      │
│      [ ] Deshabilitar puertos no usados                                      │
│      [ ] Puertos no usados en VLAN aislada                                   │
│                                                                              │
│  [ ] 5. LOGGING Y MONITOREO                                                  │
│      [ ] Syslog habilitado                                                   │
│      [ ] Alertas de violaciones de seguridad                                 │
│                                                                              │
│  [ ] 6. BACKUP Y RECUPERACIÓN                                                │
│      [ ] Configuración guardada                                              │
│      [ ] Backup exportado                                                    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## FASE 1: Gestión Segura (20 minutos)

### 🔵 DEFENSOR: Securizar acceso al switch

#### Paso 1.1: Cambiar credenciales por defecto

**Ruta:** Administration → User Accounts

1. Seleccionar usuario actual
2. Click **Edit**
3. Cambiar contraseña a una segura (mín 12 caracteres, mayúsculas, números, símbolos)
4. Click **Apply**

**Nueva contraseña:** `S3gur1d@d_R3d3s!`

#### Paso 1.2: Deshabilitar HTTP (solo HTTPS)

**Ruta:** Administration → Management Interface → HTTP/HTTPS Service

1. HTTP Service: **Disable**
2. HTTPS Service: **Enable**
3. HTTPS Port: **443**
4. Click **Apply**

#### Paso 1.3: Configurar SSH v2

**Ruta:** Administration → Management Interface → SSH

1. SSH Service: **Enable**
2. SSH Version: **SSH v2 only**
3. SSH Port: **22**
4. Click **Apply**

#### Paso 1.4: Restringir acceso de gestión por IP

**Ruta:** Security → Management Access Method → Access Profile

1. Click **Add**
2. Profile Name: `Admin_Restringido`
3. Click **Apply**

**Ruta:** Security → Management Access Method → Profile Rules

1. Seleccionar perfil `Admin_Restringido`
2. Añadir regla:
   - Action: **Permit**
   - Interface: **All**
   - Source IP: `192.168.10.0` (VLAN Gestión)
   - Mask: `255.255.255.0`
3. Añadir regla final:
   - Action: **Deny**
   - Source IP: `0.0.0.0` (todo lo demás)

#### Paso 1.5: Configurar timeout de sesión

**Ruta:** Administration → Management Interface → Session Timeout

1. Session Timeout: **10** minutos (inactividad)
2. Click **Apply**

**Captura de pantalla:** Configuración de gestión segura

---

## FASE 2: Protección Capa 2 (30 minutos)

### 🔵 DEFENSOR: Configurar defensas L2

#### Paso 2.1: Port Security

**Ruta:** Security → Port Security → Interface Settings

Para cada puerto de usuario (GE2-GE8):
1. Seleccionar puerto
2. Interface Status: **Lock**
3. Learning Mode: **Limited Dynamic Lock**
4. Max Entries: **2**
5. Action on Violation: **Discard and Trap**
6. Click **Apply**

| Puerto | Max MACs | Modo | Acción |
|--------|----------|------|--------|
| GE1 | - | Unlocked | - |
| GE2-GE8 | 2 | Limited Dynamic | Discard+Trap |
| GE9-GE10 | - | Unlocked | - |

#### Paso 2.2: DHCP Snooping

**Ruta:** IP Configuration → DHCP Snooping/Relay → Properties

1. DHCP Snooping Status: **Enable**
2. Click **Apply**

**Ruta:** IP Configuration → DHCP Snooping/Relay → Interface Settings

1. Puerto del servidor DHCP (GE1): **Trusted**
2. Puertos de usuario (GE2-GE8): **Untrusted**
3. Rate Limit: **15** paquetes/segundo
4. Click **Apply**

#### Paso 2.3: Dynamic ARP Inspection (DAI)

**Ruta:** Security → ARP Inspection → Properties

1. ARP Inspection Status: **Enable**
2. Validation:
   - [x] Source MAC
   - [x] Destination MAC
   - [x] IP Address
3. Click **Apply**

**Ruta:** Security → ARP Inspection → Interface Settings

1. Puerto del router (GE1): **Trusted**
2. Puertos de usuario (GE2-GE8): **Untrusted**
3. Click **Apply**

#### Paso 2.4: Storm Control

**Ruta:** Port Management → Storm Control

Para puertos de usuario (GE2-GE8):
1. Seleccionar puerto
2. Broadcast Storm Control: **Enable**
3. Rate Threshold: **1000** paquetes/segundo
4. Multicast Storm Control: **Enable**
5. Click **Apply**

**Captura de pantalla:** Todas las protecciones L2 configuradas

---

## FASE 3: Protección STP (15 minutos)

### 🔵 DEFENSOR: Securizar Spanning Tree

#### Paso 3.1: Habilitar BPDU Guard en puertos de acceso

**Ruta:** Spanning Tree → STP Interface Settings

Para puertos de usuario (GE2-GE8):
1. Seleccionar puerto
2. BPDU Guard: **Enable**
3. Click **Apply**

**Efecto:** Si un puerto de usuario recibe un BPDU (indicando un switch no autorizado), el puerto se desactiva automáticamente.

#### Paso 3.2: Habilitar Root Guard en puertos trunk

**Ruta:** Spanning Tree → STP Interface Settings

Para puertos trunk (GE9-GE10):
1. Seleccionar puerto
2. Root Guard: **Enable**
3. Click **Apply**

**Efecto:** Previene que otro switch se convierta en Root Bridge.

#### Paso 3.3: Configurar el switch como Root Bridge preferido

**Ruta:** Spanning Tree → STP Properties

1. STP State: **Enable**
2. STP Mode: **Rapid PVST**
3. Priority: **4096** (bajo = preferido como root)
4. Click **Apply**

---

## FASE 4: VLANs Seguras (15 minutos)

### 🔵 DEFENSOR: Securizar configuración de VLANs

#### Paso 4.1: Cambiar VLAN nativa en trunks

**Ruta:** VLAN Management → Interface Settings

Para puertos trunk (GE9-GE10):
1. Seleccionar puerto
2. Native VLAN: **999** (VLAN "black hole", sin uso)
3. Click **Apply**

Crear VLAN 999 primero si no existe.

#### Paso 4.2: Deshabilitar puertos no utilizados

**Ruta:** Port Management → Port Settings

Para puertos no utilizados:
1. Seleccionar puerto
2. Administrative Status: **Down**
3. Click **Apply**

#### Paso 4.3: Asignar puertos no usados a VLAN aislada

**Ruta:** VLAN Management → Port to VLAN

1. Crear VLAN 999 (Unused)
2. Asignar todos los puertos deshabilitados a VLAN 999

---

## FASE 5: Logging y Monitoreo (10 minutos)

### 🔵 DEFENSOR: Configurar logging

#### Paso 5.1: Habilitar logging local

**Ruta:** Administration → System Log → Log Settings

1. Logging: **Enable**
2. Log Buffer Size: **Maximum**
3. Click **Apply**

#### Paso 5.2: Configurar servidor Syslog (si hay)

**Ruta:** Administration → System Log → Remote Log Servers

1. Click **Add**
2. Server IP: `[IP del servidor syslog]`
3. Port: **514**
4. Severity: **Warning** y superior
5. Click **Apply**

#### Paso 5.3: Habilitar alertas de seguridad

**Ruta:** Administration → System Log → Log Settings

1. Security Alerts: **Enable**
2. Click **Apply**

---

## FASE 6: Backup y Guardar (10 minutos)

### 🔵 DEFENSOR: Guardar configuración

#### Paso 6.1: Guardar en startup config

**Ruta:** Administration → File Management → Copy/Save Configuration

1. Source: **Running Configuration**
2. Destination: **Startup Configuration**
3. Click **Apply**

#### Paso 6.2: Exportar backup

**Ruta:** Administration → File Management → Download/Backup Config

1. File Type: **Running Configuration**
2. Download Method: **HTTP/HTTPS**
3. Click **Apply**
4. Guardar archivo como `switch_hardened_FECHA.cfg`

---

## FASE 7: Verificación con Ataques (20 minutos)

### 🔴 ATACANTE: Probar cada defensa

#### Prueba 1: Port Security - Exceder MACs

```bash
# Cambiar MAC múltiples veces
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:01
sudo ifconfig en0 up
ping -c 2 192.168.1.1

sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:02
sudo ifconfig en0 up
ping -c 2 192.168.1.1

# Tercera MAC - debería ser bloqueada
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:03
sudo ifconfig en0 up
ping -c 2 192.168.1.1
```

**Resultado esperado:** ❌ Tercera MAC bloqueada, log generado

#### Prueba 2: DHCP Snooping - Servidor DHCP falso

```bash
# Intentar levantar servidor DHCP falso
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.50
```

**Resultado esperado:** ❌ Paquetes DHCP descartados (puerto untrusted)

#### Prueba 3: ARP Inspection - ARP Poisoning

```bash
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.X//
```

**Resultado esperado:** ❌ Paquetes ARP maliciosos descartados

#### Prueba 4: BPDU Guard - Enviar BPDUs

```bash
# Si tienes Yersinia
sudo yersinia stp -attack 0    # Enviar BPDUs
```

**Resultado esperado:** ❌ Puerto se desactiva (err-disable)

### 🔵 DEFENSOR: Verificar logs

**Ruta:** Status and Statistics → View Log → RAM Memory

Buscar entradas de:
- Port Security violations
- DHCP Snooping drops
- ARP Inspection drops
- STP BPDU Guard triggers

**Captura de pantalla:** Logs mostrando todos los ataques bloqueados

---

## FASE 8: Documentación Final (10 minutos)

### Tabla de estado de hardening

| Control | Estado | Verificado | Ataque Probado | Resultado |
|---------|--------|------------|----------------|-----------|
| Credenciales cambiadas | ✅ | ✅ | - | OK |
| Solo HTTPS | ✅ | ✅ | - | OK |
| SSH v2 | ✅ | ✅ | - | OK |
| Acceso restringido por IP | ✅ | ✅ | - | OK |
| Port Security | ✅ | ✅ | MAC flooding | Bloqueado |
| DHCP Snooping | ✅ | ✅ | Rogue DHCP | Bloqueado |
| ARP Inspection | ✅ | ✅ | ARP Poisoning | Bloqueado |
| Storm Control | ✅ | ✅ | - | OK |
| BPDU Guard | ✅ | ✅ | STP Attack | Bloqueado |
| Root Guard | ✅ | ✅ | - | OK |
| VLAN nativa segura | ✅ | ✅ | - | OK |
| Puertos no usados off | ✅ | ✅ | - | OK |
| Logging habilitado | ✅ | ✅ | - | OK |
| Config guardada | ✅ | ✅ | - | OK |
| Backup exportado | ✅ | ✅ | - | OK |

### Mapeo a Frameworks

| Framework | Control | Implementación |
|-----------|---------|----------------|
| **NIST PR.AC-1** | Control de acceso | 802.1X, Port Security |
| **NIST PR.AC-5** | Segmentación | VLANs |
| **NIST PR.DS-2** | Protección de datos | DHCP Snooping, DAI |
| **NIST DE.CM-1** | Monitoreo | Logging, Syslog |
| **CIS Control 1** | Inventario | Port Security, deshabilitar no usados |
| **CIS Control 9** | Puertos/servicios | Solo HTTPS, SSH v2 |
| **CIS Control 11** | Config segura | Hardening completo |

---

## Entregables

### 🔵 DEFENSOR
- [ ] Checklist de hardening completado (todos ✅)
- [ ] Capturas de cada configuración
- [ ] Backup de configuración exportado
- [ ] Logs de ataques bloqueados

### 🔴 ATACANTE
- [ ] Evidencia de cada ataque intentado
- [ ] Confirmación de que cada ataque fue bloqueado
- [ ] Capturas de Wireshark/terminal

### Ambos
- [ ] Tabla de estado de hardening
- [ ] Mapeo a frameworks de seguridad
- [ ] Conclusiones y recomendaciones adicionales

---

## Comandos de Referencia Rápida

```bash
# === ATAQUES PARA PROBAR ===

# Port Security - múltiples MACs
sudo ifconfig en0 ether aa:bb:cc:dd:ee:XX

# DHCP Rogue
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.50

# ARP Poisoning
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.X//

# DHCP Starvation
sudo yersinia dhcp -attack 1

# STP Attack
sudo yersinia stp -attack 0

# === VERIFICACIÓN ===

# Ver tabla ARP
arp -a

# Renovar DHCP
sudo ipconfig set en0 DHCP

# Capturar tráfico
wireshark -k -i en0
```

---

## Navegación

⬅️ [Práctica 7: Control de Acceso 802.1X](practica_07_control_acceso_8021x.md) | [Volver al Índice](README.md)
