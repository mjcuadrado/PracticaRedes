# Conceptos Fundamentales

## Equipos del Laboratorio

| Equipo | Modelo | Tipo | IP por defecto |
|--------|--------|------|----------------|
| Switch | Cisco SG300-10 | L2/L3 | 192.168.1.237 |
| Router | Cisco RV 120W | L3 | 192.168.1.1 |

## Framework NIST (5 Funciones)

1. **IDENTIFICAR (ID)** - Inventario de activos, gestión de riesgos
2. **PROTEGER (PR)** - Control de acceso, seguridad de datos
3. **DETECTAR (DE)** - Monitorización, detección de anomalías
4. **RESPONDER (RS)** - Planificación de respuesta, mitigación
5. **RECUPERAR (RC)** - Plan de recuperación, mejoras

## Tecnologías de Seguridad Clave

### Capa 2 (Enlace)
- **Port Security**: Limita MACs por puerto
- **PVLAN**: Aislamiento entre hosts en misma VLAN
- **DHCP Snooping**: Filtra servidores DHCP no autorizados
- **ARP Inspection**: Valida paquetes ARP

### Autenticación
- **802.1X**: Control de acceso basado en puerto
- **RADIUS**: Servidor de autenticación centralizado
- **EAP-PEAP**: Protocolo de autenticación extensible

### Segmentación
- **VLAN**: Segmentación lógica de red
- **DMZ**: Zona desmilitarizada para servicios públicos
- **ACL**: Listas de control de acceso

## Tipos de Ataques Cubiertos

| Ataque | Capa | Objetivo | Defensa |
|--------|------|----------|---------|
| DHCP Spoofing | 2 | MITM via DHCP falso | DHCP Snooping |
| DHCP Starvation | 2 | DoS al pool DHCP | DHCP Snooping + Port Security |
| ARP Poisoning | 2 | MITM via ARP falso | ARP Inspection |
| MAC Flooding | 2 | Convertir switch en hub | Port Security |

## Herramientas de Ataque

| Herramienta | Uso Principal |
|-------------|---------------|
| **Ettercap** | MITM, ARP Poisoning, Sniffing |
| **Yersinia** | Ataques L2 (DHCP, STP, CDP) |
| **Wireshark** | Captura y análisis de tráfico |

## Credenciales por Defecto (del TFG)

```
RADIUS Server:
  Usuario: andres
  Password: tfG2021
  Secret: testing123 (local) / rEdes2021 (switch)

Switch Cisco SG300-10:
  IP: 192.168.1.237
  Acceso: Web (HTTPS)
```

---

## Ver también

- [NIST Framework](nist_framework.md) - Las 5 funciones de ciberseguridad
- [CIS Controls](cis_controls.md) - Los 20 controles críticos
- [ISO 27001](iso_27001.md) - Controles de seguridad de la información

---

[← Volver al Índice](../INDEX.md)
