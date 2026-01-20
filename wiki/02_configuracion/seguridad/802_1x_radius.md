# IEEE 802.1X con RADIUS

## Arquitectura

```
[Suplicante] <--EAP--> [Autenticador] <--RADIUS--> [Servidor RADIUS]
   (PC)               (Switch/Puerto)              (FreeRADIUS)
```

## Configuración del Servidor RADIUS (Linux)

### Instalar FreeRADIUS
```bash
sudo apt-get update
sudo apt-get install freeradius
```

### Configurar Cliente (Switch)
Archivo: `/etc/freeradius/3.0/clients.conf`
```
client SWITCH-01 {
    ipaddr = 192.168.1.237
    secret = rEdes2021
}
```

### Configurar Usuario
Archivo: `/etc/freeradius/3.0/users`
```
andres Cleartext-Password := "tfG2021"
```

### Iniciar Servicio
```bash
# Modo debug (para pruebas)
sudo freeradius -X

# Modo servicio
sudo systemctl start freeradius
sudo systemctl enable freeradius
```

### Probar RADIUS
```bash
radtest andres tfG2021 localhost 0 testing123
```
Respuesta esperada: `Access-Accept`

## Configuración del Switch

### 1. Configurar Servidor RADIUS
```
Security > RADIUS
Add:
  - Server IP: [IP del servidor RADIUS]
  - Secret: rEdes2021
  - Authentication Port: 1812
  - Accounting Port: 1813
Apply
```

### 2. Habilitar 802.1X Global
```
Security > 802.1X/MAC/Web Authentication > Properties
  ☑ Enable Port-Based Authentication
  Authentication Method: RADIUS
Apply
```

### 3. Configurar Puertos
```
Security > 802.1X/MAC/Web Authentication > Port Authentication
[Seleccionar puerto] > Edit:
  - Administrative Port Control: Auto
  - Guest VLAN: (opcional)
  - Periodic Reauthentication: Enable
  - Reauthentication Period: 3600
Apply
```

## Estados del Puerto 802.1X

| Estado | Significado |
|--------|-------------|
| **Force-Authorized** | Siempre autorizado (sin 802.1X) |
| **Force-Unauthorized** | Siempre bloqueado |
| **Auto** | Requiere autenticación 802.1X |

## Configuración del Cliente (Windows)

1. Panel de Control > Centro de redes
2. Cambiar configuración del adaptador
3. Click derecho en adaptador > Propiedades
4. Pestaña "Autenticación"
5. Habilitar autenticación IEEE 802.1X
6. Método: EAP-PEAP
7. Configurar credenciales

## Troubleshooting

```bash
# Ver logs RADIUS
sudo tail -f /var/log/freeradius/radius.log

# Capturar tráfico RADIUS
sudo tcpdump -i any port 1812 -vvv
```

---

## Modos de Host del Puerto

### Ruta en Switch
```
Security > 802.1X/MAC/Web Authentication > Host and Session Authentication
```

### Modos Disponibles

| Modo | Descripción | Uso típico |
|------|-------------|------------|
| **Single Host** | Solo un dispositivo puede autenticarse | Equipos fijos (PC de escritorio) |
| **Multiple Host** | Un dispositivo autentica, otros pueden acceder | Hub detrás del puerto |
| **Multiple Sessions** | Cada dispositivo debe autenticarse individualmente | Máxima seguridad |

### Configuración
```
Security > 802.1X/MAC/Web Authentication > Host and Session Authentication
[Seleccionar puerto] > Edit:
  Host Authentication: Multiple Host (802.1X)
Apply
```

---

## Parámetros Avanzados del Servidor RADIUS

### Ruta
```
Security > RADIUS
```

### Parámetros por Defecto (Use Default Parameters)

| Parámetro | Descripción | Valor típico |
|-----------|-------------|--------------|
| **Retries** | Intentos antes de considerar error | 3 |
| **Timeout for Reply** | Segundos esperando respuesta | 3 |
| **Dead Time** | Minutos antes de desviar de servidor que no responde | 0 (no desvía) |
| **Key String** | Clave de autenticación compartida | rEdes2021 |

### Parámetros del Servidor Específico

Al añadir un servidor RADIUS:

| Parámetro | Descripción |
|-----------|-------------|
| **Server Definition** | Por IP o por nombre |
| **IP Version** | IPv4 o IPv6 |
| **Server IP Address** | Dirección del servidor RADIUS |
| **Priority** | Orden de intento (menor = primero) |
| **Key String** | Secret compartido con el servidor |
| **Authentication Port** | Puerto UDP autenticación (defecto: 1812) |
| **Accounting Port** | Puerto UDP contabilidad (defecto: 1813) |
| **Usage Type** | Login, 802.1X, o All |

### Usage Type

| Tipo | Uso |
|------|-----|
| **Login** | Autenticación de usuarios que administran el switch |
| **802.1X** | Autenticación de dispositivos en la red |
| **All** | Ambos usos |

### Ejemplo de Configuración Completa
```
Security > RADIUS > Add

Server Definition: By IP address
IP Version: Version 4
Server IP Address: 192.168.1.104
Priority: 1
Key String: ● User Defined (Plaintext): rEdes2021
Timeout for Reply: ● Use Default
Authentication Port: 1812
Accounting Port: 1813
Retries: ● Use Default
Dead Time: ● Use Default
Usage Type: ● All

Apply
```

---

## RADIUS Accounting

### Modos de Contabilidad
```
Security > RADIUS
RADIUS Accounting: [Seleccionar modo]
```

| Modo | Función |
|------|---------|
| **Port Based Access Control** | Contabilidad del puerto 802.1X |
| **Management Access** | Contabilidad de login de administración |
| **Both** | Ambos modos |
| **None** | Deshabilitado |

---

## Autenticación de Puertos Detallada

### Ruta
```
Security > 802.1X/MAC/Web Authentication > Port Authentication
```

### Campos por Puerto

| Campo | Descripción |
|-------|-------------|
| **Administrative Port Control** | Auto, Force-Authorized, Force-Unauthorized |
| **Current Port Control** | Estado actual del puerto |
| **Guest VLAN** | VLAN para no autenticados (opcional) |
| **Open Access** | Permitir tráfico mientras autentica |
| **802.1X Based Authentication** | Habilitar 802.1X |
| **MAC Based Authentication** | Autenticación por MAC |
| **Web Based Authentication** | Portal cautivo web |
| **Periodic Reauthentication** | Re-autenticar periódicamente |
| **Reauthentication Period** | Intervalo en segundos |

### Configuración Recomendada para Seguridad
```
[Puerto de usuario] > Edit:
  Administrative Port Control: Auto
  802.1X Based Authentication: Enable
  MAC Based Authentication: Disable
  Periodic Reauthentication: Enable
  Reauthentication Period: 3600
Apply
```

---

## Guest VLAN

### Concepto
VLAN donde se colocan los dispositivos que:
- No soportan 802.1X
- No se han autenticado
- Han fallado la autenticación

### Configuración
```
Security > 802.1X/MAC/Web Authentication > Properties
  Guest VLAN ID: [número de VLAN, ej: 99]
Apply

Security > 802.1X/MAC/Web Authentication > Port Authentication
[Puerto] > Edit:
  Guest VLAN: Enable
Apply
```

### Uso típico
- VLAN con acceso limitado (solo Internet, sin recursos internos)
- Para visitantes o dispositivos legacy

---

## Proceso de Autenticación 802.1X

```
1. Cliente conecta al puerto
   ↓
2. Switch bloquea tráfico (puerto no autorizado)
   ↓
3. Switch envía EAP-Request/Identity
   ↓
4. Cliente responde con EAP-Response/Identity (usuario)
   ↓
5. Switch encapsula en RADIUS Access-Request
   ↓
6. Servidor RADIUS valida credenciales
   ↓
7. RADIUS responde Access-Accept o Access-Reject
   ↓
8. Switch autoriza o bloquea el puerto
```

---

## Verificación

### En el Switch
```
Security > 802.1X/MAC/Web Authentication > Port Authentication
- Ver columna "Current Port Control"
- Authorized = autenticado correctamente
- Unauthorized = pendiente o fallido
```

### Hosts Autenticados
```
Security > 802.1X/MAC/Web Authentication > Authenticated Hosts
- Ver lista de hosts autenticados
- MAC, puerto, VLAN, método de autenticación
```

### Test desde Cliente Linux
```bash
# Usar wpa_supplicant
wpa_supplicant -i eth0 -c /etc/wpa_supplicant/wired.conf

# Archivo wired.conf
ctrl_interface=/var/run/wpa_supplicant
eapol_version=2
network={
    key_mgmt=IEEE8021X
    eap=PEAP
    identity="andres"
    password="tfG2021"
}
```

---

## Ver también

- [Port Security](port_security.md) - Control de acceso complementario
- [Checklist de Seguridad](../../04_defensa/hardening/checklist_seguridad.md) - Lista completa
- [Verificación](../../04_defensa/monitoreo/verificacion.md) - Cómo probar 802.1X

---

[← Volver al Índice](../../INDEX.md)
