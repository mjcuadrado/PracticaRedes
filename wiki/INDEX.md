# Wiki Práctica de Redes - Seguridad en Cisco

## Navegación Rápida

### Por Tarea
| Quiero... | Ir a |
|-----------|------|
| **TEORÍA** | |
| Entender NIST Framework | [NIST Framework](01_fundamentos/nist_framework.md) |
| Entender CIS Controls | [CIS Controls](01_fundamentos/cis_controls.md) |
| Entender ISO 27001 | [ISO 27001](01_fundamentos/iso_27001.md) |
| Ver conceptos básicos | [Conceptos](01_fundamentos/conceptos.md) |
| **CONFIGURACIÓN** | |
| Acceder al switch | [Acceso Inicial](02_configuracion/acceso_inicial/acceso_switch.md) |
| Configurar Port Security | [Port Security](02_configuracion/seguridad/port_security.md) |
| Configurar 802.1X/RADIUS | [802.1X RADIUS](02_configuracion/seguridad/802_1x_radius.md) |
| Configurar PVLAN | [Private VLAN](02_configuracion/seguridad/pvlan.md) |
| Proteger contra DHCP attacks | [DHCP Snooping](02_configuracion/seguridad/dhcp_snooping.md) |
| Proteger contra ARP attacks | [ARP Inspection](02_configuracion/seguridad/arp_inspection.md) |
| **ATAQUE** | |
| Descubrir hosts en la red | [Reconocimiento](03_ataque/reconocimiento/descubrimiento.md) |
| Ejecutar ARP Poisoning | [ARP Poisoning](03_ataque/explotacion/arp_poisoning.md) |
| Ejecutar DHCP Attacks | [DHCP Attacks](03_ataque/explotacion/dhcp_attacks.md) |
| Usar Ettercap | [Ettercap](03_ataque/herramientas/ettercap.md) |
| Usar Yersinia | [Yersinia](03_ataque/herramientas/yersinia.md) |
| **DEFENSA** | |
| Checklist de hardening | [Checklist Seguridad](04_defensa/hardening/checklist_seguridad.md) |
| Verificar que defensas funcionan | [Verificación](04_defensa/monitoreo/verificacion.md) |
| **REFERENCIA** | |
| Ver comandos rápidos | [Cheatsheet](05_comandos/cheatsheet.md) |
| Ver guía de la práctica | [Guía Práctica](06_laboratorio/guia_practica.md) |
| Plantilla para documentar | [Plantillas](06_laboratorio/plantillas/plantilla_configuracion.md) |

---

## Estructura de la Wiki

### 01. Fundamentos
- [Conceptos](01_fundamentos/conceptos.md) - Equipos, tecnologías, credenciales
- [NIST Framework](01_fundamentos/nist_framework.md) - Las 5 funciones, categorías, aplicación
- [CIS Controls](01_fundamentos/cis_controls.md) - Los 20 controles críticos
- [ISO 27001](01_fundamentos/iso_27001.md) - Controles de seguridad de la información

### 02. Configuración
- **Acceso Inicial**
  - [Acceso al Switch](02_configuracion/acceso_inicial/acceso_switch.md)
- **Seguridad**
  - [Port Security](02_configuracion/seguridad/port_security.md)
  - [802.1X con RADIUS](02_configuracion/seguridad/802_1x_radius.md)
  - [Private VLAN](02_configuracion/seguridad/pvlan.md)
  - [DHCP Snooping](02_configuracion/seguridad/dhcp_snooping.md)
  - [ARP Inspection](02_configuracion/seguridad/arp_inspection.md)

### 03. Ataque
- **Reconocimiento**
  - [Descubrimiento de Red](03_ataque/reconocimiento/descubrimiento.md)
- **Explotación**
  - [Ataques DHCP](03_ataque/explotacion/dhcp_attacks.md)
  - [ARP Poisoning](03_ataque/explotacion/arp_poisoning.md)
- **Herramientas**
  - [Ettercap](03_ataque/herramientas/ettercap.md)
  - [Yersinia](03_ataque/herramientas/yersinia.md)

### 04. Defensa
- **Hardening**
  - [Checklist de Seguridad](04_defensa/hardening/checklist_seguridad.md)
- **Monitoreo**
  - [Verificación](04_defensa/monitoreo/verificacion.md)

### 05. Comandos
- [Cheatsheet Rápido](05_comandos/cheatsheet.md)

### 06. Laboratorio
- [Guía de la Práctica](06_laboratorio/guia_practica.md)
- **Plantillas**
  - [Plantilla Configuración](06_laboratorio/plantillas/plantilla_configuracion.md)
  - [Plantilla Ataque](06_laboratorio/plantillas/plantilla_ataque.md)
  - [Plantilla Defensa](06_laboratorio/plantillas/plantilla_defensa.md)

---

## Datos del Laboratorio

| Equipo | IP | Acceso |
|--------|----|--------|
| Switch Cisco SG300-10 | 192.168.1.237 | HTTPS Web |
| Router Cisco RV 120W | 192.168.1.1 | |

## Flujo de la Práctica

```
1. RECONOCIMIENTO (15 min)
   └── Acceder al switch, explorar configuración

2. DEMOSTRAR VULNERABILIDADES (20 min)
   └── Ejecutar ataques SIN defensas

3. IMPLEMENTAR DEFENSAS (40 min)
   └── Port Security → DHCP Snooping → ARP Inspection

4. VERIFICAR DEFENSAS (30 min)
   └── Re-ejecutar ataques, verificar bloqueo

5. DOCUMENTAR (15 min)
   └── Usar plantillas para evidencias
```
