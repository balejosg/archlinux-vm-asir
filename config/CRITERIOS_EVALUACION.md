# RÚBRICA Y CRITERIOS DE EVALUACIÓN: PROYECTOS TECNOLÓGICOS Y SOSTENIBILIDAD (ASIR)

Este documento establece los criterios docentes de evaluación para los proyectos tecnológicos y de infraestructura orientados a la sostenibilidad desarrollados por los alumnos del Ciclo Formativo de Grado Superior en **Administración de Sistemas Informáticos en Red (ASIR)**.

Los agentes de IA consultan este archivo para evaluar el progreso del alumno, sugerir mejoras arquitectónicas y validar el cumplimiento de las buenas prácticas.

---

## 🎯 RESUMEN DE DIMENSIONES EVALUATIVAS

| Dimensión | Ponderación | Aspecto Clave |
| :--- | :---: | :--- |
| **1. Eficiencia Energética y Eco-Diseño (Green IT)** | **25%** | Medición de consumo (W / Joules / gCO2eq), optimización de CPU/RAM y prevención de cargas inútiles. |
| **2. Arquitectura de Red y Protocolos IoT** | **25%** | Elección adecuada de protocolos (MQTT vs HTTP), segmentación de subredes y seguridad en comunicaciones. |
| **3. Contenerización y Servicios (Docker)** | **20%** | Despliegue con Docker Compose, imágenes ligeras, límites de recursos (`cpus`, `memory`) y persistencia. |
| **4. Automatización y Scripting de Sistemas** | **15%** | Scripts limpios (Bash/Python), control de errores, modularidad y automatización mediante `systemd timers` o cron. |
| **5. Monitorización, Telemetría y Documentación** | **15%** | Dashboards visuales de métricas (Grafana), logs estructurados, justificación ambiental y memoria técnica. |

---

## 📋 CRITERIOS DETALLADOS POR DIMENSIÓN

### 1. Eficiencia Energética y Eco-Diseño de Sistemas (Green IT) — 25%
* **Nivel Excelente (4 pts):**
  - El proyecto incluye mediciones cuantitativas reales o estimadas de energía (Vatios, consumo de CPU con `powertop`, `cpupower` o telemetría de `scaphandre`).
  - Se implementan políticas activas de ahorro energético (gobernadores de CPU dinámicos, desconexión de servicios inactivos en horario no lectivo).
  - El código de recolección de datos evita loops de sondeo agresivos (*busy waiting*), empleando patrones reactivos o tiempos de suspensión razonables.
* **Nivel Aceptable (2-3 pts):**
  - Se reconoce la importancia del consumo energético pero las mediciones son cualitativas o genéricas. Hay noción de eco-eficiencia en el dimensionamiento de recursos.
* **Nivel Insuficiente (0-1 pts):**
  - Procesos ineficientes con consumo descontrolado de CPU sin justificación, bucles sin temporizador, o ausencia total de métricas de impacto ambiental.

### 2. Arquitectura de Red y Protocolos IoT Sostenibles — 25%
* **Nivel Excelente (4 pts):**
  - Uso justificado de protocolos ligeros (MQTT con broker Mosquitto, tópicos semánticamente organizados, calidad de servicio QoS adecuada).
  - Segmentación de redes privadas virtuales en Docker (`internal networks`) para aislar bases de datos y servicios backend del acceso público.
  - Gestión correcta de direccionamiento, mapeo de puertos y reglas de firewall.
* **Nivel Aceptable (2-3 pts):**
  - Protocolos funcionales pero poco optimizados en sobrecarga de cabeceras (ej. uso excesivo de peticiones HTTP REST síncronas para sensores frecuentes).
* **Nivel Insuficiente (0-1 pts):**
  - Topología plana sin aislamiento de red, puertos expuestos innecesariamente al host, o problemas de enrutamiento no resueltos.

### 3. Contenerización y Servicios (Docker & Compose) — 20%
* **Nivel Excelente (4 pts):**
  - Archivo `docker-compose.yml` declarativo, limpio y reproducible sin requerir pasos manuales en el host.
  - Uso de imágenes base compactas y eficientes (ej. `alpine`, `distroless` o imágenes oficiales oficiales específicas de versión).
  - Definición explícita de límites de recursos (`deploy.resources.limits.cpus`, `memory`) para evitar colapso del sistema anfitrión.
  - Persistencia de datos en volúmenes nombrados o carpetas montadas con permisos de usuario adecuados (no ejecución como `root` arbitrario).
* **Nivel Aceptable (2-3 pts):**
  - Contenedores funcionales pero con imágenes sobredimensionadas o sin limitación de recursos.
* **Nivel Insuficiente (0-1 pts):**
  - Fallos al levantar los servicios con `docker compose up`, datos efímeros sin volúmenes persistentes o credenciales expuestas en texto plano sin variables de entorno.

### 4. Automatización y Scripting de Sistemas (Bash / Python) — 15%
* **Nivel Excelente (4 pts):**
  - Scripts modulares, comentados y con control de código de retorno (`set -euo pipefail` en Bash, excepciones controladas en Python).
  - Integración nativa con `systemd` (servicios y temporizadores `.timer`) para ejecución desatendida y recuperación ante caídas (`Restart=on-failure`).
  - Parámetros configurables mediante variables de entorno o archivos de configuración `.env`.
* **Nivel Aceptable (2-3 pts):**
  - Scripts funcionales pero monolíticos, con dependencias fijadas a rutas absolutas rígidas.
* **Nivel Insuficiente (0-1 pts):**
  - Errores de ejecución en tiempo de arranque, ausencia de control de errores o necesidad de intervención manual constante.

### 5. Monitorización, Telemetría y Documentación Técnica — 15%
* **Nivel Excelente (4 pts):**
  - Panel visual intuitivo (Grafana / Web) que expone el estado de los indicadores de sostenibilidad (temperatura, CO2, consumo eléctrico, estado de nodos).
  - `README.md` del proyecto con arquitectura ilustrada (diagramas), requisitos, comandos de despliegue en un clic e interpretación del impacto ecológico conseguido.
  - Justificación clara del cálculo de huella de carbono evitada o recursos optimizados.
* **Nivel Aceptable (2-3 pts):**
  - Documentación básica funcional pero parca en explicación de impacto o con gráficos difíciles de interpretar.
* **Nivel Insuficiente (0-1 pts):**
  - Ausencia de documentación, sin explicación del funcionamiento ni conclusiones pedagógicas.
