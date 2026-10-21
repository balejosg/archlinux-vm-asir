#!/usr/bin/env bash
# Generador de carga de prueba para contrastar consumo eléctrico (ASIR)
set -euo pipefail

DURACION=10
echo "🧪 Iniciando prueba de carga de estrés ecológico (${DURACION} segundos)..."
echo "Observa cómo reacciona 'calculadora_huella_carbono.py' al disparo de CPU."

# Simulación de carga intensa temporal con compresión / hashing en bucle
timeout "${DURACION}" bash -c 'cat /dev/urandom | gzip -9 > /dev/null' || true

echo "✓ Prueba completada. La CPU vuelve a su estado base de reposo."
