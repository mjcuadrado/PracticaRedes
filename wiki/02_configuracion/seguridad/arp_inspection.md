# Dynamic ARP Inspection (DAI)

## Propósito
Protege contra **ARP Poisoning/Spoofing** (MITM a nivel L2)

## Concepto

```
Normal:
PC1 (192.168.1.10) --ARP Request--> "¿Quién tiene 192.168.1.1?"
Gateway (192.168.1.1) --ARP Reply--> "Yo, MAC: aa:bb:cc:dd:ee:ff"

Ataque ARP Poisoning:
Atacante envía ARP Reply falso: "192.168.1.1 está en MAC:atacante"
→ PC1 envía tráfico al atacante pensando que es el gateway

Con DAI:
Switch valida ARP Replies contra DHCP Snooping Binding Database
→ ARP falso = BLOQUEADO
```

## Prerequisito
**DHCP Snooping debe estar habilitado** (para la Binding Database)

## Configuración en Switch

### Ruta
```
Security > ARP Inspection
```

### 1. Habilitar ARP Inspection
```
Security > ARP Inspection > Properties
  ☑ ARP Inspection Status: Enable
  ☑ ARP Inspection VLAN: [seleccionar VLANs]
Apply
```

### 2. Configurar Puertos Trusted
```
Security > ARP Inspection > Interface Settings
[Puerto hacia gateway/servidor]
  Trusted: Enable
Apply
```

### 3. (Opcional) ARP Access Control
Para IPs estáticas (no DHCP), crear reglas manuales:
```
Security > ARP Inspection > ARP Access Control
Add:
  - ARP Access Control Name: SERVIDOR-WEB
  - IP Address: 192.168.1.50
  - MAC Address: 00:11:22:33:44:55
Apply
```

### 4. Aplicar ARP Access Control a VLAN
```
Security > ARP Inspection > ARP Access Control Binding
  VLAN: 1
  ARP Access Control: SERVIDOR-WEB
Apply
```

## Verificación

### Test ARP Poisoning
1. Activar ARP Inspection
2. Desde atacante en puerto untrusted:
   ```bash
   # Ettercap ARP Poisoning
   sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//
   ```
3. El switch debe bloquear los ARP falsos

### Ver Estadísticas
```
Security > ARP Inspection > Statistics
```

## Logs
```
Status > System Logs
```
Buscar "ARP Inspection" para ver violaciones.

## Combinación Recomendada

```
DHCP Snooping + ARP Inspection = Protección completa L2
```

| Configuración | DHCP Snooping | ARP Inspection |
|---------------|---------------|----------------|
| Puerto a DHCP Server | Trusted | Trusted |
| Puerto a Gateway | Untrusted | Trusted |
| Puertos usuarios | Untrusted | Untrusted |

---

## Ver también

- [DHCP Snooping](dhcp_snooping.md) - **Prerequisito** (debe estar activo)
- [ARP Poisoning](../../03_ataque/explotacion/arp_poisoning.md) - Ataque que mitiga
- [Ettercap](../../03_ataque/herramientas/ettercap.md) - Herramienta de ataque ARP
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Cómo probar que funciona

---

[← Volver al Índice](../../INDEX.md)
