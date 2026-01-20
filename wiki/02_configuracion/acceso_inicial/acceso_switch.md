# Acceso Inicial al Switch Cisco SG300-10

## Datos de Conexión

```
IP: 192.168.1.237
Protocolo: HTTPS (web)
URL: https://192.168.1.237
```

## Pasos de Acceso

1. Conectar PC al switch (cualquier puerto)
2. Configurar IP estática en el rango 192.168.1.x
3. Abrir navegador: `https://192.168.1.237`
4. Aceptar certificado autofirmado
5. Login con credenciales

## Configurar IP del PC (Windows)

```cmd
# Ver configuración actual
ipconfig /all

# Configurar IP estática (Panel de Control > Adaptador de Red)
IP: 192.168.1.100
Máscara: 255.255.255.0
Gateway: 192.168.1.1
```

## Configurar IP del PC (Linux)

```bash
# Temporal
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1

# Ver configuración
ip addr show
```

## Navegación Web del Switch

### Menús Principales
- **Status**: Estado del sistema
- **Administration**: Gestión del dispositivo
- **Port Management**: Configuración de puertos
- **VLAN Management**: Gestión de VLANs
- **Security**: Todas las opciones de seguridad
- **IP Configuration**: DHCP, routing

## Guardar Configuración

**IMPORTANTE**: Después de cada cambio:
1. Hacer clic en **Apply**
2. Ir a **Administration > File Management > Copy/Save Configuration**
3. Copiar "Running Configuration" a "Startup Configuration"

---

## Ver también

- [Port Security](../seguridad/port_security.md) - Primera configuración recomendada
- [Cheatsheet](../../05_comandos/cheatsheet.md) - Comandos rápidos
- [Guía de la Práctica](../../06_laboratorio/guia_practica.md) - Pasos completos

---

[← Volver al Índice](../../INDEX.md)
