# Práctica 3: Ciclo Completo NIST Framework

## Información General

| Campo | Valor |
|-------|-------|
| **Duración** | 2 horas |
| **Dificultad** | Media-Alta |
| **Ataques** | DHCP Spoofing o ARP Poisoning (elegir uno) |
| **Defensas** | Port Security + DHCP Snooping + ARP Inspection |
| **Framework** | NIST Cybersecurity Framework (5 funciones) |

## Objetivo

Aplicar el ciclo completo del NIST Cybersecurity Framework a un escenario práctico de seguridad en redes, ejecutando las 5 funciones: IDENTIFICAR, PROTEGER, DETECTAR, RESPONDER y RECUPERAR.

---

## Roles del Equipo

| Rol | Responsabilidad | Funciones NIST principales |
|-----|-----------------|---------------------------|
| **🔴 ATACANTE** | Demostrar vulnerabilidades, probar defensas | Apoya IDENTIFICAR y DETECTAR |
| **🔵 DEFENSOR** | Configurar switch, implementar controles | PROTEGER, RESPONDER, RECUPERAR |

> **Nota:** Ambos documentan todas las fases relacionándolas con NIST.

---

## NIST Framework - Resumen

```
┌─────────────────────────────────────────────────────────────────┐
│                    NIST CYBERSECURITY FRAMEWORK                  │
├─────────────┬─────────────┬─────────────┬───────────┬───────────┤
│ IDENTIFICAR │  PROTEGER   │  DETECTAR   │ RESPONDER │ RECUPERAR │
│   (ID)      │    (PR)     │    (DE)     │   (RS)    │   (RC)    │
├─────────────┼─────────────┼─────────────┼───────────┼───────────┤
│ - Inventario│ - Control   │ - Monitoreo │ - Análisis│ - Restaurar│
│ - Activos   │   de acceso │ - Detección │ - Mitigar │ - Mejorar │
│ - Riesgos   │ - Awareness │   anomalías │ - Reportar│ - Comunicar│
│ - Gobierno  │ - Seguridad │ - Procesos  │ - Contener│           │
│             │   de datos  │             │           │           │
└─────────────┴─────────────┴─────────────┴───────────┴───────────┘
```

---

## FASE 1: IDENTIFICAR (ID) - 20 minutos

> **Objetivo:** Conocer los activos, la topología y los riesgos de la red.

### 🔵 DEFENSOR: Inventario de activos

#### Paso 1.1: Documentar la topología

Dibuja o describe la red:

```
Red: 192.168.1.0/24

┌─────────────────────────────────────────────┐
│              INVENTARIO DE ACTIVOS          │
├─────────────┬──────────────┬────────────────┤
│   Equipo    │      IP      │      Rol       │
├─────────────┼──────────────┼────────────────┤
│ Router      │ 192.168.1.1  │ Gateway, DHCP  │
│ Switch      │ 192.168.1.237│ Switching L2   │
│ PC Atacante │ 192.168.1._  │ Estación       │
│ PC Defensor │ 192.168.1._  │ Estación       │
└─────────────┴──────────────┴────────────────┘
```

#### Paso 1.2: Identificar servicios críticos

```bash
# Escanear servicios en el router
nmap -sV 192.168.1.1

# Escanear servicios en el switch
nmap -sV 192.168.1.237
```

**Servicios identificados:**
- [ ] DHCP Server (Router): Puerto 67/68
- [ ] HTTPS (Switch): Puerto 443
- [ ] SSH (si habilitado): Puerto 22

---

### 🔴 ATACANTE: Reconocimiento de red

#### Paso 1.3: Descubrimiento de hosts

```bash
# Escaneo ARP
sudo arp-scan -l -I en0

# Escaneo nmap
nmap -sn 192.168.1.0/24
```

**Resultado del reconocimiento:**

| IP | MAC | Fabricante | Notas |
|----|-----|------------|-------|
| 192.168.1.1 | XX:XX:XX:XX:XX:XX | Cisco | Gateway |
| 192.168.1.237 | XX:XX:XX:XX:XX:XX | Cisco | Switch gestionable |
| 192.168.1._ | XX:XX:XX:XX:XX:XX | [Fab] | Defensor |

---

### Ambos: Análisis de riesgos

#### Paso 1.4: Identificar vulnerabilidades potenciales

Completen esta tabla juntos:

| Vulnerabilidad | Probabilidad | Impacto | Riesgo |
|---------------|--------------|---------|--------|
| ARP Spoofing | Alta | Alto | **CRÍTICO** |
| DHCP Spoofing | Alta | Alto | **CRÍTICO** |
| DHCP Starvation | Media | Medio | MEDIO |
| MAC Flooding | Media | Medio | MEDIO |

#### Paso 1.5: Verificar estado de seguridad actual

**🔵 DEFENSOR verifica en el switch:**

| Control | Ruta en Switch | Estado Actual |
|---------|----------------|---------------|
| Port Security | Security → Port Security | [ ] Habilitado [ ] Deshabilitado |
| DHCP Snooping | IP Config → DHCP Snooping | [ ] Habilitado [ ] Deshabilitado |
| ARP Inspection | Security → ARP Inspection | [ ] Habilitado [ ] Deshabilitado |

**Captura de pantalla:** Estado inicial de los controles de seguridad

---

### Entregable IDENTIFICAR

```markdown
## ID - IDENTIFICAR

### ID.AM - Asset Management
- Inventario de red completado: [SÍ/NO]
- Equipos documentados: [NÚMERO]
- Servicios identificados: DHCP, HTTPS, [otros]

### ID.RA - Risk Assessment
- Vulnerabilidades identificadas: ARP Spoofing, DHCP Spoofing
- Nivel de riesgo actual: ALTO (sin controles)
- Controles existentes: NINGUNO

### ID.GV - Governance
- Responsable de configuración: [NOMBRE DEFENSOR]
- Responsable de pruebas: [NOMBRE ATACANTE]
```

---

## FASE 2: Demostrar Vulnerabilidad (15 minutos)

> **Objetivo:** Evidenciar el riesgo antes de implementar controles.

### 🔴 ATACANTE: Ejecutar UN ataque

Elegir UNO de estos ataques:

#### Opción A: ARP Poisoning

```bash
# Habilitar forwarding
sudo sysctl -w net.inet.ip.forwarding=1

# Ejecutar ataque
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.Y//
```

#### Opción B: DHCP Spoofing

```bash
# Levantar servidor DHCP falso
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.100
```

---

### 🔵 DEFENSOR: Documentar el impacto

#### Si fue ARP Poisoning:

```bash
# Verificar tabla ARP envenenada
arp -a
```

**Evidencia:** La MAC del gateway es incorrecta.

#### Si fue DHCP Spoofing:

```bash
# Ver configuración de red recibida
ipconfig getpacket en0    # macOS
cat /var/lib/dhcp/dhclient.leases    # Linux
```

**Evidencia:** Gateway o DNS apuntan al atacante.

---

### Entregable - Evidencia de Vulnerabilidad

```markdown
## Evidencia Pre-Defensa

### Ataque ejecutado
- **Tipo:** [ARP Poisoning / DHCP Spoofing]
- **Herramienta:** [Ettercap / Yersinia]
- **Resultado:** EXITOSO

### Impacto demostrado
- [x] Tráfico interceptado / Gateway incorrecto
- [x] Sin alertas ni logs
- [x] Sin detección

### Capturas adjuntas
1. Captura del ataque en ejecución
2. Evidencia del impacto en la víctima
```

---

## FASE 3: PROTEGER (PR) - 35 minutos

> **Objetivo:** Implementar controles para mitigar los riesgos identificados.

### 🔵 DEFENSOR: Implementar controles en orden

#### Paso 3.1: Port Security (PR.AC - Access Control)

1. Navega a: **Security → Port Security → Interface Settings**
2. Selecciona puertos de usuario (GE2, GE3, etc.)
3. Configura:
   - **Status:** Lock
   - **Learning Mode:** Limited Dynamic Lock
   - **Max Addresses:** 2
   - **Action on Violation:** Discard and Trap
4. Click **Apply**

**Justificación:** Limita MACs por puerto, previene MAC flooding.

#### Paso 3.2: DHCP Snooping (PR.DS - Data Security)

1. Navega a: **IP Configuration → DHCP Snooping/Relay → Properties**
2. Habilita **DHCP Snooping Status**
3. Navega a: **Interface Settings**
4. Configura puerto del router (GE1) como **Trusted**
5. Configura **Rate Limit: 15** en puertos de usuario
6. Click **Apply**

**Justificación:** Solo el router puede ser servidor DHCP.

#### Paso 3.3: Dynamic ARP Inspection (PR.DS - Data Security)

1. Navega a: **Security → ARP Inspection → Properties**
2. Habilita **ARP Inspection Status**
3. Navega a: **Interface Settings**
4. Configura puerto del router (GE1) como **Trusted**
5. Habilita validación: Source MAC, Dest MAC, IP
6. Click **Apply**

**Justificación:** Valida paquetes ARP contra binding database.

#### Paso 3.4: Regenerar DHCP Bindings

Para que DAI funcione, los equipos deben tener entradas en la binding database:

```bash
# Ambos PCs deben renovar IP
# macOS
sudo ipconfig set en0 DHCP

# Linux
sudo dhclient -r eth0 && sudo dhclient eth0
```

**Verifica:** IP Configuration → DHCP Snooping → Binding Database

---

### Configuración Final

| Puerto | Port Security | DHCP Snooping | ARP Inspection |
|--------|--------------|---------------|----------------|
| GE1 (Router) | Deshabilitado | Trusted | Trusted |
| GE2 (Atacante) | Max 2 MACs | Untrusted, 15pkt/s | Untrusted |
| GE3 (Defensor) | Max 2 MACs | Untrusted, 15pkt/s | Untrusted |

**Captura de pantalla:** Configuración de cada control

---

### Entregable PROTEGER

```markdown
## PR - PROTEGER

### PR.AC - Access Control
- **Control:** Port Security
- **Configuración:** Max 2 MACs, Limited Dynamic Lock
- **Puertos aplicados:** GE2, GE3

### PR.DS - Data Security
- **Control 1:** DHCP Snooping
  - Estado: Habilitado
  - Puerto trusted: GE1
  - Rate limit: 15 pkt/s

- **Control 2:** ARP Inspection (DAI)
  - Estado: Habilitado
  - Puerto trusted: GE1
  - Validación: MAC origen, MAC destino, IP

### PR.IP - Information Protection
- Configuración guardada en Startup Config: [SÍ/NO]

### Capturas adjuntas
1. Port Security configurado
2. DHCP Snooping habilitado
3. ARP Inspection habilitado
4. DHCP Binding Database poblada
```

---

## FASE 4: DETECTAR (DE) - 20 minutos

> **Objetivo:** Verificar que los controles detectan y bloquean ataques.

### 🔴 ATACANTE: Re-ejecutar el ataque

```bash
# Mismo ataque que en Fase 2
# ARP Poisoning:
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.Y//

# O DHCP Spoofing:
sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.100
```

---

### 🔵 DEFENSOR: Monitorear detección

#### Paso 4.1: Verificar que el ataque NO tiene efecto

```bash
# ARP Poisoning - verificar tabla ARP correcta
arp -a
# La MAC del gateway debe ser la REAL

# DHCP Spoofing - verificar configuración correcta
ipconfig getpacket en0
# El gateway debe ser 192.168.1.1 (real)
```

#### Paso 4.2: Revisar logs del switch

1. Navega a: **Status and Statistics → View Log → RAM Memory**

**Logs esperados:**

Para ARP Inspection:
```
%ARP-I-INSPECT_LOG: arp inspection drop, interface GE2,
  src IP 192.168.1.X, src MAC aa:bb:cc:dd:ee:ff
```

Para DHCP Snooping:
```
%DHCP_SNOOPING-I-ERRMSG: DHCP packet dropped on untrusted port GE2
```

**Captura de pantalla:** Logs de detección

#### Paso 4.3: Ver estadísticas

**ARP Inspection:**
1. Navega a: **Security → ARP Inspection → Statistics**
2. Anota paquetes descartados

**DHCP Snooping:**
1. Navega a: **IP Configuration → DHCP Snooping → Statistics**
2. Anota paquetes descartados

---

### Entregable DETECTAR

```markdown
## DE - DETECTAR

### DE.AE - Anomalies and Events
- **Ataque detectado:** [ARP Poisoning / DHCP Spoofing]
- **Método de detección:** [ARP Inspection / DHCP Snooping]
- **Timestamp:** [HORA del log]

### DE.CM - Continuous Monitoring
- **Logs habilitados:** Sí
- **Estadísticas disponibles:** Sí
- **Paquetes bloqueados:** [NÚMERO]

### DE.DP - Detection Processes
- Detección automática: Sí
- Intervención manual requerida: No
- Tiempo de detección: Inmediato

### Capturas adjuntas
1. Logs del switch mostrando detección
2. Estadísticas de paquetes bloqueados
3. Tabla ARP/Config de red del defensor (correcta)
```

---

## FASE 5: RESPONDER (RS) - 15 minutos

> **Objetivo:** Definir y ejecutar acciones de respuesta ante incidentes.

### 🔵 DEFENSOR: Acciones de respuesta

#### Paso 5.1: Identificar el puerto atacante

De los logs, identificar qué puerto generó el tráfico malicioso:
```
Interface: GE2  ← Puerto del atacante
```

#### Paso 5.2: Opción de respuesta - Shutdown del puerto

**Si quisieras aislar completamente al atacante:**

1. Navega a: **Port Management → Port Settings**
2. Selecciona el puerto del atacante (GE2)
3. Cambia **Administrative Status:** Down
4. Click **Apply**

> ⚠️ **En esta práctica NO hagas shutdown** para poder continuar probando.

#### Paso 5.3: Documentar el incidente

Completa el formulario de incidente:

```markdown
## REPORTE DE INCIDENTE

### Información General
- **ID Incidente:** INC-001
- **Fecha/Hora detección:** [TIMESTAMP]
- **Reportado por:** Sistema (automático)
- **Severidad:** Alta

### Descripción
- **Tipo de ataque:** [ARP Poisoning / DHCP Spoofing]
- **Origen:** Puerto GE2, MAC: [MAC del atacante]
- **Objetivo:** Red interna, servicios DHCP/ARP
- **Impacto potencial:** MITM, interceptación de tráfico

### Acciones tomadas
1. [x] Ataque bloqueado automáticamente por [DAI/DHCP Snooping]
2. [x] Logs capturados
3. [ ] Puerto deshabilitado (opcional)
4. [x] Incidente documentado

### Recomendaciones
- Investigar equipo en puerto GE2
- Verificar si es comportamiento autorizado (pentesting) o malicioso
- Considerar habilitar 802.1X para autenticación
```

---

### Entregable RESPONDER

```markdown
## RS - RESPONDER

### RS.RP - Response Planning
- Plan de respuesta definido: Sí
- Acciones automáticas: Bloqueo de paquetes
- Acciones manuales disponibles: Shutdown de puerto

### RS.CO - Communications
- Incidente documentado: Sí
- ID Incidente: INC-001

### RS.AN - Analysis
- Puerto origen identificado: GE2
- MAC atacante identificada: [MAC]
- Tipo de ataque confirmado: [TIPO]

### RS.MI - Mitigation
- Ataque mitigado: Sí
- Método: Bloqueo automático por [DAI/DHCP Snooping]
- Impacto real: Ninguno (bloqueado)

### Capturas adjuntas
1. Reporte de incidente completado
2. Identificación del puerto atacante
```

---

## FASE 6: RECUPERAR (RC) - 10 minutos

> **Objetivo:** Asegurar la continuidad y mejorar la postura de seguridad.

### 🔵 DEFENSOR: Acciones de recuperación

#### Paso 6.1: Verificar que la red funciona correctamente

```bash
# Probar conectividad
ping -c 4 192.168.1.1
ping -c 4 8.8.8.8

# Verificar DHCP funciona
sudo ipconfig set en0 DHCP
```

#### Paso 6.2: Guardar configuración

1. Navega a: **Administration → File Management → Copy/Save Configuration**
2. Copia **Running Config** → **Startup Config**
3. Click **Apply**

#### Paso 6.3: Exportar configuración (backup)

1. Navega a: **Administration → File Management → Download/Backup Config**
2. Selecciona **Running Configuration**
3. Descarga el archivo

**Nombre sugerido:** `switch_config_YYYYMMDD_secured.cfg`

#### Paso 6.4: Documentar lecciones aprendidas

```markdown
## LECCIONES APRENDIDAS

### Qué funcionó bien
- Detección automática del ataque
- Bloqueo efectivo sin intervención manual
- Logs detallados para análisis

### Qué se puede mejorar
- Implementar 802.1X para autenticación de dispositivos
- Configurar alertas por email/SNMP
- Establecer revisión periódica de logs

### Cambios en la configuración
- Port Security: IMPLEMENTADO
- DHCP Snooping: IMPLEMENTADO
- ARP Inspection: IMPLEMENTADO

### Próximos pasos recomendados
1. Implementar 802.1X
2. Configurar servidor syslog centralizado
3. Documentar política de respuesta a incidentes
```

---

### Entregable RECUPERAR

```markdown
## RC - RECUPERAR

### RC.RP - Recovery Planning
- Red operativa: Sí
- Servicios restaurados: N/A (nunca interrumpidos)
- Configuración guardada: Sí

### RC.IM - Improvements
- Lecciones documentadas: Sí
- Mejoras identificadas: 802.1X, Syslog, Alertas

### RC.CO - Communications
- Stakeholders informados: [Profesor/Equipo]
- Documentación actualizada: Sí

### Capturas adjuntas
1. Backup de configuración
2. Pruebas de conectividad
3. Documento de lecciones aprendidas
```

---

## Resumen Final - Mapeo NIST Completo

| Función | Subcategoría | Actividad Realizada | Evidencia |
|---------|--------------|---------------------|-----------|
| **ID** | ID.AM | Inventario de red | Lista de activos |
| **ID** | ID.RA | Análisis de riesgos | Tabla de vulnerabilidades |
| **PR** | PR.AC | Port Security | Config screenshot |
| **PR** | PR.DS | DHCP Snooping + DAI | Config screenshot |
| **DE** | DE.AE | Detección de ataque | Logs del switch |
| **DE** | DE.CM | Monitoreo continuo | Estadísticas |
| **RS** | RS.AN | Análisis del incidente | Reporte |
| **RS** | RS.MI | Mitigación | Bloqueo automático |
| **RC** | RC.RP | Restauración | Backup config |
| **RC** | RC.IM | Mejoras | Lecciones aprendidas |

---

## Entregables Finales

### 🔴 ATACANTE
- [ ] Resultados de reconocimiento
- [ ] Evidencia de ataque exitoso (pre-defensa)
- [ ] Evidencia de ataque bloqueado (post-defensa)

### 🔵 DEFENSOR
- [ ] Inventario de activos
- [ ] Configuración de controles (3 capturas)
- [ ] Logs de detección
- [ ] Reporte de incidente
- [ ] Backup de configuración
- [ ] Lecciones aprendidas

### Ambos
- [ ] Tabla de mapeo NIST completa
- [ ] Documento final relacionando cada acción con su función NIST

---

## Navegación

⬅️ [Práctica 2: ARP Poisoning](practica_02_arp_poisoning.md) | [Práctica 4: Port Security →](practica_04_port_security.md)
