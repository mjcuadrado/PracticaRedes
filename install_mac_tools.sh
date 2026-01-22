#!/bin/bash

# Script para instalar herramientas necesarias para Prácticas de Seguridad en Redes (macOS)
# Fecha: 2026-01-22

echo "================================================"
echo "Instalación de herramientas para Prácticas Redes"
echo "================================================"
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar si Homebrew está instalado
if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Homebrew no está instalado${NC}"
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew ya está instalado${NC}"
fi

echo ""
echo "Actualizando Homebrew..."
brew update

echo ""
echo "================================================"
echo "Instalando herramientas..."
echo "================================================"

# Función para instalar con brew
install_tool() {
    local tool=$1
    local package=$2

    if [ -z "$package" ]; then
        package=$tool
    fi

    echo ""
    echo "--- Instalando $tool ---"

    if command -v $tool &> /dev/null; then
        echo -e "${YELLOW}⚠ $tool ya está instalado, actualizando...${NC}"
        brew upgrade $package 2>/dev/null || echo -e "${GREEN}✓ $tool ya está en la última versión${NC}"
    else
        brew install $package
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ $tool instalado correctamente${NC}"
        else
            echo -e "${RED}❌ Error instalando $tool${NC}"
        fi
    fi
}

# Instalar herramientas
install_tool "yersinia" "yersinia"
install_tool "ettercap" "ettercap"
install_tool "nmap" "nmap"

# Wireshark es un poco especial porque es una aplicación
echo ""
echo "--- Instalando Wireshark ---"
if [ -d "/Applications/Wireshark.app" ]; then
    echo -e "${YELLOW}⚠ Wireshark ya está instalado, actualizando...${NC}"
    brew upgrade --cask wireshark 2>/dev/null || echo -e "${GREEN}✓ Wireshark ya está en la última versión${NC}"
else
    brew install --cask wireshark
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Wireshark instalado correctamente${NC}"
    else
        echo -e "${RED}❌ Error instalando Wireshark${NC}"
    fi
fi

# Herramientas adicionales útiles
echo ""
echo "--- Instalando herramientas adicionales ---"
install_tool "tcpdump" "tcpdump"
install_tool "arp-scan" "arp-scan"

echo ""
echo "================================================"
echo "Verificación de instalación"
echo "================================================"
echo ""

# Verificar instalaciones
check_tool() {
    local tool=$1
    local version_cmd=$2

    echo -n "Verificando $tool... "
    if command -v $tool &> /dev/null; then
        version=$($version_cmd 2>&1 | head -n 1)
        echo -e "${GREEN}✓ Instalado${NC} - $version"
        return 0
    else
        echo -e "${RED}❌ No encontrado${NC}"
        return 1
    fi
}

check_tool "yersinia" "yersinia -V"
check_tool "ettercap" "ettercap --version"
check_tool "nmap" "nmap --version"
check_tool "tshark" "tshark --version"
check_tool "tcpdump" "tcpdump --version"
check_tool "arp-scan" "arp-scan --version"

echo ""
if [ -d "/Applications/Wireshark.app" ]; then
    echo -e "Wireshark (GUI)... ${GREEN}✓ Instalado${NC} - /Applications/Wireshark.app"
else
    echo -e "Wireshark (GUI)... ${RED}❌ No encontrado${NC}"
fi

echo ""
echo "================================================"
echo "Notas importantes"
echo "================================================"
echo ""
echo "1. Wireshark GUI se encuentra en /Applications/Wireshark.app"
echo "2. Algunas herramientas requieren permisos de administrador (sudo)"
echo "3. Para usar Yersinia: sudo yersinia -G (modo gráfico)"
echo "4. Para usar Ettercap: sudo ettercap -G (modo gráfico)"
echo "5. Wireshark puede requerir permisos para captura (ChmodBPF)"
echo ""
echo "Si Wireshark no puede capturar tráfico, ejecuta:"
echo "sudo chmod 644 /dev/bpf*"
echo ""
echo -e "${GREEN}✓ Instalación completada${NC}"
echo ""
