# Roles y Tareas por Práctica

## 👥 Definición de Roles

### 🔴 ROL ATACANTE
**Responsabilidad:** Ejecutar los ataques contra la red/switch

**Sistema:** Kali VM (Práctica 1) o macOS (resto de prácticas)

**Tareas:**
- Escanear la red para identificar objetivos
- Ejecutar las herramientas de ataque
- Documentar todos los comandos utilizados
- Capturar evidencias del ataque exitoso (capturas de pantalla)
- Verificar el impacto del ataque en la víctima
- Intentar re-atacar después de la defensa
- Completar plantilla de ataque

**Herramientas principales:**
- Yersinia (DHCP Starvation)
- Ettercap (ARP Poisoning, DHCP DoS)
- nmap (reconocimiento)
- arp-scan (escaneo ARP)
- Wireshark (captura de evidencias)

---

### 🔵 ROL DEFENSOR/CONFIGURADOR
**Responsabilidad:** Configurar el switch Cisco para prevenir/detectar ataques

**Sistema:** macOS (navegador + terminal)

**Tareas:**
- Acceder al switch Cisco por interfaz web (https://192.168.1.237)
- Configurar las defensas según la práctica
- Monitorear logs y estadísticas del switch
- Capturar tráfico con Wireshark durante los ataques
- Verificar que las defensas bloquean los ataques
- Revisar y analizar logs después del ataque
- Documentar la configuración aplicada
- Completar plantilla de defensa

**Herramientas principales:**
- Navegador web (acceso al switch)
- Wireshark (monitoreo de tráfico)
- Terminal (verificación de estado de red)

---

## 📋 Distribución de Tareas por Práctica

### Práctica 1: DHCP Starvation

#### 🔴 ATACANTE
**Sistema:** Kali VM

| Fase | Tarea | Herramienta | Comando |
|------|-------|-------------|---------|
| Reconocimiento | Identificar servidor DHCP | nmap | `sudo nmap -sU -p 67 192.168.1.0/24` |
| Captura previa | Iniciar captura | Wireshark | `sudo wireshark` (filtro: `bootp`) |
| Ataque | DHCP Starvation | Yersinia | `sudo yersinia -G` |
| Verificación | Comprobar pool agotado | Cliente DHCP | Intentar obtener IP |
| Re-ataque | Intentar tras defensa | Yersinia | Mismo comando |

**Evidencias a capturar:**
- Screenshot de Yersinia ejecutándose
- Captura Wireshark mostrando floods DHCP
- Screenshot de víctima sin obtener IP
- Logs después de aplicar defensa

#### 🔵 DEFENSOR (TÚ)
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando/Acción |
|------|-------|-------------|----------------|
| Preparación | Abrir Wireshark | Terminal | `open /Applications/Wireshark.app` |
| Monitoreo | Capturar ataque | Wireshark | Filtro: `bootp or dhcp` |
| Acceso | Conectar al switch | Navegador | `open https://192.168.1.237` |
| Configuración | Habilitar DHCP Snooping | Web UI | Security > DHCP Snooping > Enable |
| Configuración | Configurar puerto trusted | Web UI | Marcar puerto del router como trusted |
| Verificación | Ver logs del switch | Web UI | Logs > System Logs |
| Test | Verificar bloqueo | Wireshark | Observar que se bloquean peticiones falsas |

**Pasos de configuración en el switch:**
1. Security > DHCP Snooping > Enable DHCP Snooping
2. Identificar puerto del router (puerto trusted)
3. Configurar ese puerto como "Trusted"
4. Resto de puertos quedan como "Untrusted" por defecto
5. Aplicar configuración
6. Verificar en Logs que se bloquean peticiones sospechosas

---

### Práctica 2: ARP Poisoning MITM

#### 🔴 ATACANTE
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando |
|------|-------|-------------|---------|
| Reconocimiento | Escanear red | nmap | `nmap -sn 192.168.1.0/24` |
| Reconocimiento | Ver tabla ARP | arp | `arp -a` |
| Captura previa | Iniciar Wireshark | Terminal | `open /Applications/Wireshark.app` |
| Ataque | ARP Poisoning | Ettercap | `sudo ettercap -G` |
| Ataque | Configurar objetivos | Ettercap GUI | Router: 192.168.1.1, Víctima: otra PC |
| Verificación | Capturar tráfico MITM | Wireshark | Ver tráfico de la víctima |
| Re-ataque | Intentar tras DAI | Ettercap | Mismo ataque |

**Configuración de Ettercap:**
1. Abrir Ettercap: `sudo ettercap -G`
2. Sniff > Unified Sniffing > Seleccionar interfaz (en0)
3. Hosts > Scan for hosts
4. Hosts > Hosts list
5. Seleccionar router (192.168.1.1) > Add to Target 1
6. Seleccionar víctima > Add to Target 2
7. MITM > ARP Poisoning > Sniff remote connections
8. Start > Start sniffing

#### 🔵 DEFENSOR (TÚ)
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando/Acción |
|------|-------|-------------|----------------|
| Preparación | Abrir Wireshark | Terminal | `open /Applications/Wireshark.app` |
| Monitoreo | Capturar ARP | Wireshark | Filtro: `arp` |
| Observación | Detectar ARP spoofing | Wireshark | Ver múltiples replies para misma IP |
| Acceso | Conectar al switch | Navegador | `open https://192.168.1.237` |
| Config previa | Habilitar DHCP Snooping | Web UI | (Necesario para DAI) |
| Configuración | Habilitar DAI | Web UI | Security > ARP Inspection > Enable |
| Configuración | Configurar VLANs con DAI | Web UI | Habilitar DAI en VLAN activa |
| Verificación | Ver logs ARP drop | Web UI | Logs > verificar paquetes ARP bloqueados |

**Pasos de configuración en el switch:**
1. **Prerequisito:** DHCP Snooping debe estar habilitado
2. Security > ARP Inspection > Enable Dynamic ARP Inspection
3. Configurar en qué VLANs aplicar (normalmente VLAN 1)
4. Los puertos trusted de DHCP Snooping se respetan
5. Aplicar configuración
6. Verificar en Logs que se bloquean paquetes ARP falsificados

---

### Práctica 3: Ciclo NIST

**Nota:** Esta práctica combina elementos de las otras prácticas siguiendo el framework NIST

#### 🔴 ATACANTE
**Sistema:** macOS

**Tareas por función NIST:**
- **Identificar:** Escanear red, identificar vulnerabilidades
- **Proteger:** (No aplica - es el defensor)
- **Detectar:** (No aplica - es el defensor)
- **Responder:** Ejecutar diferentes ataques según guía
- **Recuperar:** (No aplica - es el defensor)

#### 🔵 DEFENSOR (TÚ)
**Sistema:** macOS

**Tareas por función NIST:**

| Función | Tareas | Herramientas |
|---------|--------|--------------|
| **Identificar** | Inventario de activos, topología | nmap, diagrama de red |
| **Proteger** | Configurar todas las defensas | Switch web UI |
| **Detectar** | Monitorear tráfico y logs | Wireshark, Switch logs |
| **Responder** | Bloquear ataques detectados | Configuración switch |
| **Recuperar** | Restaurar servicio, documentar | Logs, reportes |

---

### Práctica 4: Port Security

#### 🔴 ATACANTE
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando |
|------|-------|-------------|---------|
| Reconocimiento | Ver MAC actual | ifconfig | `ifconfig en0 \| grep ether` |
| Preparación | Instalar spoof-mac | brew | `brew install spoof-mac` |
| Ataque | Cambiar MAC | spoof-mac | `sudo spoof-mac set AA:BB:CC:DD:EE:FF en0` |
| Verificación | Verificar nueva MAC | ifconfig | `ifconfig en0 \| grep ether` |
| Conexión | Intentar conectar | Terminal | Verificar si obtiene IP |
| Re-ataque | Probar otra MAC | spoof-mac | Cambiar a otra MAC aleatoria |
| Restauración | Volver a MAC original | spoof-mac | `sudo spoof-mac reset en0` |

#### 🔵 DEFENSOR (TÚ)
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando/Acción |
|------|-------|-------------|----------------|
| Preparación | Identificar MAC legítima | arp-scan | `sudo arp-scan -l` |
| Acceso | Conectar al switch | Navegador | `open https://192.168.1.237` |
| Configuración | Habilitar Port Security | Web UI | Port Management > Port Security |
| Configuración | Modo: Limit | Web UI | Establecer máximo 1 MAC por puerto |
| Configuración | Acción: Shutdown | Web UI | Puerto se deshabilita si viola |
| Verificación | Ver tabla de MACs | Web UI | Ver MACs aprendidas |
| Monitoreo | Ver violaciones | Web UI | Logs > Port Security violations |
| Recuperación | Re-habilitar puerto | Web UI | Si fue deshabilitado por violación |

**Pasos de configuración en el switch:**
1. Port Management > Port Security
2. Seleccionar puerto a proteger
3. Enable Port Security
4. Modo: "Limit" o "Static"
5. Max MACs: 1 (o las necesarias)
6. Action on Violation: "Shutdown" o "Trap"
7. Si modo Static: añadir MACs permitidas manualmente
8. Aplicar configuración

---

### Práctica 5: Rogue DHCP

#### 🔴 ATACANTE
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando |
|------|-------|-------------|---------|
| Preparación | Instalar dnsmasq | brew | `brew install dnsmasq` |
| Configuración | Configurar servidor DHCP falso | dnsmasq | Editar `/opt/homebrew/etc/dnsmasq.conf` |
| Alternativa | Usar Ettercap | ettercap | `sudo ettercap -T -q -i en0 -P dhcp_server` |
| Ataque | Iniciar servidor falso | dnsmasq | `sudo brew services start dnsmasq` |
| Verificación | Ver clientes conectados | logs | Ver logs de dnsmasq |
| Captura | Monitorear respuestas | Wireshark | Filtro: `bootp` |

**Configuración de dnsmasq:**
```bash
# Editar: /opt/homebrew/etc/dnsmasq.conf
interface=en0
dhcp-range=192.168.1.100,192.168.1.200,12h
dhcp-option=3,192.168.1.254  # Gateway falso (tu IP)
dhcp-option=6,8.8.8.8        # DNS
```

#### 🔵 DEFENSOR (TÚ)
**Sistema:** macOS

| Fase | Tarea | Herramienta | Comando/Acción |
|------|-------|-------------|----------------|
| Preparación | Capturar tráfico DHCP | Wireshark | Filtro: `bootp or dhcp` |
| Detección | Identificar servidor falso | Wireshark | Ver múltiples DHCP Offers |
| Acceso | Conectar al switch | Navegador | `open https://192.168.1.237` |
| Configuración | Habilitar DHCP Snooping | Web UI | (Si no estaba ya) |
| Configuración | Configurar puerto trusted | Web UI | Solo puerto del router legítimo |
| Configuración | Rate limit DHCP | Web UI | Limitar paquetes DHCP por segundo |
| Verificación | Ver servidores bloqueados | Web UI | Logs > DHCP Snooping |

**Diferencia clave con Práctica 1:**
- Práctica 1: Atacante agota el pool (Starvation)
- Práctica 5: Atacante se hace pasar por servidor DHCP (Rogue)
- Defensa: Misma (DHCP Snooping) pero diferente enfoque

---

## 🎯 Resumen de Herramientas por Rol

### 🔴 ATACANTE

| Herramienta | Práctica(s) | Sistema | Instalación |
|-------------|-------------|---------|-------------|
| Yersinia | 1 | Kali VM | Preinstalado |
| Ettercap | 2, 5 | macOS | `brew install ettercap` ✅ |
| nmap | Todas | macOS | `brew install nmap` ✅ |
| arp-scan | Varias | macOS | `brew install arp-scan` ✅ |
| spoof-mac | 4 | macOS | `brew install spoof-mac` |
| dnsmasq | 5 | macOS | `brew install dnsmasq` |
| Wireshark | Todas | macOS | `brew install --cask wireshark` ⚠️ |

### 🔵 DEFENSOR (TÚ)

| Herramienta | Para qué | Instalación |
|-------------|----------|-------------|
| Navegador web | Configurar switch | Ya instalado ✅ |
| Wireshark | Monitorear tráfico | `brew install --cask wireshark` ⚠️ |
| Terminal | Verificaciones | Ya instalado ✅ |
| ifconfig/ip | Ver estado de red | Ya instalado ✅ |

---

## 📋 Checklist por Rol

### 🔴 ATACANTE - Antes de cada práctica

- [ ] Identificar interfaz de red (`ifconfig` o `ip addr`)
- [ ] Verificar conectividad con el switch (`ping 192.168.1.237`)
- [ ] Abrir Wireshark para captura de evidencias
- [ ] Tener comandos preparados según la práctica
- [ ] Preparar screenshots para documentación

### 🔵 DEFENSOR (TÚ) - Antes de cada práctica

- [ ] Abrir Wireshark para monitoreo (`open /Applications/Wireshark.app`)
- [ ] Acceder al switch (`open https://192.168.1.237`)
- [ ] Verificar estado inicial de configuración
- [ ] Tener manual/documentación de configuración disponible
- [ ] Preparar plantilla de defensa

### Durante la práctica (AMBOS)

🔴 **ATACANTE:**
- [ ] Documentar TODOS los comandos ejecutados
- [ ] Capturar screenshots del ataque en ejecución
- [ ] Verificar impacto del ataque
- [ ] Comunicar al defensor cuando ataque está activo
- [ ] Re-intentar ataque después de defensa aplicada

🔵 **DEFENSOR (TÚ):**
- [ ] Capturar tráfico ANTES del ataque (baseline)
- [ ] Observar el impacto del ataque en Wireshark
- [ ] Aplicar configuración de seguridad en el switch
- [ ] Verificar logs del switch
- [ ] Confirmar que ataque es bloqueado después de defensa
- [ ] Documentar todos los cambios de configuración

---

## 💡 Consejos por Rol

### Para el ATACANTE

1. **Siempre captura evidencia ANTES de atacar** (para comparar)
2. **Documenta cada comando** - necesitarás ponerlo en el informe
3. **No te adelantes** - espera a que el defensor esté listo
4. **Comunica claramente** cuándo empiezas el ataque
5. **Verifica el impacto** - asegúrate de que el ataque funciona

### Para el DEFENSOR (TÚ)

1. **Monitorea siempre con Wireshark** - es tu mejor herramienta de detección
2. **Lee los logs del switch** - ahí verás qué está bloqueando
3. **Guarda la configuración** después de cada cambio
4. **Toma screenshots** de la configuración aplicada
5. **Pide al atacante que re-intente** para verificar que la defensa funciona
6. **Documenta EXACTAMENTE qué configuraste** y por qué

---

## 🚀 Workflow Típico de una Práctica

### FASE 1: Reconocimiento (15-20 min)

**AMBOS:**
- Verificar conectividad
- Identificar equipos en la red
- Acceder a herramientas

### FASE 2: Ataque SIN Defensa (20-25 min)

🔵 **DEFENSOR (TÚ):**
1. Abrir Wireshark, iniciar captura
2. Informar al atacante: "Listo para capturar"

🔴 **ATACANTE:**
3. Lanzar ataque
4. Verificar impacto

**AMBOS:**
5. Documentar evidencias (screenshots, logs)
6. Analizar impacto

### FASE 3: Implementar Defensa (30-40 min)

🔵 **DEFENSOR (TÚ):**
1. Acceder al switch
2. Aplicar configuración de seguridad
3. Guardar configuración
4. Verificar que se aplicó correctamente
5. Informar: "Defensa aplicada, re-intenta ataque"

### FASE 4: Verificar Defensa (20-30 min)

🔴 **ATACANTE:**
1. Re-ejecutar mismo ataque
2. Verificar que NO funciona

🔵 **DEFENSOR (TÚ):**
3. Verificar en Wireshark que se bloquea
4. Revisar logs del switch
5. Tomar screenshots de logs mostrando bloqueo

**AMBOS:**
6. Confirmar que defensa es efectiva

### FASE 5: Documentación (15-35 min)

🔴 **ATACANTE:**
- Completar plantilla de ataque

🔵 **DEFENSOR (TÚ):**
- Completar plantilla de defensa
- Documentar configuración exacta aplicada

**AMBOS:**
- Tabla comparativa antes/después
- Mapeo a funciones NIST

---

## 📞 Comunicación entre Roles

### Frases clave para coordinación:

🔴 **ATACANTE dice:**
- "Empiezo reconocimiento"
- "Listo para atacar, ¿estás capturando?"
- "Ataque lanzado"
- "El ataque está funcionando / no funciona"
- "Re-intentando ataque ahora"

🔵 **DEFENSOR (TÚ) dices:**
- "Wireshark capturando, adelante"
- "Veo el ataque en Wireshark"
- "Aplicando defensa ahora"
- "Defensa aplicada, re-intenta"
- "Confirmo: ataque bloqueado"

---

**Este documento debe ser tu referencia principal para saber exactamente qué hacer en cada práctica según tu rol de DEFENSOR.**

Cuando tengas la práctica específica que van a hacer, pásame el documento y te daré instrucciones detalladas paso a paso para la configuración del switch.
