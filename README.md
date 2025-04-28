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
   - Baixe o app do [Termux](https://github.com/termux/termux-app) e o [Termux-API](https://github.com/termux/termux-api)

2. **Conceda permissão ao Termux para acessar o armazenamento**:
   - Copie e cole o comando abaixo no Termux e permita a solicitação que aparecerá na tela.
     ```bash
     termux-setup-storage

3. **Atualize os pacotes do Termux**:
     ```bash
     pkg update && pkg upgrade -y

4. **Instale os pacotes necessários**:
     ```bash
     pkg install bc termux-api curl -y

5. **Baixe o script do GitHub usando**:
     ```bash
     mkdir -p /sdcard/NqlBatteryTools && curl -o /sdcard/NqlBatteryTools/start.sh https://raw.githubusercontent.com/niiquell/NqlBatteryTools/main/start.sh && sed -i 's/\r$//' /sdcard/NqlBatteryTools/start.sh

6. **Dê permissão Root para o Termux**:
     ```bash
     su

7. **Vá até o diretório onde o script está**:
     ```bash
     cd /sdcard/NqlBatteryTools

8. **Execute o Script**:
     ```bash
     sh start.sh

Caso dê tudo certo o menu aparecerá na tela, certifique-se de dar acesso root ao termux usando Magisk/KernelSU/Apatch.

## Executar o Script Novamente
nas próximas vezes que for executar o script basta repetir os passos: **6**, **7** e **8**.
