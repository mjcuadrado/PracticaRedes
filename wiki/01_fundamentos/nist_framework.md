# NIST Cybersecurity Framework

## Origen
- Creado por el National Institute of Standards and Technology (NIST) de EE.UU.
- Basado en la Orden Ejecutiva 13636
- Desarrollado en cooperación con expertos del sector privado
- Aplicable a entidades gubernamentales y privadas

## Estructura del Framework

El NIST Framework tiene **3 partes principales**:
1. **Núcleo (Core)** - Las 5 funciones y sus categorías
2. **Niveles de Implementación (Tiers)** - Madurez de la organización
3. **Perfiles** - Estado actual vs estado objetivo

---

## Las 5 Funciones del NIST

```
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│ IDENTIFICAR │ → │  PROTEGER   │ → │  DETECTAR   │ → │  RESPONDER  │ → │  RECUPERAR  │
│     (ID)    │   │    (PR)     │   │    (DE)     │   │    (RS)     │   │    (RC)     │
└─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘
```

### 1. IDENTIFICAR (ID)
**Objetivo**: Comprender el contexto empresarial, los activos y los riesgos

| Categoría | ID | Descripción |
|-----------|-----|-------------|
| Gestión de activos | ID.AM | Inventario de hardware, software, datos |
| Entorno empresarial | ID.BE | Misión, objetivos, actividades |
| Gobernanza | ID.GV | Políticas, procedimientos, procesos |
| Evaluación de riesgos | ID.RA | Identificación de vulnerabilidades |
| Estrategia de gestión de riesgos | ID.RM | Tolerancia al riesgo |
| Gestión de cadena de suministro | ID.SC | Riesgos de terceros |

**Aplicación en el laboratorio**:
- Identificar equipos de red (switch, router)
- Documentar IPs y MACs
- Inventariar puertos y servicios

### 2. PROTEGER (PR)
**Objetivo**: Implementar salvaguardas para garantizar la entrega de servicios

| Categoría | ID | Descripción |
|-----------|-----|-------------|
| Gestión de identidad y control de acceso | PR.AC | Autenticación, autorización |
| Conciencia y capacitación | PR.AT | Formación de usuarios |
| Seguridad de datos | PR.DS | Protección de información |
| Procesos de protección | PR.IP | Políticas de seguridad |
| Mantenimiento | PR.MA | Actualizaciones, parches |
| Tecnología protectora | PR.PT | Firewalls, IDS, cifrado |

**Aplicación en el laboratorio**:
- Port Security
- 802.1X / RADIUS
- DHCP Snooping
- ARP Inspection
- PVLAN

### 3. DETECTAR (DE)
**Objetivo**: Identificar la ocurrencia de eventos de ciberseguridad

| Categoría | ID | Descripción |
|-----------|-----|-------------|
| Anomalías y eventos | DE.AE | Detección de actividad anómala |
| Vigilancia continua de seguridad | DE.CM | Monitoreo de red |
| Procesos de detección | DE.DP | Procedimientos de detección |

**Aplicación en el laboratorio**:
- Logs del switch
- Wireshark para análisis de tráfico
- Detección de ataques DHCP/ARP

### 4. RESPONDER (RS)
**Objetivo**: Tomar acción ante un incidente de ciberseguridad detectado

| Categoría | ID | Descripción |
|-----------|-----|-------------|
| Planificación de respuesta | RS.RP | Plan de respuesta a incidentes |
| Comunicaciones | RS.CO | Coordinación interna/externa |
| Análisis | RS.AN | Investigación del incidente |
| Mitigación | RS.MI | Contención del incidente |
| Mejoras | RS.IM | Lecciones aprendidas |

**Aplicación en el laboratorio**:
- Bloquear puertos comprometidos
- Aislar equipos atacantes
- Documentar el incidente

### 5. RECUPERAR (RC)
**Objetivo**: Restaurar capacidades afectadas por un incidente

| Categoría | ID | Descripción |
|-----------|-----|-------------|
| Planificación de recuperación | RC.RP | Plan de recuperación |
| Mejoras | RC.IM | Actualización de planes |
| Comunicaciones | RC.CO | Gestión de reputación |

**Aplicación en el laboratorio**:
- Restaurar configuración del switch
- Verificar conectividad
- Documentar mejoras

---

## Niveles de Implementación (Tiers)

| Nivel | Nombre | Descripción |
|-------|--------|-------------|
| Tier 1 | Parcial | Gestión de riesgos ad-hoc, reactivo |
| Tier 2 | Informado sobre riesgos | Procesos aprobados pero no organizacionales |
| Tier 3 | Repetible | Políticas formales, actualizaciones regulares |
| Tier 4 | Adaptativo | Mejora continua basada en lecciones aprendidas |

---

## Relación NIST con la Práctica

| Función NIST | Actividad del Laboratorio |
|--------------|---------------------------|
| **IDENTIFICAR** | Reconocimiento de red, descubrimiento de hosts |
| **PROTEGER** | Configurar Port Security, DHCP Snooping, ARP Inspection |
| **DETECTAR** | Analizar tráfico con Wireshark, revisar logs |
| **RESPONDER** | Bloquear ataques, aislar atacante |
| **RECUPERAR** | Restaurar configuración, documentar |

---

## Referencias Informativas

El NIST referencia otros estándares:
- **CIS Controls**
- **ISO/IEC 27001**
- **COBIT 5**
- **NIST SP 800-53**

---

## Ver también

- [CIS Controls](cis_controls.md) - Los 20 controles críticos (mapeo con NIST)
- [ISO 27001](iso_27001.md) - Controles de seguridad de la información
- [Checklist de Seguridad](../04_defensa/hardening/checklist_seguridad.md) - Aplicación práctica

---

[← Volver al Índice](../INDEX.md)
