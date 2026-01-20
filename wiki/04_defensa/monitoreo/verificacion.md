# Verificación y Monitoreo de Seguridad

## Verificar Port Security

### En el Switch
```
Security > Port Security
- Ver estado de cada puerto
- Ver MACs aprendidas por puerto
```

### Test
```
1. Conectar dispositivo autorizado → Debe funcionar
2. Conectar segundo dispositivo en mismo puerto
   - Si Max MACs=1 → Debe bloquear
3. Ver logs de violaciones
```

## Verificar DHCP Snooping

### En el Switch
```
IP Configuration > DHCP Snooping/Relay > Properties
- Verificar que está habilitado
- Verificar VLANs protegidas

IP Configuration > DHCP Snooping/Relay > DHCP Snooping Binding Database
- Ver tabla de bindings (MAC-IP-Puerto)
```

### Test desde Atacante
```bash
# Intentar DHCP Spoofing
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.50

# Resultado esperado: Las ofertas DHCP son bloqueadas
```

### Test DHCP Starvation
```bash
sudo yersinia -G
# DHCP > sending DISCOVER packet

# Resultado esperado: Rate limiting activo, ataque mitigado
```

## Verificar ARP Inspection

### En el Switch
```
Security > ARP Inspection > Properties
- Verificar que está habilitado
- Verificar VLANs protegidas

Security > ARP Inspection > Statistics
- Ver contadores de paquetes válidos/inválidos
```

### Test desde Atacante
```bash
# Intentar ARP Poisoning
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//

# Resultado esperado: ARP falsos bloqueados
```

### Verificar desde Víctima (Windows)
```cmd
# Antes del ataque
arp -a
# Anotar MAC del gateway

# Durante ataque (con defensa)
arp -a
# La MAC NO debe cambiar

# Sin defensa, la MAC cambiaría a la del atacante
```

### Verificar desde Víctima (macOS)
```bash
# Antes del ataque
arp -a | grep 192.168.1.1
# Anotar MAC del gateway

# Durante ataque (con defensa)
arp -a | grep 192.168.1.1
# La MAC NO debe cambiar

# Sin defensa, la MAC cambiaría a la del atacante
```

## Verificar PVLAN

### Test de Conectividad
```cmd
# Desde PC en puerto Isolated
ping 192.168.1.1      # Gateway → DEBE funcionar
ping 192.168.1.10     # Otro Isolated → NO debe funcionar

# Desde PC en puerto Community
ping 192.168.1.1      # Gateway → DEBE funcionar
ping 192.168.1.20     # Otro Community → DEBE funcionar
ping 192.168.1.10     # Isolated → NO debe funcionar
```

## Verificar 802.1X

### En el Switch
```
Security > 802.1X/MAC/Web Authentication > Port Authentication
- Ver estado de autenticación por puerto
- Estados: Authorized / Unauthorized / etc.
```

### Test
```
1. Conectar PC sin credenciales → Puerto no autorizado
2. Autenticar con credenciales → Puerto autorizado
3. Verificar acceso a red solo después de autenticación
```

### Test RADIUS
```bash
# Desde servidor RADIUS
radtest andres tfG2021 localhost 0 testing123
# Debe devolver: Access-Accept
```

## Monitoreo de Logs

### Ubicación
```
Status > System Logs
```

### Eventos a Buscar
| Evento | Indica |
|--------|--------|
| Port Security Violation | MAC no autorizada |
| DHCP Snooping Violation | DHCP desde puerto untrusted |
| ARP Inspection Violation | ARP no válido |
| 802.1X Auth Failure | Credenciales incorrectas |

## Captura de Tráfico para Análisis

### Wireshark - Filtros Útiles
```
# Ver solo ARP
arp

# Ver solo DHCP
bootp

# Ver violaciones sospechosas
arp.duplicate-address-detected
```

### tcpdump
```bash
# ARP (Linux: eth0, macOS: en0)
sudo tcpdump -i eth0 arp -vvv      # Linux
sudo tcpdump -i en0 arp -vvv       # macOS

# DHCP (Linux: eth0, macOS: en0)
sudo tcpdump -i eth0 port 67 or port 68 -vvv   # Linux
sudo tcpdump -i en0 port 67 or port 68 -vvv    # macOS
```

---

## Ver también

- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - Configurar defensa DHCP
- [ARP Inspection](../../02_configuracion/seguridad/arp_inspection.md) - Configurar defensa ARP
- [DHCP Attacks](../../03_ataque/explotacion/dhcp_attacks.md) - Ataques a probar
- [ARP Poisoning](../../03_ataque/explotacion/arp_poisoning.md) - Ataques a probar
- [Checklist](../hardening/checklist_seguridad.md) - Lista completa de seguridad

---

[← Volver al Índice](../../INDEX.md)
