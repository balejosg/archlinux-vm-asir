# Proyecto 3: Automatización de Políticas de Ahorro Energético con systemd

## 🎯 Objetivo Curricular (ASIR)
Aprender a programar e implantar políticas del sistema operativo (**ISO**) para maximizar la eficiencia energética de servidores corporativos y laboratorios docentes mediante `cpupower`, `bash` y unidades de `systemd` (`.service` y `.timer`).

---

## ⚙️ Conceptos Clave
* **Gobernadores de Frecuencia (CPU Governors)**:
  * `powersave`: Fija la frecuencia mínima del procesador para consumir la menor potencia posible.
  * `performance`: Fija la frecuencia máxima para tareas críticas sin importar el gasto energético.
  * `schedutil` / `ondemand`: Ajusta dinámicamente los hercios según la carga real instantánea.
* **Procesos Zombie / Bucles Inútiles**:
  * Un proceso descontrolado con un 100% de CPU constante impide que el núcleo baje a estados de reposo (*C-States*), provocando calentamiento y acortando la vida útil del hardware.

---

## 🚀 Cómo instalar y activar el temporizador en la VM

### 1. Probar el script manualmente
```bash
./eco-power-manager.sh
cat /tmp/eco-power.log
```

### 2. Registrar el servicio y el timer en systemd
```bash
sudo cp eco-power-manager.service /etc/systemd/system/
sudo cp eco-power-manager.timer /etc/systemd/system/
sudo systemctl daemon-reload
```

### 3. Habilitar e iniciar el temporizador
```bash
sudo systemctl enable --now eco-power-manager.timer
```

### 4. Comprobar su funcionamiento
```bash
# Ver cuándo será la próxima ejecución:
systemctl list-timers --all | grep eco-power

# Ver los logs en el diario del sistema:
journalctl -u eco-power-manager.service -e
```

---

## 💡 Preguntas para explorar con tu Asistente IA
1. ¿Cuál es la diferencia entre programar una tarea con `cron` y programarla con un `systemd.timer` con la directiva `Persistent=true`?
2. Si un servidor en la nube te cobra por horas de uso de CPU o necesitas reducir la huella de carbono del centro escolar, ¿cómo planificarías el encendido y apagado de contenedores Docker mediante scripts similares?
