#!/bin/bash

# Definir variables
DB_NAME="jexactyl"
DB_USER="jexactyluser"
DB_PASS="TuContraseñaSegura"
DOMAIN="info.starlights.uk"
APP_PATH="/var/www/jexactyl"

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependencias necesarias
echo "Instalando dependencias..."
sudo apt install curl nginx mariadb-server software-properties-common unzip -y
sudo apt install php8.1 php8.1-fpm php8.1-cli php8.1-mysql php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-zip -y

# Instalar Node.js y Yarn
echo "Instalando Node.js y Yarn..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm install -g yarn

# Configurar MariaDB
echo "Configurando MariaDB..."
sudo mysql_secure_installation

echo "Creando base de datos y usuario para Jexactyl..."
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Descargar e instalar Jexactyl
echo "Descargando Jexactyl..."
cd /var/www
sudo curl -Lo jexactyl.tar.gz https://github.com/jexactyl/jexactyl/archive/refs/heads/stable.tar.gz
sudo tar -xzvf jexactyl.tar.gz
sudo mv jexactyl-stable $APP_PATH

# Instalar dependencias de Jexactyl
echo "Instalando dependencias de Jexactyl..."
cd $APP_PATH
sudo yarn install

# Configurar el archivo .env
echo "Configurando archivo .env..."
sudo cp .env.example .env
sudo sed -i "s/DB_HOST=127.0.0.1/DB_HOST=localhost/" .env
sudo sed -i "s/DB_DATABASE=homestead/DB_DATABASE=$DB_NAME/" .env
sudo sed -i "s/DB_USERNAME=homestead/DB_USERNAME=$DB_USER/" .env
sudo sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=$DB_PASS/" .env

# Generar la clave de aplicación y migrar base de datos
echo "Generando clave de aplicación y migrando base de datos..."
sudo php artisan key:generate --force
sudo php artisan migrate --force
sudo php artisan db:seed --force

# Configurar Nginx
echo "Configurando Nginx..."
sudo tee /etc/nginx/sites-available/jexactyl > /dev/null <<EOL
server {
    listen 80;
    server_name $DOMAIN;
    root $APP_PATH/public;

    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Activar el sitio en Nginx y reiniciar Nginx
echo "Activando el sitio en Nginx..."
sudo ln -s /etc/nginx/sites-available/jexactyl /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Configurar cron para Jexactyl
echo "Configurando cron para Jexactyl..."
echo "* * * * * php $APP_PATH/artisan schedule:run >> /dev/null 2>&1" | sudo tee -a /etc/crontab
sudo php artisan queue:work --daemon

# Finalización
echo "La instalación ha finalizado. Accede a tu servidor en http://$DOMAIN para completar la configuración desde la interfaz web."
