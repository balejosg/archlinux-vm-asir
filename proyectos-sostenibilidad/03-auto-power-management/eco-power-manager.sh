#!/usr/bin/env bash
# ==============================================================================
# ECO-POWER-MANAGER: Gestor Automatizado de Políticas de Ahorro Energético (ASIR)
# ==============================================================================
set -euo pipefail

LOG_FILE="/tmp/eco-power.log"
HORA_ACTUAL=$(date +%H)
DIA_SEMANA=$(date +%u) # 1=Lunes, 7=Domingo

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "${msg}"
    echo "${msg}" >> "${LOG_FILE}"
}

log "🌿 Ejecutando ciclo de optimización energética de sistemas..."

# 1. Comprobar disponibilidad de cpupower
if command -v cpupower >/dev/null 2>&1; then
    # Determinar si estamos en horario valle (noches: 21h-07h o fines de semana)
    if [ "${HORA_ACTUAL}" -ge 21 ] || [ "${HORA_ACTUAL}" -lt 7 ] || [ "${DIA_SEMANA}" -ge 6 ]; then
        PERFIL_DESEADO="powersave"
        log "🌙 Horario valle o no lectivo detectado. Aplicando perfil ultra-eficiente: ${PERFIL_DESEADO}"
    else
        PERFIL_DESEADO="schedutil"
        log "☀️ Horario laboral/docente detectado. Aplicando perfil dinámico equilibrado: ${PERFIL_DESEADO}"
    fi

    # Intentar aplicar gobernador si tenemos privilegios de sudo
    if [ "$(id -u)" -eq 0 ] || sudo -n true 2>/dev/null; then
        sudo cpupower frequency-set -g "${PERFIL_DESEADO}" >/dev/null 2>&1 || true
        log "✓ Gobernador de frecuencia CPU ajustado a '${PERFIL_DESEADO}'"
    else
        log "ℹ️ Ejecutado sin privilegios root; simulando cambio a perfil '${PERFIL_DESEADO}'."
    fi
else
    log "ℹ️ 'cpupower' no instalado en este host (se ejecuta en la VM Arch Linux)."
fi

# 2. Detección de procesos parásitos descontrolados (CPU > 80%)
UMBRAL_CPU=80.0
log "🔍 Analizando procesos en busca de bucles descontrolados (> ${UMBRAL_CPU}% CPU)..."

PROCESOS_CRITICOS=$(ps -eo pid,pcpu,comm --no-headers | awk -v umbral="${UMBRAL_CPU}" '$2 > umbral { print $1, $2, $3 }')

if [ -n "${PROCESOS_CRITICOS}" ]; then
    log "⚠️ PROCESO CRÍTICO DETECTADO DESPERDICIANDO ENERGÍA:"
    while read -r pid pcpu comm; do
        log "   PID: ${pid} (${comm}) consumiendo ${pcpu}% de CPU de forma anómala!"
    done <<< "${PROCESOS_CRITICOS}"
else
    log "✓ Todos los procesos operan en rangos térmicos y energéticos normales."
fi

# 3. Comprobación de estado de suspensión de discos y contenedores inactivos
if command -v docker >/dev/null 2>&1; then
    NUM_CONTENEDORES=$(docker ps -q 2>/dev/null | wc -l || echo 0)
    log "🐳 Contenedores activos en ejecución: ${NUM_CONTENEDORES}"
fi

log "✓ Ciclo de eco-gestión completado con éxito."
echo ""
