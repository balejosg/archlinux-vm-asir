# Proyecto 1: Smart Campus IoT Sostenible (MQTT + InfluxDB + Grafana)

## 🎯 Objetivo Curricular (ASIR)
Diseñar y desplegar una arquitectura de red ligera y eco-eficiente para monitorizar en tiempo real el consumo eléctrico y la calidad ambiental de las aulas de un centro educativo.

Este proyecto aplica competencias de los módulos:
* **PAR** (Redes): Protocolo MQTT, puertos, subredes virtuales de contenedores, calidad de servicio QoS.
* **SRI** (Servicios): Despliegue de broker Mosquitto y conectividad cliente-servidor.
* **ASGBD** (Bases de datos): Telemetría en InfluxDB (series temporales) y políticas de retención.
* **IAW / SAD** (Aplicaciones Web y Seguridad): Visualización en Grafana con control de accesos.

---

## 🏗️ Arquitectura de la Solución

```mermaid
graph LR
    subgraph Sensores IoT
        S1["Simulador Sensores Aula 101"]
        S2["Simulador Sensores Aula 102"]
        S3["Simulador Laboratorio Redes"]
    end

    subgraph Red Docker Privada (eco_net)
        Broker["Eclipse Mosquitto (Broker MQTT) :1883"]
        DB["InfluxDB v2 (Series Temporales) :8086"]
        Dash["Grafana (Paneles de Control) :3000"]
    end

    subgraph Procesamiento y Alertas
        Alertas["Eco-Controller Python (Reglas de Ahorro y CO2)"]
    end

    S1 -->|Publica telemetría JSON| Broker
    S2 -->|Publica telemetría JSON| Broker
    S3 -->|Publica telemetría JSON| Broker

    Broker -->|Suscripción| Alertas
    Broker -->|Ingesta de métricas| DB
    DB -->|Consultas Flux/InfluxQL| Dash
```

---

## 🚀 Puesta en Marcha en 3 Pasos

### Paso 1: Levantar los contenedores de infraestructura
```bash
docker compose up -d
```
Verifica que los tres contenedores estén en estado saludable:
```bash
docker compose ps
```

### Paso 2: Ejecutar el gestor de alertas eco-eficiente
En una terminal:
```bash
python gestor_alertas_eco.py
```

### Paso 3: Lanzar el simulador de telemetría de sensores
En otra pestaña o terminal:
```bash
python simulador_sensores.py
```

---

## 💡 Retos de Aprendizaje para el Alumno (Explora con tu Asistente IA)
1. **Reducción de consumo de red**: ¿Por qué MQTT con formato JSON o Protocol Buffers genera menos tráfico y huella energética que realizar peticiones HTTP POST continuas?
2. **Seguridad y Sostenibilidad**: Configura autenticación con usuario y contraseña en Mosquitto (`mosquitto_passwd`) y desactiva el acceso anónimo.
3. **Automatización de Ahorro**: Añade una función al script `gestor_alertas_eco.py` que envíe una orden MQTT en el tópico `campus/edificioA/aula101/actuador/luces/set` con valor `OFF` cuando el aula esté desierta.
