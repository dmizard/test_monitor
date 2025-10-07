#!/bin/bash

SERVICE_NAME="monitoring.service"
LOG_FILE="/var/log/monitoring.log"

log_activation() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ACTIVATOR: $1" >> "$LOG_FILE"
}

wait_for_network() {
    log_activation "Ожидание сети..."
    until ping -c 1 -W 1 8.8.8.8 &>/dev/null; do
        sleep 2
    done
    log_activation "Сеть доступна"
}

activate_service() {
    log_activation "Активация сервиса $SERVICE_NAME"
    
    if ! systemctl is-enabled "$SERVICE_NAME" &>/dev/null; then
        systemctl enable "$SERVICE_NAME"
        log_activation "Сервис добавлен в автозагрузку"
    fi
}

main() {
    log_activation "=== Запуск активатора ==="
    
    wait_for_network
    
    if activate_service; then
        log_activation "Активатор завершил работу успешно"
    else
        log_activation "Активатор завершил работу с ошибками"
        exit 1
    fi
}

main
