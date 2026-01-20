# Port Security - Cisco SG300-10

## Ruta en el Switch
```
Security > Port Security
```

## Modos de Port Security

| Modo | Descripción | Uso |
|------|-------------|-----|
| **Classic Lock** | Bloquea puerto, no aprende nuevas MACs | Puerto crítico ya configurado |
| **Limited Dynamic Lock** | Aprende hasta X MACs, luego bloquea | Uso general (recomendado) |
| **Secure Permanent** | MACs aprendidas se guardan permanentemente | Equipos fijos conocidos |
| **Secure Delete on Reset** | MACs se borran al reiniciar | Temporal |

## Configuración Paso a Paso

### 1. Habilitar Port Security Global
```
Security > Port Security
☑ Enable Port Security (Global)
Apply
```

### 2. Configurar Puerto Específico
```
Security > Port Security > [Seleccionar Puerto]
Edit:
  - Interface Status: Lock
  - Learning Mode: Limited Dynamic Lock
  - Max No. of Addresses Allowed: 1-128 (ej: 2)
  - Action on Violation: Discard / Forward / Shutdown
Apply
```

## Acciones ante Violación

| Acción | Comportamiento |
|--------|----------------|
| **Discard** | Descarta tramas, no notifica |
| **Forward** | Permite tráfico (solo logging) |
| **Shutdown** | Apaga el puerto (requiere reset manual) |

## Ver MACs Aprendidas
```
Security > Port Security > [Puerto] > Addresses
```

## Limpiar MACs de un Puerto
```
Security > Port Security > Clear MAC Addresses
```

## Verificación
- Conectar dispositivo autorizado: debe funcionar
- Conectar dispositivo no autorizado: según acción configurada
- Ver logs: Status > System Logs

---

## Ver también

- [DHCP Snooping](dhcp_snooping.md) - Siguiente paso recomendado
- [Checklist de Seguridad](../../04_defensa/hardening/checklist_seguridad.md) - Lista completa de hardening
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Cómo probar las defensas

---

[← Volver al Índice](../../INDEX.md)
