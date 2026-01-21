# ENUNCIADO: Práctica Seguridad LAN 2025

## Información

| Campo | Valor |
|-------|-------|
| **Asignatura** | Seguridad en las Redes |
| **Máster** | Seguridad Informática |
| **Universidad** | Escuela Politécnica Superior de Jaén |

---

## Topología de Red

```
                         ┌─────────────────┐
                         │    INTERNET     │
                         └────────┬────────┘
                                  │
                         ┌────────▼────────┐
                         │     ROUTER      │
                         │  192.168.88.1   │
                         │  User: admin    │
                         │  Pass: (vacío)  │
                         └────────┬────────┘
                                  │
                         ┌────────▼────────┐
                         │     SWITCH      │
                         │  192.168.88.XX  │
                         │  User: cisco25  │
                         │  Pass: cisco.25 │
                         └───┬─────────┬───┘
                             │         │
                    ┌────────▼───┐ ┌───▼────────────┐
                    │ PC LINUX/  │ │ PC WINDOWS/    │
                    │ macOS      │ │ macOS          │
                    │ (Atacante) │ │ (Gestión)      │
                    │192.168.88.X│ │ 192.168.88.X   │
                    └────────────┘ └────────────────┘
```

---

## Instrucciones Iniciales

1. **Instalar la red** según el diagrama
2. **Reiniciar** el router y el switch
3. **Iniciar** dos ordenadores (pueden ser Linux, macOS o Windows)

---

## Tareas de Reconocimiento

### Desde PC Gestión - Router

1. Acceder a la página web de gestión del router
2. Entrar en **IP → ARP** (tablas IP-ARP)
3. Entrar en **TOOLS → IP Scan** (escanear red 192.168.88.0/24)
4. **Anotar** las direcciones IP y MAC de la red

### Desde PC Gestión - Switch

1. Acceder a la página web de gestión del switch
2. Configurar usuario: `cisco25` con password: `cisco.25`
3. Poner el usuario en **modo avanzado**
4. Analizar el menú **"IPv4 - DHCP Snooping"**
5. Analizar el menú **"Security"**
6. Analizar la **ayuda** del switch

### Desde PC Atacante - Instalar Ettercap

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update && sudo apt-get install ettercap-graphical -y
sudo ettercap -G
```

**macOS:**
```bash
brew install ettercap
sudo ettercap -G
```

---

## PARTE 1: ARP

### Ataque ARP

1. Desde Ettercap, obtener lista de hosts (**host list**)
2. Definir objetivos (targets):
   - **Target 1:** IP ordenador víctima (PC Gestión)
   - **Target 2:** IP LAN router
3. Arrancar el **sniffing**
4. Arrancar el **ataque MiTM de ARP**
5. Analizar las direcciones MAC e IP desde el router en **IP → ARP**
6. Analizar las conexiones en Ettercap

### Defensa ARP

En la gestión del switch:

| Menú | Configuración |
|------|---------------|
| **Security → ARP Inspection** | |
| ARP Inspection Status | Habilitar |
| ARP Packet Validation | Habilitar validaciones |
| Interface Settings | Configurar puertos de confianza |
| ARP Access Control | Crear reglas IP-MAC |
| VLAN Settings | Activar en VLAN 1 |

---

## PARTE 2: DHCP

### Ataque DHCP

1. Desde Ettercap, activar **DHCP Spoofing**:
   - Netmask: `255.255.255.0`
   - DNS Server IP: Dirección IP del ordenador atacante
2. En PC víctima, renovar IP:

   **Windows:**
   ```cmd
   ipconfig /release
   ipconfig /renew
   ```

   **macOS:**
   ```bash
   sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP
   ```

3. Analizar las direcciones MAC e IP desde el router en **IP → ARP**
4. Verificar la configuración de red:
   - **Windows:** `ipconfig /all`
   - **macOS:** `ipconfig getpacket en0`
5. Analizar las conexiones en Ettercap

### Defensa DHCP

En la gestión del switch:

| Menú | Configuración |
|------|---------------|
| **IPv4 → DHCP Snooping** | |
| DHCP Snooping | Activar |
| Tabla DHCP interfaces | Revisar |
| Interfaces de confianza | Configurar puerto del router como trusted |
| Database table | Verificar bindings |

---

## Entregables

- [ ] Tabla con IPs y MACs de la red
- [ ] Capturas de pantalla del ataque ARP funcionando
- [ ] Capturas de pantalla de la defensa ARP configurada
- [ ] Capturas de pantalla del ataque DHCP funcionando
- [ ] Capturas de pantalla de la defensa DHCP configurada
- [ ] Evidencia de que las defensas bloquean los ataques

---

## Navegación

[Ver Solución Completa →](SOLUCION_practica_seguridad_lan_2025.md)

⬅️ [Volver a Prácticas](README.md) | [Índice Wiki](../../INDEX.md)
