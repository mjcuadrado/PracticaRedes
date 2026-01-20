# Yersinia - Ataques Layer 2

## Instalación

```bash
sudo apt-get update
sudo apt-get install yersinia
```

## Modos de Ejecución

```bash
# Modo gráfico (GTK) - RECOMENDADO
sudo yersinia -G

# Modo texto interactivo
sudo yersinia -I

# Modo daemon
sudo yersinia -D
```

## Protocolos Soportados

| Protocolo | Ataques posibles |
|-----------|------------------|
| **DHCP** | Starvation, Rogue Server |
| **STP** | Root Bridge, TCN |
| **CDP** | Flooding |
| **DTP** | Trunk negotiation |
| **802.1Q** | VLAN hopping |
| **VTP** | Domain manipulation |
| **HSRP** | Active router takeover |

## Ataque DHCP Starvation

### Desde GUI
1. `sudo yersinia -G`
2. Menú: **Launch attack**
3. Seleccionar **DHCP**
4. Tipo: **sending DISCOVER packet** (starvation)
5. Click **OK**

### Desde línea de comandos
```bash
# Modo interactivo
sudo yersinia -I
# Seleccionar: d (DHCP)
# Seleccionar: x (launch attack)
# Seleccionar: 1 (sending DISCOVER packet)
```

### Efecto
- Envía múltiples DHCP DISCOVER con MACs aleatorias
- Agota el pool de direcciones del servidor DHCP
- Los clientes legítimos no pueden obtener IP

## Ataque DHCP Rogue Server

### Desde GUI
1. `sudo yersinia -G`
2. **Launch attack** > **DHCP**
3. Tipo: **creating DHCP rogue server**
4. Configurar:
   - IP pool
   - Gateway (IP del atacante para MITM)
   - DNS

## Ataque STP (Spanning Tree)

### Becoming Root Bridge
```bash
# Envía BPDUs con prioridad 0
# El atacante se convierte en root bridge
# Todo el tráfico pasa por él
```
1. **Launch attack** > **STP**
2. Seleccionar: **sending conf BPDUs**

## Verificación de Ataques

### DHCP Starvation
```bash
# En el servidor DHCP, ver leases
cat /var/lib/dhcp/dhcpd.leases

# En Wireshark
# Filtro: bootp
# Ver muchos DISCOVER desde MACs diferentes
```

### Desde víctima
```cmd
# Windows - intentar renovar
ipconfig /release
ipconfig /renew
# Debería fallar si el pool está agotado
```

## Detener Ataque

- GUI: Click en **Stop attack** o cerrar ventana
- Interactivo: `q` para salir

## Precauciones

- Yersinia es muy agresivo
- Puede causar DoS en toda la red
- Usar solo en entornos de laboratorio controlados

---

## Ver también

- [DHCP Attacks](../explotacion/dhcp_attacks.md) - Guía completa de ataques DHCP
- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - **DEFENSA** contra estos ataques
- [Port Security](../../02_configuracion/seguridad/port_security.md) - Complementa contra Starvation
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Probar las defensas

---

[← Volver al Índice](../../INDEX.md)
