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
| **PRÁCTICAS DE EXAMEN (Ataque/Defensa)** | |
| Práctica fácil (DHCP Starvation) | [Práctica 1](06_laboratorio/practicas/practica_01_dhcp_starvation.md) |
| Práctica fácil (Port Security) | [Práctica 4](06_laboratorio/practicas/practica_04_port_security.md) |
| Práctica media (ARP Poisoning) | [Práctica 2](06_laboratorio/practicas/practica_02_arp_poisoning.md) |
| Práctica media (Rogue DHCP) | [Práctica 5](06_laboratorio/practicas/practica_05_rogue_dhcp.md) |
| Práctica completa (Ciclo NIST) | [Práctica 3](06_laboratorio/practicas/practica_03_ciclo_nist.md) |
| **PRÁCTICAS DE DISEÑO/CONFIG** | |
| Segmentación con VLANs | [Práctica 6](06_laboratorio/practicas/practica_06_segmentacion_vlans.md) |
| Control Acceso 802.1X | [Práctica 7](06_laboratorio/practicas/practica_07_control_acceso_8021x.md) |
| Hardening Completo | [Práctica 8](06_laboratorio/practicas/practica_08_hardening_completo.md) |
| **SOLUCIÓN PRÁCTICA 2025** | |
| Diseño Infraestructura (resuelto) | [Solución](06_laboratorio/practicas/SOLUCION_practica_diseno_infraestructura.md) |
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
- **Prácticas de Ataque/Defensa** (2 horas, trabajo en parejas)
  - [Práctica 1: DHCP Starvation](06_laboratorio/practicas/practica_01_dhcp_starvation.md) - Dificultad: Baja
  - [Práctica 2: ARP Poisoning MITM](06_laboratorio/practicas/practica_02_arp_poisoning.md) - Dificultad: Media
  - [Práctica 3: Ciclo NIST Completo](06_laboratorio/practicas/practica_03_ciclo_nist.md) - Dificultad: Media-Alta
  - [Práctica 4: Port Security Básico](06_laboratorio/practicas/practica_04_port_security.md) - Dificultad: Baja
  - [Práctica 5: Rogue DHCP Server](06_laboratorio/practicas/practica_05_rogue_dhcp.md) - Dificultad: Media
- **Prácticas de Diseño/Configuración** (basadas en práctica 2025)
  - [Práctica 6: Segmentación VLANs](06_laboratorio/practicas/practica_06_segmentacion_vlans.md) - Dificultad: Media
  - [Práctica 7: Control Acceso 802.1X](06_laboratorio/practicas/practica_07_control_acceso_8021x.md) - Dificultad: Media-Alta
  - [Práctica 8: Hardening Completo](06_laboratorio/practicas/practica_08_hardening_completo.md) - Dificultad: Media-Alta
- **Solución Práctica Teórica 2025**
  - [SOLUCIÓN: Diseño Infraestructura](06_laboratorio/practicas/SOLUCION_practica_diseno_infraestructura.md)
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

---

## Prácticas Propuestas para Examen

Todas las prácticas están diseñadas para **2 horas** y trabajo **en parejas**.

### Tipo 1: Ataque/Defensa (Atacante + Defensor)

| # | Práctica | Dificultad | Ataque | Defensa | Probabilidad |
|---|----------|------------|--------|---------|--------------|
| 1 | [DHCP Starvation](06_laboratorio/practicas/practica_01_dhcp_starvation.md) | Baja | Yersinia | DHCP Snooping | 85% |
| 2 | [ARP Poisoning MITM](06_laboratorio/practicas/practica_02_arp_poisoning.md) | Media | Ettercap | DAI (ARP Inspection) | 80% |
| 3 | [Ciclo NIST](06_laboratorio/practicas/practica_03_ciclo_nist.md) | Media-Alta | Varios | Varios + Framework | 60% |
| 4 | [Port Security](06_laboratorio/practicas/practica_04_port_security.md) | Baja | Cambio de MAC | Port Security | 50% |
| 5 | [Rogue DHCP](06_laboratorio/practicas/practica_05_rogue_dhcp.md) | Media | Ettercap/dnsmasq | DHCP Snooping | 70% |

### Tipo 2: Diseño/Configuración (Diseñador + Implementador)

| # | Práctica | Dificultad | Enfoque | Probabilidad |
|---|----------|------------|---------|--------------|
| 6 | [Segmentación VLANs](06_laboratorio/practicas/practica_06_segmentacion_vlans.md) | Media | VLANs + Aislamiento | 75% |
| 7 | [Control Acceso 802.1X](06_laboratorio/practicas/practica_07_control_acceso_8021x.md) | Media-Alta | NAC + RADIUS | 40% |
| 8 | [Hardening Completo](06_laboratorio/practicas/practica_08_hardening_completo.md) | Media-Alta | Securización integral | 65% |

### Tipo 3: Teórico (Diseño de Infraestructura)

| Documento | Descripción |
|-----------|-------------|
| [SOLUCIÓN Práctica 2025](06_laboratorio/practicas/SOLUCION_practica_diseno_infraestructura.md) | Diseño completo de red empresarial |

### Roles por Tipo de Práctica
- **Tipo 1:** 🔴 ATACANTE + 🔵 DEFENSOR
- **Tipo 2:** 🔵 DISEÑADOR + 🔴 IMPLEMENTADOR
- **Tipo 3:** Trabajo individual o en grupo (documentación)

---

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
