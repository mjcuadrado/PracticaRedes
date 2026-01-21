# Práctica 6: Segmentación de Red con VLANs

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Media |
| **Equipo** | Cisco SG300-10 |
| **Enfoque** | Diseño + Implementación de VLANs |
| **Basada en** | Práctica de Diseño de Infraestructura 2025 |

## Objetivo

Diseñar e implementar una segmentación de red mediante VLANs en el switch Cisco SG300, simulando un escenario empresarial con diferentes departamentos y verificar el aislamiento entre ellos.

---

## Roles del Equipo

| Rol | Responsabilidad |
|-----|-----------------|
| **🔵 DISEÑADOR** | Planificar VLANs, direccionamiento, documentar diseño |
| **🔴 IMPLEMENTADOR** | Configurar switch, probar conectividad, verificar aislamiento |

---

## Escenario

```
EMPRESA: MiniCorp (simulada en laboratorio)

Departamentos:
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   VLAN 10 - GESTIÓN         VLAN 20 - SERVIDORES            │
│   ┌─────────────┐           ┌─────────────┐                 │
│   │ Admin TIC   │           │ Servidor    │                 │
│   │ (GE1-GE2)   │           │ (GE3)       │                 │
│   └─────────────┘           └─────────────┘                 │
│                                                              │
│   VLAN 30 - USUARIOS        VLAN 40 - INVITADOS             │
│   ┌─────────────┐           ┌─────────────┐                 │
│   │ Empleados   │           │ Visitantes  │                 │
│   │ (GE4-GE6)   │           │ (GE7-GE8)   │                 │
│   └─────────────┘           └─────────────┘                 │
│                                                              │
│   TRUNK (GE9-GE10) → Conexión a router/otro switch          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## FASE 1: Diseño (25 minutos)

### 🔵 DISEÑADOR: Planificar la segmentación

#### Paso 1.1: Definir las VLANs

Completa la siguiente tabla:

| VLAN ID | Nombre | Propósito | Puertos | Red IP |
|---------|--------|-----------|---------|--------|
| 10 | Gestion | Administración de equipos | GE1-GE2 | 192.168.10.0/24 |
| 20 | Servidores | Servicios internos | GE3 | 192.168.20.0/24 |
| 30 | Usuarios | Empleados | GE4-GE6 | 192.168.30.0/24 |
| 40 | Invitados | WiFi/Visitantes | GE7-GE8 | 192.168.40.0/24 |
| 99 | Native | Trunk (sin uso) | GE9-GE10 | - |

#### Paso 1.2: Diseñar el direccionamiento IP

```
VLAN 10 (Gestión):
- Red: 192.168.10.0/24
- Gateway: 192.168.10.1
- Switch: 192.168.10.237
- Rango admin: 192.168.10.10-50

VLAN 20 (Servidores):
- Red: 192.168.20.0/24
- Gateway: 192.168.20.1
- Servidor 1: 192.168.20.10
- Servidor 2: 192.168.20.11

VLAN 30 (Usuarios):
- Red: 192.168.30.0/24
- Gateway: 192.168.30.1
- DHCP: 192.168.30.100-200

VLAN 40 (Invitados):
- Red: 192.168.40.0/24
- Gateway: 192.168.40.1
- DHCP: 192.168.40.100-200
```

#### Paso 1.3: Documentar matriz de comunicación

| Desde/Hacia | Gestión | Servidores | Usuarios | Invitados |
|-------------|---------|------------|----------|-----------|
| **Gestión** | ✅ | ✅ | ✅ | ✅ |
| **Servidores** | ✅ | ✅ | ✅ | ❌ |
| **Usuarios** | ❌ | ✅ | ✅ | ❌ |
| **Invitados** | ❌ | ❌ | ❌ | ❌ (Solo Internet) |

**Captura:** Diagrama de diseño completado

---

## FASE 2: Implementación de VLANs (35 minutos)

### 🔴 IMPLEMENTADOR: Configurar el switch

#### Paso 2.1: Acceder al switch

1. Navegador: `https://192.168.1.237`
2. Iniciar sesión

#### Paso 2.2: Crear las VLANs

**Ruta:** VLAN Management → VLAN Settings

1. Click en **Add**
2. Crear VLAN 10:
   - VLAN ID: `10`
   - VLAN Name: `Gestion`
   - Click **Apply**
3. Repetir para VLANs 20, 30, 40, 99

**Captura de pantalla:** Lista de VLANs creadas

#### Paso 2.3: Asignar puertos a VLANs

**Ruta:** VLAN Management → Port to VLAN

Para cada VLAN, seleccionar y configurar:

**VLAN 10 (Gestión):**
- GE1: Untagged (Access)
- GE2: Untagged (Access)

**VLAN 20 (Servidores):**
- GE3: Untagged (Access)

**VLAN 30 (Usuarios):**
- GE4: Untagged (Access)
- GE5: Untagged (Access)
- GE6: Untagged (Access)

**VLAN 40 (Invitados):**
- GE7: Untagged (Access)
- GE8: Untagged (Access)

**VLAN 99 + Trunk:**
- GE9: Tagged (todas las VLANs)
- GE10: Tagged (todas las VLANs)

#### Paso 2.4: Configurar puertos de acceso

**Ruta:** VLAN Management → Interface Settings

Para cada puerto de acceso (GE1-GE8):
1. Seleccionar puerto
2. Interface VLAN Mode: **Access**
3. PVID: [VLAN correspondiente]
4. Click **Apply**

#### Paso 2.5: Configurar puertos trunk

Para puertos GE9, GE10:
1. Interface VLAN Mode: **Trunk**
2. Native VLAN: **99**
3. Click **Apply**

**Captura de pantalla:** Configuración de Interface Settings

#### Paso 2.6: Configurar IP de gestión del switch

**Ruta:** IP Configuration → IPv4 Interface

1. Seleccionar VLAN 10
2. IP Address: `192.168.10.237`
3. Mask: `255.255.255.0`
4. Click **Apply**

> **Nota:** Después de esto, accederás al switch desde 192.168.10.237

---

## FASE 3: Verificación de Aislamiento (30 minutos)

### 🔴 IMPLEMENTADOR + 🔵 DISEÑADOR: Probar juntos

#### Paso 3.1: Configurar equipos de prueba

Conectar PCs a diferentes puertos y asignar IPs:

| PC | Puerto | VLAN | IP Manual |
|----|--------|------|-----------|
| PC1 | GE4 | 30 (Usuarios) | 192.168.30.10 |
| PC2 | GE5 | 30 (Usuarios) | 192.168.30.11 |
| PC3 | GE7 | 40 (Invitados) | 192.168.40.10 |

```bash
# En PC1 (VLAN 30)
sudo ifconfig en0 192.168.30.10 netmask 255.255.255.0

# En PC3 (VLAN 40)
sudo ifconfig en0 192.168.40.10 netmask 255.255.255.0
```

#### Paso 3.2: Probar comunicación dentro de la misma VLAN

Desde PC1 (VLAN 30):
```bash
# Ping a PC2 (misma VLAN) - DEBE FUNCIONAR
ping -c 4 192.168.30.11
```

**Resultado esperado:** ✅ Ping exitoso (misma VLAN)

#### Paso 3.3: Probar aislamiento entre VLANs

Desde PC1 (VLAN 30):
```bash
# Ping a PC3 (VLAN 40) - NO DEBE FUNCIONAR
ping -c 4 192.168.40.10
```

**Resultado esperado:** ❌ Ping falla (VLANs diferentes, sin routing)

```bash
# Ping al switch en VLAN Gestión - NO DEBE FUNCIONAR
ping -c 4 192.168.10.237
```

**Resultado esperado:** ❌ Ping falla (VLANs diferentes)

#### Paso 3.4: Verificar con Wireshark

```bash
# Capturar tráfico en PC1
wireshark -k -i en0
```

Observar que:
- Solo se ve tráfico de VLAN 30
- No se ve tráfico de otras VLANs
- Los broadcasts están contenidos

**Captura de pantalla:** Wireshark mostrando solo tráfico de una VLAN

#### Paso 3.5: Verificar configuración en el switch

**Ruta:** VLAN Management → Port VLAN Membership

Revisar que cada puerto muestra la VLAN correcta.

**Captura de pantalla:** Membresía de puertos

---

## FASE 4: Seguridad Adicional (20 minutos)

### 🔴 IMPLEMENTADOR: Añadir controles de seguridad

#### Paso 4.1: Habilitar Port Security en puertos de usuario

**Ruta:** Security → Port Security → Interface Settings

Para puertos GE4-GE8 (usuarios e invitados):
1. Status: **Lock**
2. Learning Mode: **Limited Dynamic Lock**
3. Max Addresses: **2**
4. Action: **Discard and Trap**
5. Click **Apply**

#### Paso 4.2: Habilitar DHCP Snooping (si hay DHCP)

**Ruta:** IP Configuration → DHCP Snooping → Properties

1. DHCP Snooping Status: **Enable**
2. En Interface Settings, marcar puerto del router/DHCP como **Trusted**

#### Paso 4.3: Configurar VLAN de Invitados como PVLAN (Opcional)

Si el SG300 soporta PVLAN:

**Ruta:** VLAN Management → Private VLAN Settings

1. VLAN 40: Tipo **Isolated**
2. Esto evita que invitados se vean entre sí

---

## FASE 5: Documentación (10 minutos)

### Ambos: Completar documentación

#### Tabla de configuración final

| Puerto | Modo | VLAN(s) | Port Security | Notas |
|--------|------|---------|---------------|-------|
| GE1 | Access | 10 | No | Admin TIC |
| GE2 | Access | 10 | No | Admin TIC |
| GE3 | Access | 20 | No | Servidor |
| GE4 | Access | 30 | Sí (2 MACs) | Usuario |
| GE5 | Access | 30 | Sí (2 MACs) | Usuario |
| GE6 | Access | 30 | Sí (2 MACs) | Usuario |
| GE7 | Access | 40 | Sí (2 MACs) | Invitado |
| GE8 | Access | 40 | Sí (2 MACs) | Invitado |
| GE9 | Trunk | All | No | Uplink |
| GE10 | Trunk | All | No | Uplink |

#### Mapeo a la práctica de diseño de infraestructura

| Aspecto del Diseño | Implementación en Laboratorio |
|--------------------|------------------------------|
| VLANs por departamento | 4 VLANs creadas |
| VLAN de Gestión | VLAN 10, acceso restringido |
| Segmentación usuarios/invitados | VLANs 30 y 40 separadas |
| Protección L2 | Port Security habilitado |
| Trunk para interconexión | GE9-GE10 configurados |

---

## Entregables

### 🔵 DISEÑADOR
- [ ] Diagrama de VLANs con puertos asignados
- [ ] Tabla de direccionamiento IP
- [ ] Matriz de comunicación entre VLANs

### 🔴 IMPLEMENTADOR
- [ ] Captura: Lista de VLANs creadas
- [ ] Captura: Port to VLAN configurado
- [ ] Captura: Interface Settings
- [ ] Captura: Ping exitoso (misma VLAN)
- [ ] Captura: Ping fallido (entre VLANs)

### Ambos
- [ ] Tabla de configuración final
- [ ] Relación con práctica de diseño de infraestructura

---

## Troubleshooting

### No hay comunicación dentro de la misma VLAN
- Verificar que ambos puertos tienen la misma VLAN asignada
- Verificar que el modo es "Access" y no "Trunk"
- Comprobar PVID (debe ser la VLAN correcta)

### Hay comunicación entre VLANs (no debería)
- Sin router, las VLANs no se comunican
- Si hay comunicación, verificar que no están en la misma VLAN
- Revisar si hay una interfaz L3 haciendo routing

### No puedo acceder al switch después de cambiar IP
- El switch ahora está en la IP de VLAN Gestión
- Conectar PC a puerto de VLAN 10
- Configurar IP en el rango de VLAN 10

---

## Relación con Frameworks de Seguridad

| Framework | Control | Implementación |
|-----------|---------|----------------|
| **NIST** | PR.AC-5 | Segmentación de red por VLANs |
| **CIS** | Control 14 | Segmentación basada en necesidad |
| **ISO 27001** | A.13.1.3 | Segregación en redes |

---

## Navegación

⬅️ [Práctica 5: Rogue DHCP](practica_05_rogue_dhcp.md) | [Práctica 7: Control de Acceso 802.1X →](practica_07_control_acceso_8021x.md)
