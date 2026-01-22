# Instalación de Herramientas para Prácticas de Seguridad en Redes (macOS)

## Estado de la Instalación

### ✅ Herramientas Instaladas Correctamente

| Herramienta | Versión | Estado | Comando de verificación |
|-------------|---------|--------|------------------------|
| **nmap** | 7.98 | ✅ Instalado | `nmap --version` |
| **ettercap** | 0.8.3.1 | ✅ Instalado | `ettercap --version` |
| **tcpdump** | 4.99.1 | ✅ Instalado | `tcpdump --version` |
| **arp-scan** | 1.10.0 | ✅ Instalado | `arp-scan --version` |

### ⚠️ Herramientas que Requieren Instalación Manual

#### 1. Wireshark

**Problema:** Requiere permisos de administrador (sudo) para completar la instalación.

**Solución - Opción A (Recomendada): Instalación manual desde web**
1. Descarga Wireshark desde: https://www.wireshark.org/download.html
2. Selecciona "macOS Arm 64-bit .dmg" (para Apple Silicon) o "macOS Intel 64-bit .dmg"
3. Abre el archivo .dmg descargado
4. Arrastra Wireshark.app a la carpeta Applications
5. Abre Wireshark y sigue las instrucciones para instalar ChmodBPF (permisos de captura)

**Solución - Opción B: Completar instalación con Homebrew**
```bash
# El archivo ya está descargado, solo necesitas ejecutar con sudo en una terminal:
brew install --cask wireshark
# Te pedirá tu contraseña de administrador
```

**Verificación:**
```bash
# Verificar aplicación
ls /Applications/Wireshark.app

# Verificar tshark (línea de comandos)
tshark --version
```

**Configurar permisos de captura (importante):**
```bash
# Después de instalar Wireshark, para capturar tráfico sin sudo:
sudo chmod 644 /dev/bpf*

# O mejor aún, instala ChmodBPF (se hace automáticamente al abrir Wireshark la primera vez)
```

---

#### 2. Yersinia

**Problema:** No está disponible en Homebrew para macOS.

**Solución - Opción A: Compilar desde código fuente**
```bash
# Instalar dependencias
brew install libnet libpcap

# Descargar y compilar Yersinia
cd /tmp
git clone https://github.com/tomac/yersinia.git
cd yersinia
./autogen.sh
./configure
make
sudo make install

# Verificar instalación
yersinia -V
```

**Solución - Opción B: Usar Docker (más fácil)**
```bash
# Descargar imagen de Yersinia
docker pull ghcr.io/tomac/yersinia

# Ejecutar Yersinia con Docker
docker run --rm -it --net=host ghcr.io/tomac/yersinia yersinia -G
```

**Solución - Opción C: Usar máquina virtual Linux**
- Instala VirtualBox o VMware
- Crea una VM con Kali Linux o Ubuntu
- Instala Yersinia en Linux: `sudo apt install yersinia`

**Nota:** Para las prácticas de DHCP Starvation, puedes usar **ettercap** como alternativa:
```bash
sudo ettercap -G  # Interfaz gráfica
# En el menú: Plugins -> dhcp_dos
```

---

## Resumen de Herramientas por Práctica

### Práctica 1: DHCP Starvation
- **Necesitas:** Yersinia (o Ettercap como alternativa)
- **Estado:** ⚠️ Requiere instalación manual
- **Alternativa:** Ettercap (✅ instalado) puede hacer DHCP DoS

### Práctica 2: ARP Poisoning MITM
- **Necesitas:** Ettercap, Wireshark
- **Estado:** Ettercap ✅ | Wireshark ⚠️

### Práctica 3: Ciclo NIST
- **Necesitas:** Varias herramientas
- **Estado:** Mayormente instaladas

### Práctica 4: Port Security
- **Necesitas:** Comandos básicos de red
- **Estado:** ✅ Todo disponible (ifconfig, ip, etc.)

### Práctica 5: Rogue DHCP
- **Necesitas:** Ettercap o dnsmasq
- **Estado:** Ettercap ✅ | dnsmasq se instala con `brew install dnsmasq`

---

## Comandos de Verificación Rápida

```bash
# Ejecuta este comando para verificar todo:
echo "=== Verificación de Herramientas ===" && \
echo "" && \
echo "nmap: $(which nmap && echo '✅' || echo '❌')" && \
echo "ettercap: $(which ettercap && echo '✅' || echo '❌')" && \
echo "tcpdump: $(which tcpdump && echo '✅' || echo '❌')" && \
echo "arp-scan: $(which arp-scan && echo '✅' || echo '❌')" && \
echo "wireshark: $(test -d /Applications/Wireshark.app && echo '✅' || echo '⚠️ Requiere instalación')" && \
echo "tshark: $(which tshark && echo '✅' || echo '⚠️ Viene con Wireshark')" && \
echo "yersinia: $(which yersinia && echo '✅' || echo '⚠️ Requiere instalación manual')"
```

---

## Uso de las Herramientas (Requieren sudo)

### Ettercap
```bash
# Modo gráfico
sudo ettercap -G

# Modo texto para DHCP DoS
sudo ettercap -T -q -i en0 -P dhcp_dos

# ARP Poisoning
sudo ettercap -T -q -i en0 -M arp:remote /192.168.1.1// /192.168.1.100//
```

### Yersinia (si lo instalaste)
```bash
# Modo gráfico
sudo yersinia -G

# DHCP Starvation desde línea de comandos
sudo yersinia -attack 1 -interface en0 dhcp
```

### nmap
```bash
# Escaneo básico de red
nmap -sn 192.168.1.0/24

# Escaneo de puertos
nmap -p- 192.168.1.237

# Detección de sistema operativo
sudo nmap -O 192.168.1.237
```

### arp-scan
```bash
# Escanear toda la red local
sudo arp-scan -l

# Escanear rango específico
sudo arp-scan 192.168.1.0/24
```

### Wireshark
```bash
# Línea de comandos
sudo tshark -i en0

# Interfaz gráfica
open /Applications/Wireshark.app
```

---

## Identificar tu Interfaz de Red

Antes de usar las herramientas, necesitas saber qué interfaz usar:

```bash
# Listar todas las interfaces
ifconfig

# Ver cuál está conectada
ifconfig | grep "inet " | grep -v 127.0.0.1

# Interfaces comunes en Mac:
# - en0: Ethernet/WiFi principal
# - en1: Segunda interfaz
# - bridge0: Puente de red
```

---

## Permisos y Seguridad

La mayoría de estas herramientas requieren permisos de administrador porque:
1. Manipulan tráfico de red a bajo nivel
2. Pueden capturar todo el tráfico de la red
3. Pueden modificar paquetes en tránsito

**Siempre usa `sudo` cuando sea necesario:**
```bash
sudo ettercap -G
sudo yersinia -G
sudo tshark -i en0
```

---

## Troubleshooting

### Problema: "Operation not permitted" o "Permission denied"
**Solución:** Usa `sudo` antes del comando

### Problema: Wireshark no captura paquetes
**Solución:**
```bash
# Dar permisos a BPF (Berkeley Packet Filter)
sudo chmod 644 /dev/bpf*

# O instalar ChmodBPF de forma permanente (se hace automáticamente en primera ejecución)
```

### Problema: "No such device" o "Interface not found"
**Solución:** Verifica el nombre de tu interfaz con `ifconfig` y usa la correcta (ej: en0, en1)

### Problema: Ettercap no encuentra targets
**Solución:**
```bash
# Escanea la red primero
sudo nmap -sn 192.168.1.0/24

# Verifica que estés en la misma red que el switch (192.168.1.x)
```

---

## Script de Verificación

He creado un script `install_mac_tools.sh` que:
- ✅ Instala automáticamente: nmap, ettercap, tcpdump, arp-scan
- ⚠️ Descarga Wireshark pero requiere sudo manual
- ⚠️ No puede instalar Yersinia automáticamente (no disponible en Homebrew)

**Para re-ejecutar:**
```bash
./install_mac_tools.sh
```

---

## Recursos Adicionales

- **Wireshark:** https://www.wireshark.org/
- **Yersinia:** https://github.com/tomac/yersinia
- **Ettercap:** https://www.ettercap-project.org/
- **nmap:** https://nmap.org/

---

## Próximos Pasos

1. ✅ Herramientas básicas ya instaladas (nmap, ettercap, arp-scan)
2. ⚠️ Instalar Wireshark manualmente (descarga desde web o ejecuta `brew install --cask wireshark` con sudo)
3. ⚠️ Decidir cómo usar Yersinia:
   - Compilar desde fuente
   - Usar Docker
   - Usar Ettercap como alternativa
   - Usar VM con Linux
4. ✅ Verificar que puedes acceder al switch Cisco en https://192.168.1.237

---

**Fecha de instalación:** 2026-01-22
**Script usado:** `install_mac_tools.sh`
