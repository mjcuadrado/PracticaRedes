# Plantilla: Documentación de Defensa

## Información General

| Campo | Valor |
|-------|-------|
| **Fecha** | ____/____/________ |
| **Estudiante** | |
| **Mecanismo de defensa** | |
| **Ataque que mitiga** | |

---

## Configuración de la Defensa

### Ruta en el switch
```
Menú > Submenú > Opción
```

### Parámetros configurados

| Parámetro | Valor |
|-----------|-------|
| Estado | Habilitado / Deshabilitado |
| | |
| | |
| | |

### Puertos configurados

| Puerto | Tipo/Rol | Configuración |
|--------|----------|---------------|
| GE1 | Gateway | Trusted |
| GE2 | Usuario | Untrusted |
| | | |
| | | |

### Captura de pantalla
_[Insertar captura de la configuración]_

---

## Prueba de Efectividad

### Ataque realizado para probar
**Herramienta:** ____________
**Comando:**
```bash

```

### Resultado SIN la defensa
```
Describir qué pasaba antes de activar la defensa:


```

### Resultado CON la defensa
```
Describir qué pasa después de activar la defensa:


```

### ¿La defensa es efectiva?
- [ ] Sí, el ataque fue bloqueado completamente
- [ ] Parcialmente, el ataque fue mitigado pero no bloqueado
- [ ] No, el ataque sigue siendo exitoso

---

## Logs y Evidencias

### Logs del switch
```
Copiar logs relevantes de Status > System Logs:


```

### Captura de Wireshark
_[Insertar captura mostrando el bloqueo]_

**Filtro usado:** `____________`

---

## Verificación desde la Víctima

### Antes del ataque (estado normal)
```cmd
arp -a
# Resultado:

```

### Durante el ataque (con defensa activa)
```cmd
arp -a
# Resultado (debe ser igual al estado normal):

```

### Conectividad
```cmd
ping 8.8.8.8
# Resultado:

tracert -d 8.8.8.8
# Primer salto (debe ser el gateway real):

```

---

## Conclusiones

### Efectividad de la defensa
| Criterio | Evaluación |
|----------|------------|
| Bloquea el ataque | Sí / No / Parcial |
| Fácil de configurar | Sí / No |
| Impacto en rendimiento | Bajo / Medio / Alto |
| Genera logs útiles | Sí / No |

### Recomendaciones
```



```

---

## Notas adicionales
```



```

---

## Ver también

- [Plantilla Configuración](plantilla_configuracion.md) - Para documentar configs
- [Plantilla Ataque](plantilla_ataque.md) - Para documentar ataques
- [Guía de la Práctica](../guia_practica.md) - Pasos de la práctica
- [DHCP Snooping](../../02_configuracion/seguridad/dhcp_snooping.md) - Configurar defensa
- [ARP Inspection](../../02_configuracion/seguridad/arp_inspection.md) - Configurar defensa

---

[← Volver al Índice](../../INDEX.md)
