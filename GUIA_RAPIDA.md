# Guía Rápida: ¿Qué Sistema Usar?

## 🎯 Decisión Rápida por Práctica

### ✅ Práctica 1: DHCP Starvation
**Sistema:** 🔴 Kali VM (para Yersinia) + ✅ macOS (para monitoreo)

| Rol | Sistema | Herramienta | Comando |
|-----|---------|-------------|---------|
| Captura | macOS | Wireshark | `open /Applications/Wireshark.app` |
| Ataque | Kali VM | Yersinia | `sudo yersinia -G` |
| Defensa | macOS | Navegador | `open https://192.168.1.237` |

**Alternativa sin Kali:**
- Usar Ettercap en macOS: `sudo ettercap -T -q -i en0 -P dhcp_dos`

---

### ✅ Práctica 2: ARP Poisoning MITM
**Sistema:** ✅ TODO desde macOS

| Tarea | Herramienta | Comando |
|-------|-------------|---------|
| Escaneo | nmap | `nmap -sn 192.168.1.0/24` |
| Captura | Wireshark | `open /Applications/Wireshark.app` |
| Ataque | Ettercap | `sudo ettercap -G` |
| Defensa | Navegador | `open https://192.168.1.237` |

---

### ✅ Práctica 3: Ciclo NIST
**Sistema:** ✅ TODO desde macOS

| Fase NIST | Herramienta | Sistema |
|-----------|-------------|---------|
| Identificar | nmap, arp-scan | macOS |
| Proteger | Navegador (switch) | macOS |
| Detectar | Wireshark | macOS |
| Responder | Navegador (switch) | macOS |
| Recuperar | Navegador (switch) | macOS |

---

### ✅ Práctica 4: Port Security
**Sistema:** ✅ TODO desde macOS

| Tarea | Comando |
|-------|---------|
| Ver MAC actual | `ifconfig en0 \| grep ether` |
| Cambiar MAC | `brew install spoof-mac` <br> `sudo spoof-mac set AA:BB:CC:DD:EE:FF en0` |
| Acceso switch | `open https://192.168.1.237` |

---

### ✅ Práctica 5: Rogue DHCP
**Sistema:** ✅ TODO desde macOS

| Tarea | Herramienta | Comando |
|-------|-------------|---------|
| Opción A | Ettercap | `sudo ettercap -T -q -i en0 -P dhcp_server` |
| Opción B | dnsmasq | `brew install dnsmasq` |
| Monitoreo | Wireshark | `open /Applications/Wireshark.app` |
| Defensa | Navegador | `open https://192.168.1.237` |

---

## 📊 Resumen Visual

```
╔═══════════════════════════════════════════════════════════════╗
║  PRÁCTICA          │  macOS  │  Kali VM  │  Rendimiento      ║
╠═══════════════════════════════════════════════════════════════╣
║  1. DHCP Starvation│    ✅   │    🔴     │  Híbrido          ║
║  2. ARP Poisoning  │    ✅   │    ❌     │  Máximo (nativo)  ║
║  3. Ciclo NIST     │    ✅   │    ❌     │  Máximo (nativo)  ║
║  4. Port Security  │    ✅   │    ❌     │  Máximo (nativo)  ║
║  5. Rogue DHCP     │    ✅   │    ❌     │  Máximo (nativo)  ║
╚═══════════════════════════════════════════════════════════════╝

✅ = Usar este sistema
🔴 = Usar solo para Yersinia
❌ = No necesario
```

---

## 🚀 Setup Inicial (Una sola vez)

### En macOS:

```bash
# 1. Ejecutar el script de instalación
./install_mac_tools.sh

# 2. Instalar Wireshark manualmente (requiere sudo)
brew install --cask wireshark

# 3. Verificar todo
which nmap ettercap arp-scan tcpdump
ls /Applications/Wireshark.app

# 4. Identificar tu interfaz de red
ifconfig
# Normalmente será 'en0'

# 5. Verificar acceso al switch
ping 192.168.1.237
```

### En Kali VM (solo si harás Práctica 1):

```bash
# 1. Configurar VM en modo Bridge

# 2. Copiar y ejecutar script de verificación
chmod +x verify_kali.sh
./verify_kali.sh

# 3. Verificar solo Yersinia
yersinia -V

# 4. Verificar conectividad
ping 192.168.1.237
```

---

## 📱 Workflows por Escenario

### Escenario A: Práctica SIN Yersinia (2, 3, 4, 5)

**Solo necesitas macOS:**

```bash
# Terminal 1: Escaneo inicial
nmap -sn 192.168.1.0/24
sudo arp-scan -l

# Terminal 2: Captura (Wireshark GUI)
open /Applications/Wireshark.app

# Terminal 3: Herramienta de ataque
sudo ettercap -G

# Navegador: Configuración del switch
open https://192.168.1.237
```

### Escenario B: Práctica CON Yersinia (Solo Práctica 1)

**Necesitas macOS + Kali VM:**

```bash
# En macOS - Terminal 1: Captura
open /Applications/Wireshark.app

# En macOS - Navegador: Switch
open https://192.168.1.237

# En Kali VM - Terminal: Ataque
sudo yersinia -G
```

---

## 🎓 Comandos Más Usados

### macOS - Top 10 Comandos

```bash
# 1. Escaneo rápido de red
nmap -sn 192.168.1.0/24

# 2. Escaneo ARP detallado
sudo arp-scan -l

# 3. Ver tu interfaz de red
ifconfig en0

# 4. Wireshark
open /Applications/Wireshark.app

# 5. Ettercap GUI
sudo ettercap -G

# 6. ARP Poisoning
sudo ettercap -T -q -i en0 -M arp:remote /192.168.1.1// /192.168.1.100//

# 7. DHCP DoS (alternativa a Yersinia)
sudo ettercap -T -q -i en0 -P dhcp_dos

# 8. Captura con tcpdump
sudo tcpdump -i en0 -w captura.pcap

# 9. Ver tu MAC
ifconfig en0 | grep ether

# 10. Acceder al switch
open https://192.168.1.237
```

### Kali VM - Solo Yersinia

```bash
# 1. Verificar interfaz
ip addr show

# 2. Yersinia GUI
sudo yersinia -G

# 3. Yersinia interactivo
sudo yersinia -I

# 4. DHCP Starvation directo
sudo yersinia -attack 1 -interface eth0 dhcp
```

---

## ✅ Checklist Antes de Cada Práctica

### Preparación Común (siempre)

- [ ] Switch Cisco accesible: `ping 192.168.1.237`
- [ ] Identificar interfaz: `ifconfig` (normalmente `en0`)
- [ ] Abrir Wireshark: `open /Applications/Wireshark.app`
- [ ] Abrir navegador al switch: `open https://192.168.1.237`

### Si usas Kali (solo Práctica 1)

- [ ] VM en modo Bridge
- [ ] IP en 192.168.1.x: `ip addr show`
- [ ] Ping al switch: `ping 192.168.1.237`
- [ ] Yersinia listo: `yersinia -V`

---

## 🔍 Solución de Problemas Comunes

### Problema: No puedo ejecutar ettercap/tcpdump en macOS
**Solución:** Necesitas sudo
```bash
sudo ettercap -G
sudo tcpdump -i en0
```

### Problema: Wireshark no captura en macOS
**Solución:** Configurar permisos BPF
```bash
sudo chmod 644 /dev/bpf*
```

### Problema: No sé qué interfaz usar en macOS
**Solución:** Ver interfaces activas
```bash
ifconfig | grep -A 1 "flags=" | grep "inet "
# Normalmente es 'en0'
```

### Problema: Kali no alcanza el switch
**Solución:** Verificar red
```bash
# 1. VM debe estar en Bridge (no NAT)
# 2. Obtener nueva IP
sudo dhclient -r && sudo dhclient
# 3. Verificar IP
ip addr show | grep "inet 192.168.1"
```

### Problema: ¿Puedo hacer DHCP Starvation sin Yersinia?
**Solución:** Sí, usa Ettercap en macOS
```bash
sudo ettercap -T -q -i en0 -P dhcp_dos
```
Nota: Yersinia es más efectivo, pero Ettercap también funciona.

---

## 📚 Documentación Adicional

| Documento | Descripción | Cuándo consultarlo |
|-----------|-------------|-------------------|
| [SETUP_HIBRIDO.md](SETUP_HIBRIDO.md) | Configuración completa híbrida | Setup inicial |
| [INSTALACION_MAC.md](INSTALACION_MAC.md) | Instalación detallada macOS | Problemas de instalación |
| [SETUP_KALI_VM.md](SETUP_KALI_VM.md) | Configuración completa Kali | Solo si usas Kali |
| [install_mac_tools.sh](install_mac_tools.sh) | Script instalación macOS | Ejecútalo una vez |
| [verify_kali.sh](verify_kali.sh) | Script verificación Kali | Antes de Práctica 1 |

---

## 💡 Recomendaciones Finales

### Para máxima eficiencia:

1. **Haz 4 de 5 prácticas completamente en macOS** (mejor rendimiento)
2. **Solo enciende Kali VM para Práctica 1** (DHCP Starvation)
3. **Mantén Wireshark siempre en macOS** (mejor captura)
4. **Usa el navegador de macOS para el switch** (más cómodo)

### Orden sugerido de prácticas:

1. **Práctica 4** (Port Security) - Más fácil, todo en macOS
2. **Práctica 2** (ARP Poisoning) - Visual y divertida, todo en macOS
3. **Práctica 5** (Rogue DHCP) - Intermedia, todo en macOS
4. **Práctica 1** (DHCP Starvation) - Requiere Kali VM
5. **Práctica 3** (Ciclo NIST) - Más compleja, todo en macOS

---

## 🎯 TL;DR (Resumen Ejecutivo)

**¿Qué necesito?**

- ✅ macOS con: nmap, ettercap, Wireshark, arp-scan (ya instalados excepto Wireshark)
- 🔴 Kali VM: SOLO para Práctica 1 (Yersinia)

**¿Cómo empiezo?**

```bash
# En macOS
brew install --cask wireshark
./install_mac_tools.sh
ping 192.168.1.237
```

**¿Listo para empezar?**

```bash
# Para Prácticas 2, 3, 4, 5 (sin Kali):
open /Applications/Wireshark.app
sudo ettercap -G
open https://192.168.1.237

# Para Práctica 1 (con Kali):
# macOS: open /Applications/Wireshark.app
# Kali: sudo yersinia -G
```

---

**¡Ya estás listo para empezar las prácticas! 🚀**

Consulta [SETUP_HIBRIDO.md](SETUP_HIBRIDO.md) para detalles completos de cada práctica.
