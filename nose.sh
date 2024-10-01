#!/bin/bash

# Variables
DB_NAME="paymenter"
DB_USER="paymenter_user"
DB_PASS="password123"
DOMAIN="clientes.starlights.uk"

# Actualizar y preparar el sistema
sudo apt update && sudo apt upgrade -y
sudo apt install -y git unzip curl nginx mysql-server \
php8.1 php8.1-fpm php8.1-mysql php8.1-curl php8.1-mbstring \
php8.1-xml php8.1-zip

# Clonar el repositorio de Paymenter
cd /var/www
sudo git clone https://github.com/paymenter/paymenter.git
cd paymenter

# Instalar Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer install

# Configurar permisos
sudo chown -R www-data:www-data /var/www/paymenter
sudo chmod -R 755 /var/www/paymenter

# Configurar la base de datos
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Configurar el archivo .env
cp .env.example .env
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=$DB_NAME/" .env
sed -i "s/DB_USERNAME=root/DB_USERNAME=$DB_USER/" .env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=$DB_PASS/" .env

# Generar clave de aplicación
php artisan key:generate

# Migrar la base de datos
php artisan migrate

# Configurar Nginx
sudo bash -c "cat > /etc/nginx/sites-available/paymenter <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    root /var/www/paymenter/public;

    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF"

# Habilitar el sitio de Nginx
sudo ln -s /etc/nginx/sites-available/paymenter /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Finalización
echo "La instalación de Paymenter se ha completado. Accede a http://$DOMAIN para verificar."
