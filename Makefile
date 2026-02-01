# --- RUTAS ---
# Ajustadas a tu estructura en ~/Documents/dotfiles
DOTFILES_DIR := $(shell pwd)
ANSIBLE_DIR := $(DOTFILES_DIR)/ansible
BACKUP_DIR := $(DOTFILES_DIR)/gnome/backup
BACKUP_FILE := $(BACKUP_DIR)/settings.dconf

# --- COMANDOS ---
.PHONY: help install apply backup init

help: ## Muestra esta ayuda
	@echo "🛠️  Gestor de Dotfiles - Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

init: ## Instala dependencias iniciales (Ansible Docker collection)
	@echo "📦 Instalando colección de Docker para Ansible..."
	ansible-galaxy collection install community.docker
	@echo "✅ Listo."

apply: ## Aplica los cambios (Instala programas, configura GNOME)
	@echo "🚀 Aplicando configuración con Ansible..."
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini main.yml -K

backup: ## Guarda la configuración actual de GNOME (Visual, atajos, dock)
	@echo "💾 Guardando configuración de GNOME..."
	@mkdir -p $(BACKUP_DIR)
	dconf dump / > $(BACKUP_FILE)
	@echo "✅ Backup guardado en: $(BACKUP_FILE)"

update: backup apply ## Combo: Guarda cambios visuales primero, luego aplica Ansible
	@echo "🔄 Sincronización completa (Backup + Apply)..."