# Private VLAN (PVLAN)

## Concepto

Las PVLAN permiten aislar hosts dentro de la misma VLAN, útil para:
- Aislar clientes en redes WiFi públicas
- Separar servidores en DMZ
- Segmentar sin crear múltiples VLANs

## Tipos de PVLAN

| Tipo | Comunicación | Uso |
|------|--------------|-----|
| **Primary VLAN** | Contiene las secundarias | VLAN "padre" |
| **Isolated VLAN** | Solo con Promiscuous | Máximo aislamiento |
| **Community VLAN** | Entre sí + Promiscuous | Grupos de trabajo |

## Tipos de Puertos

| Puerto | Puede comunicar con |
|--------|---------------------|
| **Promiscuous** | Todos (gateway, servidor) |
| **Isolated** | Solo Promiscuous |
| **Community** | Su comunidad + Promiscuous |

## Diagrama

```
                    [Router/Gateway]
                          |
                    (Promiscuous)
                          |
    +----------+----------+----------+
    |          |          |          |
(Isolated) (Isolated) (Community) (Community)
   PC1        PC2        PC3        PC4
    |          |          |__________|
    |          |          (pueden comunicarse)
    |__________|
    (NO pueden comunicarse)
```

## Configuración en Switch

### 1. Crear VLAN Primary
```
VLAN Management > VLAN Settings
Add VLAN: 100 (Primary)
Apply
```

### 2. Crear VLANs Secundarias
```
VLAN Management > VLAN Settings
Add VLAN: 101 (Isolated)
Add VLAN: 102 (Community)
Apply
```

### 3. Configurar Private VLAN
```
VLAN Management > Private VLAN Settings
  Primary VLAN: 100
  ☑ Isolated VLAN: 101
  ☑ Community VLAN: 102
Apply
```

### 4. Asignar Puertos

#### Puerto Promiscuous (ej: puerto 1 - gateway)
```
VLAN Management > Private VLAN > Port to PVLAN
Port: GE1
  Type: Promiscuous
  Primary VLAN: 100
Apply
```

#### Puerto Isolated (ej: puertos 2-5)
```
Port: GE2
  Type: Isolated
  Primary VLAN: 100
  Secondary VLAN: 101
Apply
```

#### Puerto Community (ej: puertos 6-8)
```
Port: GE6
  Type: Community
  Primary VLAN: 100
  Secondary VLAN: 102
Apply
```

## Verificación

### Test de Conectividad
```cmd
# Desde PC Isolated
ping [IP Gateway]     → Debe funcionar
ping [IP otro Isolated] → NO debe funcionar
ping [IP Community]   → NO debe funcionar

# Desde PC Community
ping [IP Gateway]     → Debe funcionar
ping [IP otro Community] → Debe funcionar
ping [IP Isolated]    → NO debe funcionar
```

## Casos de Uso

1. **Hotel/WiFi público**: Cada huésped en Isolated
2. **DMZ**: Servidores en Community por función
3. **Multi-tenant**: Cada cliente en su Community

---

## Ver también

- [Port Security](port_security.md) - Control de acceso por MAC
- [802.1X RADIUS](802_1x_radius.md) - Autenticación de usuarios
- [Checklist de Seguridad](../../04_defensa/hardening/checklist_seguridad.md) - Lista completa

---

[← Volver al Índice](../../INDEX.md)
