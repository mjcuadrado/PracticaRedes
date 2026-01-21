# Práctica 4: Port Security Básico

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 1 hora 30 minutos |
| **Dificultad** | Baja (Ideal para primeros contactos con Cisco) |
| **Ataque simulado** | Conexión de dispositivos no autorizados |
| **Defensa** | Port Security (limitación de MACs por puerto) |
| **Herramientas** | Interfaz web del switch, comandos básicos |

## Objetivo

Familiarizarse con la interfaz del switch Cisco SG300-10 y configurar Port Security para limitar el número de dispositivos que pueden conectarse a cada puerto, detectando conexiones no autorizadas.

---

## Roles del Equipo

| Rol | Responsabilidad | Actividades |
|-----|-----------------|-------------|
| **🔴 INTRUSO** | Simular conexión no autorizada | Conectar dispositivos extra, cambiar MAC |
| **🔵 ADMINISTRADOR** | Configurar y monitorear el switch | Port Security, revisar logs |

> Esta práctica es ideal para empezar porque no requiere herramientas de ataque especiales.

---

## Escenario

```
Escenario: Una oficina pequeña donde cada empleado tiene UN dispositivo asignado.
Política: Máximo 1-2 dispositivos por puerto (PC + ocasionalmente móvil).
Problema: Alguien podría conectar un switch no autorizado o múltiples dispositivos.

┌────────────────────────────────────────────────────┐
│                    SWITCH SG300                     │
│  ┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┤
│  │GE1 │GE2 │GE3 │GE4 │GE5 │GE6 │GE7 │GE8 │GE9 │GE10│
│  └─┬──┴─┬──┴─┬──┴────┴────┴────┴────┴────┴────┴────┤
│    │    │    │                                      │
└────┼────┼────┼──────────────────────────────────────┘
     │    │    │
   Router │    │
          │    │
    🔵 Admin   🔴 Intruso
    (1 MAC)   (¿Múltiples MACs?)
```

---

## FASE 1: Exploración del Switch (20 minutos)

> **Objetivo:** Familiarizarse con la interfaz web del switch.

### 🔵 ADMINISTRADOR: Acceso y exploración

#### Paso 1.1: Acceder al switch

1. Abre el navegador
2. Navega a: `https://192.168.1.237`
3. Acepta la advertencia del certificado
4. Inicia sesión con las credenciales proporcionadas

**Captura de pantalla:** Pantalla de login

#### Paso 1.2: Explorar el dashboard

Una vez dentro, observa:
- **System Summary:** Información del equipo, uptime, versión
- **Port Status:** Estado de cada puerto

**Navega a:** Status and Statistics → System Summary

**Anota:**
- Modelo: `_______________`
- Versión firmware: `_______________`
- Uptime: `_______________`

#### Paso 1.3: Ver estado de los puertos

**Navega a:** Status and Statistics → Port Status

Observa:
- Qué puertos están UP (link activo)
- Velocidad de cada puerto
- Modo duplex

**Tabla de puertos:**

| Puerto | Estado | Velocidad | Duplex |
|--------|--------|-----------|--------|
| GE1 | | | |
| GE2 | | | |
| GE3 | | | |
| ... | | | |

#### Paso 1.4: Ver direcciones MAC aprendidas

**Navega a:** Status and Statistics → MAC Address Table

Observa qué MACs ha aprendido el switch y en qué puertos.

**Captura de pantalla:** Tabla MAC actual

---

### 🔴 INTRUSO: Identificar tu configuración

#### Paso 1.5: Obtener tu dirección MAC

```bash
# macOS
ifconfig en0 | grep ether

# Linux
ip link show eth0 | grep ether

# Windows
ipconfig /all | findstr "Physical"
```

**Tu MAC:** `___:___:___:___:___:___`
**Tu puerto en el switch:** `GE___`

---

## FASE 2: Situación SIN Port Security (15 minutos)

> **Objetivo:** Demostrar qué pasa cuando no hay control de MACs.

### 🔵 ADMINISTRADOR: Verificar que Port Security está deshabilitado

#### Paso 2.1: Comprobar estado actual

**Navega a:** Security → Port Security → Port Security Status

Verifica que todos los puertos muestran:
- Status: **Unlocked** o **Disabled**

**Captura de pantalla:** Port Security deshabilitado

---

### 🔴 INTRUSO: Simular múltiples dispositivos

#### Paso 2.2: Opción A - Conectar dispositivo adicional (si hay un hub/switch pequeño)

Si tienes un pequeño switch o hub:
1. Conecta el hub/switch al puerto del switch principal
2. Conecta múltiples dispositivos al hub

#### Paso 2.3: Opción B - Cambiar dirección MAC (más común)

Simular un "dispositivo diferente" cambiando tu MAC:

```bash
# === macOS ===
# Desconectar WiFi primero si es necesario
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:01
sudo ifconfig en0 up

# Generar tráfico para que el switch aprenda la MAC
ping -c 3 192.168.1.1

# Cambiar a otra MAC
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:02
sudo ifconfig en0 up
ping -c 3 192.168.1.1

# === Linux ===
sudo ip link set eth0 down
sudo ip link set eth0 address aa:bb:cc:dd:ee:01
sudo ip link set eth0 up
ping -c 3 192.168.1.1
```

---

### 🔵 ADMINISTRADOR: Observar las MACs aprendidas

#### Paso 2.4: Ver tabla MAC después de los cambios

**Navega a:** Status and Statistics → MAC Address Table

**Observación esperada:** El puerto del intruso (GE3) muestra MÚLTIPLES MACs.

| Puerto | MACs aprendidas |
|--------|-----------------|
| GE3 | aa:bb:cc:dd:ee:01, aa:bb:cc:dd:ee:02, ... |

**Captura de pantalla:** Múltiples MACs en un puerto

**Problema identificado:** Sin Port Security, cualquiera puede conectar múltiples dispositivos o cambiar su MAC sin restricción.

---

## FASE 3: Configurar Port Security (30 minutos)

> **Objetivo:** Implementar control de MACs por puerto.

### 🔵 ADMINISTRADOR: Configurar Port Security

#### Paso 3.1: Acceder a la configuración

**Navega a:** Security → Port Security → Interface Settings

#### Paso 3.2: Entender los modos de Port Security

| Modo | Descripción | Uso típico |
|------|-------------|------------|
| **Classic Lock** | Solo MACs estáticas configuradas | Alta seguridad |
| **Limited Dynamic Lock** | Aprende MACs hasta límite, luego bloquea | **Recomendado** |
| **Secure Permanent** | Aprende y guarda MACs permanentemente | Equipos fijos |
| **Secure Delete on Reset** | Como Permanent pero borra al reiniciar | Temporal |

#### Paso 3.3: Configurar puerto del Intruso (GE3)

1. Selecciona el puerto **GE3** (o el puerto del intruso)
2. Click en **Edit**
3. Configura:
   - **Interface Status:** Lock ✅
   - **Learning Mode:** Limited Dynamic Lock
   - **Max MAC Addresses:** 2
   - **Action on Violation:** Discard and Trap (o Discard and Shutdown)
4. Click **Apply**

**Explicación de Actions:**
| Acción | Comportamiento |
|--------|----------------|
| Discard | Descarta paquetes de MACs no autorizadas (silencioso) |
| Discard and Trap | Descarta + genera log/alerta |
| Discard and Shutdown | Descarta + apaga el puerto (más restrictivo) |

#### Paso 3.4: Configurar puerto del Administrador (GE2)

Repite el proceso para GE2:
- **Max MAC Addresses:** 2
- **Action:** Discard and Trap

#### Paso 3.5: Configurar globalmente (opcional)

Para aplicar a todos los puertos de usuarios:

1. Selecciona múltiples puertos (GE2-GE10)
2. Click **Edit**
3. Aplica la misma configuración

**Captura de pantalla:** Configuración de Port Security

#### Paso 3.6: Guardar configuración

**Navega a:** Administration → File Management → Copy/Save Configuration

1. Source: Running Configuration
2. Destination: Startup Configuration
3. Click **Apply**

---

### Configuración Final

| Puerto | Estado | Modo | Max MACs | Acción |
|--------|--------|------|----------|--------|
| GE1 (Router) | Unlocked | - | - | - |
| GE2 (Admin) | Locked | Limited Dynamic | 2 | Discard+Trap |
| GE3 (Intruso) | Locked | Limited Dynamic | 2 | Discard+Trap |

---

## FASE 4: Probar Port Security (20 minutos)

> **Objetivo:** Verificar que el control funciona.

### 🔴 INTRUSO: Intentar exceder el límite

#### Paso 4.1: Restaurar tu MAC original

```bash
# macOS - restaurar MAC original
sudo ifconfig en0 down
# El sistema restaura la MAC original al reiniciar la interfaz
sudo ifconfig en0 up

# Linux
sudo ip link set eth0 down
sudo ip link set eth0 up
```

#### Paso 4.2: Verificar conectividad inicial

```bash
ping -c 4 192.168.1.1
# Debe funcionar (esta es tu MAC #1)
```

#### Paso 4.3: Intentar agregar más MACs

```bash
# Cambiar a MAC #2
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:02
sudo ifconfig en0 up
ping -c 4 192.168.1.1
# Todavía debe funcionar (MAC #2 de 2 permitidas)

# Cambiar a MAC #3 (excede límite!)
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:03
sudo ifconfig en0 up
ping -c 4 192.168.1.1
# DEBE FALLAR - excede el límite de 2 MACs
```

**Resultado esperado:** El ping con la tercera MAC debe fallar (timeout).

---

### 🔵 ADMINISTRADOR: Verificar detección

#### Paso 4.4: Ver violaciones de seguridad

**Navega a:** Security → Port Security → Port Security Status

Observa:
- El puerto GE3 debe mostrar una **violación**
- Contador de MACs rechazadas

**Captura de pantalla:** Violación detectada

#### Paso 4.5: Ver logs del evento

**Navega a:** Status and Statistics → View Log → RAM Memory

Busca entradas como:
```
Port Security violation on port GE3: MAC aa:bb:cc:dd:ee:03 denied
```

**Captura de pantalla:** Log de la violación

#### Paso 4.6: Ver MACs aprendidas por puerto

**Navega a:** Security → Port Security → MAC Addresses

Verás las MACs que el switch ha "permitido" para cada puerto.

---

### 🔴 INTRUSO: Recuperar conectividad

#### Paso 4.7: Volver a una MAC permitida

```bash
# Volver a MAC #1 o #2 (las que ya estaban aprendidas)
sudo ifconfig en0 down
sudo ifconfig en0 ether aa:bb:cc:dd:ee:01  # O tu MAC original
sudo ifconfig en0 up
ping -c 4 192.168.1.1
# Debe funcionar de nuevo
```

---

## FASE 5: Documentación (15 minutos)

### Tabla comparativa

| Aspecto | Sin Port Security | Con Port Security |
|---------|-------------------|-------------------|
| MACs por puerto | Ilimitadas | Máximo 2 |
| Dispositivos extra | Permitidos | Bloqueados |
| Detección | No | Sí (logs, alertas) |
| Acción automática | Ninguna | Discard/Shutdown |

### Plantilla de configuración

```markdown
## Port Security - Configuración

### Parámetros globales
- Función: Port Security
- Estado: Habilitado

### Configuración por puerto
| Puerto | Estado | Modo | Max MACs | Acción |
|--------|--------|------|----------|--------|
| GE1 | Unlocked | - | - | - |
| GE2 | Locked | Limited Dynamic | 2 | Discard+Trap |
| GE3 | Locked | Limited Dynamic | 2 | Discard+Trap |

### Ruta en el switch
Security → Port Security → Interface Settings

### Prueba realizada
- Intento de usar 3 MACs diferentes en puerto con límite de 2
- Resultado: Tercera MAC bloqueada
- Log generado: Sí
```

### Mapeo a frameworks

| Framework | Control | Aplicación |
|-----------|---------|------------|
| **NIST** | PR.AC-1 | Control de acceso a nivel de puerto |
| **CIS** | Control 1 | Inventario de dispositivos autorizados |
| **ISO 27001** | A.9.1.2 | Acceso a redes y servicios |

---

## Entregables

### 🔵 ADMINISTRADOR
- [ ] Captura: Dashboard del switch
- [ ] Captura: Tabla MAC antes de Port Security
- [ ] Captura: Configuración de Port Security
- [ ] Captura: Violación detectada
- [ ] Captura: Logs del evento
- [ ] Plantilla de configuración completada

### 🔴 INTRUSO
- [ ] Documentar las MACs usadas
- [ ] Captura: Ping exitoso (dentro del límite)
- [ ] Captura: Ping fallido (excede límite)
- [ ] Documentar el proceso de cambio de MAC

### Ambos
- [ ] Tabla comparativa antes/después
- [ ] Conclusiones sobre la utilidad de Port Security

---

## Troubleshooting

### No puedo cambiar la MAC en macOS

```bash
# Asegúrate de que WiFi está desconectado si usas ethernet
# O al revés

# Verifica que la interfaz existe
networksetup -listallhardwareports
```

### El switch no muestra violaciones

- Verifica que Port Security está en **Lock**, no Unlocked
- Asegúrate de que el límite de MACs es menor que las MACs intentadas
- Genera tráfico (ping) para que el switch detecte la MAC

### Perdí conectividad completamente

- El puerto puede estar en shutdown si usaste "Discard and Shutdown"
- El admin debe ir a: Port Management → Port Settings → Habilitar el puerto
- O: Security → Port Security → Interface Settings → Cambiar Action a solo "Discard"

### No puedo restaurar mi MAC original

```bash
# macOS - reiniciar la interfaz suele restaurarla
sudo ifconfig en0 down
sudo ifconfig en0 up

# Si no funciona, reiniciar el sistema restaura la MAC original
```

---

## Ejercicio adicional (si sobra tiempo)

### Probar diferentes Actions

1. Cambia la acción a **"Discard and Shutdown"**
2. Intenta exceder el límite de MACs
3. Observa que el puerto se apaga completamente
4. Rehabilita el puerto manualmente

### Configurar MAC estática

1. Ve a: Security → Port Security → MAC Addresses
2. Agrega manualmente una MAC permitida para un puerto
3. Prueba que solo esa MAC específica funciona

---

## Comandos de referencia

```bash
# === Ver tu MAC ===
ifconfig en0 | grep ether       # macOS
ip link show eth0               # Linux

# === Cambiar MAC (temporal) ===
# macOS
sudo ifconfig en0 down
sudo ifconfig en0 ether XX:XX:XX:XX:XX:XX
sudo ifconfig en0 up

# Linux
sudo ip link set eth0 down
sudo ip link set eth0 address XX:XX:XX:XX:XX:XX
sudo ip link set eth0 up

# === Generar tráfico ===
ping -c 3 192.168.1.1

# === Ver tabla ARP local ===
arp -a
```

---

## Navegación

⬅️ [Práctica 3: Ciclo NIST](practica_03_ciclo_nist.md) | [Práctica 5: Rogue DHCP →](practica_05_rogue_dhcp.md)
