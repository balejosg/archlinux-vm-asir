# Proyecto 2: Auditoría Energética y Huella de Carbono Digital

## 🎯 Objetivo Curricular (ASIR)
Aprender a medir, auditar y minimizar el consumo eléctrico (Vatios, Joules) y la huella de carbono digital (gCO2eq) de los servidores y servicios web bajo administración de sistemas.

Módulos involucrados:
* **ISO**: Diagnóstico de procesos con `psutil`, `powertop` y telemetría RAPL del procesador.
* **SRI**: Configuración eco-diseñada de servidores web (Nginx) y compresión HTTP.
* **SAD**: Monitorización preventiva de sobrecalentamiento y saturación de recursos.

---

## 🔬 Fundamento Técnico: Green IT en Centros de Datos
Un servidor no solo cuesta dinero en electricidad; el cómputo genera calor y demanda refrigeración. Los administradores de sistemas en empresas modernas (especialmente con las normativas europeas CSRD de sostenibilidad) deben auditar el impacto ambiental de sus infraestructuras TI.

En Linux existen interfaces de hardware como **RAPL** (*Running Average Power Limit*) accesibles en `/sys/class/powercap/intel-rapl/` y herramientas como **Scaphandre** y **PowerTOP**.

---

## 🚀 Cómo ejecutar la práctica

### 1. Levantar el servidor web eco-diseñado
```bash
docker compose up -d
```
Accede al servidor desde tu navegador host en: `http://localhost:8080`

### 2. Iniciar la calculadora de consumo en tiempo real
En una terminal:
```bash
python calculadora_huella_carbono.py
```
Observa los valores en reposo (Idle).

### 3. Simular un pico de cómputo ineficiente
En otra terminal, corre:
```bash
./test_carga_eco.sh
```
Fíjate en cómo la potencia salta de ~12W a más de 50W instantáneamente y cómo la emisión acumulada de CO2 se acelera.

---

## 💡 Preguntas para explorar con tu Asistente IA
1. ¿Qué directivas de Nginx ayudan a reducir el consumo de CPU y ancho de banda al servir contenido estático?
2. Si un script de copias de seguridad se ejecuta de noche, ¿es mejor que consuma el 100% de CPU durante 10 minutos o el 25% durante 40 minutos en términos de estrés térmico y consumo energético?
3. ¿Cómo influye el mix energético (hora solar vs noche) en las emisiones de CO2 de un centro de datos en España?
