#!/bin/bash

# Script para verificar informações da bateria no Termux, em tempo real, com configurações
# Autor: t.me/niiquel

# Verifica se o Termux tem permissões root
if [ "$(id -u)" != "0" ]; then
    echo "Este script precisa de permissões root para acessar dados completos da bateria."
    echo "Execute com 'su' ou como root. Algumas opções podem funcionar sem root."
    sleep 2
fi

# Arquivo de configuração
CONFIG_FILE="$HOME/.battery_monitor_config"

# Carrega configurações ou define padrão
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    UPDATE_INTERVAL=1
fi

# Caminhos comuns para informações da bateria
BATTERY_PATH="/sys/class/power_supply/battery"
CHARGE_FULL_DESIGN_FILE="$BATTERY_PATH/charge_full_design"
CHARGE_FULL_FILE="$BATTERY_PATH/charge_full"
CHARGE_NOW_FILE="$BATTERY_PATH/charge_now"
VOLTAGE_FILE="$BATTERY_PATH/voltage_now"
CURRENT_FILE="$BATTERY_PATH/current_now"
STATUS_FILE="$BATTERY_PATH/status"
TEMP_FILE="$BATTERY_PATH/temp"
CYCLE_COUNT_FILE="$BATTERY_PATH/cycle_count"

# Função para verificar a vida útil da bateria
check_battery_health() {
    if [ -f "$CHARGE_FULL_DESIGN_FILE" ] && [ -f "$CHARGE_FULL_FILE" ]; then
        CHARGE_FULL_DESIGN=$(cat "$CHARGE_FULL_DESIGN_FILE")
        CHARGE_FULL=$(cat "$CHARGE_FULL_FILE")
        if [ -n "$CHARGE_FULL_DESIGN" ] && [ -n "$CHARGE_FULL" ] && [ "$CHARGE_FULL_DESIGN" -ne 0 ]; then
            BATTERY_HEALTH=$(echo "scale=2; ($CHARGE_FULL * 100) / $CHARGE_FULL_DESIGN" | bc)
            echo "Vida útil da bateria: $BATTERY_HEALTH%"
        else
            echo "Erro: Dados de vida útil inválidos ou não disponíveis."
        fi
    else
        echo "Erro: Arquivos de vida útil da bateria não encontrados."
    fi
}

# Função para verificar a porcentagem atual da bateria
check_battery_percentage() {
    if [ -f "$CHARGE_FULL_FILE" ] && [ -f "$CHARGE_NOW_FILE" ]; then
        CHARGE_FULL=$(cat "$CHARGE_FULL_FILE")
        CHARGE_NOW=$(cat "$CHARGE_NOW_FILE")
        if [ -n "$CHARGE_FULL" ] && [ -n "$CHARGE_NOW" ] && [ "$CHARGE_FULL" -ne 0 ]; then
            PERCENTAGE=$(echo "scale=2; ($CHARGE_NOW * 100) / $CHARGE_FULL" | bc)
            echo "Porcentagem atual da bateria: $PERCENTAGE%"
        else
            echo "Erro: Dados de porcentagem inválidos ou não disponíveis."
        fi
    else
        # Tenta usar dumpsys como alternativa (não precisa de root)
        if command -v dumpsys >/dev/null 2>&1; then
            PERCENTAGE=$(dumpsys battery | grep level | awk '{print $2}')
            if [ -n "$PERCENTAGE" ]; then
                echo "Porcentagem atual da bateria: $PERCENTAGE%"
            else
                echo "Erro: Não foi possível obter a porcentagem da bateria."
            fi
        else
            echo "Erro: Arquivos de porcentagem não encontrados e dumpsys não disponível."
        fi
    fi
}

# Função para verificar voltagem
check_voltage() {
    if [ -f "$VOLTAGE_FILE" ]; then
        VOLTAGE=$(cat "$VOLTAGE_FILE")
        if [ -n "$VOLTAGE" ]; then
            VOLTAGE_MV=$(echo "scale=2; $VOLTAGE / 1000" | bc)
            echo "Voltagem da bateria: $VOLTAGE_MV mV"
        else
            echo "Erro: Dados de voltagem inválidos."
        fi
    else
        echo "Erro: Arquivo de voltagem não encontrado."
    fi
}

# Função para verificar corrente
check_current() {
    if [ -f "$CURRENT_FILE" ]; then
        CURRENT=$(cat "$CURRENT_FILE")
        if [ -n "$CURRENT" ]; then
            CURRENT_MA=$(echo "scale=2; $CURRENT / 1000" | bc)
            echo "Corrente da bateria: $CURRENT_MA mA"
        else
            echo "Erro: Dados de corrente inválidos."
        fi
    else
        echo "Erro: Arquivo de corrente não encontrado."
    fi
}

# Função para verificar temperatura
check_temperature() {
    if [ -f "$TEMP_FILE" ]; then
        TEMP=$(cat "$TEMP_FILE")
        if [ -n "$TEMP" ]; then
            TEMP_C=$(echo "scale=1; $TEMP / 10" | bc)
            echo "Temperatura da bateria: $TEMP_C °C"
        else
            echo "Erro: Dados de temperatura inválidos."
        fi
    else
        echo "Erro: Arquivo de temperatura não encontrado."
    fi
}

# Função para verificar status
check_status() {
    if [ -f "$STATUS_FILE" ]; then
        STATUS=$(cat "$STATUS_FILE")
        echo "Status da bateria: $STATUS"
    else
        echo "Erro: Arquivo de status não encontrado."
    fi
}

# Função para verificar ciclos de carga
check_cycle_count() {
    if [ -f "$CYCLE_COUNT_FILE" ]; then
        CYCLE_COUNT=$(cat "$CYCLE_COUNT_FILE")
        if [ -n "$CYCLE_COUNT" ]; then
            echo "Ciclos de carga: $CYCLE_COUNT"
        else
            echo "Erro: Dados de ciclos de carga inválidos."
        fi
    else
        echo "Erro: Arquivo de ciclos de carga não encontrado. Seu dispositivo pode não suportar."
    fi
}

# Função para mostrar todas as informações
show_all_info() {
    echo "=== Informações Completas da Bateria ==="
    check_battery_health
    check_battery_percentage
    check_voltage
    check_current
    check_temperature
    check_status
    check_cycle_count
    echo "======================================"
}

# Função para exibir dados em tempo real
display_realtime() {
    local func=$1
    local title=$2
    while true; do
        clear
        echo "=== $title (Atualizando a cada $UPDATE_INTERVAL segundo) ==="
        echo "Pressione 'q' para voltar ao menu principal."
        echo
        $func
        echo
        echo "Última atualização: $(date '+%H:%M:%S')"
        # Lê entrada do usuário sem bloquear
        read -t $UPDATE_INTERVAL -n 1 -s key
        if [ "$key" = "q" ]; then
            break
        fi
    done
}

# Função para a opção Ajuda (Telegram)
show_help() {
    echo "Gostaria de abrir o grupo do Telegram (@niiquell) para mais ajuda?"
    echo -n "Digite 's' para Sim ou 'n' para Não: "
    read telegram_choice
    case $telegram_choice in
        [Ss]*)
            echo "Abrindo grupo no Telegram: https://t.me/niiquell"
            termux-open-url "https://t.me/niiquell"
            echo -n "Pressione Enter para continuar..."
            read
            ;;
        [Nn]*)
            echo "Retornando ao menu principal..."
            sleep 1
            ;;
        *)
            echo "Opção inválida. Retornando ao menu principal..."
            sleep 1
            ;;
    esac
}

# Função para configurar opções
configure_settings() {
    clear
    echo "=== Configurações ==="
    echo "Tempo de atualização atual: $UPDATE_INTERVAL segundos"
    echo -n "Digite o novo tempo de atualização (em segundos, mínimo 0.1) ou pressione Enter para manter: "
    read new_interval
    if [ -n "$new_interval" ]; then
        # Verifica se é um número válido e maior que 0.1
        if echo "$new_interval" | grep -qE '^[0-9]+(\.[0-9]+)?$' && [ "$(echo "$new_interval >= 0.1" | bc)" -eq 1 ]; then
            UPDATE_INTERVAL="$new_interval"
            # Salva no arquivo de configuração
            echo "UPDATE_INTERVAL=$UPDATE_INTERVAL" > "$CONFIG_FILE"
            echo "Tempo de atualização alterado para $UPDATE_INTERVAL segundos."
        else
            echo "Erro: Digite um número válido maior ou igual a 0.1."
        fi
    else
        echo "Tempo de atualização não alterado."
    fi
    echo -n "Pressione Enter para continuar..."
    read
}

# Menu principal
while true; do
    clear
    echo "=== Monitor de Bateria para Termux ==="
    echo "Selecione uma opção:"
    echo "1. Ver vida útil da bateria (%)"
    echo "2. Ver porcentagem atual da bateria"
    echo "3. Ver voltagem da bateria"
    echo "4. Ver corrente da bateria"
    echo "5. Ver temperatura da bateria"
    echo "6. Ver status da bateria"
    echo "7. Ver ciclos de carga"
    echo "8. Mostrar todas as informações"
    echo "9. Ajuda"
    echo "c. Configurar"
    echo "0. Sair"
    echo -n "Digite sua escolha: "
    read choice

    case $choice in
        1)
            display_realtime check_battery_health "Vida Útil da Bateria"
            ;;
        2)
            display_realtime check_battery_percentage "Porcentagem Atual da Bateria"
            ;;
        3)
            display_realtime check_voltage "Voltagem da Bateria"
            ;;
        4)
            display_realtime check_current "Corrente da Bateria"
            ;;
        5)
            display_realtime check_temperature "Temperatura da Bateria"
            ;;
        6)
            display_realtime check_status "Status da Bateria"
            ;;
        7)
            display_realtime check_cycle_count "Ciclos de Carga"
            ;;
        8)
            display_realtime show_all_info "Informações Completas da Bateria"
            ;;
        9)
            show_help
            ;;
        c|C)
            configure_settings
            ;;
        0)
            echo "Saindo do script. Até mais!"
            exit 0
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            sleep 2
            ;;
    esac
done
