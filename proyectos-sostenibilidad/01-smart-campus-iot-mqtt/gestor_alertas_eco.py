#!/usr/bin/env python3
"""
Gestor de Alertas y Ahorro Energético (Eco-Controller)
ASIR - Proyecto Green IT & IoT
"""

import time
import json
import sys

try:
    import paho.mqtt.client as mqtt
except ImportError:
    print("❌ Falta paho-mqtt. Instálalo con 'sudo pacman -S python-paho-mqtt'")
    sys.exit(1)

BROKER_HOST = "localhost"
BROKER_PORT = 1883
TOPIC_SUBSCRIPTION = "campus/edificioA/+/telemetria"

# Factor de emisión de la red eléctrica peninsular española (~135 g CO2eq / kWh)
FACTOR_CO2_G_KWH = 135.0

# Contadores de métricas de sostenibilidad
total_kwh_desperdiciados = 0.0
total_alertas_co2 = 0
total_alertas_energia = 0

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"✓ Conectado a Mosquitto. Suscrito a '{TOPIC_SUBSCRIPTION}'")
        client.subscribe(TOPIC_SUBSCRIPTION)
    else:
        print(f"❌ Error de conexión MQTT. Código: {rc}")

def on_message(client, userdata, msg):
    global total_kwh_desperdiciados, total_alertas_co2, total_alertas_energia
    try:
        data = json.loads(msg.payload.decode("utf-8"))
        aula = data.get("aula", "desconocida")
        co2 = data.get("co2_ppm", 0)
        presencia = data.get("presencia", False)
        luces_w = data.get("potencia_luces_w", 0)
        potencia_w = data.get("potencia_total_w", 0)

        # Regla 1: Alerta de Calidad de Aire y Eficiencia de Climatización
        if co2 > 1000:
            total_alertas_co2 += 1
            print(f"⚠️  [ECO-ALERTA CO2] {aula}: {co2} ppm. Recomendación: activar ventilación cruzada.")

        # Regla 2: Detección de Desperdicio Energético (Cargas Fantasma / Luces en Aulas Vacías)
        if not presencia and luces_w > 0:
            total_alertas_energia += 1
            # Simulamos cálculo de energía evitable (si las luces quedan 1 hora encendidas)
            kwh_hora = luces_w / 1000.0
            g_co2_hora = kwh_hora * FACTOR_CO2_G_KWH
            total_kwh_desperdiciados += kwh_hora / 900.0 # Proporcional al sondeo

            print(f"🚨 [DERROCHE ENERGÉTICO] {aula} vacía pero con {luces_w}W de iluminación activa!")
            print(f"   💡 Apagado automático sugerido: ahorra {kwh_hora:.3f} kWh y evita {g_co2_hora:.1f} g CO2eq/hora.")

    except Exception as e:
        print(f"Error procesando mensaje: {e}")

def main():
    print("🌍 Iniciando Eco-Controller de Alertas y Telemetría Sostenible...")
    client = mqtt.Client(client_id="eco-alert-manager")
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        client.connect(BROKER_HOST, BROKER_PORT, keepalive=60)
        client.loop_forever()
    except KeyboardInterrupt:
        print("\n\n" + "=" * 55)
        print("📊 RESUMEN DE SESIÓN DE SOSTENIBILIDAD:")
        print(f" • Alertas de ventilación CO2 gestionadas: {total_alertas_co2}")
        print(f" • Eventos de derroche energético detectados: {total_alertas_energia}")
        print(f" • Huella de carbono potencialmente evitada: {total_kwh_desperdiciados * FACTOR_CO2_G_KWH:.2f} g CO2eq")
        print("=" * 55)

if __name__ == "__main__":
    main()
