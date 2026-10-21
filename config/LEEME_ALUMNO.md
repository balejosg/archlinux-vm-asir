# GUÍA RÁPIDA PARA EL ALUMNO (ASIR - GREEN IT EDITION)

¡Bienvenido a tu entorno de laboratorio de **Arch Linux** para proyectos de **Sistemas, Redes y Sostenibilidad Tecnológica**!

Esta máquina virtual incluye las herramientas necesarias para diseñar, monitorizar y desplegar infraestructuras eco-eficientes.

---

## 🔑 CREDENCIALES DE ACCESO

* **Usuario:** `alumno`
* **Contraseña:** `alumno`
* **Privilegios de Administrador:** `sudo <comando>` (usa la contraseña `alumno`).
* **Conexión SSH desde tu PC anfitrión:**
  ```bash
  ssh -p 2222 alumno@127.0.0.1
  ```

---

## 📁 CARPETA COMPARTIDA CON EL ANFITRIÓN (`~/trabajo`)

Para editar tus scripts o configuraciones cómodamente con VS Code en tu equipo real:
1. En el menú de VirtualBox: **Dispositivos ➡️ Carpetas compartidas ➡️ Preferencias...**
2. Añade tu carpeta local, dale de nombre exactamente: `trabajo`
3. Marca: **Automontar** y **Hacer permanente**.
4. En la consola de la VM escribe:
   ```bash
   montar-trabajo
   ```
   Tus archivos estarán sincronizados en tiempo real dentro de `/home/alumno/trabajo/`.

---

## 🚀 HERRAMIENTAS PREINSTALADAS

### 1. Gestión de Contenedores y Servicios
* `docker` y `docker compose` (tu usuario ya pertenece al grupo docker; no necesitas `sudo` para correr `docker ps`).
* Comandos útiles:
  ```bash
  docker compose up -d
  docker compose ps
  docker stats --no-stream
  ```

### 2. Mensajería IoT y Telemetría
* Broker **Eclipse Mosquitto** (puerto `1883` en la VM y expuesto en el host).
* Comandos de prueba rápida:
  ```bash
  # Suscribirse a los datos de telemetría de un sensor:
  mosquitto_sub -h localhost -t "campus/#" -v

  # Publicar una métrica de prueba:
  mosquitto_pub -h localhost -t "campus/sensor1/co2" -m "450"
  ```

### 3. Diagnóstico Energético y Green IT
* `powertop`: Diagnóstico de consumo y afinamiento energético (`sudo powertop`).
* `cpupower`: Consulta y cambio de perfiles del procesador (`sudo cpupower frequency-info`).
* `glances`: Monitor de sistema interactivo con exportación de métricas.

### 4. Agentes de Inteligencia Artificial
* **Antigravity CLI**: `agy` (para sesiones agénticas avanzadas).
* **OpenCode CLI**: `opencode` (alternativa 100% abierta y gratuita).
* **Tutor Socrático**: Ambos agentes están instruidos para ayudarte a pensar la arquitectura de red y la eficiencia de tus sistemas sin darte la solución en bandeja.
