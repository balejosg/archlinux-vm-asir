#!/usr/bin/env python3
"""
Calculadora de Huella de Carbono y Consumo Energético en Servidores
ASIR - Green SysAdmin Tool
"""

import time
import sys

try:
    import psutil
except ImportError:
    print("❌ Falta la librería 'psutil'. Instálala con 'sudo pacman -S python-psutil'")
    sys.exit(1)

# Parámetros del modelo energético (estimación basada en arquitectura x86_64 estándar)
TDP_MAX_WATTS = 65.0      # Consumo máximo a plena carga de CPU
POTENCIA_IDLE_WATTS = 12.0 # Consumo base en reposo
FACTOR_EMISION_ES = 135.0  # Gramos de CO2 eq por kWh en España (mix renovable/térmico)

def estimar_consumo_actual():
    """Calcula la potencia instantánea estimada en función del uso de CPU."""
    uso_cpu_pct = psutil.cpu_percent(interval=1.0)
    # Modelo lineal simplificado de potencia: P = P_idle + (P_max - P_idle) * (uso / 100)
    potencia_w = POTENCIA_IDLE_WATTS + ((TDP_MAX_WATTS - POTENCIA_IDLE_WATTS) * (uso_cpu_pct / 100.0))
    return uso_cpu_pct, potencia_w

def main():
    print("🌿 Calculadora de Huella de Carbono de Servidores (ASIR Green IT)")
    print(f"📊 Modelo: Idle = {POTENCIA_IDLE_WATTS}W | Max TDP = {TDP_MAX_WATTS}W | Factor CO2 = {FACTOR_EMISION_ES} g/kWh")
    print("=" * 70)
    print("Presiona Ctrl+C para finalizar y ver el informe total de la sesión.\n")

    segundos_totales = 0
    joules_acumulados = 0.0

    try:
        while True:
            cpu_pct, potencia_w = estimar_consumo_actual()
            segundos_totales += 1
            # 1 Watt = 1 Joule por segundo
            joules_acumulados += potencia_w
            
            kwh = joules_acumulados / 3_600_000.0
            g_co2 = kwh * FACTOR_EMISION_ES

            # Obtener el proceso que más CPU está consumiendo
            top_proc = "ninguno"
            try:
                procesos = sorted(psutil.process_iter(['name', 'cpu_percent']), key=lambda p: p.info['cpu_percent'] or 0, reverse=True)
                if procesos:
                    p = procesos[0]
                    top_proc = f"{p.info['name']} ({p.info['cpu_percent']}%)"
            except Exception:
                pass

            print(f"[{time.strftime('%H:%M:%S')}] CPU: {cpu_pct:5.1f}% | Potencia: {potencia_w:5.1f} W | Energía: {joules_acumulados:8.1f} J | CO2: {g_co2:6.4f} g | Top: {top_proc}")

    except KeyboardInterrupt:
        print("\n\n" + "=" * 60)
        print("📋 INFORME FINAL DE AUDITORÍA ENERGÉTICA:")
        print(f" • Tiempo monitorizado: {segundos_totales} segundos")
        kwh_total = joules_acumulados / 3_600_000.0
        g_co2_total = kwh_total * FACTOR_EMISION_ES
        print(f" • Energía total consumida: {joules_acumulados:.2f} Joules ({kwh_total:.6f} kWh)")
        print(f" • Huella de carbono generada: {g_co2_total:.4f} g CO2eq")
        
        # Proyección anual si este servidor operase 24/7 con esta carga media
        if segundos_totales > 0:
            potencia_media = joules_acumulados / segundos_totales
            kwh_anual = (potencia_media * 24 * 365) / 1000.0
            co2_anual_kg = (kwh_anual * FACTOR_EMISION_ES) / 1000.0
            print(f" • Proyección anual (24/7): {kwh_anual:.1f} kWh/año ({co2_anual_kg:.1f} kg CO2eq/año)")
            
            if potencia_media > 35.0:
                print("\n⚠️ CONSEJO GREEN IT: El consumo medio es elevado. Considera ajustar el gobernador de CPU a 'powersave' o limitar los recursos de los contenedores Docker.")
            else:
                print("\n✓ EXCELENTE: El servidor mantiene una huella contenida y eficiente.")
        print("=" * 60)

if __name__ == "__main__":
    main()
