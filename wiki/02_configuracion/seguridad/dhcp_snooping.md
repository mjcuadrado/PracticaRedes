# DHCP Snooping

## Propósito
Protege contra:
- **DHCP Spoofing**: Servidor DHCP falso (MITM)
- **DHCP Starvation**: Agotamiento del pool DHCP (DoS)

## Concepto

```
[DHCP Server Legítimo] ----[Trusted Port]
         |
      [Switch con DHCP Snooping]
         |
[Cliente]----[Untrusted Port]----[Atacante con DHCP falso]
                                        ↓
                              BLOQUEADO por el switch
```

## Tipos de Puertos

| Tipo | Permite | Uso típico |
|------|---------|------------|
| **Trusted** | Respuestas DHCP (Offer, Ack) | Hacia servidor DHCP real |
| **Untrusted** | Solo peticiones DHCP | Puertos de usuarios |

## Configuración en Switch

### Ruta
```
IP Configuration > DHCP Snooping/Relay > Properties
```

### 1. Habilitar DHCP Snooping
```
IP Configuration > DHCP Snooping/Relay > Properties
  ☑ DHCP Snooping Status: Enable
  ☑ DHCP Snooping VLAN: [seleccionar VLANs]
Apply
```

### 2. Configurar Puertos Trusted
```
IP Configuration > DHCP Snooping/Relay > Interface Settings
[Seleccionar puerto hacia DHCP server]
  Trusted: Enable
Apply
```

Los demás puertos son **Untrusted** por defecto.

### 3. (Opcional) Rate Limiting
```
IP Configuration > DHCP Snooping/Relay > Interface Settings
[Puerto untrusted]
  DHCP Snooping Rate Limit: 15 (paquetes/segundo)
Apply
```

## DHCP Snooping Binding Database

El switch mantiene una tabla de bindings:
- MAC Address
- IP Address
- VLAN
- Interface
- Lease Time

### Ver Binding Database
```
IP Configuration > DHCP Snooping/Relay > DHCP Snooping Binding Database
```

## Verificación

### Test DHCP Spoofing
1. Configurar DHCP Snooping
2. Desde atacante en puerto untrusted:
   ```bash
   # Intentar levantar DHCP falso con Ettercap
   sudo ettercap -T -M dhcp:192.168.1.200-220/255.255.255.0/192.168.1.1
   ```
3. El switch debe bloquear las respuestas DHCP del atacante

### Test DHCP Starvation
1. Desde atacante:
   ```bash
   yersinia -G
   # Seleccionar DHCP > Launch Attack > DHCP Starvation
   ```
2. Con Rate Limiting activo, el ataque es mitigado

## Logs
```
Status > System Logs
```
Buscar entradas de DHCP Snooping violations.

---

## Tabla de Tratamiento de Paquetes DHCP

### Paquetes en Interfaz NO Confiable vs Confiable

| Tipo de Paquete | Interfaz NO Confiable | Interfaz Confiable |
|-----------------|----------------------|-------------------|
| **DHCPDISCOVER** | Reenvío solo a interfaces confiables | Reenvío solo a interfaces confiables |
| **DHCPOFFER** | **FILTRO** (bloqueado) | Reenvía según info DHCP. Si destino desconocido, filtra |
| **DHCPREQUEST** | Reenvío solo a interfaces confiables | Reenvío solo a interfaces confiables |
| **DHCPACK** | **FILTRO** (bloqueado) | Igual que OFFER + añade entrada a Binding Database |
| **DHCPNAK** | **FILTRO** (bloqueado) | Igual que OFFER. Elimina entrada si existe |
| **DHCPDECLINE** | Verifica en BD. Si no coincide con interfaz, filtra | Reenvío solo a interfaces confiables |
| **DHCPRELEASE** | Igual que DECLINE | Igual que DECLINE |
| **DHCPINFORM** | Reenvío solo a interfaces confiables | Reenvío solo a interfaces confiables |
| **DHCPLEASE-QUERY** | **FILTRO** | **FILTRO** |

### Resumen
- **Desde puerto Untrusted**: Solo se permiten DISCOVER, REQUEST, DECLINE, RELEASE, INFORM
- **Desde puerto Trusted**: Se permiten todos los tipos de paquetes
- Los OFFER y ACK desde puertos untrusted son **siempre bloqueados** (esto bloquea servidores DHCP falsos)

---

## Opción 82 (DHCP Relay Agent Information)

### Concepto
La Opción 82 añade información adicional a las solicitudes DHCP:
- **Información del puerto** donde se conecta el cliente
- **Información del agente** (switch) que hace la solicitud
- Útil cuando cliente y servidor DHCP están en **redes diferentes**

### Uso
Ayuda al servidor DHCP a:
- Saber dónde está físicamente conectado el cliente
- Seleccionar la mejor subred IP para asignar

### Configuración
```
IP Configuration > DHCP Snooping/Relay > Properties
```

| Opción | Función |
|--------|---------|
| **Inserción DHCP** | Añade info de Opción 82 a paquetes que no la tienen |
| **Envío de DHCP** | Reenvía o rechaza paquetes con Opción 82 de puertos untrusted |
| **Transferencia Opción 82** | Mantiene info de Opción 82 al reenviar |
| **Verificar dirección MAC** | Verifica que MAC L2 coincida con MAC en header DHCP |

---

## Retransmisión DHCP (DHCP Relay)

### Concepto
Retransmite paquetes DHCP cuando el servidor está **fuera de la red local**.

### Modos
- **Modo Capa 2**: Reenvía mensajes de VLANs con Relay habilitado
- **Modo Capa 3**: Puede retransmitir desde VLANs sin IP (inserta Opción 82 automáticamente)

### Configuración
```
IP Configuration > DHCP Snooping/Relay > Properties
  ☑ DHCP Relay: Enable
  DHCP Relay Server Table: [Añadir IP del servidor DHCP]
Apply
```

---

## Base de Datos de Vinculación (Binding Database)

### Campos de cada entrada
| Campo | Descripción |
|-------|-------------|
| **VLAN ID** | VLAN donde se espera el paquete |
| **Dirección MAC** | MAC del cliente |
| **Dirección IP** | IP asignada |
| **Interfaz** | Puerto donde se espera el tráfico |
| **Tipo** | Dinámico (con lease) o Estático (manual) |
| **Tiempo de concesión** | Tiempo que la entrada permanece activa |

### Ver la base de datos
```
IP Configuration > DHCP Snooping/Relay > DHCP Snooping Binding Database
```

### Añadir entrada manual
Para clientes con IP estática que no usan DHCP:
```
Add:
  VLAN ID: 1
  MAC Address: aa:bb:cc:dd:ee:ff
  IP Address: 192.168.1.50
  Interface: GE3
  Type: Static
Apply
```

### Backup de la base de datos
```
☑ Backup Database: Enable
☑ Backup Database Update Interval: [segundos]
```
Guarda copia en flash del switch para persistir tras reinicio.

---

## Configuración Completa Paso a Paso

### 1. Habilitar DHCP Snooping Global
```
IP Configuration > DHCP Snooping/Relay > Properties
  ☑ DHCP Snooping Status: Enable
  ☑ Verify MAC Address: Enable (recomendado)
  ☑ Backup Database: Enable
Apply
```

### 2. Habilitar en VLAN específica
```
IP Configuration > DHCP Snooping/Relay > Interface Settings
Add:
  Interface: VLAN 1
  DHCP Relay: Enable
  DHCP Snooping: Enable
Apply
```

### 3. Configurar puerto Trusted (hacia servidor DHCP)
```
IP Configuration > DHCP Snooping/Relay > DHCP Snooping Trusted Interfaces
[Seleccionar puerto GE8] > Edit
  Trusted Interface: Yes
Apply
```

### 4. Verificar configuración
```
- Ver puertos trusted/untrusted en la tabla
- Verificar Binding Database se llena al conectar clientes
- Revisar logs para violaciones
```

---

## Ver también

- [ARP Inspection](arp_inspection.md) - **Siguiente paso** (requiere DHCP Snooping)
- [DHCP Attacks](../../03_ataque/explotacion/dhcp_attacks.md) - Ataques que mitiga
- [Yersinia](../../03_ataque/herramientas/yersinia.md) - Herramienta de ataque DHCP
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Cómo probar que funciona

---

[← Volver al Índice](../../INDEX.md)
