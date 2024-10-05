#!/bin/bash

# Color
BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+]                AUTO INSTALLER THEME             [+]${NC}"
  echo -e "${BLUE}[+]                  © ZERONE OFFC                [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "script ini dibuat untuk mempermudah penginstalasian theme pterodactyl,"
  echo -e "dilarang keras untuk memperjual belikan."
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

# Update and install jq
install_jq() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]             UPDATE & INSTALL JQ                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "                                                       "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+]              INSTALL JQ BERHASIL                [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
  else
    echo -e "                                                       "
    echo -e "${RED}[+] =============================================== [+]${NC}"
    echo -e "${RED}[+]              INSTALL JQ GAGAL                   [+]${NC}"
    echo -e "${RED}[+] =============================================== [+]${NC}"
    exit 1
  fi
  echo -e "                                                       "
  sleep 1
  clear
}

# Check user token
check_token() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               LICENSY ZERONE OFFC             [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  TOKEN=$(jq -r '.token' token.json)

  echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"
  read -r USER_TOKEN

  if [ "$USER_TOKEN" = "zerone" ]; then
    echo -e "${GREEN}AKSES BERHASIL${NC}"
  else
    echo -e "${GREEN}AKSES GAGAL${NC}"
    exit 1
  fi
  clear
}

# Check if theme is already installed
check_installed_theme() {
  if [ -d "/var/www/pterodactyl/resources/scripts/components/dashboard" ]; then
    echo -e "${YELLOW}Tema ya instalado. ¿Deseas actualizarlo? (y/n):${NC}"
    read -r UPDATE_CHOICE
    if [ "$UPDATE_CHOICE" != "y" ]; then
      echo "Instalación cancelada."
      exit 0
    fi
  fi
}

# Install theme
install_theme() {
  check_installed_theme
  while true; do
    echo -e "                                                       "
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${BLUE}[+]                   SELECT THEME                  [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "                                                       "
    echo -e "PILIH THEME YANG INGIN DI INSTALL"
    echo "1. stellar"
    echo "2. billing"
    echo "3. enigma"
    echo "x. kembali"
    echo -e "masukan pilihan (1/2/3/x) :"
    read -r SELECT_THEME
    case "$SELECT_THEME" in
      1)
        THEME_URL="https://github.com/XdrianGM/xd/raw/main/stellar.zip"
        break
        ;;
      2)
        THEME_URL="https://github.com/XdrianGM/xd/raw/main/billing.zip"
        break
        ;;
      3)
        THEME_URL="https://github.com/DITZZ112/foxxhostt/raw/main/C3.zip"
        break
        ;; 
      x)
        return
        ;;
      *)
        echo -e "${RED}Pilihan tidak valid, silahkan coba lagi.${NC}"
        ;;
    esac
  done

  # Actualizar el tema solo si ya está instalado
  if [ -e /root/pterodactyl ]; then
    sudo rm -rf /root/pterodactyl
  fi
  wget -q "$THEME_URL"
  sudo unzip -o "$(basename "$THEME_URL")"

  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                  ACTUALIZANDO THEME               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  php artisan view:clear
  yarn build:production
  
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]              ACTUALIZACIÓN COMPLETA               [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 2
  clear
  return
}

# Uninstall theme
uninstall_theme() {
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                    DELETE THEME                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  bash <(curl https://raw.githubusercontent.com/XdrianGM/Nose/main/repair.sh)
  echo -e "                                                       "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+]                 DELETE THEME SUKSES             [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  sleep 2
  clear
}

# Main script
display_welcome
install_jq
check_token

while true; do
  clear
  echo -e "                                                       "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                   SELECT OPTION                 [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "                                                       "
  echo -e "SELECT OPTION :"
  echo "1. Install theme"
  echo "2. Uninstall theme"
  echo "x. Exit"
  echo -e "Masukkan pilihan (1/2/x):"
  read -r MENU_CHOICE
  clear

  case "$MENU_CHOICE" in
    1)
      install_theme
      ;;
    2)
      uninstall_theme
      ;;
    x)
      echo "Keluar dari skrip."
      exit 0
      ;;
    *)
      echo "Pilihan tidak valid, silahkan coba lagi."
      ;;
  esac
done
