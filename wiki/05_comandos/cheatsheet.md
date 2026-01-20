# Cheatsheet de Comandos Rápidos

## Windows - Comandos de Red

```cmd
# Ver configuración IP
ipconfig /all

# Liberar y renovar IP (DHCP)
ipconfig /release
ipconfig /renew

# Ver tabla ARP
arp -a

# Limpiar cache ARP
arp -d *

# Traza de ruta
tracert -d 8.8.8.8

# Ping
ping 192.168.1.1

# Ver conexiones
netstat -an

# DNS flush
ipconfig /flushdns
```

## Linux - Comandos de Red

```bash
# Ver configuración IP
ip addr show
ip a

# Ver rutas
ip route show

# Ver tabla ARP
ip neigh show
arp -a

# Configurar IP temporal
sudo ip addr add 192.168.1.100/24 dev eth0

# DHCP release/renew
sudo dhclient -r eth0
sudo dhclient eth0

# Ping
ping -c 4 192.168.1.1

# Traza de ruta
traceroute -n 8.8.8.8
```

## macOS - Comandos de Red

```bash
# Ver configuración IP
ifconfig
ifconfig en0                    # Interfaz específica (en0=Ethernet, en1=WiFi)

# Ver IP asignada
ipconfig getifaddr en0

# Ver rutas
netstat -rn

# Ver tabla ARP
arp -a

# Limpiar cache ARP
sudo arp -d -a

# Configurar IP temporal
sudo ifconfig en0 192.168.1.100 netmask 255.255.255.0

# DHCP release/renew
sudo ipconfig set en0 DHCP      # Renovar DHCP
sudo ipconfig set en0 BOOTP     # Forzar release
sudo ipconfig set en0 DHCP      # Obtener nueva IP

# Ping
ping -c 4 192.168.1.1

# Traza de ruta
traceroute -n 8.8.8.8

# DNS flush
sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder

# Ver conexiones activas
netstat -an
lsof -i -P                      # Procesos con conexiones

# Ver interfaz de red activa
networksetup -listallhardwareports
route get default | grep interface
```

### Instalar herramientas en macOS (Homebrew)
```bash
# Instalar Homebrew si no está
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar herramientas de red
brew install nmap
brew install arp-scan
brew install ettercap
brew install wireshark
```

## Herramientas de Ataque

### Ettercap
```bash
# ARP Poisoning
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//

# DHCP Spoofing
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.1

# Modo gráfico
sudo ettercap -G
```

### Yersinia
```bash
# Modo gráfico
sudo yersinia -G

# DHCP Starvation: Launch attack > DHCP > sending DISCOVER
```

### arpspoof
```bash
# Habilitar forwarding (Linux)
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Habilitar forwarding (macOS)
sudo sysctl -w net.inet.ip.forwarding=1

# ARP spoof (Linux - eth0)
sudo arpspoof -i eth0 -t 192.168.1.10 192.168.1.1

# ARP spoof (macOS - en0)
sudo arpspoof -i en0 -t 192.168.1.10 192.168.1.1
```

## Captura y Análisis

### tcpdump
```bash
# Todo el tráfico (Linux: eth0, macOS: en0)
sudo tcpdump -i eth0              # Linux
sudo tcpdump -i en0               # macOS

# Solo ARP
sudo tcpdump -i en0 arp

# Solo DHCP
sudo tcpdump -i en0 port 67 or port 68

# Guardar captura
sudo tcpdump -i en0 -w captura.pcap

# Ver interfaces disponibles (macOS)
tcpdump -D
```

### Wireshark Filtros
```
arp                    # Tráfico ARP
bootp                  # Tráfico DHCP
ip.addr == 192.168.1.1 # IP específica
eth.addr == aa:bb:cc   # MAC específica
```

## RADIUS

```bash
# Test autenticación
radtest andres tfG2021 localhost 0 testing123

# Iniciar en modo debug
sudo freeradius -X

# Ver logs
sudo tail -f /var/log/freeradius/radius.log
```

## Switch Cisco SG300 - Rutas Web

| Función | Ruta |
|---------|------|
| **Port Security** | Security > Port Security |
| **802.1X** | Security > 802.1X/MAC/Web Authentication |
| **RADIUS** | Security > RADIUS |
| **DHCP Snooping** | IP Configuration > DHCP Snooping/Relay |
| **ARP Inspection** | Security > ARP Inspection |
| **PVLAN** | VLAN Management > Private VLAN Settings |
| **Logs** | Status > System Logs |
| **Guardar Config** | Administration > File Management > Copy/Save Configuration |

## Verificación Rápida

### Windows
```cmd
:: 1. Anotar MAC del gateway antes de ataque
arp -a

:: 2. Durante ataque verificar que no cambia
arp -a

:: 3. Verificar conectividad
ping 8.8.8.8
tracert -d 8.8.8.8
```

### macOS / Linux
```bash
# 1. Anotar MAC del gateway antes de ataque
arp -a | grep 192.168.1.1

# 2. Durante ataque verificar que no cambia
arp -a | grep 192.168.1.1

# 3. Verificar conectividad
ping -c 4 8.8.8.8
traceroute -n 8.8.8.8
```

---

## Ver también

- [Guía de la Práctica](../06_laboratorio/guia_practica.md) - Pasos completos
- [Verificación](../04_defensa/monitoreo/verificacion.md) - Cómo verificar defensas
- [Ettercap](../03_ataque/herramientas/ettercap.md) - Guía de uso
- [Yersinia](../03_ataque/herramientas/yersinia.md) - Guía de uso

---

[← Volver al Índice](../INDEX.md)
