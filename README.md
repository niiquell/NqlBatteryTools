# Niquel Battery Tools

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Android%20(Termux)-green.svg)

**Niquel Battery Tools** é um script Bash para o Termux, permitindo que usuários de dispositivos Android monitorem informações detalhadas da bateria em tempo real. O script oferece métricas como vida útil da bateria, porcentagem atual, voltagem, corrente, temperatura, status, ciclos de carga, e mais. Ele também inclui opções de configuração e integração com um grupo do Telegram para suporte.

## Funcionalidades

- **Monitoramento em tempo real**: Atualiza dados da bateria dinamicamente (ex.: status muda de "Discharging" para "Charging" ao conectar o carregador).
- **Métricas detalhadas**:
  - Vida útil da bateria (% em relação à capacidade original).
  - Porcentagem atual da carga.
  - Voltagem (mV), corrente (mA), temperatura (°C), status (Charging/Discharging), e ciclos de carga.
  - Exibição de todas as informações em uma única tela.
- **Configuração personalizável**: Ajuste o intervalo de atualização (mínimo 0.1s) com persistência em um arquivo de configuração.
- **Integração com Telegram**: Opção "Ajuda" para abrir o grupo do Telegram ([@niiquell](https://t.me/niiquell)) para suporte.
- **Interface interativa**: Menu intuitivo com navegação por números e tecla `q` para voltar.
- **Comando personalizado**: Execute o script com `nbt start` após a configuração.
- **Suporte a root e não-root**: Algumas métricas (ex.: porcentagem) funcionam sem root via `dumpsys`.

## Requisitos

- **Dispositivo**: Android com Termux instalado.
- **Root**: Necessário para a maioria das métricas (ex.: vida útil, ciclos). Use Magisk ou outro método de root.
- **Dependências**:
  - `bc`: Para cálculos de ponto flutuante.
  - `termux-api`: Para abrir links do Telegram.
  - `curl`: Para baixar o script do GitHub.
- **Navegador ou Telegram**: Para a opção de ajuda (link do grupo).
- **Permissões**: Conceda acesso ao armazenamento no Termux com `termux-setup-storage`.

## Instalação

1. **Instale o Termux**:
   - Baixe o [Termux](https://github.com/termux/termux-app) e o [Termux-API](https://github.com/termux/termux-api)

2. **Execute o comando de instalação**:
   - Copie e cole o comando abaixo no Termux para instalar dependências, baixar o script, e configurar o comando `nbt start`:
     ```bash
     pkg update && pkg upgrade -y && pkg install bc termux-api curl -y && curl -o ~/niquelbatterytools.sh https://raw.githubusercontent.com/Amogus3/Niquel-Battery-Tools/refs/heads/main/niquelbatterytools.sh && sed -i 's/\r$//' ~/niquelbatterytools.sh && chmod +x ~/niquelbatterytools.sh && mkdir -p ~/bin && echo -e '#!/bin/bash\nif [ "$1" = "start" ]; then\n  su -c ~/niquelbatterytools.sh\nelse\n  echo "Uso: nbt start"\nfi' > ~/bin/nbt && chmod +x ~/bin/nbt && echo "export PATH=\$PATH:~/bin" >> ~/.bashrc && source ~/.bashrc && echo "Configuração concluída! Use 'nbt start' para executar o script."

3. **Verifique a conclusão**:
   - Após a instalação, você verá: `Configuração concluída! Use 'nbt start' para executar o script.`

## Uso

1. **Inicie o script**:
   ```bash
   nbt start
