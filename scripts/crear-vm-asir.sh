#!/usr/bin/env bash
# ==============================================================================
# CREACIÓN Y EXPORTACIÓN AUTOMATIZADA: Arch Linux VM (ASIR Sostenibilidad)
# ==============================================================================
set -euo pipefail

VM_NAME="ArchLinux-ASIR"
OVA_OUTPUT="ArchLinux-ASIR.ova"
BASE_DIR="${HOME}/arch-asir-build"
DISK_SIZE_MB=40960 # 40 GB disco dinámico

echo "======================================================================"
echo "🚀 INICIANDO CONSTRUCCIÓN DE LA VM ARCH LINUX (ASIR GREEN IT)"
echo "======================================================================"

# Verificar dependencias en el host
for cmd in VBoxManage curl qemu-img; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ Falta la herramienta requerida en el anfitrión: $cmd"
        echo "   Instálala antes de continuar (ej: sudo pacman -S virtualbox qemu-img curl)"
        exit 1
    fi
done

mkdir -p "${BASE_DIR}"
cd "${BASE_DIR}"

IMAGE_URL="https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-basic.qcow2"
QCOW_FILE="Arch-Linux-x86_64-basic.qcow2"
VDI_FILE="${VM_NAME}.vdi"

# 1. Descarga de imagen oficial de Arch Linux
if [ ! -f "${QCOW_FILE}" ]; then
    echo "📥 Descargando imagen oficial básica de Arch Linux..."
    curl -L -C - --retry 5 --retry-delay 2 -o "${QCOW_FILE}" "${IMAGE_URL}"
else
    echo "✓ Usando imagen base ya descargada: ${QCOW_FILE}"
fi

# 2. Conversión a disco VirtualBox VDI
if [ ! -f "${VDI_FILE}" ]; then
    echo "🔄 Convirtiendo imagen qcow2 a disco dinámico VDI..."
    qemu-img convert -O vdi -c "${QCOW_FILE}" "${VDI_FILE}"
    VBoxManage modifymedium disk "${VDI_FILE}" --resize "${DISK_SIZE_MB}" || true
else
    echo "✓ Disco VDI ya existente: ${VDI_FILE}"
fi

# 3. Eliminar VM previa si existía
if VBoxManage showvminfo "${VM_NAME}" >/dev/null 2>&1; then
    echo "⚠️ Eliminando registro previo de la VM ${VM_NAME}..."
    VBoxManage unregistervm "${VM_NAME}" --delete || true
fi

# 4. Crear y registrar la VM en VirtualBox
echo "⚙️ Registrando máquina virtual '${VM_NAME}'..."
VBoxManage createvm --name "${VM_NAME}" --ostype "ArchLinux_64" --register

# Configuración de hardware
VBoxManage modifyvm "${VM_NAME}" \
    --cpus 2 \
    --memory 2048 \
    --vram 16 \
    --graphicscontroller vmsvga \
    --boot1 disk \
    --nic1 nat \
    --natpf1 "ssh,tcp,127.0.0.1,2222,,22" \
    --natpf1 "web,tcp,127.0.0.1,8080,,80" \
    --natpf1 "mqtt,tcp,127.0.0.1,1883,,1883" \
    --natpf1 "grafana,tcp,127.0.0.1,3000,,3000" \
    --natpf1 "influx,tcp,127.0.0.1,8086,,8086" \
    --audio-enabled off \
    --clipboard-mode bidirectional

# Controladora de almacenamiento
VBoxManage storagectl "${VM_NAME}" --name "SATA" --add sata --controller IntelAhci --portcount 2
VBoxManage storageattach "${VM_NAME}" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "${VDI_FILE}"

echo "✓ VM '${VM_NAME}' configurada correctamente."
echo "Puertos expuestos hacia el host (127.0.0.1):"
echo " • 2222 -> 22   (SSH)"
echo " • 8080 -> 80   (Servidor Web)"
echo " • 1883 -> 1883 (Broker MQTT Mosquitto)"
echo " • 3000 -> 3000 (Grafana Dashboards)"
echo " • 8086 -> 8086 (InfluxDB API)"
echo ""
echo "Para exportar a OVA una vez aprovisionada:"
echo "VBoxManage export \"${VM_NAME}\" -o \"${OVA_OUTPUT}\""
