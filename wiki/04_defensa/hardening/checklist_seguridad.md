# Checklist de Hardening - Switch Cisco SG300

## 1. Acceso al Dispositivo

- [ ] Cambiar credenciales por defecto
- [ ] Deshabilitar HTTP, usar solo HTTPS
- [ ] Deshabilitar Telnet, usar solo SSH
- [ ] Configurar timeout de sesión
- [ ] Limitar IPs de gestión (ACL)

## 2. Seguridad de Puertos

### Port Security
- [ ] Habilitar Port Security globalmente
- [ ] Configurar modo "Limited Dynamic Lock" en puertos de usuarios
- [ ] Establecer máximo de MACs por puerto (1-2)
- [ ] Configurar acción ante violación (Discard o Shutdown)

### 802.1X
- [ ] Configurar servidor RADIUS
- [ ] Habilitar 802.1X en puertos de acceso
- [ ] Configurar Guest VLAN para no autenticados
- [ ] Habilitar re-autenticación periódica

## 3. Protección DHCP

### DHCP Snooping
- [ ] Habilitar DHCP Snooping
- [ ] Marcar puerto hacia DHCP server como Trusted
- [ ] Todos los puertos de usuarios como Untrusted
- [ ] Configurar rate limiting en puertos untrusted

## 4. Protección ARP

### Dynamic ARP Inspection (DAI)
- [ ] Habilitar ARP Inspection (requiere DHCP Snooping)
- [ ] Marcar puerto hacia gateway como Trusted
- [ ] Crear ARP Access Control para IPs estáticas
- [ ] Aplicar reglas a VLANs correspondientes

## 5. Segmentación

### VLANs
- [ ] Crear VLANs por función/departamento
- [ ] Configurar VLAN de gestión separada
- [ ] Native VLAN diferente a VLAN 1

### Private VLAN
- [ ] Configurar PVLAN para aislamiento de hosts
- [ ] Puerto promiscuous solo para gateway
- [ ] Puertos de usuarios como isolated/community

## 6. Protección L2 Adicional

### STP Security
- [ ] Habilitar BPDU Guard en puertos de acceso
- [ ] Habilitar Root Guard en puertos de distribución
- [ ] Configurar Portfast en puertos de acceso

### Storm Control
- [ ] Habilitar Storm Control para broadcast
- [ ] Habilitar Storm Control para multicast
- [ ] Configurar umbrales apropiados

## 7. Logging y Monitoreo

- [ ] Habilitar logging de eventos de seguridad
- [ ] Configurar servidor Syslog externo
- [ ] Habilitar SNMP v3 (no v1/v2)
- [ ] Revisar logs periódicamente

## 8. Configuración Final

- [ ] Guardar configuración en startup-config
- [ ] Documentar configuración aplicada
- [ ] Realizar backup de configuración

---

## Orden de Implementación Recomendado

1. **Primero**: Port Security (más básico)
2. **Segundo**: DHCP Snooping (necesario para DAI)
3. **Tercero**: ARP Inspection
4. **Cuarto**: 802.1X (más complejo)
5. **Quinto**: PVLAN (si aplica)

---

## Ver también

- [Port Security](../../02_configuracion/seguridad/port_security.md) - Paso 1
- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - Paso 2
- [ARP Inspection](../../02_configuracion/seguridad/arp_inspection.md) - Paso 3
- [802.1X RADIUS](../../02_configuracion/seguridad/802_1x_radius.md) - Paso 4
- [PVLAN](../../02_configuracion/seguridad/pvlan.md) - Paso 5
- [Verificación](../monitoreo/verificacion.md) - Probar que todo funciona

---

[← Volver al Índice](../../INDEX.md)
