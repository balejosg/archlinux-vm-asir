#!/usr/bin/env python3
"""
Simulador de Sensores Ambientales y Energéticos (Smart Campus Sostenible)
ASIR - Proyecto Green IT & IoT
"""

import time
import json
import random
import sys

try:
    import paho.mqtt.client as mqtt
except ImportError:
    print("❌ Error: falta la librería 'paho-mqtt'. Instálala con:")
    print("   sudo pacman -S python-paho-mqtt (o pip install paho-mqtt)")
    sys.exit(1)

BROKER_HOST = "localhost"
BROKER_PORT = 1883
TOPIC_BASE = "campus/edificioA"

AULAS = ["aula101", "aula102", "laboratorio_redes"]

def generar_datos_aula(aula):
    """Simula métricas ambientales y de consumo eléctrico."""
    # Presencia simulada
    hay_alumnos = random.choice([True, True, False])
    
    # Nivel de CO2 en ppm (partes por millón): >1000 requiere ventilación
    co2 = random.randint(750, 1350) if hay_alumnos else random.randint(400, 550)
    
    # Temperatura y humedad
    temperatura = round(random.uniform(20.5, 24.8), 1)
    humedad = round(random.uniform(42.0, 58.0), 1)
    
    # Consumo eléctrico de iluminación y puestos (en Vatios)
    potencia_luces_w = 120 if hay_alumnos else random.choice([0, 120]) # Posible desperdicio si no hay nadie
    potencia_equipos_w = round(random.uniform(250.0, 680.0), 1) if hay_alumnos else 15.0 # Standby

    return {
        "timestamp": int(time.time()),
        "aula": aula,
        "presencia": hay_alumnos,
        "co2_ppm": co2,
        "temperatura_c": temperatura,
        "humedad_pct": humedad,
        "potencia_luces_w": potencia_luces_w,
        "potencia_equipos_w": potencia_equipos_w,
        "potencia_total_w": round(potencia_luces_w + potencia_equipos_w, 1)
    }

def main():
    print("🌿 Iniciando Emulador de Telemetría IoT Sostenible (ASIR)...")
    print(f"📡 Conectando a Mosquitto en {BROKER_HOST}:{BROKER_PORT}...")

    client = mqtt.Client(client_id="eco-sensor-simulator")

    try:
        client.connect(BROKER_HOST, BROKER_PORT, keepalive=60)
        client.loop_start()
        print("✓ Conexión establecida. Publicando telemetría cada 4 segundos...")
        print("  Presiona Ctrl+C para detener.\n")
    except Exception as e:
        print(f"❌ Error al conectar con el broker MQTT: {e}")
        print("  Verifica que el servicio esté activo: 'docker compose up -d mosquitto'")
        sys.exit(1)

    try:
        while True:
            for aula in AULAS:
                datos = generar_datos_aula(aula)
                topic = f"{TOPIC_BASE}/{aula}/telemetria"
                payload = json.dumps(datos)
                client.publish(topic, payload, qos=0)
                
                estado = "🟢 NORMAL"
                if datos["co2_ppm"] > 1000:
                    estado = "🟡 CO2 ALTO (Ventilar)"
                if not datos["presencia"] and datos["potencia_luces_w"] > 0:
                    estado = "🔴 DESPERDICIO ENERGÉTICO (Luces encendidas sin gente)"

                print(f"[{time.strftime('%H:%M:%S')}] {aula:18} | Potencia: {datos['potencia_total_w']:5.1f} W | CO2: {datos['co2_ppm']:4} ppm | {estado}")
            
            print("-" * 75)
            time.sleep(4)
    except KeyboardInterrupt:
        print("\n🛑 Simulador detenido por el usuario.")
    finally:
        client.loop_stop()
        client.disconnect()

if __name__ == "__main__":
    main()
