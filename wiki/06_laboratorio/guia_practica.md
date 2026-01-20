# Guía de la Práctica de Laboratorio

## Duración: 2 horas

## Equipo
- Switch Cisco SG300-10 (192.168.1.237)
- Router Cisco RV 120W (192.168.1.1)
- PCs de laboratorio

## Escenario Típico

```
[Internet]
    |
[Router RV 120W] ─── 192.168.1.1
    |
[Switch SG300-10] ─── 192.168.1.237
    |
    ├── [PC Admin]      ─── 192.168.1.100
    ├── [PC Víctima]    ─── 192.168.1.10 (DHCP)
    └── [PC Atacante]   ─── 192.168.1.50 (Kali Linux)
```

---

## FASE 1: Reconocimiento (15 min)

### 1.1 Configurar PC de administración
```cmd
IP: 192.168.1.100
Máscara: 255.255.255.0
Gateway: 192.168.1.1
```

### 1.2 Acceder al switch
```
https://192.168.1.237
```

### 1.3 Explorar la configuración actual
- Ver VLANs existentes
- Ver configuración de puertos
- Ver estado de seguridad

---

## FASE 2: Demostrar Vulnerabilidades (20 min)

### 2.1 ARP Poisoning (sin defensa)
```bash
# Desde PC Atacante
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//
```

**Verificar desde PC Víctima:**
```cmd
arp -a
tracert -d 8.8.8.8
```

### 2.2 DHCP Starvation (sin defensa)
```bash
# Desde PC Atacante
sudo yersinia -G
# Launch attack > DHCP > sending DISCOVER
```

**Verificar:**
```cmd
# Desde PC Víctima
ipconfig /release
ipconfig /renew  # Debería fallar
```

---

## FASE 3: Implementar Defensas (40 min)

### 3.1 Port Security
```
Security > Port Security
- Habilitar globalmente
- Configurar puertos: Limited Dynamic Lock, Max 2
```
**Ver:** `wiki/02_configuracion/seguridad/port_security.md`

### 3.2 DHCP Snooping
```
IP Configuration > DHCP Snooping/Relay > Properties
- Habilitar
- Puerto hacia DHCP: Trusted
- Puertos usuarios: Untrusted
```
**Ver:** `wiki/02_configuracion/seguridad/dhcp_snooping.md`

### 3.3 ARP Inspection
```
Security > ARP Inspection > Properties
- Habilitar
- Puerto hacia gateway: Trusted
```
**Ver:** `wiki/02_configuracion/seguridad/arp_inspection.md`

### 3.4 Guardar Configuración
```
Administration > File Management > Copy/Save Configuration
Running → Startup
```

---

## FASE 4: Verificar Defensas (30 min)

### 4.1 Re-intentar ARP Poisoning
```bash
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//
```

**Verificar:**
- Desde víctima: `arp -a` (MAC del gateway NO cambia)
- En switch: Status > System Logs (ver violaciones)

### 4.2 Re-intentar DHCP Starvation
```bash
sudo yersinia -G
# DHCP > sending DISCOVER
```

**Verificar:**
- Ataque mitigado por rate limiting
- Ver binding database: IP Config > DHCP Snooping > Binding Database

### 4.3 Documentar Resultados
Usar plantillas en `wiki/06_laboratorio/plantillas/`

---

## FASE 5: Configuraciones Adicionales (15 min)

### Opciones según tiempo disponible:

1. **802.1X + RADIUS** (si hay servidor)
   - Ver: `wiki/02_configuracion/seguridad/802_1x_radius.md`

2. **Private VLAN** (aislamiento)
   - Ver: `wiki/02_configuracion/seguridad/pvlan.md`

3. **Storm Control**
   - Limitar broadcast/multicast

---

## Troubleshooting Común

| Problema | Solución |
|----------|----------|
| No accedo al switch | Verificar IP del PC en rango 192.168.1.x |
| Configuración no persiste | Guardar Running → Startup |
| DHCP no funciona | Verificar puerto DHCP server como Trusted |
| ARP Inspection bloquea todo | Verificar puerto gateway como Trusted |
| 802.1X no autentica | Verificar RADIUS server y credenciales |

---

## Entregables

1. Capturas de pantalla de configuraciones
2. Evidencia de ataques (antes y después de defensa)
3. Logs de violaciones
4. Documentación de cada paso realizado

---

## Ver también

- [Cheatsheet](../05_comandos/cheatsheet.md) - Comandos rápidos
- [Plantilla Configuración](plantillas/plantilla_configuracion.md) - Para documentar configs
- [Plantilla Ataque](plantillas/plantilla_ataque.md) - Para documentar ataques
- [Plantilla Defensa](plantillas/plantilla_defensa.md) - Para documentar defensas
- [Checklist](../04_defensa/hardening/checklist_seguridad.md) - Lista de seguridad

---

[← Volver al Índice](../INDEX.md)
