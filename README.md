# Prácticas de Seguridad en Redes Cisco

Setup y documentación para realizar las prácticas de laboratorio de seguridad en redes con equipamiento Cisco.

## 🚀 Inicio Rápido

### ¿Primera vez aquí?

**Lee primero:** [GUIA_RAPIDA.md](GUIA_RAPIDA.md) ⭐

Este documento te dirá exactamente qué herramienta usar en cada práctica y desde qué sistema (macOS o Kali VM).

### Instalación en macOS

```bash
# 1. Ejecutar script de instalación automática
./install_mac_tools.sh

# 2. Instalar Wireshark manualmente (requiere sudo)
brew install --cask wireshark

# 3. Verificar acceso al switch
ping 192.168.1.237
```

### Configuración de Kali VM (solo para Práctica 1)

```bash
# Ejecutar en Kali VM
./verify_kali.sh
```

---

## 📚 Documentación Disponible

### Guías de Setup

| Documento | Descripción | Cuándo leerlo |
|-----------|-------------|---------------|
| [**GUIA_RAPIDA.md**](GUIA_RAPIDA.md) | ⭐ **EMPIEZA AQUÍ** - Qué usar en cada práctica | Primera lectura obligatoria |
| [SETUP_HIBRIDO.md](SETUP_HIBRIDO.md) | Configuración completa macOS + Kali | Setup inicial detallado |
| [INSTALACION_MAC.md](INSTALACION_MAC.md) | Instalación y troubleshooting macOS | Problemas con instalación |
| [SETUP_KALI_VM.md](SETUP_KALI_VM.md) | Configuración completa de Kali VM | Solo si usas Kali |

### Scripts de Instalación

| Script | Descripción | Uso |
|--------|-------------|-----|
| [install_mac_tools.sh](install_mac_tools.sh) | Instala herramientas en macOS | `./install_mac_tools.sh` |
| [verify_kali.sh](verify_kali.sh) | Verifica setup de Kali VM | `./verify_kali.sh` (en Kali) |

### Prácticas de Laboratorio

| Documento | Descripción |
|-----------|-------------|
| [wiki/06_laboratorio/practicas/README.md](wiki/06_laboratorio/practicas/README.md) | Índice completo de todas las prácticas |

---

## 🎯 Resumen de Configuración

### Estrategia Recomendada

**macOS (Sistema Principal)** - 4 de 5 prácticas
- ✅ Práctica 2: ARP Poisoning MITM
- ✅ Práctica 3: Ciclo NIST
- ✅ Práctica 4: Port Security
- ✅ Práctica 5: Rogue DHCP

**Kali VM (Solo cuando sea necesario)** - 1 de 5 prácticas
- 🔴 Práctica 1: DHCP Starvation (requiere Yersinia)

### Herramientas Instaladas en macOS

| Herramienta | Estado | Versión |
|-------------|--------|---------|
| nmap | ✅ Instalado | 7.98 |
| ettercap | ✅ Instalado | 0.8.3.1 |
| tcpdump | ✅ Instalado | 4.99.1 |
| arp-scan | ✅ Instalado | 1.10.0 |
| Wireshark | ⚠️ Instalar | - |

---

## 📝 Equipamiento de Laboratorio

- **Switch:** Cisco SG300-10 (192.168.1.237)
- **Router:** Cisco RV120W (192.168.1.1)
- **PCs:** macOS (host) + Kali Linux VM
- **Red:** 192.168.1.0/24

---

## 🔧 Comandos Más Usados

### Desde macOS

```bash
# Escaneo de red
nmap -sn 192.168.1.0/24
sudo arp-scan -l

# Herramientas gráficas
open /Applications/Wireshark.app
sudo ettercap -G

# Acceso al switch
open https://192.168.1.237

# ARP Poisoning
sudo ettercap -T -q -i en0 -M arp:remote /192.168.1.1// /192.168.1.100//

# DHCP DoS (alternativa a Yersinia)
sudo ettercap -T -q -i en0 -P dhcp_dos
```

### Desde Kali VM (solo Práctica 1)

```bash
# Yersinia para DHCP Starvation
sudo yersinia -G
```

---

## 🎓 Prácticas Disponibles

### Prácticas de Ataque/Defensa

1. **DHCP Starvation** - Agotar pool DHCP, implementar DHCP Snooping
2. **ARP Poisoning MITM** - Man-in-the-Middle en capa 2, implementar DAI
3. **Ciclo NIST** - Framework completo de ciberseguridad
4. **Port Security** - Control de direcciones MAC por puerto
5. **Rogue DHCP** - Servidor DHCP falso, detección y prevención

### Prácticas de Configuración

6. **Segmentación VLANs** - Diseño e implementación de VLANs
7. **Control Acceso 802.1X** - NAC con RADIUS
8. **Hardening Completo** - Securización integral del switch

### Práctica Real (Examen 2025)

- [**ENUNCIADO**](wiki/06_laboratorio/practicas/ENUNCIADO_practica_seguridad_lan_2025.md)
- [**SOLUCIÓN**](wiki/06_laboratorio/practicas/SOLUCION_practica_seguridad_lan_2025.md)

---

## 💡 Consejos

### Antes de Empezar

1. Verifica que puedes hacer ping al switch: `ping 192.168.1.237`
2. Identifica tu interfaz de red: `ifconfig` (normalmente `en0`)
3. Ten Wireshark siempre abierto para capturar evidencia
4. Documenta todos los comandos que ejecutes

### Durante las Prácticas

- **Atacante:** Documenta comandos, captura evidencias, verifica impacto
- **Defensor:** Configura el switch, monitorea logs, verifica defensas
- **Ambos:** Trabajad en equipo, comunicad los hallazgos

### Herramientas Requieren sudo

```bash
# Todas las herramientas de red requieren permisos de administrador
sudo ettercap -G
sudo tcpdump -i en0
sudo wireshark
sudo arp-scan -l
```

---

## 🔍 Troubleshooting

### Problema: No puedo acceder al switch (192.168.1.237)

```bash
# Verificar conectividad
ping 192.168.1.237

# Ver tu IP actual
ifconfig en0 | grep "inet "

# Solicitar nueva IP por DHCP
sudo ipconfig set en0 DHCP
```

### Problema: Wireshark no captura paquetes en macOS

```bash
# Dar permisos a BPF (Berkeley Packet Filter)
sudo chmod 644 /dev/bpf*
```

### Problema: No sé qué interfaz usar

```bash
# Ver todas las interfaces
ifconfig

# Ver solo las activas
ifconfig | grep -A 1 "flags=" | grep "inet "

# Normalmente es 'en0' (WiFi/Ethernet principal)
```

### Más problemas

Consulta la sección de troubleshooting en:
- [GUIA_RAPIDA.md](GUIA_RAPIDA.md#-solución-de-problemas-comunes)
- [INSTALACION_MAC.md](INSTALACION_MAC.md#troubleshooting)

---

## 📖 Estructura del Repositorio

```
PracticaRedes/
├── README.md                    # Este archivo - punto de entrada
├── GUIA_RAPIDA.md              # ⭐ Guía de decisión rápida
├── SETUP_HIBRIDO.md            # Setup completo macOS + Kali
├── INSTALACION_MAC.md          # Instalación detallada macOS
├── SETUP_KALI_VM.md            # Configuración de Kali VM
├── install_mac_tools.sh        # Script de instalación macOS
├── verify_kali.sh              # Script de verificación Kali
└── wiki/
    └── 06_laboratorio/
        └── practicas/
            ├── README.md                                    # Índice de prácticas
            ├── practica_01_dhcp_starvation.md
            ├── practica_02_arp_poisoning.md
            ├── practica_03_ciclo_nist.md
            ├── practica_04_port_security.md
            ├── practica_05_rogue_dhcp.md
            ├── practica_06_segmentacion_vlans.md
            ├── practica_07_control_acceso_8021x.md
            ├── practica_08_hardening_completo.md
            ├── ENUNCIADO_practica_seguridad_lan_2025.md
            └── SOLUCION_practica_seguridad_lan_2025.md
```

---

## 🚀 Empezar Ahora

### Paso 1: Instalación

```bash
# Instalar herramientas en macOS
./install_mac_tools.sh
brew install --cask wireshark
```

### Paso 2: Verificación

```bash
# Verificar herramientas
which nmap ettercap arp-scan tcpdump
ls /Applications/Wireshark.app

# Verificar acceso al switch
ping 192.168.1.237
```

### Paso 3: Elegir Práctica

Consulta [GUIA_RAPIDA.md](GUIA_RAPIDA.md) para ver qué herramientas usar en cada práctica.

### Paso 4: Ejecutar

```bash
# Abrir herramientas
open /Applications/Wireshark.app
sudo ettercap -G
open https://192.168.1.237
```

---

## 📞 Ayuda y Soporte

- **Problemas de instalación:** Ver [INSTALACION_MAC.md](INSTALACION_MAC.md)
- **Problemas de configuración:** Ver [SETUP_HIBRIDO.md](SETUP_HIBRIDO.md)
- **Dudas sobre qué usar:** Ver [GUIA_RAPIDA.md](GUIA_RAPIDA.md)
- **Troubleshooting general:** Buscar en cada guía

---

## 📊 Estado del Proyecto

- ✅ Documentación completa
- ✅ Scripts de instalación
- ✅ Scripts de verificación
- ✅ Guías por práctica
- ✅ Setup híbrido macOS + Kali
- ✅ Troubleshooting

**Todo listo para empezar las prácticas!** 🎉

---

## 🎯 Orden Recomendado de Lectura

1. **README.md** (este archivo) - Contexto general
2. **[GUIA_RAPIDA.md](GUIA_RAPIDA.md)** - Qué usar en cada práctica ⭐
3. **[SETUP_HIBRIDO.md](SETUP_HIBRIDO.md)** - Configuración completa
4. **[wiki/06_laboratorio/practicas/README.md](wiki/06_laboratorio/practicas/README.md)** - Empezar prácticas

---

**Última actualización:** 2026-01-22
