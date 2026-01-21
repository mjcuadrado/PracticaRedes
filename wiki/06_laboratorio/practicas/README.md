# Prácticas de Laboratorio - Seguridad en Redes Cisco

## Información General

- **Duración:** 2 horas cada práctica
- **Modalidad:** Trabajo en parejas (Atacante + Defensor)
- **Equipamiento:** Switch Cisco SG300-10, Router Cisco RV120W, PCs con Linux/macOS
- **Nivel:** Principiantes en Cisco (nunca han tocado un switch Cisco)

---

## Resumen de Prácticas

### Prácticas de Ataque/Defensa (Laboratorio)

| # | Nombre | Dificultad | Ataque | Defensa | Herramientas |
|---|--------|------------|--------|---------|--------------|
| 1 | [DHCP Starvation](practica_01_dhcp_starvation.md) | Baja | DHCP Starvation | DHCP Snooping | Yersinia |
| 2 | [ARP Poisoning MITM](practica_02_arp_poisoning.md) | Media | ARP Spoofing | DAI | Ettercap |
| 3 | [Ciclo NIST](practica_03_ciclo_nist.md) | Media-Alta | Varios | Varios | Varias |
| 4 | [Port Security](practica_04_port_security.md) | Baja | MAC Spoofing | Port Security | Comandos básicos |
| 5 | [Rogue DHCP](practica_05_rogue_dhcp.md) | Media | DHCP Spoofing | DHCP Snooping | Ettercap/dnsmasq |

### Prácticas de Diseño/Configuración (Basadas en Práctica 2025)

| # | Nombre | Dificultad | Enfoque | Tipo |
|---|--------|------------|---------|------|
| 6 | [Segmentación VLANs](practica_06_segmentacion_vlans.md) | Media | Diseño + Implementación VLANs | Config |
| 7 | [Control Acceso 802.1X](practica_07_control_acceso_8021x.md) | Media-Alta | NAC con RADIUS | Config |
| 8 | [Hardening Completo](practica_08_hardening_completo.md) | Media-Alta | Securización integral | Config + Test |

### Solución Práctica de Diseño de Infraestructura 2025

| Documento | Descripción |
|-----------|-------------|
| [SOLUCIÓN Diseño Infraestructura](SOLUCION_practica_diseno_infraestructura.md) | Solución completa de la práctica teórica |

---

## Roles del Equipo

### 🔴 ATACANTE
- Ejecuta los ataques con las herramientas indicadas
- Documenta comandos utilizados
- Captura evidencias del ataque (Wireshark, terminal)
- Verifica impacto en la víctima
- Completa la plantilla de ataque

### 🔵 DEFENSOR
- Accede y configura el switch Cisco
- Implementa los controles de seguridad
- Monitorea logs y estadísticas
- Verifica que las defensas funcionan
- Completa la plantilla de defensa

---

## Estructura de Cada Práctica

```
FASE 1: Reconocimiento (15-20 min)
├── Identificar equipos y configuración
├── Acceder al switch
└── Verificar estado inicial

FASE 2: Ataque SIN Defensa (20-25 min)
├── 🔵 Preparar captura (Wireshark)
├── 🔴 Ejecutar ataque
└── 🔵 Documentar impacto

FASE 3: Implementar Defensa (30-40 min)
└── 🔵 Configurar controles en el switch

FASE 4: Verificar Defensa (20-30 min)
├── 🔴 Re-ejecutar ataque
├── 🔵 Verificar bloqueo
└── 🔵 Revisar logs

FASE 5: Documentación (15-35 min)
├── 🔴 Plantilla de ataque
├── 🔵 Plantilla de defensa
└── Ambos: Tabla comparativa + NIST
```

---

## Recomendación por Situación

### Si nunca han tocado un Cisco
**Empezar con:** [Práctica 4: Port Security](practica_04_port_security.md)
- Es la más sencilla
- Familiariza con la interfaz del switch
- No requiere herramientas de ataque complejas

### Si quieren algo rápido y visual
**Elegir:** [Práctica 1: DHCP Starvation](practica_01_dhcp_starvation.md)
- El ataque es muy visual (cientos de paquetes)
- La defensa tiene efecto inmediato
- Yersinia es fácil de usar

### Si quieren MITM clásico
**Elegir:** [Práctica 2: ARP Poisoning](practica_02_arp_poisoning.md)
- Es el ataque más conocido
- Permite capturar tráfico real
- Combina DHCP Snooping + DAI

### Si quieren algo completo para el examen
**Elegir:** [Práctica 3: Ciclo NIST](practica_03_ciclo_nist.md)
- Cubre las 5 funciones del framework
- Incluye documentación estructurada
- Demuestra comprensión integral

### Si quieren entender servidores DHCP falsos
**Elegir:** [Práctica 5: Rogue DHCP](practica_05_rogue_dhcp.md)
- Muy relevante para seguridad de redes
- Demuestra cómo un atacante se convierte en gateway

### Si la práctica es de DISEÑO de infraestructura (como 2025)
**Elegir:** [Práctica 6: Segmentación VLANs](practica_06_segmentacion_vlans.md)
- Diseño + implementación práctica
- Relaciona con la práctica teórica de diseño
- Incluye verificación de aislamiento

### Si piden control de acceso / NAC
**Elegir:** [Práctica 7: Control Acceso 802.1X](practica_07_control_acceso_8021x.md)
- Requiere servidor RADIUS (FreeRADIUS)
- Asignación dinámica de VLAN
- Más compleja pero muy completa

### Si piden securizar completamente el switch
**Elegir:** [Práctica 8: Hardening Completo](practica_08_hardening_completo.md)
- Aplica TODAS las defensas
- Verifica con ataques reales
- Checklist completo de seguridad

---

## Checklist Pre-Práctica

### Equipamiento necesario
- [ ] 2 PCs (uno para atacante, otro para defensor)
- [ ] Switch Cisco SG300-10 accesible en 192.168.1.237
- [ ] Router como servidor DHCP en 192.168.1.1
- [ ] Conexión de red funcional

### Software necesario (PC Atacante)
- [ ] Yersinia instalado (`brew install yersinia` / `apt install yersinia`)
- [ ] Ettercap instalado (`brew install ettercap` / `apt install ettercap-graphical`)
- [ ] Wireshark instalado
- [ ] nmap instalado

### Software necesario (PC Defensor)
- [ ] Navegador web (para acceder al switch)
- [ ] Wireshark instalado
- [ ] Terminal con acceso a comandos de red

### Credenciales
- [ ] Acceso al switch verificado
- [ ] IP del switch: 192.168.1.237
- [ ] Protocolo: HTTPS

---

## Entregables Esperados

Cada práctica debe generar:

1. **Capturas de pantalla**
   - Ataque en ejecución
   - Impacto del ataque (sin defensa)
   - Configuración de la defensa
   - Bloqueo del ataque (con defensa)
   - Logs del switch

2. **Documentos**
   - Plantilla de ataque completada
   - Plantilla de defensa completada
   - Tabla comparativa antes/después
   - Mapeo a funciones NIST

3. **Conclusiones**
   - Efectividad de la defensa
   - Lecciones aprendidas

---

## Navegación

### Prácticas de Ataque/Defensa
| Práctica | Descripción |
|----------|-------------|
| [Práctica 1](practica_01_dhcp_starvation.md) | DHCP Starvation - Agotar pool DHCP |
| [Práctica 2](practica_02_arp_poisoning.md) | ARP Poisoning - MITM en capa 2 |
| [Práctica 3](practica_03_ciclo_nist.md) | Ciclo completo NIST Framework |
| [Práctica 4](practica_04_port_security.md) | Port Security - Control de MACs |
| [Práctica 5](practica_05_rogue_dhcp.md) | Rogue DHCP - Servidor DHCP falso |

### Prácticas de Diseño/Configuración
| Práctica | Descripción |
|----------|-------------|
| [Práctica 6](practica_06_segmentacion_vlans.md) | Segmentación de red con VLANs |
| [Práctica 7](practica_07_control_acceso_8021x.md) | Control de acceso con 802.1X y RADIUS |
| [Práctica 8](practica_08_hardening_completo.md) | Hardening completo del switch |

### Material de Referencia
| Documento | Descripción |
|-----------|-------------|
| [SOLUCIÓN Diseño Infraestructura](SOLUCION_practica_diseno_infraestructura.md) | Solución práctica teórica 2025 |

⬅️ [Volver a Guía Práctica](../guia_practica.md) | [Volver al Índice](../../INDEX.md)
