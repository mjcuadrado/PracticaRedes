#!/bin/bash

# Script de verificación para Kali Linux VM
# Prácticas de Seguridad en Redes Cisco

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  VERIFICACIÓN DE HERRAMIENTAS - KALI LINUX${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Función para verificar herramienta
check_tool() {
    local tool=$1
    local version_cmd=$2
    local required=$3

    echo -n "Verificando $tool... "
    if command -v $tool &> /dev/null; then
        version=$($version_cmd 2>&1 | head -n 1)
        echo -e "${GREEN}✅ $version${NC}"
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}❌ No instalado (REQUERIDO)${NC}"
            echo "   Instalar con: sudo apt install $tool"
        else
            echo -e "${YELLOW}⚠️  No instalado (opcional)${NC}"
        fi
        return 1
    fi
}

echo -e "${YELLOW}[1/4] Verificando herramientas de ataque...${NC}"
echo ""

# Herramientas requeridas
check_tool "yersinia" "yersinia -V" "required"
check_tool "ettercap" "ettercap --version" "required"
check_tool "nmap" "nmap --version" "required"
check_tool "arp-scan" "arp-scan --version" "required"
check_tool "wireshark" "wireshark --version" "required"
check_tool "tshark" "tshark --version" "required"

echo ""
echo -e "${YELLOW}[2/4] Verificando herramientas adicionales...${NC}"
echo ""

check_tool "tcpdump" "tcpdump --version" "optional"
check_tool "dnsmasq" "dnsmasq --version" "optional"
check_tool "macchanger" "macchanger --version" "optional"
check_tool "hping3" "hping3 --version" "optional"
check_tool "arpspoof" "arpspoof -h" "optional"

echo ""
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  VERIFICACIÓN DE RED${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""
echo -e "${YELLOW}[3/4] Verificando configuración de red...${NC}"
echo ""

# Obtener interfaz principal (no loopback)
MAIN_IFACE=$(ip -br addr show | grep -v "lo" | grep "UP" | head -1 | awk '{print $1}')

if [ -z "$MAIN_IFACE" ]; then
    echo -e "${RED}❌ No se encontró interfaz de red activa${NC}"
    echo "   Interfaces disponibles:"
    ip -br addr show
    exit 1
fi

echo -e "${GREEN}✅ Interfaz principal: $MAIN_IFACE${NC}"

# Obtener IP
IP_ADDR=$(ip -4 addr show $MAIN_IFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -z "$IP_ADDR" ]; then
    echo -e "${RED}❌ No hay dirección IP asignada${NC}"
    echo "   Ejecuta: sudo dhclient $MAIN_IFACE"
    exit 1
fi

echo -e "${GREEN}✅ Dirección IP: $IP_ADDR${NC}"

# Verificar si está en la red correcta (192.168.1.x)
if [[ $IP_ADDR == 192.168.1.* ]]; then
    echo -e "${GREEN}✅ IP en la red correcta (192.168.1.x)${NC}"
else
    echo -e "${YELLOW}⚠️  IP no está en 192.168.1.x${NC}"
    echo "   Tu IP: $IP_ADDR"
    echo "   Verifica que la VM esté en modo Bridge y en la red correcta"
fi

# Verificar gateway
GATEWAY=$(ip route show default | awk '{print $3}' | head -1)

if [ -z "$GATEWAY" ]; then
    echo -e "${RED}❌ No se encontró gateway${NC}"
else
    echo -e "${GREEN}✅ Gateway: $GATEWAY${NC}"
fi

# Verificar modo promiscuo
PROMISC=$(ip link show $MAIN_IFACE | grep -o PROMISC)

if [ "$PROMISC" = "PROMISC" ]; then
    echo -e "${GREEN}✅ Modo promiscuo: Activado${NC}"
else
    echo -e "${YELLOW}⚠️  Modo promiscuo: Desactivado${NC}"
    echo "   Activar con: sudo ip link set $MAIN_IFACE promisc on"
fi

# Mostrar MAC address
MAC=$(ip link show $MAIN_IFACE | grep "link/ether" | awk '{print $2}')
echo -e "${GREEN}✅ Dirección MAC: $MAC${NC}"

echo ""
echo -e "${YELLOW}[4/4] Verificando conectividad con objetivos...${NC}"
echo ""

# Ping al switch Cisco
echo -n "Probando switch Cisco (192.168.1.237)... "
if ping -c 2 -W 2 192.168.1.237 &> /dev/null; then
    echo -e "${GREEN}✅ Accesible${NC}"
    SWITCH_OK=1
else
    echo -e "${RED}❌ No accesible${NC}"
    echo "   Verifica que:"
    echo "   1. El switch esté encendido"
    echo "   2. La VM esté en modo Bridge"
    echo "   3. Estés conectado a la misma red"
    SWITCH_OK=0
fi

# Ping al gateway
if [ ! -z "$GATEWAY" ]; then
    echo -n "Probando gateway ($GATEWAY)... "
    if ping -c 2 -W 2 $GATEWAY &> /dev/null; then
        echo -e "${GREEN}✅ Accesible${NC}"
    else
        echo -e "${RED}❌ No accesible${NC}"
    fi
fi

# Ping a Internet
echo -n "Probando conectividad a Internet... "
if ping -c 2 -W 2 8.8.8.8 &> /dev/null; then
    echo -e "${GREEN}✅ Conectado${NC}"
else
    echo -e "${YELLOW}⚠️  Sin conexión a Internet${NC}"
    echo "   (No es crítico para las prácticas locales)"
fi

echo ""
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  ESCANEO RÁPIDO DE RED${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

if [ $SWITCH_OK -eq 1 ]; then
    echo "Escaneando red 192.168.1.0/24..."
    echo ""

    # Verificar si arp-scan está disponible
    if command -v arp-scan &> /dev/null; then
        echo "Dispositivos encontrados:"
        sudo arp-scan -l -I $MAIN_IFACE 2>/dev/null | grep "192.168.1" | while read line; do
            echo "  $line"
        done
    else
        echo "Usando nmap para escaneo rápido..."
        sudo nmap -sn 192.168.1.0/24 2>/dev/null | grep "Nmap scan report" | awk '{print "  " $5}'
    fi
else
    echo -e "${YELLOW}⚠️  Salteando escaneo (switch no accesible)${NC}"
fi

echo ""
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  RESUMEN Y RECOMENDACIONES${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Contar herramientas instaladas
TOOLS_INSTALLED=0
TOOLS_TOTAL=6

command -v yersinia &> /dev/null && ((TOOLS_INSTALLED++))
command -v ettercap &> /dev/null && ((TOOLS_INSTALLED++))
command -v nmap &> /dev/null && ((TOOLS_INSTALLED++))
command -v arp-scan &> /dev/null && ((TOOLS_INSTALLED++))
command -v wireshark &> /dev/null && ((TOOLS_INSTALLED++))
command -v tshark &> /dev/null && ((TOOLS_INSTALLED++))

echo "📊 Herramientas requeridas: $TOOLS_INSTALLED/$TOOLS_TOTAL"

if [ ! -z "$IP_ADDR" ]; then
    echo "🌐 Configuración de red: OK"
else
    echo "🌐 Configuración de red: REQUIERE ATENCIÓN"
fi

if [ $SWITCH_OK -eq 1 ]; then
    echo "🎯 Conectividad con switch: OK"
else
    echo "🎯 Conectividad con switch: NO CONECTADO"
fi

echo ""

# Veredicto final
if [ $TOOLS_INSTALLED -eq $TOOLS_TOTAL ] && [ ! -z "$IP_ADDR" ] && [ $SWITCH_OK -eq 1 ]; then
    echo -e "${GREEN}✅ ¡TODO LISTO! Puedes comenzar las prácticas${NC}"
    echo ""
    echo "🚀 Próximos pasos:"
    echo "   1. Abre Wireshark: sudo wireshark &"
    echo "   2. Accede al switch desde tu navegador: https://192.168.1.237"
    echo "   3. Consulta SETUP_KALI_VM.md para comandos específicos"
elif [ $TOOLS_INSTALLED -eq $TOOLS_TOTAL ] && [ ! -z "$IP_ADDR" ]; then
    echo -e "${YELLOW}⚠️  Casi listo, pero no se puede acceder al switch${NC}"
    echo ""
    echo "🔧 Acciones requeridas:"
    echo "   1. Verifica que el switch esté encendido"
    echo "   2. Confirma que la VM esté en modo Bridge (no NAT)"
    echo "   3. Verifica que estés conectado a la misma red que el switch"
    echo "   4. Re-ejecuta este script después de corregir"
elif [ $TOOLS_INSTALLED -lt $TOOLS_TOTAL ]; then
    echo -e "${RED}❌ Faltan herramientas por instalar${NC}"
    echo ""
    echo "🔧 Acciones requeridas:"
    echo "   sudo apt update"
    echo "   sudo apt install yersinia ettercap-graphical wireshark nmap arp-scan"
else
    echo -e "${YELLOW}⚠️  Configuración incompleta${NC}"
    echo ""
    echo "🔧 Revisa los puntos marcados arriba"
fi

echo ""
echo -e "${BLUE}=============================================${NC}"
echo ""
