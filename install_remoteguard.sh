#!/bin/bash

# Definindo Cores e Estilos para personalizar as Mensagens
RESET="\e[0m"
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"

# Funções para exibir Mensagens Personalizadas
function info {
  echo -e "\n${BLUE}${BOLD}[INFO]${RESET} $1"
}

function success {
  echo -e "\n${GREEN}${BOLD}[SUCCESS]${RESET} $1"
}

function warning {
  echo -e "\n${YELLOW}${BOLD}[WARNING]${RESET} $1"
}

function error {
  echo -e "\n${RED}${BOLD}[ERROR]${RESET} $1"
}

# Atualizando Pacotes
info "Iniciando Atualização dos Pacotes...\n"
sudo apt-get update && sudo apt-get upgrade -y

if [ $? -eq 0 ]
	then success "Pacotes Atualizados com Sucesso!\n"
	else error "Erro ao Atualizar os Pacotes!\n"
fi

# Verificando Instalação do Python
info "Iniciando Verificação de Instalação do Python...\n"
python3 --version

if [ $? -eq 0 ]
	then info "Python já Instalado!\n"
	else warning "Python Não Instalado!\n"
        info "Iniciando Instalação do Python...\n"
        sudo apt-get install python3.12

        python3 --version
        if [ $? -eq 0 ]
          then success "Python Instalado com Sucesso!\n"
          else error "Erro ao Instalar o Python3.12!\n"
        fi
fi

# Instalando PIP
info "Iniciando Instalação das Dependências necessárias do Python...\n"

# Instalando VENV
info "Iniciando Instalação do Gerenciador de Pacotes do Python (PIP)\n"
sudo apt install python3-pip -y
pip3 --version

if [ $? -eq 0 ]
	then success "PIP Instalado com Sucesso!\n"
	else error "Erro ao Instalar o PIP!\n"
fi

# Instalando VENV
info "Iniciando Instalação do Ambiente Virtual (VENV)\n"
sudo apt install python3-venv -y
python3 -m venv --help

if [ $? -eq 0 ]
	then success "VENV Instalado com Sucesso!\n"
	else error "Erro ao Instalar o VENV!\n"
fi

# Criando Ambiente Virtual
info "Configurando Ambiente Virtual...\n"
python3 -m venv amb

# Habilitando Ambiente Virtual
source amb/bin/activate

if [ $? -eq 0 ]
	then success "VENV Configurado com Sucesso!\n"
	else error "Erro ao Configurar o VENV!\n"
fi

# Instalando Bibliotecas
info "Iniciando Instalação das Dependências...\n"

pip install psutil
if [ $? -eq 0 ]
	then success "PSUTIL Instalado com Sucesso!\n"
	else error "Erro ao Instalar PSUTIL!\n"
fi

pip install atlassian-python-api
if [ $? -eq 0 ]
	then success "ATLASSIAN-API Instalado com Sucesso!\n"
	else error "Erro ao Instalar ATLASSIAN-API!\n"
fi

pip install boto3
if [ $? -eq 0 ]
	then success "BOTO3 Instalado com Sucesso!\n"
	else error "Erro ao Instalar BOTO3!\n"
fi

pip install botocore
if [ $? -eq 0 ]
	then success "BOTOCORE Instalado com Sucesso!\n"
	else error "Erro ao Instalar BOTOCORE!\n"
fi

pip install requests
if [ $? -eq 0 ]
	then success "REQUESTS Instalado com Sucesso!\n"
	else error "Erro ao Instalar REQUESTS!\n"
fi

# Desativando Ambiente Virtual
deactivate

success "Ambiente Python Configurado com Sucesso!\n"

info "Iniciando Instalação e Configuração do Docker...\n"

# Adicionando Certificados do Docker"
info "Carregando Certificados do Docker...\n"
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adicionando Repositório do Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Instalando as últimas versões do Ambiente Docker
info "Iniciando Instalação Docker...\n"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Verificando Instalação do Docker
sudo docker -v

if [ $? -eq 0 ]
        then success "Docker Instalado com Sucesso!\n"
        else error "Erro ao Instalador Docker!\n"
fi

# Inicializando o Docker
info "Iniciando Docker...\n"
sudo systemctl start docker

# Configurando para o Docker sempre Iniciar após o Boot
info "Configurando Inicialização Automática do Docker...\n"
sudo systemctl enable docker

# Adicionando o Usuário ao Grupo do Docker
info "Adicionando Usuário ao Grupo do Docker...\n"
sudo usermod -aG docker $USER
newgrp docker

success "Docker Configurado com Sucesso!\n"

# Criando e Configurando Containeres
info "Iniciando Criação e Configuração dos Containeres da Aplicação...\n"
cd RemoteGuard-Env/
docker compose -f ~/RemoteGuard-Env/docker-compose.yml up -d

if [ $? -eq 0 ]
        then success "Containeres Criados e Configurados com Sucesso!\n"
        else error "Erro ao Configurar os Containeres!\n"
fi

info "Fim da Instalação e Configuração do Ambiente RemoteGuard!\n"