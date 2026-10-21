# Arch Linux VM para VirtualBox (Edición Especial ASIR - Green IT & Sostenibilidad)

Máquina virtual oficial de Arch Linux configurada específicamente para el ciclo formativo de **ASIR (Administración de Sistemas Informáticos en Red)**. Diseñada para el desarrollo de **proyectos tecnológicos relacionados con la sostenibilidad, la eficiencia energética y la sensorización ambiental**, integrando un **tutor pedagógico de IA socrático** que orienta al alumno en la resolución de incidencias y buenas prácticas de sistemas sin darle las soluciones hechas.

## 🚀 Enlaces y Descargas
* 🌐 **Página Web / GitHub Pages**: [https://balejosg.github.io/archlinux-vm-asir/](https://balejosg.github.io/archlinux-vm-asir/)
* 📖 **Caso de Estudio (Cómo se hizo con IA)**: [https://balejosg.github.io/archlinux-vm-asir/como-se-hizo.html](https://balejosg.github.io/archlinux-vm-asir/como-se-hizo.html)
* 📦 **Descarga directa (.ova, ~2.1 GB)**: [ArchLinux-ASIR.ova (v1.0.0)](https://github.com/balejosg/archlinux-vm-asir/releases/download/v1.0.0/ArchLinux-ASIR.ova)
  * **Checksum SHA-256**: `9b5f709f2457b1d311ff4f57feb239f28441d4eff9bfb6fce73bde05d36e0bbf`

---

## 🔑 Credenciales y Mapeo de Puertos NAT

| Parámetro | Valor |
| :--- | :--- |
| **Usuario** | `alumno` |
| **Contraseña** | `alumno` |
| **Permisos de Administrador** | `sudo` completo habilitado |
| **Conexión SSH** | Puerto anfitrión `2222` (`ssh -p 2222 alumno@127.0.0.1`) |
| **Servidor Web HTTP** | Puerto anfitrión `8080` (`http://localhost:8080`) |
| **Broker MQTT (Mosquitto)** | Puerto anfitrión `1883` (`localhost:1883`) |
| **Dashboards Grafana** | Puerto anfitrión `3000` (`http://localhost:3000`, `admin`/`admin`) |
| **Base de Datos InfluxDB** | Puerto anfitrión `8086` (`http://localhost:8086`) |
| **Carpeta compartida Host** | Sincronización en caliente en `/home/alumno/trabajo` |
| **Localización y Teclado** | España (`es_ES.UTF-8`, `KEYMAP=es`, zona horaria `Europe/Madrid`) |
| **Guest Additions** | `virtualbox-guest-utils` preinstalado y activo |

---

## 🌿 Entorno Pedagógico ASIR & Sostenibilidad

### 1. Rol "Green SysAdmin" (Tutor Socrático de Sistemas)
Los agentes de IA preinstalados (`agy` y `opencode`) leen las directrices de `AGENTS.md`:
* **Prohibido dar soluciones directas:** No escriben scripts completos ni archivos de configuración hechos si el alumno no ha reflexionado sobre la causa raíz.
* **Diagnóstico Didáctico de Sistemas:** Explican permisos POSIX (`chmod`/`chown`), puertos ocupados, aislamiento de redes virtuales en Docker y errores en units de `systemd`.
* **Criterio de Sostenibilidad (Green IT):** Hacen reflexionar sobre bucles inútiles (*busy-waiting*) que queman vatios inútilmente, el sobredimensionamiento de imágenes de Docker y el cálculo cuantitativo de la huella de carbono digital en gramos de CO2eq.

### 2. Catálogo de Proyectos Prácticos Incluidos
Dentro de `~/trabajo/plantillas-sostenibilidad/` se incluyen tres proyectos listos para desplegar:
* `01-smart-campus-iot-mqtt`: Broker Mosquitto, InfluxDB v2, Grafana y emulador de sensores en Python para medir CO2, temperatura y derroche de iluminación en aulas.
* `02-green-metrics-scaphandre`: Herramienta de auditoría para medir en tiempo real Vatios, Joules y huella de carbono según el mix eléctrico de España.
* `03-auto-power-management`: Script y servicios de `systemd` (`.service` y `.timer`) para gobernar frecuencias de CPU con `cpupower` y aplicar políticas de ahorro nocturno.

### 3. Estructura de Contexto en `~/trabajo`
```text
~/trabajo/
├── proyectos/                     <-- Proyectos propios de los alumnos (editables con VS Code en el host)
├── plantillas-sostenibilidad/     <-- Ejemplos funcionales de Green IT y telemetría
│   ├── 01-smart-campus-iot-mqtt/
│   ├── 02-green-metrics-scaphandre/
│   └── 03-auto-power-management/
├── apuntes/                       <-- Guías docentes y apuntes del módulo
├── CRITERIOS_EVALUACION.md        <-- Rúbricas docentes de sistemas y sostenibilidad
├── AGENTS.md                      <-- Reglas del rol socrático del agente
└── LEEME.txt                      <-- Chuleta de ayuda rápida para el alumno
```

---

## 📁 Cómo vincular tu carpeta local de trabajo

1. En VirtualBox: **Dispositivos ➡️ Carpetas compartidas ➡️ Preferencias...**
2. Añade (+) la carpeta de tu ordenador real donde guardas tus proyectos.
3. Nombre de la carpeta: **`trabajo`**
4. Marca: **Automontar** y **Hacer permanente**.
5. Al arrancar la VM se montará sola en `~/trabajo` (o escribe `montar-trabajo` en la terminal).

---

## 💡 ¿Cómo reproducir o modificar este entorno?

Toda la infraestructura y los scripts de aprovisionamiento están incluidos en la carpeta `scripts/`:
* `scripts/crear-vm-asir.sh`: Script para automatizar la descarga de la imagen base de Arch Linux, creación del disco VDI y registro de hardware en VirtualBox.
* `scripts/provision-asir-sostenible.sh`: Script de aprovisionamiento interno del sistema.

Para interactuar con el agente en tu máquina Linux:
* **Antigravity CLI**: `paru -S antigravity-cli` y ejecuta `agy`.
* **OpenCode (100% Libre y Gratuito)**: `curl -fsSL https://opencode.ai/install | bash` y ejecuta `opencode`.
