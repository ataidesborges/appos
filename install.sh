#!/bin/bash

# Verifica execucao SUDO
if [ "$EUID" -ne 0 ]; then
    echo "Este script deve ser executado como root. Use sudo:"
    sudo "$0" "$@"
    exit $?
fi

##############################################################
## Script desenvolvido por Bruno Barreto e Leonardo Bernardi
## Versao Instalador: v2.6.20240705
## Publicado na versao 4.46.0 do appos
##############################################################

# <=== Controle de STEPs ===>
# stepSET - Definicao de Variaveis
# etapa0 - Display
# etapa1 - Boas Vindas
# etapa2 - Selecao de Versao
# etapa3 - Download de Dependências
# etapa4 - Instalação XAMPP
# etapa5 - Instalação app-os
# etapa6 - Instalação Composer
# etapa7 - Configuração pelo Browser
# etapa8 - Configuração de dados de E-mail
# etapa9 - Auto Disparador de E-mail
# etapa10 - Alterar Número da OS
# <=== Controle de STEPs ===>

# <=== Inicio SET Diretorios ===>
    installCommand="sudo apt-get -y"
    dirDefault=/opt/Instaladorappos
    urlXampp="https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run/download"
    dirXampp=/opt/lampp
    dirapposConfig=/opt/lampp/htdocs/appos/application/.env
    dirHtdocs=/opt/lampp/htdocs
    dirMySQL=/opt/lampp/bin/mysql
# <=== Fim SET Diretorios ===>

# <=== Inicio Display ===>
    clear
    echo "**************************************************"
    echo "**************************************************"
    echo "**                                              **"
    echo "**                                              **"
    echo "**                                              **"
    echo "**           SCRIPT AUTO INSTALADOR             **"
    echo "**    app-os - SISTEMA DE ORDEM DE SERVICO      **"
    echo "**        LINUX (Debian / Ubuntu) x64           **"
    echo "**                                              **"
    echo "**                                              **"
    echo "**                                              **"
    echo "**************************************************"
    echo "**************************************************"
    echo
# <=== Fim Display ===>

# <=== Inicio Boas Vindas ===>
    echo "Ola, seja bem vindo."
    echo "Esse script foi desenvolvido com o intuito de auxiliar na instalacao padrao do Sistema app-os e os componentes necessarios de forma automatizada."
    echo "Reforcamos que nao recomendamos a instalacao em localhost para uso de PRODUCAO, apenas para TESTE ou DESENVOLVIMENTO devido a riscos de perdas de dados e seguranca."
    echo
    read -p "Continuar com a instalacao? (S/N): " resposta
    if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
        exit 0
    elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
        echo
    fi
# <=== Fim Boas Vindas ===>

# <=== Inicio Boas Vindas ===>
    clear
    echo "# DESEJA INSTALAR O app-os RELEASE OU MASTER?"
    echo "1- Release (Versao Estavel)"
    echo "2- Master (Versao Desenvolvimento)"
    echo "9 - Sair"
    echo
    read -p "Digite uma opcao: (1,2,9): " resposta
    if [ "$resposta" = "1" ]; then
        downappos=release
    elif [ "$resposta" = "2" ]; then
        downappos=master 
    elif [ "$resposta" = "9" ]; then
        exit 0
    fi
# <=== Fim Termos de Aceite ===>

# <=== Inicio Download de Dependências ===>
    clear
    echo "# BAIXANDO DEPENDENCIAS..."
    if [ ! -d "$dirDefault" ]; then
        mkdir $dirDefault
    fi
    $installCommand install -y wget unzip curl &> /dev/null
# <=== Fim Download de Dependências ===>

# <=== Inicio Instalação XAMPP ===>
    clear
    echo "# SERVIDOR WEB XAMPP..."
    echo
    if [ -d "$dirXampp" ]
    then
        echo "* XAMPP ja esta instalado."
    else
        echo "* Por favor aguarde, baixando XAMPP"
        wget --quiet --show-progress "$urlXampp" -O $dirDefault/xampp-installer.run
        echo
        echo "* Por favor aguarde, a instalacao pode levar ate 5 min."
        chmod +x $dirDefault/xampp-installer.run
        sudo $dirDefault/xampp-installer.run --mode unattended
        echo
        echo "* Por favor aguarde, instalando Extensões PHP"
        $installCommand install -y php-curl php-gd php-zip php-xml &> /dev/null
        $dirXampp/lampp restart
    fi
    echo
    echo "* Verificando Inicializado com o sistema"
    if [ -d "/etc/init.d/start_xampp" ]
    then
        echo "* XAMPP ja inicia com o sistema"
    else
        echo "[Unit]"> /etc/systemd/system/xampp.service
        echo "Description=XAMPP Control Panel">> /etc/systemd/system/xampp.service
        echo "[Service]">> /etc/systemd/system/xampp.service
        echo "ExecStart=/opt/lampp/lampp start">> /etc/systemd/system/xampp.service
        echo "ExecStop=/opt/lampp/lampp stop">> /etc/systemd/system/xampp.service
        echo "Type=forking">> /etc/systemd/system/xampp.service
        echo "[Install]">> /etc/systemd/system/xampp.service
        echo "WantedBy=multi-user.target">> /etc/systemd/system/xampp.service
        sudo systemctl daemon-reload
        sudo systemctl enable xampp.service
        echo "* Configurado inicializacao automatica"
    fi
# <=== Fim Instalação XAMPP ===>

#  <=== Inicio Instalação app-os ===>
    clear
    echo "# INSTALACAO SISTEMA app-os..."
    if [ -d "$dirHtdocs/appos" ]
    then
        echo "* app-os presente no sistema."
    else
        echo "* Baixando a ultima versao do projeto."

        if [ "$downappos" = "release" ]; then
            wget --quiet --show-progress -O $dirDefault/appos.zip $(curl -s https://api.github.com/repos/ataidesborges/appos/releases/latest | grep "zipball_url" | awk -F\" '{print $4}')
        elif [ "$downappos" = "master" ]; then
            wget --quiet --show-progress -O $dirDefault/appos.zip https://github.com/ataidesborges/appos/archive/refs/heads/master.zip
        fi
        echo
        echo "* Extraindo projeto."
        unzip -q $dirDefault/appos.zip -d $dirHtdocs/
        mv -i $dirHtdocs/*appos* $dirHtdocs/appos
        echo
        echo "* Atribuindo permissões."
        sudo chmod 777 $dirHtdocs/appos/updates/
        sudo chmod 777 $dirHtdocs/appos/application/
        sudo chmod 777 $dirHtdocs/appos/index.php
        sudo chmod 777 $dirHtdocs/appos/application/config/config.php
        sudo chmod 777 $dirHtdocs/appos/application/config/database.php
        sudo chmod 777 $dirHtdocs/appos/application/config/.env
        sudo chmod 777 $dirHtdocs/appos/application/config/.env.example
        echo
        echo "* Criando banco de dados."
        $dirMySQL -u root -e "CREATE DATABASE appos;"
    fi
# <=== Fim Instalação app-os ===>

# <=== Inicio Instalação Composer ===>
    clear
    echo "04 COMPLEMENTO COMPOSER..."
    echo
    echo "04.1 Executando instalador COMPOSER"
    if command -v composer &> /dev/null
    then
        echo "* Composer ja esta instalado."
    else
        echo "* Instalando Composer"
        sudo apt install composer -y &> /dev/null
    fi
    echo
    echo "* Verificando complemento"
    if [ -f "$dirHtdocs/appos/application/vendor" ]
    then
        echo "* Complementos ja instalados."
    else
        echo "* Instalando complementos."
        cd $dirHtdocs/appos
        composer install --no-dev -n &> /dev/null
        composer update -n &> /dev/null
    fi
# <=== Fim Instalação Composer ===>

# <=== Inicio Configuração pelo Browser ===>
    clear
    echo "# CONFIGURANDO appos..."
    echo "Acesse o appos via navegador http://localhost/appos"
    echo "Clique me PROXIMO e insira os dados abaixo:"
    echo
    echo "Host: localhost"
    echo "Usuario: root"
    echo "Senha: \"Em Branco\""
    echo "Banco de Dados: appos"
    echo
    echo Nome: "Digite seu Nome Completo"
    echo Email: "Informe seu E-mail para Login"
    echo Senha: "Insira sua senha para acesso"
    echo
    echo "URL: http://localhost/appos"
    echo
    echo "Obs: Caso a instalacao nao tenha sido bem sucedida, encerre o script e execute novamente."
    read -p "Gostaria de seguir com a Autoconfiguracao Opcional? (S/N)" resposta
    if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
        exit 0
    elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
        echo
    fi
# <=== Inicio Configuração pelo Browser ===>

# <=== Inicio Configurações Personalizadas ===>
    clear
    echo  "************************************************"
    echo  "****     CONFIGURAÇÕES PERSONALIZADAS       ****"
    echo  "************************************************"

    # <=== Inicio Configuração de dados de E-mail ===>
        echo
        read -p "Gostaria de configurar os dados de e-mail? (S/N): " resposta
        if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
            echo "* Dados de Email nao alterado."
        elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
            echo
            read -p "Informe o Protocolo (Padrao: SMTP): " protocolo
            read -p "Informe o endereco do Host SMTP (Ex: smtp.seudominio.com): " hostsmtp
            read -p "Informe a Criptografia (SSL/TLS): " criptografia
            read -p "Informe a Porta (Ex: 587): " porta
            read -p "Informe o Email (Ex: nome@seudominio.com): " email
            read -p "Informe a Senha (****): " senha

            sed -i "s/\EMAIL_PROTOCOL.*/\EMAIL_PROTOCOL='$protocolo'/" $dirapposConfig
            sed -i "s/\EMAIL_SMTP_HOST.*/\EMAIL_SMTP_HOST='$hostsmtp'/" $dirapposConfig
            sed -i "s/\EMAIL_SMTP_CRYPTO.*/\EMAIL_SMTP_CRYPTO='$criptografia'/" $dirapposConfig
            sed -i "s/\EMAIL_SMTP_PORT.*/\EMAIL_SMTP_PORT='$porta'/" $dirapposConfig
            sed -i "s/\EMAIL_SMTP_USER.*/\EMAIL_SMTP_USER='$email'/" $dirapposConfig
            sed -i "s/\EMAIL_SMTP_PASS.*/\EMAIL_SMTP_PASS='$senha'/" $dirapposConfig
            echo
            echo "* Dados de Email alterados com sucesso."
        fi
    # <=== Fim Configuração de dados de E-mail ===>

    # <=== Inicio Configuracao da Cron ===>
        echo
        read -p "Gostaria de ativar disparo automatico de Emails? (S/N): " resposta
        if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
            echo "* Nao configurado disparo automatico."
        elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
            echo "* Disparo automatico configurado com sucesso."
            (crontab -l ; echo "*/2 * * * * php $dirHtdocs/appos/index.php email/process") | crontab -
            (crontab -l ; echo "*/5 * * * * php $dirHtdocs/appos/index.php email/retry") | crontab -
        fi
    # <=== Fim Configuracao da Cron ===>

    # <=== Inicio Configuracao da Cron ===>
    echo
    read -p "Gostaria de alterar o numero da primeira OS? (S/N): " resposta
    if [ "$resposta" = "N" ] || [ "$resposta" = "n" ]; then
            echo "* Nao alterado valor da primeira OS."
    elif [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
        read -p "Informe o numero (Padrao: 1):" nOS
        $dirMySQL -u root -e "USE appos; ALTER TABLE os AUTO_INCREMENT=$nOS;"
        echo "* Número da próxima OS alterado para $nOS"
    fi
    # <=== Fim Configuracao da Cron ===>
# <=== Fim Configurações Personalizadas ===>

# Mensagem de status
clear
echo  "************************************************"
echo  "****    appos CONFIGURADO COM SUCESSO       ****"
echo  "************************************************"
sleep 2
rm -rf $dirDefault
exit 0
