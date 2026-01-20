# CIS Critical Security Controls

## Origen
- Desarrollado por el Center for Internet Security (CIS)
- Conjunto de 20 controles de ciberseguridad
- Prácticas de mitigación basadas en ataques reales
- Aplicable a cualquier organización

## Categorías de Controles

```
┌────────────────────┬────────────────────┬────────────────────┐
│      BÁSICA        │    PRIMORDIAL      │  ORGANIZACIONAL    │
│   Controles 1-6    │   Controles 7-16   │  Controles 17-20   │
│                    │                    │                    │
│ Esenciales para    │ Beneficios         │ Enfoque en el      │
│ ciberseguridad     │ avanzados          │ factor humano      │
└────────────────────┴────────────────────┴────────────────────┘
```

## Los 20 Controles CIS

### Controles Básicos (1-6)

| # | Control | Descripción |
|---|---------|-------------|
| 1 | **Inventario de dispositivos** | Gestionar activamente todos los dispositivos de hardware en la red |
| 2 | **Inventario de software** | Gestionar activamente todo software instalado en la red |
| 3 | **Gestión continua de vulnerabilidades** | Escaneo y remediación de vulnerabilidades |
| 4 | **Control de privilegios administrativos** | Gestión de cuentas privilegiadas |
| 5 | **Configuración segura** | Hardening de dispositivos y software |
| 6 | **Mantenimiento y análisis de logs** | Registro y auditoría de eventos |

### Controles Primordiales (7-16)

| # | Control | Descripción |
|---|---------|-------------|
| 7 | **Protección de email y navegador** | Defensa contra phishing y malware web |
| 8 | **Defensa contra malware** | Antivirus, EDR, control de ejecución |
| 9 | **Limitación de puertos y servicios** | Reducir superficie de ataque |
| 10 | **Capacidad de recuperación de datos** | Backups y restauración |
| 11 | **Configuración segura de red** | Firewalls, routers, switches |
| 12 | **Defensa de borde** | Segmentación, IDS/IPS |
| 13 | **Protección de datos** | Cifrado, DLP |
| 14 | **Control de acceso basado en necesidad** | Principio de mínimo privilegio |
| 15 | **Control de acceso inalámbrico** | Seguridad WiFi |
| 16 | **Monitoreo y control de cuentas** | Gestión del ciclo de vida de cuentas |

### Controles Organizacionales (17-20)

| # | Control | Descripción |
|---|---------|-------------|
| 17 | **Programa de concienciación** | Capacitación en seguridad |
| 18 | **Seguridad del software de aplicación** | Desarrollo seguro |
| 19 | **Gestión de incidentes** | Respuesta a incidentes |
| 20 | **Pruebas de penetración** | Red team, pentesting |

---

## Principios Fundamentales CIS

1. **La ofensiva informa a la defensiva**
   - Aprender de vulnerabilidades y ataques
   - Base de conocimiento continuo

2. **Priorizar**
   - Controles que mayor mitigación ofrecen
   - Efectivos en relación al tiempo

3. **Mediciones y métricas**
   - Lenguaje común para TI, auditores, ejecutivos
   - Medir efectividad de controles

4. **Diagnóstico y mitigación**
   - Prevención continua de riesgos
   - Prioridad según momento

5. **Automatización**
   - Estándares de prevención
   - Estadísticas confiables

---

## Controles Relevantes para el Laboratorio

### Control 1: Inventario de Dispositivos
```
- Escaneo de red: nmap -sn 192.168.1.0/24
- Identificar switch, router, PCs
- Documentar MACs e IPs
```

### Control 9: Limitación de Puertos
```
- Port Security en switch
- Limitar MACs por puerto
- Bloquear puertos no utilizados
```

### Control 11: Configuración Segura de Red
```
- DHCP Snooping
- ARP Inspection
- PVLAN
- 802.1X
```

### Control 12: Defensa de Borde
```
- ACLs en router
- Segmentación con VLANs
- Monitoreo de tráfico
```

---

## Mapeo CIS → NIST

| Control CIS | Función NIST |
|-------------|--------------|
| 1-2: Inventario | IDENTIFICAR |
| 3: Vulnerabilidades | IDENTIFICAR |
| 4-5: Configuración | PROTEGER |
| 6: Logs | DETECTAR |
| 9-11: Red | PROTEGER |
| 19: Incidentes | RESPONDER |
| 10: Recuperación | RECUPERAR |

---

## Ver también

- [NIST Framework](nist_framework.md) - Las 5 funciones de ciberseguridad
- [ISO 27001](iso_27001.md) - Controles ISO de seguridad
- [Checklist de Seguridad](../04_defensa/hardening/checklist_seguridad.md) - Aplicación práctica

---

[← Volver al Índice](../INDEX.md)
