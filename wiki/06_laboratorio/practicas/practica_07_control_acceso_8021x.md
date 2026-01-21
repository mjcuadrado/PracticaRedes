# Práctica 7: Control de Acceso con 802.1X

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Media-Alta |
| **Equipo** | Cisco SG300-10 + Servidor RADIUS (FreeRADIUS) |
| **Enfoque** | Autenticación de puerto basada en 802.1X |
| **Basada en** | Práctica de Diseño de Infraestructura 2025 |

## Objetivo

Implementar control de acceso a la red mediante 802.1X, donde los usuarios deben autenticarse antes de obtener acceso a la red. Demostrar cómo los dispositivos no autenticados son bloqueados o asignados a una VLAN de cuarentena.

---

## Roles del Equipo

| Rol | Responsabilidad |
|-----|-----------------|
| **🔵 ADMIN RED** | Configurar switch y políticas 802.1X |
| **🔴 ADMIN RADIUS** | Configurar servidor FreeRADIUS, gestionar usuarios |

---

## Arquitectura 802.1X

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          ARQUITECTURA 802.1X                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌───────────────┐        ┌───────────────┐        ┌───────────────┐       │
│   │  SUPLICANTE   │  EAP   │ AUTENTICADOR  │ RADIUS │   SERVIDOR    │       │
│   │   (Cliente)   │◄──────►│   (Switch)    │◄──────►│   RADIUS      │       │
│   │               │        │   SG300       │        │ (FreeRADIUS)  │       │
│   └───────────────┘        └───────────────┘        └───────────────┘       │
│                                                                              │
│   Flujo:                                                                     │
│   1. Cliente conecta → Puerto bloqueado                                     │
│   2. Switch solicita credenciales (EAP)                                     │
│   3. Cliente envía usuario/contraseña                                       │
│   4. Switch reenvía a RADIUS                                                │
│   5. RADIUS valida → Accept/Reject                                          │
│   6. Switch habilita puerto (o asigna VLAN)                                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Escenario del Laboratorio

```
                    ┌─────────────────────┐
                    │   SERVIDOR RADIUS   │
                    │   192.168.1.100     │
                    │   (FreeRADIUS)      │
                    │   Puerto: 1812/1813 │
                    └──────────┬──────────┘
                               │ GE1
                    ┌──────────┴──────────┐
                    │    SWITCH SG300     │
                    │    192.168.1.237    │
                    │                     │
                    │  GE2: 802.1X ON     │
                    │  GE3: 802.1X ON     │
                    │  GE4: 802.1X ON     │
                    └──┬──────┬──────┬────┘
                       │      │      │
                    ┌──▼──┐┌──▼──┐┌──▼──┐
                    │ PC1 ││ PC2 ││ PC3 │
                    │Auth ││NoAuth│Guest│
                    └─────┘└─────┘└─────┘

Usuarios en RADIUS:
- empleado1 / password123 → VLAN 30 (Usuarios)
- admin1 / adminpass → VLAN 10 (Gestión)
- (sin auth) → VLAN 200 (Cuarentena)
```

---

## FASE 1: Configurar Servidor RADIUS (30 minutos)

### 🔴 ADMIN RADIUS: Instalar y configurar FreeRADIUS

#### Paso 1.1: Instalar FreeRADIUS

```bash
# macOS (con Homebrew)
brew install freeradius-server

# Linux (Debian/Ubuntu)
sudo apt update
sudo apt install freeradius freeradius-utils
```

#### Paso 1.2: Configurar clientes RADIUS

Editar `/etc/freeradius/3.0/clients.conf` (Linux) o `/usr/local/etc/raddb/clients.conf` (macOS):

```bash
# Añadir el switch como cliente
client switch_sg300 {
    ipaddr = 192.168.1.237
    secret = radius_secret_2024
    shortname = switch-laboratorio
}
```

#### Paso 1.3: Configurar usuarios

Editar `/etc/freeradius/3.0/users` o `/usr/local/etc/raddb/users`:

```bash
# Usuario empleado - asignar VLAN 30
empleado1   Cleartext-Password := "password123"
            Tunnel-Type = VLAN,
            Tunnel-Medium-Type = IEEE-802,
            Tunnel-Private-Group-ID = "30"

# Usuario admin - asignar VLAN 10
admin1      Cleartext-Password := "adminpass"
            Tunnel-Type = VLAN,
            Tunnel-Medium-Type = IEEE-802,
            Tunnel-Private-Group-ID = "10"

# Usuario invitado - VLAN 40
guest1      Cleartext-Password := "guest123"
            Tunnel-Type = VLAN,
            Tunnel-Medium-Type = IEEE-802,
            Tunnel-Private-Group-ID = "40"
```

#### Paso 1.4: Iniciar FreeRADIUS en modo debug

```bash
# Detener servicio si está corriendo
sudo systemctl stop freeradius   # Linux
brew services stop freeradius    # macOS

# Iniciar en modo debug (para ver las autenticaciones)
sudo freeradius -X
```

**Salida esperada:**
```
Ready to process requests
```

#### Paso 1.5: Probar autenticación localmente

```bash
# Desde otra terminal
radtest empleado1 password123 127.0.0.1 0 testing123

# Resultado esperado:
# Received Access-Accept
```

**Captura de pantalla:** FreeRADIUS aceptando autenticación

---

## FASE 2: Configurar Switch para 802.1X (30 minutos)

### 🔵 ADMIN RED: Configurar el SG300

#### Paso 2.1: Acceder al switch

1. Navegador: `https://192.168.1.237`
2. Iniciar sesión

#### Paso 2.2: Configurar servidor RADIUS

**Ruta:** Security → RADIUS → RADIUS Server Settings

1. Click **Add**
2. Configurar:
   - Server IP: `192.168.1.100`
   - Authentication Port: `1812`
   - Accounting Port: `1813`
   - Secret Key: `radius_secret_2024`
   - Usage Type: `802.1X`
3. Click **Apply**

**Captura de pantalla:** Servidor RADIUS configurado

#### Paso 2.3: Habilitar 802.1X globalmente

**Ruta:** Security → 802.1X/MAC/Web Authentication → Properties

1. Port-Based Authentication: **Enable**
2. Authentication Method: **RADIUS**
3. Click **Apply**

#### Paso 2.4: Configurar puertos para 802.1X

**Ruta:** Security → 802.1X/MAC/Web Authentication → Port Authentication

Para puertos GE2, GE3, GE4:
1. Seleccionar puerto
2. Click **Edit**
3. Configurar:
   - Administrative Port Control: **Auto** (requiere autenticación)
   - Guest VLAN: **200** (si no autentica, va a cuarentena)
   - RADIUS VLAN Assignment: **Enable**
   - Periodic Reauthentication: **Enable**
   - Reauthentication Period: **3600** (1 hora)
4. Click **Apply**

**Opciones de Port Control:**
| Modo | Comportamiento |
|------|---------------|
| **Force Authorized** | Puerto siempre abierto (sin 802.1X) |
| **Force Unauthorized** | Puerto siempre bloqueado |
| **Auto** | Requiere autenticación 802.1X |

#### Paso 2.5: Crear VLAN de cuarentena (Guest VLAN)

**Ruta:** VLAN Management → VLAN Settings

1. Click **Add**
2. VLAN ID: `200`
3. VLAN Name: `Cuarentena`
4. Click **Apply**

#### Paso 2.6: Asignar VLAN de cuarentena a puertos

**Ruta:** VLAN Management → Port to VLAN

1. Seleccionar VLAN 200
2. Marcar GE2, GE3, GE4 como **Tagged** o configurar como Guest VLAN

**Captura de pantalla:** Configuración de puertos 802.1X

---

## FASE 3: Configurar Cliente (Suplicante) (15 minutos)

### 🔵 ADMIN RED o 🔴 ADMIN RADIUS: Configurar PCs

#### Paso 3.1: Configurar suplicante en macOS

1. **Preferencias del Sistema → Red**
2. Seleccionar interfaz Ethernet
3. Click en **Avanzado → 802.1X**
4. Marcar **Conectar automáticamente**
5. Añadir perfil:
   - Modo: EAP-PEAP o EAP-TTLS
   - Usuario: `empleado1`
   - Contraseña: `password123`

#### Paso 3.2: Configurar suplicante en Linux

Editar `/etc/wpa_supplicant/wpa_supplicant.conf`:

```bash
ctrl_interface=/var/run/wpa_supplicant
eapol_version=2
ap_scan=0
network={
    key_mgmt=IEEE8021X
    eap=PEAP
    identity="empleado1"
    password="password123"
    phase2="auth=MSCHAPV2"
}
```

Iniciar suplicante:
```bash
sudo wpa_supplicant -i eth0 -D wired -c /etc/wpa_supplicant/wpa_supplicant.conf
```

#### Paso 3.3: Alternativa - Usar línea de comandos

```bash
# Linux con wpa_supplicant interactivo
sudo wpa_cli -i eth0
> add_network
> set_network 0 key_mgmt IEEE8021X
> set_network 0 eap PEAP
> set_network 0 identity "empleado1"
> set_network 0 password "password123"
> enable_network 0
```

---

## FASE 4: Verificar Autenticación (25 minutos)

### Ambos: Probar diferentes escenarios

#### Escenario 1: Usuario válido (empleado1)

**🔴 ADMIN RADIUS observa en FreeRADIUS:**
```
(0) Received Access-Request from 192.168.1.237
(0) Login OK: [empleado1]
(0) Sent Access-Accept
```

**🔵 ADMIN RED verifica en el switch:**

**Ruta:** Security → 802.1X/MAC/Web Authentication → Authenticated Hosts

Debe mostrar:
| Puerto | Usuario | VLAN Asignada | Estado |
|--------|---------|---------------|--------|
| GE2 | empleado1 | 30 | Authenticated |

**PC verifica:**
```bash
# Debe obtener IP de VLAN 30
ip addr show eth0
# IP: 192.168.30.x
```

**Captura de pantalla:** Usuario autenticado en el switch

#### Escenario 2: Usuario inválido

Intentar conectar con credenciales incorrectas.

**🔴 ADMIN RADIUS observa:**
```
(1) Received Access-Request from 192.168.1.237
(1) Login incorrect: [usuario_falso]
(1) Sent Access-Reject
```

**🔵 ADMIN RED verifica:**
- El puerto permanece en estado "Not Authenticated"
- El PC es asignado a Guest VLAN (200) o bloqueado

**PC verifica:**
```bash
# Si hay Guest VLAN, IP de VLAN 200
# Si no, sin conectividad
ping -c 4 192.168.1.1
# DEBE FALLAR o ir a portal cautivo
```

#### Escenario 3: Sin suplicante configurado

Conectar un PC sin cliente 802.1X configurado.

**Resultado esperado:**
- Puerto no autentica
- PC asignado a Guest VLAN (cuarentena)
- Acceso muy limitado o nulo

---

## FASE 5: Documentación (20 minutos)

### Tabla de resultados

| Escenario | Usuario | Resultado RADIUS | VLAN Asignada | Conectividad |
|-----------|---------|------------------|---------------|--------------|
| Auth OK | empleado1 | Access-Accept | 30 | Completa |
| Auth OK | admin1 | Access-Accept | 10 | Completa |
| Auth Fail | falso | Access-Reject | 200 | Cuarentena |
| Sin suplicante | - | Timeout | 200 | Cuarentena |

### Diagrama de flujo de autenticación

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   CLIENTE   │     │   SWITCH    │     │   RADIUS    │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       │   Conecta         │                   │
       │──────────────────►│                   │
       │                   │                   │
       │   EAP-Request     │                   │
       │◄──────────────────│                   │
       │                   │                   │
       │   EAP-Response    │                   │
       │   (credenciales)  │                   │
       │──────────────────►│                   │
       │                   │                   │
       │                   │  Access-Request   │
       │                   │──────────────────►│
       │                   │                   │
       │                   │  Access-Accept    │
       │                   │  (VLAN=30)        │
       │                   │◄──────────────────│
       │                   │                   │
       │   EAP-Success     │                   │
       │◄──────────────────│                   │
       │                   │                   │
       │   Puerto habilitado en VLAN 30       │
       │                   │                   │
```

### Relación con práctica de diseño de infraestructura

| Aspecto del Diseño | Implementación |
|--------------------|----------------|
| Control de acceso a la red | 802.1X en puertos de usuario |
| Autenticación centralizada | Servidor RADIUS |
| Asignación dinámica de VLAN | RADIUS devuelve VLAN según usuario |
| VLAN de cuarentena | Guest VLAN para no autenticados |
| Principio de mínimo privilegio | Cada rol obtiene su VLAN |

---

## Entregables

### 🔴 ADMIN RADIUS
- [ ] Captura: Configuración de clients.conf
- [ ] Captura: Configuración de users
- [ ] Captura: FreeRADIUS aceptando autenticación
- [ ] Captura: FreeRADIUS rechazando autenticación

### 🔵 ADMIN RED
- [ ] Captura: Servidor RADIUS configurado en switch
- [ ] Captura: 802.1X habilitado globalmente
- [ ] Captura: Puertos configurados en modo Auto
- [ ] Captura: Usuarios autenticados en el switch
- [ ] Captura: Guest VLAN configurada

### Ambos
- [ ] Tabla de resultados de pruebas
- [ ] Diagrama de flujo completado
- [ ] Conclusiones sobre seguridad de 802.1X

---

## Troubleshooting

### El switch no contacta al servidor RADIUS
- Verificar IP del servidor RADIUS
- Verificar que el puerto 1812 está abierto
- Comprobar que el secret coincide en ambos lados
- Verificar conectividad: `ping 192.168.1.100`

### RADIUS rechaza todas las autenticaciones
- Verificar que el usuario existe en el archivo `users`
- Comprobar la contraseña
- Revisar logs de FreeRADIUS: `sudo freeradius -X`

### El cliente no intenta autenticarse
- Verificar que el suplicante está configurado
- En macOS/Linux, verificar wpa_supplicant
- Algunos sistemas requieren habilitar 802.1X manualmente

### La VLAN asignada no funciona
- Verificar que la VLAN existe en el switch
- Comprobar que el atributo Tunnel-Private-Group-ID es correcto
- Verificar que RADIUS VLAN Assignment está habilitado en el puerto

---

## Navegación

⬅️ [Práctica 6: Segmentación VLANs](practica_06_segmentacion_vlans.md) | [Práctica 8: Hardening Completo →](practica_08_hardening_completo.md)
