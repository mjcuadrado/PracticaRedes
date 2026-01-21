# SOLUCIÓN: Práctica Diseño de Infraestructuras de Comunicaciones

## Información del Ejercicio

| Campo | Valor |
|-------|-------|
| **Asignatura** | Seguridad en las Redes |
| **Máster** | Seguridad Informática |
| **Universidad** | Escuela Politécnica Superior de Jaén |
| **Tipo** | Diseño de infraestructura empresarial |

---

## Escenario Propuesto

**Empresa:** TechSecure S.L. (empresa de consultoría tecnológica)

| Sede | Ubicación | Empleados | Características |
|------|-----------|-----------|-----------------|
| **Principal** | Jaén | 150 | CPD, servidores, departamentos completos |
| **Secundaria 1** | Granada | 40 | Oficina comercial + desarrollo |
| **Secundaria 2** | Málaga | 25 | Oficina comercial |
| **Secundaria 3** | Sevilla | 30 | Soporte técnico |

---

## 1. Personal TIC - Gestión de Red

### Estructura del Departamento TIC (Sede Principal)

```
┌─────────────────────────────────────────────────────────┐
│                    DIRECTOR TIC                          │
│               (Gestión estratégica)                      │
└─────────────────────┬───────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
┌───────▼───────┐ ┌───▼───────┐ ┌───▼───────────┐
│ Administrador │ │ Técnico   │ │ Responsable   │
│ de Sistemas   │ │ de Red    │ │ Seguridad     │
│ (2 personas)  │ │(2 personas)│ │ (1 persona)   │
└───────────────┘ └───────────┘ └───────────────┘
```

### Gestión Centralizada

| Función | Herramienta/Método | Ubicación |
|---------|-------------------|-----------|
| **Gestión de equipos** | Microsoft SCCM / Intune | Sede Principal |
| **Directorio de usuarios** | Active Directory | Sede Principal (replicado) |
| **Gestión switches/routers** | SSH + SNMP + Web HTTPS | Desde VLAN Gestión |
| **Monitorización** | Zabbix / Nagios | Sede Principal |
| **Logs centralizados** | Servidor Syslog / SIEM | CPD Principal |

### Acceso a Equipos de Comunicaciones

| Tipo de Acceso | Método | Seguridad |
|----------------|--------|-----------|
| **Local** | Consola física (puerto serial) | Solo en CPD, acceso físico restringido |
| **Remoto (LAN)** | SSH v2 + HTTPS | Solo desde VLAN Gestión |
| **Remoto (WAN)** | VPN + SSH/HTTPS | Client-to-Site VPN obligatoria |

```
Política de acceso remoto:
- Administradores TIC → VPN → VLAN Gestión → Equipos
- Sin acceso directo desde Internet
- Autenticación: RADIUS + Certificados
- MFA obligatorio para acceso remoto
```

---

## 2. Dispositivos

### Inventario por Sede

#### Sede Principal (Jaén)

| Categoría | Dispositivos | Cantidad |
|-----------|-------------|----------|
| **Estaciones de trabajo** | PCs de escritorio | 120 |
| **Portátiles** | Laptops | 40 |
| **Teléfonos VoIP** | Cisco IP Phone | 150 |
| **Impresoras de red** | Multifuncionales | 15 |
| **IoT** | Sensores temperatura CPD, cámaras IP | 20 |

#### CPD Sede Principal

| Servidor | Función | Redundancia |
|----------|---------|-------------|
| **DC01, DC02** | Active Directory + DNS | Cluster |
| **FILE01** | Servidor de archivos (NAS) | RAID 6 |
| **MAIL01** | Exchange / Mail Server | Backup diario |
| **VOIP01** | Centralita VoIP (Asterisk/Cisco) | Activo-Pasivo |
| **WEB01** | Servidor web interno (Intranet) | - |
| **BACKUP01** | Servidor de copias de seguridad | Cinta + Cloud |
| **SIEM01** | SIEM / Logs centralizados | - |
| **MON01** | Monitorización (Zabbix) | - |

#### Sedes Secundarias

| Sede | PCs | VoIP | Impresoras |
|------|-----|------|------------|
| Granada | 35 | 40 | 4 |
| Málaga | 20 | 25 | 3 |
| Sevilla | 25 | 30 | 3 |

---

## 3. Equipos de Comunicaciones

### Sede Principal

```
┌─────────────────────────────────────────────────────────────────┐
│                           INTERNET                               │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                    ┌───────────▼───────────┐
                    │   ROUTER FRONTERA     │
                    │   (Cisco ISR 4331)    │
                    │   - NAT               │
                    │   - BGP/OSPF          │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │      FIREWALL         │
                    │  (Fortinet/Palo Alto) │
                    │   - Stateful          │
                    │   - IPS/IDS           │
                    │   - VPN Concentrator  │
                    └───────────┬───────────┘
                                │
          ┌─────────────────────┼─────────────────────┐
          │                     │                     │
┌─────────▼─────────┐ ┌─────────▼─────────┐ ┌────────▼────────┐
│       DMZ         │ │    LAN INTERNA    │ │  VLAN GESTIÓN   │
│  (Serv. Públicos) │ │                   │ │                 │
└───────────────────┘ └─────────┬─────────┘ └─────────────────┘
                                │
                    ┌───────────▼───────────┐
                    │    SWITCH CORE        │
                    │  (Cisco 3850/9300)    │
                    │   - L3 Routing        │
                    │   - Redundante (2x)   │
                    └───────────┬───────────┘
                                │
          ┌─────────────────────┼─────────────────────┐
          │                     │                     │
┌─────────▼─────────┐ ┌─────────▼─────────┐ ┌────────▼────────┐
│ SWITCH DISTRIBUC. │ │ SWITCH DISTRIBUC. │ │SWITCH DISTRIBUC.│
│   Edificio A      │ │   Edificio B      │ │      CPD        │
│  (Cisco 2960-X)   │ │  (Cisco 2960-X)   │ │ (Cisco 2960-X)  │
└─────────┬─────────┘ └─────────┬─────────┘ └────────┬────────┘
          │                     │                     │
    ┌─────┼─────┐         ┌─────┼─────┐         ┌────┼────┐
    │     │     │         │     │     │         │    │    │
   SW    SW    SW        SW    SW    SW       Servidores
  Acceso Acceso Acceso  Acceso Acceso Acceso
```

### Equipos por Capa

| Capa | Equipo | Modelo Sugerido | Cantidad | Funciones |
|------|--------|-----------------|----------|-----------|
| **Internet Edge** | Router | Cisco ISR 4331 | 2 (HA) | NAT, routing, WAN |
| **Seguridad** | Firewall | FortiGate 200F | 2 (HA) | FW, IPS, VPN |
| **Core** | Switch L3 | Cisco C9300-48P | 2 (stack) | Inter-VLAN routing |
| **Distribución** | Switch L2 | Cisco C2960X-48 | 6 | Agregación |
| **Acceso** | Switch L2 | Cisco SG300-28P | 20 | Puertos usuario |
| **Wireless** | AP | Cisco Aironet/Meraki | 25 | WiFi empresarial |
| **Wireless** | Controlador | Cisco WLC | 1 | Gestión APs |

### Host Bastión

```
┌─────────────────────────────────────────┐
│            HOST BASTIÓN                  │
│  (Jump Server / Pivot de seguridad)     │
├─────────────────────────────────────────┤
│  - Ubicación: DMZ o VLAN dedicada       │
│  - Acceso: Único punto entrada admin    │
│  - Servicios: SSH, RDP Gateway          │
│  - Logs: Todo registrado                │
│  - Hardening: Mínimos servicios         │
│  - MFA: Obligatorio                     │
└─────────────────────────────────────────┘

Flujo de administración:
Admin → VPN → Bastión → Equipos internos
```

### Sedes Secundarias

| Sede | Router | Firewall | Switch | APs |
|------|--------|----------|--------|-----|
| Granada | ISR 1111 | FortiGate 60F | SG300-28 (x2) | 4 |
| Málaga | ISR 1111 | FortiGate 40F | SG300-28 (x1) | 2 |
| Sevilla | ISR 1111 | FortiGate 60F | SG300-28 (x2) | 3 |

---

## 4. Topología

### Topología Física - Sede Principal

```
                                    ┌─────────────────┐
                                    │    INTERNET     │
                                    │   (2 ISPs)      │
                                    └────────┬────────┘
                                             │
┌────────────────────────────────────────────┼────────────────────────────────────────────┐
│  RACK PRINCIPAL CPD                        │                                            │
│  ┌─────────────────────────────────────────▼─────────────────────────────────────────┐  │
│  │  [Router ISP1] ══════════════════════════════════════════════ [Router ISP2]      │  │
│  │       │                                                              │            │  │
│  │       └──────────────────────┬───────────────────────────────────────┘            │  │
│  │                              │                                                    │  │
│  │                    ┌─────────▼─────────┐                                          │  │
│  │                    │  FIREWALL HA      │                                          │  │
│  │                    │  (Activo-Pasivo)  │                                          │  │
│  │                    └─────────┬─────────┘                                          │  │
│  │                              │                                                    │  │
│  │              ┌───────────────┼───────────────┐                                    │  │
│  │              │               │               │                                    │  │
│  │        ┌─────▼─────┐   ┌─────▼─────┐   ┌─────▼─────┐                              │  │
│  │        │  CORE SW  │═══│  CORE SW  │   │  DMZ SW   │                              │  │
│  │        │  (Stack)  │   │  (Stack)  │   │           │                              │  │
│  │        └─────┬─────┘   └─────┬─────┘   └───────────┘                              │  │
│  │              └───────────────┘                                                    │  │
│  │                      │                                                            │  │
│  │        ┌─────────────┼─────────────┐                                              │  │
│  │        │             │             │                                              │  │
│  │   [Dist SW]     [Dist SW]     [Dist SW]                                           │  │
│  │   Edif. A       Edif. B         CPD                                               │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

### Red Jerárquica: 3 Capas

| Capa | Función | Equipos | Características |
|------|---------|---------|-----------------|
| **CORE** | Backbone de alta velocidad | 2x Switches L3 | 10Gbps, redundancia, routing inter-VLAN |
| **DISTRIBUCIÓN** | Agregación y políticas | 6x Switches L2/L3 | Agregación de acceso, QoS, ACLs |
| **ACCESO** | Conexión de usuarios | 20x Switches L2 | PoE para VoIP/APs, Port Security |

### Cableado

| Tipo | Uso | Categoría/Tipo |
|------|-----|----------------|
| **Backbone** | Core ↔ Distribución | Fibra óptica MM (OM4) 10Gbps |
| **Distribución** | Distribución ↔ Acceso | Fibra óptica MM o Cat6a |
| **Acceso** | Switch ↔ Usuario | Cat6 UTP (1Gbps) |
| **Horizontal** | Patch panel ↔ Roseta | Cat6 UTP |

### Plan de Direccionamiento IP

#### Sede Principal (10.1.0.0/16)

| VLAN ID | Nombre | Red | Gateway | Rango DHCP | Hosts |
|---------|--------|-----|---------|------------|-------|
| 1 | Default (no usar) | - | - | - | - |
| 10 | **Gestión** | 10.1.10.0/24 | 10.1.10.1 | Estático | 254 |
| 20 | **Servidores** | 10.1.20.0/24 | 10.1.20.1 | Estático | 254 |
| 30 | **Usuarios Admón** | 10.1.30.0/24 | 10.1.30.1 | .100-.200 | 254 |
| 40 | **Usuarios Técnico** | 10.1.40.0/24 | 10.1.40.1 | .100-.200 | 254 |
| 50 | **Usuarios Comercial** | 10.1.50.0/24 | 10.1.50.1 | .100-.200 | 254 |
| 60 | **VoIP** | 10.1.60.0/24 | 10.1.60.1 | .100-.250 | 254 |
| 70 | **WiFi Corporativa** | 10.1.70.0/24 | 10.1.70.1 | .50-.250 | 254 |
| 80 | **WiFi Invitados** | 10.1.80.0/24 | 10.1.80.1 | .50-.250 | 254 |
| 90 | **IoT/Cámaras** | 10.1.90.0/24 | 10.1.90.1 | .50-.200 | 254 |
| 100 | **DMZ** | 10.1.100.0/24 | 10.1.100.1 | Estático | 254 |
| 200 | **Cuarentena** | 10.1.200.0/24 | 10.1.200.1 | .50-.200 | 254 |

#### Sedes Secundarias

| Sede | Red Base | VLAN Usuarios | VLAN VoIP | VLAN Gestión |
|------|----------|---------------|-----------|--------------|
| Granada | 10.2.0.0/16 | 10.2.30.0/24 | 10.2.60.0/24 | 10.2.10.0/24 |
| Málaga | 10.3.0.0/16 | 10.3.30.0/24 | 10.3.60.0/24 | 10.3.10.0/24 |
| Sevilla | 10.4.0.0/16 | 10.4.30.0/24 | 10.4.60.0/24 | 10.4.10.0/24 |

#### Direcciones Públicas / DMZ

| Servicio | IP Pública | IP Privada (DMZ) | Puerto |
|----------|------------|------------------|--------|
| Web corporativa | 80.X.X.10 | 10.1.100.10 | 443 |
| Mail (MX) | 80.X.X.11 | 10.1.100.11 | 25, 587, 993 |
| VPN | 80.X.X.12 | 10.1.100.12 | 443, 1194 |

---

## 5. VLANs

### Diseño de VLANs

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DISEÑO DE VLANs                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                   │
│  │   VLAN 10    │    │   VLAN 20    │    │   VLAN 100   │                   │
│  │   GESTIÓN    │    │  SERVIDORES  │    │     DMZ      │                   │
│  │  (Switches,  │    │  (DC, Mail,  │    │  (Web, Mail  │                   │
│  │   Routers)   │    │   Files)     │    │   público)   │                   │
│  └──────────────┘    └──────────────┘    └──────────────┘                   │
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                   │
│  │   VLAN 30    │    │   VLAN 40    │    │   VLAN 50    │                   │
│  │ ADMINISTRAC. │    │   TÉCNICOS   │    │  COMERCIAL   │                   │
│  │  (RRHH,      │    │(Desarrollo,  │    │  (Ventas,    │                   │
│  │   Finanzas)  │    │   Soporte)   │    │   Marketing) │                   │
│  └──────────────┘    └──────────────┘    └──────────────┘                   │
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                   │
│  │   VLAN 60    │    │   VLAN 70    │    │   VLAN 80    │                   │
│  │     VoIP     │    │WiFi CORPORAT.│    │WiFi INVITADOS│                   │
│  │  (Teléfonos  │    │  (Empleados  │    │  (Aislada,   │                   │
│  │   IP, QoS)   │    │   móviles)   │    │ solo Internet│                   │
│  └──────────────┘    └──────────────┘    └──────────────┘                   │
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐                                       │
│  │   VLAN 90    │    │   VLAN 200   │                                       │
│  │  IoT/CÁMARAS │    │  CUARENTENA  │                                       │
│  │  (Sensores,  │    │  (Equipos no │                                       │
│  │   CCTV)      │    │  compliance) │                                       │
│  └──────────────┘    └──────────────┘                                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### VLAN de Gestión (VLAN 10)

**Propósito:** Administración de equipos de red

```
Características:
- Acceso restringido solo a personal TIC
- No accesible desde VLANs de usuarios
- SSH, HTTPS, SNMP habilitados
- ACLs estrictas en firewall

Equipos en VLAN Gestión:
- Interfaces de gestión de switches
- Interfaces de gestión de routers
- Interfaces de gestión de firewalls
- Interfaces de gestión de APs
- Servidor de monitorización
```

### Private VLAN (PVLAN)

**Uso:** VLAN 80 (WiFi Invitados) y VLAN 90 (IoT)

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRIVATE VLAN - WiFi Invitados                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Primary VLAN: 80                                                │
│                                                                  │
│  ┌─────────────────┐                                             │
│  │ Promiscuous     │ → Gateway, DHCP, DNS                        │
│  │ Port            │   (Puede hablar con todos)                  │
│  └─────────────────┘                                             │
│                                                                  │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐                │
│  │Isolated │ │Isolated │ │Isolated │ │Isolated │                │
│  │ Host 1  │ │ Host 2  │ │ Host 3  │ │ Host 4  │                │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘                │
│       ↕            ↕           ↕           ↕                     │
│    Solo Gateway  Solo GW   Solo GW    Solo GW                    │
│    (No entre ellos - AISLADOS)                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

Beneficio: Los invitados no pueden ver/atacar a otros invitados
```

### VLAN Internetworking (Trunks)

```
Configuración de Trunks entre switches:

┌─────────────┐     Trunk (802.1Q)      ┌─────────────┐
│  CORE SW    │◄───────────────────────►│  DIST SW    │
│             │   VLANs permitidas:     │             │
└─────────────┘   10,20,30,40,50,60,    └─────────────┘
                  70,80,90,100

Native VLAN: 999 (VLAN "black hole" - sin uso)
Trunk Encapsulation: 802.1Q

Seguridad en Trunks:
- Native VLAN diferente a VLAN 1
- Deshabilitar DTP (switchport nonegotiate)
- Permitir solo VLANs necesarias
```

---

## 6. Protección frente a Amenazas Internas

### Matriz de Amenazas y Contramedidas

| Amenaza | Vector | Impacto | Contramedida |
|---------|--------|---------|--------------|
| **ARP Spoofing** | Envenenamiento tabla ARP | MITM, captura de tráfico | Dynamic ARP Inspection (DAI) |
| **DHCP Starvation** | Agotar pool DHCP | DoS | DHCP Snooping + Rate Limiting |
| **DHCP Spoofing** | Servidor DHCP falso | MITM | DHCP Snooping (trusted ports) |
| **MAC Flooding** | Inundar tabla CAM | Switch actúa como hub | Port Security |
| **VLAN Hopping** | Saltar entre VLANs | Acceso no autorizado | Native VLAN, deshabilitar DTP |
| **STP Attack** | Manipular spanning tree | Interrupción de red | BPDU Guard, Root Guard |
| **Rogue AP** | Punto acceso no autorizado | Captura de credenciales | 802.1X, WIPS |

### Configuración de Contramedidas en Switches

#### Port Security

```
Configuración recomendada por tipo de puerto:

Puerto de usuario:
- Max MACs: 2 (PC + VoIP)
- Modo: Limited Dynamic Lock
- Violación: Discard + Trap
- Aging: 60 minutos

Puerto de servidor:
- Max MACs: 1 (fijo)
- Modo: Secure Permanent
- Violación: Shutdown

Puerto trunk:
- Port Security: Deshabilitado (múltiples MACs esperadas)
```

#### DHCP Snooping

```
Configuración:

DHCP Snooping: Habilitado globalmente
VLANs protegidas: 30, 40, 50, 60, 70, 80

Puertos TRUSTED:
- Uplinks hacia Core/Distribución
- Puerto del servidor DHCP

Puertos UNTRUSTED:
- Todos los puertos de acceso de usuarios
- Rate Limit: 15 paquetes/segundo
```

#### Dynamic ARP Inspection (DAI)

```
Requisito: DHCP Snooping habilitado primero

DAI: Habilitado en VLANs 30, 40, 50, 60, 70, 80

Validación:
- Source MAC
- Destination MAC
- IP Address

Puertos TRUSTED: Mismos que DHCP Snooping
```

#### Protección STP

```
En puertos de acceso (usuarios):
- BPDU Guard: Habilitado
- Si recibe BPDU → Puerto en err-disable

En puertos trunk (hacia Core):
- Root Guard: Habilitado
- Previene que otro switch se convierta en root

En Core switches:
- STP Priority: 0 (Root Bridge)
- Rapid PVST+ habilitado
```

---

## 7. Control de Acceso

### Modelo de Control de Acceso

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CONTROL DE ACCESO - CAPAS                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  CAPA 1: ACCESO A LA RED (Network Access Control)                            │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  802.1X + RADIUS                                                     │    │
│  │  - Autenticación antes de acceso a red                               │    │
│  │  - Asignación dinámica de VLAN según usuario/dispositivo             │    │
│  │  - Certificados + credenciales AD                                    │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  CAPA 2: ACCESO A APLICACIONES                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  SSO + LDAP/SAML                                                     │    │
│  │  - Single Sign-On corporativo                                        │    │
│  │  - Integración con Active Directory                                  │    │
│  │  - MFA para aplicaciones críticas                                    │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  CAPA 3: ACCESO A INFORMACIÓN                                                │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  RBAC (Role-Based Access Control)                                    │    │
│  │  - Permisos basados en rol/departamento                              │    │
│  │  - Principio de mínimo privilegio                                    │    │
│  │  - Clasificación de información (Pública, Interna, Confidencial)     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 802.1X - Implementación

```
Componentes:
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│  SUPLICANTE   │      │ AUTENTICADOR  │      │   SERVIDOR    │
│  (PC/Laptop)  │◄────►│   (Switch)    │◄────►│   RADIUS      │
│               │ EAP  │               │RADIUS│  (FreeRADIUS/ │
│               │      │               │      │   NPS)        │
└───────────────┘      └───────────────┘      └───────────────┘

Flujo de autenticación:
1. PC conecta al puerto del switch
2. Switch solicita credenciales (EAP)
3. PC envía usuario/certificado
4. Switch reenvía a RADIUS
5. RADIUS valida contra AD
6. RADIUS responde: Accept/Reject + VLAN asignada
7. Switch habilita puerto en VLAN correspondiente
```

### Matriz de Permisos por Rol

| Rol | VLAN Asignada | Acceso Servidores | Acceso Internet | Acceso VPN |
|-----|---------------|-------------------|-----------------|------------|
| **Administración** | 30 | Files, Mail, ERP | Completo | Sí |
| **Técnico** | 40 | Files, Mail, Dev servers | Completo | Sí |
| **Comercial** | 50 | Files, Mail, CRM | Completo | Sí |
| **Invitado** | 80 | Ninguno | Solo HTTP/HTTPS | No |
| **Dispositivo IoT** | 90 | Servidor IoT | Limitado | No |
| **No autenticado** | 200 (Cuarentena) | Portal cautivo | No | No |

---

## 8. DMZ (Zona Desmilitarizada)

### Arquitectura DMZ

```
                           INTERNET
                               │
                    ┌──────────▼──────────┐
                    │   FIREWALL EXTERNO  │
                    │  (Zona UNTRUST)     │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
        ┌─────▼─────┐    ┌─────▼─────┐    ┌─────▼─────┐
        │  WEB SRV  │    │  MAIL SRV │    │   VPN     │
        │  (HTTPS)  │    │  (SMTP)   │    │  Gateway  │
        │10.1.100.10│    │10.1.100.11│    │10.1.100.12│
        └───────────┘    └───────────┘    └───────────┘
                               │
                    ┌──────────▼──────────┐
                    │   FIREWALL INTERNO  │
                    │   (Zona DMZ→LAN)    │
                    └──────────┬──────────┘
                               │
                         RED INTERNA
                         (TRUST)
```

### Servicios en DMZ

| Servidor | IP DMZ | Puertos Expuestos | Función |
|----------|--------|-------------------|---------|
| **WEB01-DMZ** | 10.1.100.10 | 443 (HTTPS) | Web corporativa, portal clientes |
| **MAIL01-DMZ** | 10.1.100.11 | 25, 587, 993 | Relay de correo entrante |
| **VPN01-DMZ** | 10.1.100.12 | 443, 1194 | Concentrador VPN |
| **DNS01-DMZ** | 10.1.100.13 | 53 | DNS público (autoritativo) |

### Reglas de Firewall DMZ

```
# Internet → DMZ (Permitido específico)
ALLOW  Internet → WEB01-DMZ:443
ALLOW  Internet → MAIL01-DMZ:25,587
ALLOW  Internet → VPN01-DMZ:443,1194
ALLOW  Internet → DNS01-DMZ:53
DENY   Internet → DMZ:* (todo lo demás)

# DMZ → Internet (Limitado)
ALLOW  MAIL01-DMZ → Internet:25,587 (envío correo)
ALLOW  DMZ → Internet:80,443 (actualizaciones)
DENY   DMZ → Internet:* (resto)

# DMZ → LAN (Muy restringido)
ALLOW  MAIL01-DMZ → MAIL01-LAN:25 (relay interno)
ALLOW  WEB01-DMZ → DB01-LAN:3306 (consultas BD)
DENY   DMZ → LAN:* (todo lo demás)

# LAN → DMZ (Administración)
ALLOW  VLAN_Gestion → DMZ:22,443 (admin)
DENY   LAN → DMZ:* (usuarios normales)
```

### Implementación

| Opción | Método | Ventajas | Desventajas |
|--------|--------|----------|-------------|
| **VLAN DMZ** | VLAN 100 dedicada | Simple, económico | Depende de ACLs del firewall |
| **Red física separada** | Switches/cableado independiente | Aislamiento total | Más costoso |
| **Firewall multi-zona** | Interfaces dedicadas en FW | Control granular | Requiere FW potente |

**Recomendación:** Interfaces dedicadas en firewall (DMZ como zona separada)

---

## 9. Comunicaciones

### Conexión a Internet

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      CONEXIÓN INTERNET - REDUNDANCIA                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│     ISP Principal                              ISP Backup                    │
│    (Fibra 1 Gbps)                           (Fibra 300 Mbps)                │
│         │                                          │                         │
│    ┌────▼────┐                                ┌────▼────┐                    │
│    │Router 1 │                                │Router 2 │                    │
│    │(Activo) │                                │(Standby)│                    │
│    └────┬────┘                                └────┬────┘                    │
│         │              ┌───────────┐               │                         │
│         └──────────────►  FIREWALL ◄───────────────┘                         │
│                        │   (HA)    │                                         │
│                        └─────┬─────┘                                         │
│                              │                                               │
│                         RED INTERNA                                          │
│                                                                              │
│  Política de failover:                                                       │
│  - ISP Principal: Todo el tráfico                                            │
│  - ISP Backup: Activa si Principal cae (health check)                        │
│  - Tiempo de conmutación: < 30 segundos                                      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### VPN Site-to-Site (Sedes)

```
┌──────────────┐        IPSec VPN         ┌──────────────┐
│ SEDE JAÉN    │◄────────────────────────►│ SEDE GRANADA │
│ (Principal)  │    Túnel 1: 10.1↔10.2    │              │
│              │                          │              │
│              │◄────────────────────────►│ SEDE MÁLAGA  │
│              │    Túnel 2: 10.1↔10.3    │              │
│              │                          │              │
│              │◄────────────────────────►│ SEDE SEVILLA │
│              │    Túnel 3: 10.1↔10.4    │              │
└──────────────┘                          └──────────────┘

Configuración VPN Site-to-Site:
- Protocolo: IPSec (IKEv2)
- Cifrado: AES-256-GCM
- Autenticación: PSK o Certificados
- PFS: Diffie-Hellman Group 14
- SA Lifetime: 8 horas
```

### VPN Client-to-Site (Teletrabajo)

```
┌─────────────────┐                    ┌─────────────────┐
│    EMPLEADO     │     SSL VPN        │  CONCENTRADOR   │
│   (Remoto)      │◄──────────────────►│      VPN        │
│                 │    Puerto 443      │  (FortiClient/  │
│  FortiClient    │                    │   OpenVPN)      │
│  OpenVPN        │                    │                 │
└─────────────────┘                    └─────────────────┘

Características:
- Protocolo: SSL/TLS (OpenVPN) o IPSec
- Puerto: 443 (pasa firewalls restrictivos)
- Autenticación: Usuario AD + Certificado + MFA
- Split tunnel: Deshabilitado (todo por VPN)
- Políticas: Según rol del usuario
```

### Alternativa: MPLS (Red Privada)

```
Si se requiere mayor fiabilidad y menor latencia:

┌──────────┐     MPLS Cloud      ┌──────────┐
│ Sede Jaén│◄───────────────────►│  Granada │
│   CE     │                     │    CE    │
└──────────┘         │           └──────────┘
                     │
              ┌──────▼──────┐
              │   Málaga    │
              │     CE      │
              └─────────────┘

Ventajas MPLS:
- QoS garantizado
- Menor latencia que VPN sobre Internet
- SLA del proveedor

Desventajas:
- Coste elevado
- Dependencia de un proveedor
```

---

## 10. Tolerancia a Fallos y Resiliencia

### Matriz de Redundancia

| Componente | Redundancia | Método | RTO |
|------------|-------------|--------|-----|
| **Internet** | 2 ISPs | Failover automático | < 30s |
| **Firewall** | HA Activo-Pasivo | VRRP/Cluster | < 10s |
| **Core Switch** | 2 en Stack | VSS/StackWise | 0s (stateful) |
| **Distribución** | Enlaces redundantes | STP/LACP | < 1s |
| **Servidores críticos** | Cluster o réplica | Windows Cluster | < 5min |
| **Almacenamiento** | RAID 6 + Réplica | Síncrona/Asíncrona | Inmediato |
| **Energía** | UPS + Generador | Automático | UPS: 0s, Gen: 30s |

### Servicios Críticos y su Protección

```
┌─────────────────────────────────────────────────────────────────┐
│                    SERVICIOS CRÍTICOS                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ACTIVE DIRECTORY                                                │
│  ┌─────────────┐     Replicación     ┌─────────────┐            │
│  │    DC01     │◄───────────────────►│    DC02     │            │
│  │  (Jaén)     │                     │  (Granada)  │            │
│  └─────────────┘                     └─────────────┘            │
│                                                                  │
│  CORREO ELECTRÓNICO                                              │
│  ┌─────────────┐     DAG/Backup      ┌─────────────┐            │
│  │   MAIL01    │◄───────────────────►│   MAIL02    │            │
│  │  (Activo)   │                     │  (Standby)  │            │
│  └─────────────┘                     └─────────────┘            │
│                                                                  │
│  ALMACENAMIENTO                                                  │
│  ┌─────────────┐     Réplica sync    ┌─────────────┐            │
│  │    NAS01    │◄───────────────────►│   BACKUP    │            │
│  │  (RAID 6)   │                     │   (Cloud)   │            │
│  └─────────────┘                     └─────────────┘            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Estrategia de Backup

| Tipo | Frecuencia | Retención | Destino |
|------|------------|-----------|---------|
| **Completo** | Semanal (domingo) | 4 semanas | NAS local + Cloud |
| **Incremental** | Diario | 7 días | NAS local |
| **Configuraciones equipos** | Diario | 30 días | TFTP/Git |
| **Bases de datos** | Cada 4 horas | 7 días | NAS + réplica |

### Balanceo de Carga

```
                    ┌─────────────────┐
                    │   BALANCEADOR   │
                    │   (F5/HAProxy)  │
                    │   VIP: x.x.x.x  │
                    └────────┬────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
     ┌─────▼─────┐     ┌─────▼─────┐     ┌─────▼─────┐
     │  WEB01    │     │  WEB02    │     │  WEB03    │
     │  (33%)    │     │  (33%)    │     │  (33%)    │
     └───────────┘     └───────────┘     └───────────┘

Algoritmos:
- Round Robin (por defecto)
- Least Connections (para aplicaciones pesadas)
- Health Checks: HTTP 200 cada 10s
```

---

## 11. Monitorización de Red

### Arquitectura de Monitorización

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SISTEMA DE MONITORIZACIÓN                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      ZABBIX / NAGIOS                                 │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │    │
│  │  │   SERVIDOR   │  │   PROXIES    │  │  DASHBOARD   │               │    │
│  │  │    ZABBIX    │  │  (por sede)  │  │   GRAFANA    │               │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘               │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                              │                                               │
│                              │ SNMP, ICMP, Agentes                           │
│                              ▼                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   Switches   │  │   Routers    │  │  Firewalls   │  │  Servidores  │    │
│  │   (SNMP v3)  │  │   (SNMP v3)  │  │   (API)      │  │  (Agentes)   │    │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Métricas Monitorizadas

| Categoría | Métricas | Umbral Alerta | Umbral Crítico |
|-----------|----------|---------------|----------------|
| **Red** | Ancho de banda, latencia, pérdida paquetes | 70% BW, 50ms, 1% | 90% BW, 100ms, 5% |
| **Switches** | CPU, memoria, estado puertos, errores | 70% CPU/RAM | 90% CPU/RAM |
| **Servidores** | CPU, RAM, disco, servicios | 80% uso | 95% uso |
| **Seguridad** | Intentos login fallidos, tráfico anómalo | 5 intentos | 10 intentos |
| **Disponibilidad** | Uptime equipos, servicios | < 99.9% | < 99% |

### Generación de Logs (Syslog)

```
┌──────────────────┐        ┌──────────────────┐
│  Switches        │───────►│                  │
│  Routers         │  UDP   │  SERVIDOR SYSLOG │
│  Firewalls       │  514   │  (rsyslog/       │
│  Servidores      │───────►│   Graylog)       │
│  APs             │        │                  │
└──────────────────┘        └────────┬─────────┘
                                     │
                                     ▼
                            ┌──────────────────┐
                            │       SIEM       │
                            │  (Correlación)   │
                            │  - Alertas       │
                            │  - Reportes      │
                            │  - Forense       │
                            └──────────────────┘

Retención de logs:
- Caliente (búsqueda rápida): 30 días
- Tibio (comprimido): 90 días
- Frío (archivo): 1 año
```

---

## 12. Detección

### Honeypot

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              HONEYPOT                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Ubicación: VLAN dedicada (VLAN 250) o junto a servidores reales            │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  HONEYPOT (ej: Cowrie, HoneyD, T-Pot)                               │    │
│  │                                                                      │    │
│  │  Servicios simulados:                                                │    │
│  │  - SSH (puerto 22) → Captura credenciales                           │    │
│  │  - HTTP (puerto 80) → Detecta escaneos web                          │    │
│  │  - SMB (puerto 445) → Detecta ransomware/worms                      │    │
│  │  - RDP (puerto 3389) → Detecta intentos de acceso                   │    │
│  │                                                                      │    │
│  │  Alertas cuando:                                                     │    │
│  │  - Cualquier conexión (nadie legítimo debería conectar)             │    │
│  │  - Escaneo de puertos detectado                                      │    │
│  │  - Intento de explotación                                            │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  Objetivo: Detectar movimiento lateral de atacantes internos                │
│            Detectar malware propagándose por la red                         │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### NIDS (Network Intrusion Detection System)

```
                           INTERNET
                               │
                    ┌──────────▼──────────┐
                    │      FIREWALL       │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │    SPAN/TAP PORT    │◄──────┐
                    │    (Mirror tráfico) │       │
                    └──────────┬──────────┘       │
                               │                  │
                    ┌──────────▼──────────┐       │
                    │        NIDS         │       │
                    │   (Suricata/Snort)  │───────┘
                    │                     │
                    │  Análisis de:       │
                    │  - Firmas conocidas │
                    │  - Anomalías        │
                    │  - Protocolos       │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │   SIEM (Alertas)     │
                    └──────────────────────┘

Ubicación de sensores NIDS:
1. Entre Internet y Firewall (tráfico entrante)
2. Detrás del Firewall (tráfico que pasa)
3. En segmentos críticos (servidores, DMZ)
```

### Integración con SIEM

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SIEM                                            │
│                    (Security Information and Event Management)               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  FUENTES DE DATOS:                                                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │ Firewall │ │  NIDS    │ │ Honeypot │ │ Switches │ │Servidores│          │
│  │  Logs    │ │ Alertas  │ │ Alertas  │ │  Logs    │ │  Logs    │          │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘          │
│       └────────────┴────────────┴────────────┴────────────┘                 │
│                                    │                                         │
│                                    ▼                                         │
│                    ┌───────────────────────────────┐                        │
│                    │        CORRELACIÓN            │                        │
│                    │  - Reglas de detección        │                        │
│                    │  - Machine Learning           │                        │
│                    │  - Threat Intelligence        │                        │
│                    └───────────────┬───────────────┘                        │
│                                    │                                         │
│                                    ▼                                         │
│                    ┌───────────────────────────────┐                        │
│                    │         ALERTAS               │                        │
│                    │  - Dashboard tiempo real      │                        │
│                    │  - Email/SMS a SOC            │                        │
│                    │  - Tickets automáticos        │                        │
│                    └───────────────────────────────┘                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

Ejemplos de correlación:
- Login fallido + Login exitoso desde diferente IP = Posible compromiso
- Escaneo de puertos + Conexión a honeypot = Atacante interno
- Tráfico anómalo + Conexión a C&C conocido = Malware activo
```

---

## Diagrama General de la Infraestructura

```
                                        INTERNET
                                            │
                           ┌────────────────┼────────────────┐
                           │                │                │
                      ┌────▼────┐      ┌────▼────┐          │
                      │  ISP 1  │      │  ISP 2  │          │
                      │(Principal│      │(Backup) │          │
                      └────┬────┘      └────┬────┘          │
                           └────────┬───────┘               │
                                    │                       │
                         ┌──────────▼──────────┐            │
                         │   ROUTER BORDE      │            │
                         └──────────┬──────────┘            │
                                    │                       │
                         ┌──────────▼──────────┐            │
                         │     FIREWALL HA     │◄───────────┘
                         │  (FortiGate/Palo)   │        VPN Site-to-Site
                         └─────────┬───────────┘        (Sedes secundarias)
                                   │
            ┌──────────────────────┼──────────────────────┐
            │                      │                      │
   ┌────────▼────────┐   ┌────────▼────────┐   ┌────────▼────────┐
   │      DMZ        │   │   CORE SWITCH   │   │  VLAN GESTIÓN   │
   │  ┌──────────┐   │   │   (HA Stack)    │   │  ┌──────────┐   │
   │  │ WEB/MAIL │   │   └────────┬────────┘   │  │ MON/SIEM │   │
   │  │ VPN GW   │   │            │            │  │ RADIUS   │   │
   │  └──────────┘   │   ┌────────┴────────┐   │  └──────────┘   │
   └─────────────────┘   │                 │   └─────────────────┘
                         │                 │
              ┌──────────▼───┐    ┌────────▼──────────┐
              │ DISTRIBUCIÓN │    │   DISTRIBUCIÓN    │
              │  (Edificios) │    │      (CPD)        │
              └──────┬───────┘    └────────┬──────────┘
                     │                     │
        ┌────────────┼────────────┐   ┌────┴────┐
        │            │            │   │SERVIDORES│
    ┌───▼───┐   ┌───▼───┐   ┌───▼───┐│ DC, Mail │
    │ACCESO │   │ACCESO │   │ACCESO ││ Files,NAS│
    │(Users)│   │(VoIP) │   │ (IoT) ││ VoIP,etc │
    └───────┘   └───────┘   └───────┘└──────────┘

    VLANs:                           VLANs:
    30,40,50 (Usuarios)              20 (Servidores)
    60 (VoIP)                        10 (Gestión)
    70,80 (WiFi)
    90 (IoT)
```

---

## Resumen de Seguridad Implementada

| Capa | Medidas de Seguridad |
|------|---------------------|
| **Perímetro** | Firewall NG, IPS, VPN, DMZ |
| **Red** | VLANs, PVLAN, ACLs, 802.1X |
| **Acceso L2** | Port Security, DHCP Snooping, DAI, BPDU Guard |
| **Acceso Usuario** | 802.1X + RADIUS, MFA, NAC |
| **Endpoint** | Antivirus, EDR, actualizaciones |
| **Datos** | Cifrado, backup, clasificación |
| **Monitorización** | SIEM, NIDS, Honeypot, Logging |
| **Resiliencia** | Redundancia, HA, DR Plan |

---

## Navegación

⬅️ [Volver a Prácticas](README.md) | [Índice Wiki](../../INDEX.md)
