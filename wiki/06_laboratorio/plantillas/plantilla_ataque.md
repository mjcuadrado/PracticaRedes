# Plantilla: Documentación de Ataque

## Información General

| Campo | Valor |
|-------|-------|
| **Fecha** | ____/____/________ |
| **Estudiante** | |
| **Tipo de ataque** | |
| **Herramienta usada** | |

---

## Escenario

### Topología
```
Dibujar o describir la topología:

[            ] ─── IP: ____________
      |
[            ] ─── IP: ____________
      |
├── [Víctima]    ─── IP: ____________
└── [Atacante]   ─── IP: ____________
```

### Objetivo del ataque
_Ej: MITM, DoS, captura de credenciales_

**____________________________________________**

---

## Ejecución del Ataque

### Comando ejecutado
```bash

```

### Captura de pantalla del ataque
_[Insertar captura]_

---

## Verificación del Éxito

### Desde la máquina víctima

**Comando ejecutado:**
```cmd

```

**Resultado:**
```

```

### Evidencia del ataque
- [ ] Tabla ARP modificada (ARP Poisoning)
- [ ] IP asignada por atacante (DHCP Spoofing)
- [ ] Sin IP disponible (DHCP Starvation)
- [ ] Tráfico capturado
- [ ] Otro: _______________________

### Captura de Wireshark
_[Insertar captura de tráfico relevante]_

**Filtro usado:** `____________`

---

## Estado de las Defensas

### Durante este ataque
- [ ] Sin defensas activas
- [ ] Port Security: Activo / Inactivo
- [ ] DHCP Snooping: Activo / Inactivo
- [ ] ARP Inspection: Activo / Inactivo

### Resultado con defensas
| Defensa | ¿Bloqueó el ataque? | Evidencia |
|---------|---------------------|-----------|
| Port Security | Sí / No / N/A | |
| DHCP Snooping | Sí / No / N/A | |
| ARP Inspection | Sí / No / N/A | |

---

## Conclusiones

### ¿El ataque fue exitoso?
- [ ] Sí, sin defensas
- [ ] Sí, con defensas (defensa inefectiva)
- [ ] No, bloqueado por: _______________________

### Lecciones aprendidas
```




```

---

## Notas adicionales
```



```

---

## Ver también

- [Plantilla Configuración](plantilla_configuracion.md) - Para documentar configs
- [Plantilla Defensa](plantilla_defensa.md) - Para documentar defensas
- [Guía de la Práctica](../guia_practica.md) - Pasos de la práctica
- [ARP Poisoning](../../03_ataque/explotacion/arp_poisoning.md) - Guía de ataque
- [DHCP Attacks](../../03_ataque/explotacion/dhcp_attacks.md) - Guía de ataques

---

[← Volver al Índice](../../INDEX.md)
