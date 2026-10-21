#!/usr/bin/env bash
# ==============================================================================
# Script de aprovisionamiento interno para Arch Linux VM (ASIR Green IT Edition)
# Se ejecuta dentro de la máquina virtual (vía SSH o durante la creación)
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "🌿 APROVISIONANDO ENTORNO ASIR: SISTEMAS, REDES Y GREEN IT"
echo "======================================================================"

# 1. Localización y Teclado Español
echo "[1/8] Configurando localización española (es_ES.UTF-8, KEYMAP=es)..."
sed -i 's/^#\(es_ES.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

cat << 'EOF' > /etc/locale.conf
LANG=es_ES.UTF-8
LC_COLLATE=C
EOF

cat << 'EOF' > /etc/vconsole.conf
KEYMAP=es
FONT=eurlatgr
EOF

ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
timedatectl set-timezone Europe/Madrid || true

# 2. Actualización de repositorios y paquetes base de ASIR
echo "[2/8] Instalando paquetes de Redes, Sistemas y Sostenibilidad..."
pacman -Sy --noconfirm --needed \
    base-devel git curl wget rsync jq vim nano tmux zsh \
    htop glances ripgrep fd tree \
    net-tools iproute2 nmap tcpdump iperf3 bind-tools socat traceroute \
    docker docker-compose \
    mosquitto \
    powertop linux-tools \
    python python-pip python-paho-mqtt python-psutil python-requests python-rich

# 3. Configuración del servicio Docker
echo "[3/8] Habilitando Docker y asignando permisos al usuario 'alumno'..."
systemctl enable docker.service
systemctl start docker.service || true

if id -u alumno >/dev/null 2>&1; then
    usermod -aG docker alumno
fi

# 4. Configuración del servicio Mosquitto (Broker MQTT)
echo "[4/8] Preparando servicio Mosquitto..."
systemctl enable mosquitto.service || true

# 5. Soporte para Carpetas Compartidas de VirtualBox
echo "[5/8] Verificando VirtualBox Guest Additions..."
pacman -S --noconfirm --needed virtualbox-guest-utils || true
systemctl enable vboxservice.service || true

# Añadir alumno al grupo vboxsf
if id -u alumno >/dev/null 2>&1; then
    usermod -aG vboxsf alumno
fi

# 6. Instalación de Agentes de IA (Antigravity CLI, OpenCode, Herdr)
echo "[6/8] Configurando herramientas de Inteligencia Artificial Agéntica..."

# Instalar OpenCode (100% Libre y de código abierto)
if ! command -v opencode >/dev/null 2>&1; then
    echo "Instalando OpenCode CLI..."
    curl -fsSL https://opencode.ai/install | bash || true
    if [ -f /root/.opencode/bin/opencode ]; then
        cp /root/.opencode/bin/opencode /usr/local/bin/opencode || true
    fi
fi

# Instalar Herdr
if ! command -v herdr >/dev/null 2>&1; then
    echo "Instalando Herdr CLI..."
    curl -fsSL https://herdr.dev/install.sh | bash || true
    if [ -f /root/.herdr/bin/herdr ]; then
        cp /root/.herdr/bin/herdr /usr/local/bin/herdr || true
    fi
fi

# 7. Configuración del Asistente Técnico de IA para ASIR
echo "[7/8] Instalando directrices técnicas de Green IT en los agentes..."
USER_HOME="/home/alumno"

mkdir -p "${USER_HOME}/.config/opencode"
mkdir -p "${USER_HOME}/.gemini/antigravity-cli/rules"
mkdir -p "${USER_HOME}/.gemini/rules"

if [ -f /tmp/AGENTS.md ]; then
    cp /tmp/AGENTS.md "${USER_HOME}/.config/opencode/AGENTS.md"
    cp /tmp/AGENTS.md "${USER_HOME}/.gemini/antigravity-cli/rules/asistente-asir-sostenible.md"
    cp /tmp/AGENTS.md "${USER_HOME}/.gemini/rules/asistente-asir-sostenible.md"
fi

# 8. Espacio de Trabajo (~/trabajo) y comando 'montar-trabajo'
echo "[8/8] Preparando workspace ~/trabajo y utilidades..."
mkdir -p "${USER_HOME}/trabajo/proyectos"
mkdir -p "${USER_HOME}/trabajo/plantillas-sostenibilidad"
mkdir -p "${USER_HOME}/trabajo/apuntes"

if [ -d /tmp/proyectos-sostenibilidad ]; then
    cp -r /tmp/proyectos-sostenibilidad/* "${USER_HOME}/trabajo/plantillas-sostenibilidad/" || true
fi

if [ -f /tmp/CRITERIOS_EVALUACION.md ]; then
    cp /tmp/CRITERIOS_EVALUACION.md "${USER_HOME}/trabajo/" || true
fi

if [ -f /tmp/AGENTS.md ]; then
    cp /tmp/AGENTS.md "${USER_HOME}/trabajo/" || true
fi

if [ -f /tmp/LEEME_ALUMNO.md ]; then
    cp /tmp/LEEME_ALUMNO.md "${USER_HOME}/trabajo/LEEME.txt" || true
fi

if [ -f /tmp/montar-trabajo ]; then
    cp /tmp/montar-trabajo /usr/local/bin/montar-trabajo
    chmod +x /usr/local/bin/montar-trabajo
fi

# Configurar entrada en /etc/fstab para la carpeta compartida con 'nofail'
if ! grep -q "trabajo /home/alumno/trabajo" /etc/fstab; then
    cat << 'EOF' >> /etc/fstab
trabajo /home/alumno/trabajo vboxsf rw,uid=1001,gid=1001,dmode=755,fmode=644,nofail 0 0
EOF
fi

# Asignar permisos al usuario alumno
chown -R alumno:alumno "${USER_HOME}" || true

echo "======================================================================"
echo "✓ APROVISIONAMIENTO ASIR COMPLETADO SATISFACTORIAMENTE"
echo "======================================================================"
