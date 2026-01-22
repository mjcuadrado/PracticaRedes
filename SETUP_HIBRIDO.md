# Setup Híbrido: macOS + Kali VM

## 🎯 Estrategia Óptima

Usar **macOS nativo** para la mayoría de tareas (mejor rendimiento, sin overhead de VM) y **Kali VM solo para Yersinia** (único programa no disponible en macOS).

---

## 📊 Distribución de Herramientas

### ✅ Usar desde macOS (Ya instalado)

| Herramienta | Versión | Uso | Comando |
|-------------|---------|-----|---------|
| **nmap** | 7.98 | Escaneo de red | `nmap -sn 192.168.1.0/24` |
| **ettercap** | 0.8.3.1 | ARP Poisoning, DHCP DoS | `sudo ettercap -G` |
| **tcpdump** | 4.99.1 | Captura de paquetes | `sudo tcpdump -i en0` |
| **arp-scan** | 1.10.0 | Escaneo ARP | `sudo arp-scan -l` |
| **Navegador** | - | Acceso al switch | `https://192.168.1.237` |

### ⚠️ Instalar en macOS (Falta Wireshark)

```bash
brew install --cask wireshark
```

### 🔴 Usar desde Kali VM (Solo cuando sea necesario)

| Herramienta | Cuándo usarla | Práctica |
|-------------|---------------|----------|
| **Yersinia** | DHCP Starvation | Práctica 1 |

---

## 🛠️ Configuración por Práctica

### Práctica 1: DHCP Starvation

**🔴 Requiere Kali VM** (Yersinia no está en macOS)

**Setup:**
1. **Desde macOS:** Abre Wireshark para capturar
   ```bash
   # Instalar si no lo tienes
   brew install --cask wireshark

   # Abrir Wireshark
   open /Applications/Wireshark.app
   ```

2. **Desde Kali VM:** Ejecuta el ataque
   ```bash
   # Verificar interfaz
   ip addr show

   # Lanzar Yersinia
   sudo yersinia -G
   ```

3. **Desde macOS:** Accede al switch para configurar defensa
   ```bash
   # Abrir navegador
   open https://192.168.1.237
   ```

**Workflow:**
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  macOS Host  │         │  Kali VM     │         │ Switch Cisco │
├──────────────┤         ├──────────────┤         ├──────────────┤
│ Wireshark    │◀───────┤ Yersinia     ├────────▶│ Víctima del  │
│ (captura)    │ observa│ (ataque)     │ ataque  │ ataque       │
│              │         │              │         │              │
│ Navegador    ├────────┼──────────────┼────────▶│ Configurar   │
│ (defensa)    │        │              │ defensa │ DHCP Snooping│
└──────────────┘         └──────────────┘         └──────────────┘
```

---

### Práctica 2: ARP Poisoning MITM

**✅ Todo desde macOS** (Ettercap ya instalado)

**Setup:**
```bash
# Terminal 1: Wireshark
open /Applications/Wireshark.app

# Terminal 2: Escanear red para identificar víctima
nmap -sn 192.168.1.0/24

# Terminal 3: ARP Poisoning con Ettercap
sudo ettercap -G

# Navegador: Configurar defensa en el switch
open https://192.168.1.237
```

**Comandos Ettercap en macOS:**
```bash
# Modo gráfico
sudo ettercap -G

# Modo terminal (ARP Poisoning)
sudo ettercap -T -q -i en0 -M arp:remote /192.168.1.1// /192.168.1.100//
#                              ↑ tu interfaz   ↑ router   ↑ víctima

# DHCP DoS (alternativa a Yersinia)
sudo ettercap -T -q -i en0 -P dhcp_dos
```

**Identificar tu interfaz en macOS:**
```bash
# Ver todas las interfaces
ifconfig

# Interfaces comunes:
# - en0: WiFi o Ethernet principal
# - en1: Segunda interfaz
```

---

### Práctica 3: Ciclo NIST

**✅ Mayormente desde macOS**

Solo usar Kali si necesitas Yersinia para algún ataque específico.

**Herramientas desde macOS:**
- Reconocimiento: `nmap`, `arp-scan`
- Monitoreo: Wireshark
- Configuración: Navegador web
- Ataques: `ettercap`

---

### Práctica 4: Port Security

**✅ Todo desde macOS**

```bash
# Ver tu MAC actual
ifconfig en0 | grep ether

# Cambiar MAC en macOS (requiere desactivar WiFi)
sudo ifconfig en0 ether AA:BB:CC:DD:EE:FF

# Restaurar MAC original (reinicia la interfaz)
sudo ifconfig en0 down
sudo ifconfig en0 up
```

**Nota:** En macOS es más fácil cambiar la MAC con SpoofMAC:
```bash
brew install spoof-mac

# Cambiar MAC
sudo spoof-mac set AA:BB:CC:DD:EE:FF en0

# Restaurar original
sudo spoof-mac reset en0
```

---

### Práctica 5: Rogue DHCP

**✅ Todo desde macOS** (usando Ettercap o dnsmasq)

**Opción A: Con Ettercap (ya instalado)**
```bash
# Editar configuración
sudo nano /opt/homebrew/etc/ettercap.conf
# O si usas Intel Mac:
sudo nano /usr/local/etc/ettercap.conf

# Buscar [dhcp_server] y configurar
# Luego ejecutar:
sudo ettercap -T -q -i en0 -P dhcp_server
```

**Opción B: Con dnsmasq**
```bash
# Instalar
brew install dnsmasq

# Configurar
sudo nano /opt/homebrew/etc/dnsmasq.conf

# Añadir:
# interface=en0
# dhcp-range=192.168.1.100,192.168.1.200,12h
# dhcp-option=3,192.168.1.254
# dhcp-option=6,8.8.8.8

# Iniciar
sudo brew services start dnsmasq
```

---

## 🔧 Verificación del Setup Híbrido

### En macOS:

```bash
# Ejecutar el script de verificación
./install_mac_tools.sh

# O verificar manualmente:
which nmap ettercap tcpdump arp-scan
ls /Applications/Wireshark.app
```

### En Kali VM:

```bash
# Copiar el script a la VM y ejecutar
chmod +x verify_kali.sh
./verify_kali.sh

# O verificar solo Yersinia:
yersinia -V
```

---

## 📋 Checklist Pre-Práctica

### Preparación General (Una sola vez)

**En macOS:**
- [ ] Instalar Wireshark: `brew install --cask wireshark`
- [ ] Verificar herramientas: `which nmap ettercap arp-scan`
- [ ] Identificar tu interfaz: `ifconfig` (normalmente `en0`)
- [ ] Acceso al switch verificado: `ping 192.168.1.237`

**En Kali VM (solo si usarás Yersinia):**
- [ ] VM en modo Bridge
- [ ] Modo Promiscuous activado
- [ ] IP en 192.168.1.x
- [ ] Yersinia instalado: `yersinia -V`

### Antes de Cada Práctica

**Si NO necesitas Yersinia (Prácticas 2, 3, 4, 5):**
```bash
# En macOS solamente
ping 192.168.1.237
open /Applications/Wireshark.app
open https://192.168.1.237
```

**Si necesitas Yersinia (Práctica 1):**
```bash
# En macOS: preparar Wireshark
open /Applications/Wireshark.app

# En Kali VM: preparar ataque
sudo yersinia -G

# En macOS: preparar defensa
open https://192.168.1.237
```

---

## 🚀 Workflows Recomendados

### Workflow Normal (Sin Yersinia)

```
Todo desde macOS
├── Terminal 1: nmap, arp-scan (reconocimiento)
├── Terminal 2: ettercap (ataques)
├── Wireshark.app (captura)
└── Navegador (configuración switch)
```

### Workflow con Yersinia (Solo Práctica 1)

```
macOS (monitoreo + defensa)          Kali VM (solo ataque)
├── Wireshark (captura)     +        └── Yersinia (DHCP Starvation)
└── Navegador (config)
```

---

## 💡 Ventajas de este Setup Híbrido

### ✅ Pros de usar macOS nativo:
- **Rendimiento:** Sin overhead de virtualización
- **Simplicidad:** Una sola máquina para la mayoría de tareas
- **Wireshark:** Mejor rendimiento de captura
- **Acceso al switch:** Navegador nativo

### ✅ Pros de usar Kali VM (solo cuando sea necesario):
- **Yersinia:** Única herramienta no disponible en macOS
- **Aislamiento:** Los ataques corren en VM separada
- **Compatibilidad:** 100% compatible con herramientas de seguridad

---

## 🎯 Guía Rápida de Decisión

**¿Qué herramienta usar?**

| Necesito... | Usar | Desde |
|-------------|------|-------|
| Escanear la red | `nmap` o `arp-scan` | ✅ macOS |
| Capturar tráfico | Wireshark | ✅ macOS |
| ARP Poisoning | `ettercap` | ✅ macOS |
| DHCP DoS | `ettercap` | ✅ macOS |
| **DHCP Starvation** | **Yersinia** | 🔴 **Kali VM** |
| Rogue DHCP | `ettercap` o `dnsmasq` | ✅ macOS |
| Cambiar MAC | `spoof-mac` | ✅ macOS |
| Acceder al switch | Navegador | ✅ macOS |

---

## 📝 Resumen de Comandos por Sistema

### macOS - Comandos Principales

```bash
# Escaneo
nmap -sn 192.168.1.0/24
sudo arp-scan -l

# Captura
open /Applications/Wireshark.app
sudo tcpdump -i en0

# Ataques
sudo ettercap -G                                    # Interfaz gráfica
sudo ettercap -T -q -i en0 -P dhcp_dos             # DHCP DoS
sudo ettercap -T -q -i en0 -M arp:remote /IP1// /IP2//  # ARP Poison

# Configuración
open https://192.168.1.237                         # Switch
ifconfig en0                                       # Ver interfaz
```

### Kali VM - Comandos (Solo Yersinia)

```bash
# Verificación
ip addr show
ping 192.168.1.237

# Yersinia
sudo yersinia -G                    # Interfaz gráfica
sudo yersinia -I                    # Modo interactivo
sudo yersinia -attack 1 -interface eth0 dhcp  # DHCP Starvation directo
```

---

## 🔍 Troubleshooting

### macOS: "Operation not permitted"
```bash
# Usar sudo
sudo ettercap -G
sudo tcpdump -i en0
```

### macOS: Wireshark no captura paquetes
```bash
# Dar permisos a BPF
sudo chmod 644 /dev/bpf*

# O reinstalar con permisos:
brew reinstall --cask wireshark
```

### macOS: No sé qué interfaz usar
```bash
# Ver todas las interfaces
ifconfig

# Ver solo las activas con IP
ifconfig | grep -A 1 "flags=" | grep "inet "

# Normalmente es 'en0' (WiFi/Ethernet principal)
```

### Kali VM: No puedo hacer ping al switch
1. Verificar modo Bridge (no NAT)
2. Obtener nueva IP: `sudo dhclient -r && sudo dhclient`
3. Verificar que estás en 192.168.1.x: `ip addr show`

---

## 🎓 Recomendación Final

**Para máxima eficiencia:**

1. **Usa macOS para todo** excepto Yersinia
2. **Solo enciende Kali VM** cuando hagas Práctica 1 (DHCP Starvation)
3. **Mantén Wireshark en macOS** siempre (mejor rendimiento de captura)
4. **Accede al switch desde macOS** (navegador nativo más cómodo)

Esto te da:
- ✅ Mejor rendimiento
- ✅ Menos complejidad
- ✅ Menos consumo de recursos
- ✅ Todas las herramientas necesarias

---

**Archivos de referencia:**
- [INSTALACION_MAC.md](INSTALACION_MAC.md) - Detalles de instalación en macOS
- [SETUP_KALI_VM.md](SETUP_KALI_VM.md) - Configuración completa de Kali
- [install_mac_tools.sh](install_mac_tools.sh) - Script de instalación macOS
- [verify_kali.sh](verify_kali.sh) - Script de verificación Kali
