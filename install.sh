#!/bin/bash

# Color
AZUL='\033[0;34m'       
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[0;33m'
NC='\033[0m'

# Mostrar mensaje de bienvenida
mostrar_bienvenida() {
  echo -e ""
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "${AZUL}[+]                                                 [+]${NC}"
  echo -e "${AZUL}[+]                INSTALADOR AUTOMÁTICO            [+]${NC}"
  echo -e "${AZUL}[+]                  © ZERONE OFFC                [+]${NC}"
  echo -e "${AZUL}[+]                                                 [+]${NC}"
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "Este script está diseñado para facilitar la instalación del tema Pterodactyl,"
  echo -e "está estrictamente prohibido venderlo."
  echo -e ""
  echo -e "𝗪𝗛𝗔𝗧𝗦𝗔𝗣𝗣 :"
  echo -e "0838-5641-0394"
  echo -e "𝗬𝗢𝗨𝗧𝗨𝗕𝗘 :"
  echo -e "@ZeroOffc"
  echo -e "𝗖𝗥𝗘𝗗𝗜𝗧𝗦 :"
  echo -e "@foxstore"
  sleep 4
  clear
}

# Actualizar e instalar jq
instalar_jq() {
  echo -e "                                                       "
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "${AZUL}[+]             ACTUALIZAR E INSTALAR JQ             [+]${NC}"
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
    echo -e "${VERDE}[+] =============================================== [+]${NC}"
    echo -e "${VERDE}[+]              INSTALACIÓN DE JQ EXITOSA           [+]${NC}"
    echo -e "${VERDE}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
    echo -e "${ROJO}[+] =============================================== [+]${NC}"
    echo -e "${ROJO}[+]              INSTALACIÓN DE JQ FALLIDA           [+]${NC}"
    echo -e "${ROJO}[+] =============================================== [+]${NC}"
    exit 1
  fi
  echo -e "                                                       "
  sleep 1
  clear
}

# Verificar token de usuario
verificar_token() {
  echo -e "                                                       "
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "${AZUL}[+]                LICENCIA ZERONE OFFC             [+]${NC}"
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  TOKEN=$(jq -r '.token' token.json)

  echo -e "${AMARILLO}INGRESE EL TOKEN DE ACCESO:${NC}"
  read -r TOKEN_USUARIO

  if [ "$TOKEN_USUARIO" = "zerone" ]; then
    echo -e "${VERDE}ACCESO EXITOSO${NC}"
  else
    echo -e "${ROJO}ACCESO FALLIDO${NC}"
    exit 1
  fi
  clear
}

# Instalar tema
instalar_tema() {
  while true; do
    echo -e "                                                       "
    echo -e "${AZUL}[+] =============================================== [+]${NC}"
    echo -e "${AZUL}[+]                   SELECCIONAR TEMA                [+]${NC}"
    echo -e "${AZUL}[+] =============================================== [+]${NC}"
    echo -e "                                                       "
    echo -e "SELECCIONE EL TEMA QUE DESEA INSTALAR"
    echo "1. stellar"
    echo "x. regresar"
    echo -e "ingrese su opción (1/x) :"
    read -r SELECCION_TEMA
    case "$SELECCION_TEMA" in
      1)
        URL_TEMA="https://github.com/XdrianGM/xd/raw/main/C1.zip"
        break
        ;;
      x)
        return
        ;;
      *)
        echo -e "${ROJO}Opción no válida, por favor intente de nuevo.${NC}"
        ;;
    esac
  done
  
  if [ -e /root/pterodactyl ]; then
    sudo rm -rf /root/pterodactyl
  fi
  wget -q "$URL_TEMA"
  sudo unzip -o "$(basename "$URL_TEMA")"
  echo -e "                                                       "
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "${AZUL}[+]                INSTALACIÓN DEL TEMA              [+]${NC}"
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan migrate
  yarn build:production
  php artisan view:clear
  sudo rm /root/C1.zip
  sudo rm -rf /root/pterodactyl

  echo -e "                                                       "
  echo -e "${VERDE}[+] =============================================== [+]${NC}"
  echo -e "${VERDE}[+]                INSTALACIÓN EXITOSA               [+]${NC}"
  echo -e "${VERDE}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 2
  clear
}

# Desinstalar tema
desinstalar_tema() {
  echo -e "                                                       "
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "${AZUL}[+]                 ELIMINAR TEMA                    [+]${NC}"
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  bash <(curl https://raw.githubusercontent.com/Foxstoree/pterodactyl-auto-installer/main/repair.sh)
  echo -e "                                                       "
  echo -e "${VERDE}[+] =============================================== [+]${NC}"
  echo -e "${VERDE}[+]              ELIMINACIÓN EXITOSA                [+]${NC}"
  echo -e "${VERDE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
}

# Script principal
mostrar_bienvenida
instalar_jq
verificar_token

while true; do
  clear
  echo -e "                                                       "
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "${AZUL}[+]                   SELECCIONAR OPCIÓN              [+]${NC}"
  echo -e "${AZUL}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "SELECCIONE OPCIÓN :"
  echo "1. Instalar tema"
  echo "2. Desinstalar tema"
  echo "x. Salir"
  echo -e "Ingrese su opción (1/2/x):"
  read -r OPCION_MENU
  clear

  case "$OPCION_MENU" in
    1)
      instalar_tema
      ;;
    2)
      desinstalar_tema
      ;;
    x)
      echo "Saliendo del script."
      exit 0
      ;;
    *)
      echo "Opción no válida, por favor intente de nuevo."
      ;;
  esac
done