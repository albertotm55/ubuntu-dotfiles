Aquí tienes la guía completa en formato Markdown. Puedes copiar este contenido y guardarlo como **`README.md`** dentro de tu carpeta `~/Documents/dotfiles/`.

Así siempre tendrás las instrucciones a mano en tu propio repositorio.

---

```markdown
# 🛠️ Guía de Uso y Mantenimiento: Dotfiles & Ansible

Este repositorio gestiona la configuración de mi sistema (Pop!_OS 24.04), aplicaciones y entorno visual (GNOME). El objetivo es tener un sistema **declarativo**: en lugar de instalar cosas manualmente, las definimos aquí y dejamos que el sistema se configure solo.

## 📂 Estructura de Carpetas

Todo debe vivir en `~/Documents/dotfiles/`:

```text
~/Documents/dotfiles/
├── Makefile              # Centro de control (Comandos rápidos)
├── ansible/
│   ├── inventory.ini     # Define dónde se ejecuta (localhost)
│   └── main.yml          # Lista de programas y tareas a instalar
├── docker/               # Tus servicios dockerizados
│   └── [nombre-servicio]/docker-compose.yml
└── gnome/
    └── backup/
        └── settings.dconf # Copia de seguridad visual (Atajos, Dock, Tema)

```

---

## 🚀 Instalación Inicial (Nuevo PC)

Si acabas de clonar esto en un ordenador nuevo o recién formateado:

1. Abre la terminal en esta carpeta.
2. Instala las dependencias iniciales:
```bash
make init

```


3. Aplica toda la configuración (Instalará programas y restaurará GNOME):
```bash
make apply

```


4. Reinicia el ordenador para asegurar que los cambios de usuario (grupos docker, etc.) surtan efecto.

---

## ⚡ Flujo de Trabajo Diario

### 1. Instalar un nuevo programa (Vía APT)

No uses `sudo apt install` directamente. Para que el programa persista tras un formateo:

1. Edita el archivo `ansible/main.yml`.
2. Busca la sección `apt:` y añade el nombre del paquete a la lista.
3. Ejecuta:
```bash
make apply

```



### 2. Guardar cambios visuales (GNOME)

Si has cambiado el fondo de pantalla, movido el Dock, o configurado atajos de teclado nuevos y quieres guardarlos:

1. Abre la terminal en esta carpeta.
2. Ejecuta:
```bash
make backup

```


*(Esto actualiza el archivo `gnome/backup/settings.dconf`).*

### 3. Añadir un servicio Docker

1. Crea la carpeta: `mkdir docker/mi-servicio`.
2. Pon tu `docker-compose.yml` dentro.
3. (Opcional) Si quieres que Ansible lo levante automáticamente, añádelo a la lista `loop` en `main.yml`.
4. Ejecuta:
```bash
make apply

```



### 4. Mantenimiento Total

Para asegurarte de que todo está sincronizado (guardar tus cambios visuales Y aplicar nuevas configuraciones de código a la vez):

```bash
make update

```

---

## 📄 El Makefile Maestro

Este archivo automatiza los comandos largos. Asegúrate de tener un archivo llamado `Makefile` en la raíz con este contenido:

```makefile
# --- RUTAS ---
DOTFILES_DIR := $(shell pwd)
ANSIBLE_DIR := $(DOTFILES_DIR)/ansible
BACKUP_DIR := $(DOTFILES_DIR)/gnome/backup
BACKUP_FILE := $(BACKUP_DIR)/settings.dconf

# --- COMANDOS ---
.PHONY: help install apply backup init

help: ## Muestra los comandos disponibles
	@echo "🛠️  Gestor de Dotfiles - Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

init: ## Instala dependencias iniciales (Ansible Docker collection)
	@echo "📦 Instalando colección de Docker para Ansible..."
	ansible-galaxy collection install community.docker
	@echo "✅ Listo."

apply: ## Aplica la configuración (Instala programas, configura GNOME)
	@echo "🚀 Aplicando configuración con Ansible..."
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini main.yml -K

backup: ## Guarda la configuración visual actual de GNOME
	@echo "💾 Guardando configuración de GNOME..."
	@mkdir -p $(BACKUP_DIR)
	dconf dump / > $(BACKUP_FILE)
	@echo "✅ Backup guardado en: $(BACKUP_FILE)"

update: backup apply ## Combo: Guarda visual primero, luego aplica cambios de código
	@echo "🔄 Sincronización completa..."

```

---

## ⚠️ Notas Importantes para Pop!_OS 24.04

* **Entorno Gráfico:** Recuerda que para jugar (NVIDIA), debes seleccionar **"GNOME on Xorg"** en el engranaje de la pantalla de inicio de sesión.
* **Extensiones:** Ansible instala el *Gestor de Extensiones*, pero extensiones específicas como **Dash to Dock** es mejor instalarlas/activarlas manualmente desde la app "Extension Manager" tras el primer reinicio para evitar conflictos de versiones.

```

```
