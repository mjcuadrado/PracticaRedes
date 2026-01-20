# Reconocimiento de Red

## Descubrimiento de Hosts

### Con nmap
```bash
# Ping scan (descubrir hosts activos)
nmap -sn 192.168.1.0/24

# Scan con ARP (más fiable en LAN)
sudo nmap -sn -PR 192.168.1.0/24
```

### Con arp-scan
```bash
sudo apt-get install arp-scan
sudo arp-scan --localnet
sudo arp-scan 192.168.1.0/24
```

### Con netdiscover
```bash
sudo apt-get install netdiscover
sudo netdiscover -r 192.168.1.0/24
```

## Información de la Red Local

### Ver configuración IP
```bash
# Linux
ip addr show
ip route show

# Windows
ipconfig /all
route print
```

### Ver tabla ARP
```bash
# Linux
ip neigh show
arp -a

# Windows
arp -a
```

### Ver conexiones activas
```bash
# Linux
ss -tuln
netstat -tuln

# Windows
netstat -an
```

## Escaneo de Puertos

### Básico
```bash
nmap 192.168.1.237
```

### Completo
```bash
# Todos los puertos TCP
nmap -p- 192.168.1.237

# Puertos UDP comunes
sudo nmap -sU --top-ports 100 192.168.1.237
```

### Detección de servicios
```bash
nmap -sV 192.168.1.237
```

## Identificación del Switch Cisco

### Puertos comunes
- **80/443**: Interfaz web de gestión
- **22**: SSH
- **23**: Telnet (inseguro)
- **161/162**: SNMP

### Fingerprinting
```bash
nmap -sV -O 192.168.1.237
```

## Captura de Tráfico

### Con tcpdump
```bash
# Todo el tráfico
sudo tcpdump -i eth0

# Solo DHCP
sudo tcpdump -i eth0 port 67 or port 68

# Solo ARP
sudo tcpdump -i eth0 arp

# Guardar en archivo
sudo tcpdump -i eth0 -w captura.pcap
```

### Con Wireshark
```bash
wireshark &
# Seleccionar interfaz
# Aplicar filtros según necesidad
```

## Filtros Wireshark Útiles

| Filtro | Muestra |
|--------|---------|
| `arp` | Tráfico ARP |
| `bootp` | Tráfico DHCP |
| `ip.addr == 192.168.1.237` | Tráfico hacia/desde IP |
| `eth.addr == aa:bb:cc:dd:ee:ff` | Tráfico de MAC específica |
| `tcp.port == 80` | Tráfico HTTP |

---

## Ver también

- [ARP Poisoning](../explotacion/arp_poisoning.md) - Siguiente paso: ataque ARP
- [DHCP Attacks](../explotacion/dhcp_attacks.md) - Siguiente paso: ataques DHCP
- [Ettercap](../herramientas/ettercap.md) - Herramienta para MITM
- [Cheatsheet](../../05_comandos/cheatsheet.md) - Comandos rápidos

---

[← Volver al Índice](../../INDEX.md)
