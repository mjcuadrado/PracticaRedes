# Práctica 1: Defensa contra DHCP Starvation

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Baja |
| **Ataque principal** | DHCP Starvation |
| **Defensa principal** | DHCP Snooping + Rate Limiting |
| **Herramientas** | Yersinia, Wireshark, nmap |

## Objetivo

Demostrar cómo un atacante puede agotar el pool de direcciones DHCP de una red, provocando una denegación de servicio, y cómo mitigar este ataque mediante DHCP Snooping.

---

## Roles del Equipo

| Rol | Responsabilidad | Equipo |
|-----|-----------------|--------|
| **🔴 ATACANTE** | Ejecutar DHCP Starvation con Yersinia, documentar ataque | PC Atacante |
| **🔵 DEFENSOR** | Configurar switch, verificar defensas, documentar | PC Defensor + Switch |

> **Dinámica:** El atacante lanza el ataque mientras el defensor configura y verifica las defensas. Ambos documentan sus acciones.

---

## Topología de Red

```
                   ┌──────────────────┐
                   │  Router (DHCP)   │
                   │  192.168.1.1     │
                   │  Pool: .100-.200 │
                   └────────┬─────────┘
                            │ GE1
                   ┌────────┴─────────┐
                   │   Switch SG300   │
                   │   192.168.1.237  │
                   └┬────────┬────────┘
                    │GE2     │GE3
                    │        │
             ┌──────┴────┐ ┌─┴──────────┐
             │🔵DEFENSOR │ │🔴ATACANTE   │
             │           │ │            │
             └───────────┘ └────────────┘
```

---

## FASE 1: Reconocimiento (15 minutos)

### 🔴 ATACANTE + 🔵 DEFENSOR: Identificar configuración de red

#### Paso 1.1: Identificar tu dirección IP y interfaz

```bash
# macOS
ifconfig en0 | grep inet

# Linux
ip addr show eth0
```

**Anota:**
- Tu IP: `_______________`
- Tu interfaz: `_______________`

#### Paso 1.2: Descubrir equipos en la red

```bash
# Escaneo rápido de la red
nmap -sn 192.168.1.0/24

# Alternativa con arp-scan (más rápido)
sudo arp-scan -l -I en0      # macOS
sudo arp-scan -l -I eth0     # Linux
```

**Identifica y anota:**
- Router/Gateway (servidor DHCP): `192.168.1.1`
- Switch Cisco SG300: `192.168.1.237`
- PC Atacante: `192.168.1.___`
- PC Defensor: `192.168.1.___`

---

### 🔵 DEFENSOR: Acceder al switch

#### Paso 1.3: Acceder al switch

1. Abre el navegador
2. Ve a: `https://192.168.1.237`
3. Acepta el certificado de seguridad
4. Inicia sesión con las credenciales proporcionadas

#### Paso 1.4: Verificar configuración actual de DHCP Snooping

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**
2. Captura de pantalla del estado actual
3. **Asegúrate de que DHCP Snooping está DESHABILITADO** para la primera parte

**Estado actual:**
- [ ] DHCP Snooping: Deshabilitado
- [ ] Todos los puertos: Untrusted

**Captura de pantalla:** Estado inicial deshabilitado

---

## FASE 2: Ataque SIN Defensa (20 minutos)

### 🔵 DEFENSOR: Preparar captura de tráfico

#### Paso 2.1: Preparar captura de tráfico

Abre Wireshark en una terminal:

```bash
# Iniciar captura con filtro DHCP
wireshark -k -i en0 -f "port 67 or port 68"
```

O abre Wireshark gráficamente y aplica el filtro:
```
bootp || dhcp
```

### Paso 2.2: Verificar funcionamiento normal de DHCP

Antes del ataque, verifica que DHCP funciona:

```bash
# Renovar IP (esto debería funcionar)
# macOS
sudo ipconfig set en0 DHCP

# Linux
sudo dhclient -r eth0 && sudo dhclient eth0
```

**Captura de pantalla:** Muestra el intercambio DHCP normal (DISCOVER → OFFER → REQUEST → ACK)

---

### 🔴 ATACANTE: Ejecutar DHCP Starvation

#### Paso 2.3: Ejecutar DHCP Starvation

```bash
# Iniciar Yersinia en modo gráfico
sudo yersinia -G
```

**En la interfaz de Yersinia:**

1. Selecciona la pestaña **DHCP**
2. Click en **Launch attack**
3. Selecciona **"sending DISCOVER packet"** (Opción 1 - DHCP Starvation)
4. Click en **OK**

**Alternativa por línea de comandos:**
```bash
sudo yersinia dhcp -attack 1 -interface en0
```

---

### 🔵 DEFENSOR: Observar el ataque en Wireshark

#### Paso 2.4: Observar el ataque

**En Wireshark verás:**
- Cientos de paquetes DHCP DISCOVER
- Cada uno con una MAC diferente (spoofed)
- El servidor DHCP responde con OFFER hasta agotar el pool

**Captura de pantalla necesaria:**
1. Wireshark mostrando múltiples DHCP DISCOVER
2. Contador de paquetes (debería ser alto: 100+)

#### Paso 2.5: Verificar impacto del ataque

Desde otro equipo o máquina virtual, intenta obtener IP:

```bash
# Este comando debería FALLAR o tardar mucho
sudo dhclient -r eth0 && sudo dhclient eth0
```

**Resultado esperado:** No se obtiene IP porque el pool está agotado.

---

### 🔴 ATACANTE: Detener el ataque

#### Paso 2.6: Detener el ataque

En Yersinia:
1. Click en **List attacks**
2. Selecciona el ataque activo
3. Click en **Cancel attack**

O si usaste línea de comandos: `Ctrl+C`

---

## FASE 3: Implementar Defensa (30 minutos)

### 🔵 DEFENSOR: Configurar DHCP Snooping

#### Paso 3.1: Acceder a la configuración de DHCP Snooping

En el switch (https://192.168.1.237):

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**

### Paso 3.2: Habilitar DHCP Snooping globalmente

1. Marca la casilla **DHCP Snooping Status: Enable**
2. Opcionalmente habilita **DHCP Snooping VLAN**: VLAN 1
3. Click en **Apply**

**Captura de pantalla:** Configuración global habilitada

### Paso 3.3: Configurar puerto TRUSTED para el servidor DHCP

El puerto donde está conectado el router (servidor DHCP) debe ser TRUSTED:

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Interface Settings**
2. Selecciona el puerto del router (ejemplo: GE1)
3. Edita y marca como **Trusted**
4. Click en **Apply**

**Importante:** Solo el puerto del servidor DHCP legítimo debe ser Trusted.

### Paso 3.4: Configurar Rate Limiting en puertos de usuario

Para limitar la cantidad de paquetes DHCP por segundo:

1. En **Interface Settings**, selecciona los puertos de usuarios (GE2-GE10)
2. Configura **DHCP Snooping Rate Limit**: `15` paquetes/segundo
3. Click en **Apply**

**Justificación:** Un cliente legítimo envía muy pocos paquetes DHCP. 15/segundo es más que suficiente para uso normal pero bloquea ataques de flooding.

### Paso 3.5: Verificar la configuración

Revisa la tabla de configuración:

| Puerto | Estado | Trusted | Rate Limit |
|--------|--------|---------|------------|
| GE1 (Router) | Habilitado | ✅ Sí | Ilimitado |
| GE2-GE10 | Habilitado | ❌ No | 15 pkt/s |

**Captura de pantalla:** Tabla de puertos con configuración final

### Paso 3.6: Guardar la configuración

1. Navega a: **Administration → File Management → Copy/Save Configuration**
2. Copia de **Running Configuration** a **Startup Configuration**
3. Click en **Apply**

---

## FASE 4: Verificar Defensa (20 minutos)

### 🔵 DEFENSOR: Preparar monitoreo

#### Paso 4.1: Reiniciar captura en Wireshark

```bash
wireshark -k -i en0 -f "port 67 or port 68"
```

---

### 🔴 ATACANTE: Re-ejecutar el ataque

#### Paso 4.2: Re-ejecutar el ataque

```bash
sudo yersinia dhcp -attack 1 -interface en0
```

---

### 🔵 DEFENSOR: Observar el bloqueo

#### Paso 4.3: Observar el bloqueo

**Lo que deberías ver:**
- Los paquetes DHCP DISCOVER se envían
- **PERO** el switch los descarta silenciosamente
- No hay respuestas OFFER para las MACs falsas
- El ataque no tiene efecto

**Captura de pantalla:** Wireshark mostrando DISCOVER sin OFFER correspondientes

### Paso 4.4: Verificar logs del switch

1. Navega a: **Status and Statistics → View Log → RAM Memory**
2. Busca entradas relacionadas con DHCP Snooping

**Ejemplo de log esperado:**
```
DHCP Snooping: Packet dropped - untrusted port
DHCP Snooping: Rate limit exceeded on port GE3
```

**Captura de pantalla:** Logs mostrando los intentos bloqueados

### Paso 4.5: Verificar que DHCP legítimo sigue funcionando

```bash
# Esto SÍ debe funcionar
sudo ipconfig set en0 DHCP    # macOS
sudo dhclient eth0            # Linux
```

**Resultado esperado:** Obtiene IP correctamente del servidor legítimo.

### Paso 4.6: Ver la DHCP Binding Database

1. Navega a: **IP Configuration → DHCP Snooping/Relay → DHCP Snooping Binding Database**
2. Verás las asignaciones legítimas aprendidas

**Captura de pantalla:** Binding database con entradas legítimas

---

## FASE 5: Documentación (35 minutos)

### 🔴 ATACANTE: Completar plantilla de ataque

#### Paso 5.1: Completar la plantilla de ataque

Usa la plantilla en `wiki/06_laboratorio/plantillas/plantilla_ataque.md`:

```markdown
## Ataque: DHCP Starvation

### Información del ataque
- **Fecha:** [HOY]
- **Herramienta:** Yersinia
- **Comando:** `sudo yersinia dhcp -attack 1 -interface en0`

### Estado de defensas
- DHCP Snooping: DESHABILITADO (primera prueba) / HABILITADO (segunda prueba)

### Resultado SIN defensa
- [ ] Ataque exitoso
- Impacto: Pool DHCP agotado, nuevos clientes no pueden obtener IP

### Resultado CON defensa
- [ ] Ataque bloqueado
- Evidencia: Logs del switch, no hay OFFER para MACs falsas
```

---

### 🔵 DEFENSOR: Completar plantilla de defensa

#### Paso 5.2: Completar la plantilla de defensa

Usa la plantilla en `wiki/06_laboratorio/plantillas/plantilla_defensa.md`:

```markdown
## Defensa: DHCP Snooping

### Configuración implementada
- **Función habilitada:** DHCP Snooping Global
- **Puerto trusted:** GE1 (Router)
- **Rate limiting:** 15 pkt/s en puertos GE2-GE10

### Ruta en el switch
IP Configuration → DHCP Snooping/Relay → Properties

### Prueba de efectividad
- Ataque probado: DHCP Starvation
- Resultado: BLOQUEADO
- Evidencia: [Captura de log]
```

---

### Ambos: Documentación conjunta

#### Paso 5.3: Crear tabla comparativa

| Aspecto | Sin Defensa | Con Defensa |
|---------|-------------|-------------|
| Paquetes DISCOVER enviados | ✅ Sí | ✅ Sí |
| Respuestas OFFER recibidas | ✅ Muchas | ❌ Ninguna (MACs falsas) |
| Pool DHCP agotado | ✅ Sí | ❌ No |
| Nuevos clientes obtienen IP | ❌ No | ✅ Sí |
| Registro en logs | ❌ Nada | ✅ Alertas |

### Paso 5.4: Relacionar con NIST Framework

| Función NIST | Acción realizada |
|--------------|------------------|
| **IDENTIFICAR** | Escaneo de red, identificar servidor DHCP |
| **PROTEGER** | Configurar DHCP Snooping y Rate Limiting |
| **DETECTAR** | Monitorear logs del switch |
| **RESPONDER** | Bloqueo automático por Rate Limiting |
| **RECUPERAR** | Configuración guardada para persistencia |

---

## Entregables

### 🔴 ATACANTE
- [ ] Captura: Yersinia ejecutando el ataque
- [ ] Captura de Wireshark: Ataque SIN defensa (múltiples DISCOVER)
- [ ] Captura de Wireshark: Ataque CON defensa (DISCOVER sin efecto)
- [ ] Plantilla de ataque completada

### 🔵 DEFENSOR
- [ ] Screenshot: Estado inicial (DHCP Snooping deshabilitado)
- [ ] Screenshot: Configuración DHCP Snooping habilitado
- [ ] Screenshot: Rate Limiting configurado
- [ ] Screenshot: Puerto Trusted configurado
- [ ] Screenshot: Logs del switch mostrando bloqueo
- [ ] Screenshot: DHCP Binding Database
- [ ] Plantilla de defensa completada

### Ambos
- [ ] Tabla comparativa antes/después
- [ ] Mapeo a funciones NIST
- [ ] Conclusiones sobre la efectividad de DHCP Snooping

---

## Troubleshooting

### El ataque no funciona
- Verifica que estás en la misma VLAN que el servidor DHCP
- Asegúrate de que Yersinia tiene permisos root: `sudo yersinia`
- Verifica la interfaz correcta: `ifconfig` / `ip addr`

### La defensa no bloquea el ataque
- Verifica que DHCP Snooping está habilitado globalmente
- Asegúrate de que el puerto del atacante NO está como Trusted
- El Rate Limiting puede tardar unos segundos en activarse

### No hay logs en el switch
- Verifica que el logging está habilitado
- Algunos eventos se registran en Flash Memory, no en RAM
- Prueba en: **Status and Statistics → View Log → Flash Memory**

---

## Comandos de referencia rápida

```bash
# Escaneo de red
nmap -sn 192.168.1.0/24

# Captura DHCP
wireshark -k -i en0 -f "port 67 or port 68"

# Ataque DHCP Starvation
sudo yersinia dhcp -attack 1 -interface en0

# Renovar IP (verificar DHCP funciona)
sudo ipconfig set en0 DHCP    # macOS
sudo dhclient eth0            # Linux
```

---

## Navegación

⬅️ [Volver a Guía Práctica](../guia_practica.md) | [Práctica 2: ARP Poisoning →](practica_02_arp_poisoning.md)
