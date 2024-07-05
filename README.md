# Deploy PHP Symfony (use Capistrano)

### Установить все необходимые зависимости и пакеты на вашу машину, с которой будет осуществляться деплой

```
sudo apt install ruby rubygems-integration -y

sudo gem install capistrano

sudo gem install capistrano-composer
```

### Install necessary packages on target VM
```
sudo apt install build-essential pkg-config openssl libssl-dev \
bison autoconf automake libtool re2c flex libxml2-dev libssl-dev libbz2-dev \
libcurl4-openssl-dev libjpeg-dev libfreetype6-dev libgmp3-dev \
libc-client2007e-dev libldap2-dev libmcrypt-dev libmhash-dev \
freetds-dev zlib1g-dev libmysqlclient-dev libncurses5-dev libpcre3-dev \
libsqlite0-dev libaspell-dev libreadline6-dev librecode-dev libsnmp-dev \
libtidy-dev libxslt-dev -y
```

### Install PHP8.2, nginx, mysql on target VM
```
sudo apt-get install -y software-properties-common

echo -ne "\n" | sudo add-apt-repository ppa:ondrej/php

sudo apt-get update

sudo apt install php8.2 php8.2-fpm php8.2-mbstring php8.2-xml php8.2-gd \
php8.2-curl nginx-full php8.2-mysql php8.2-sqlite3 mysql-server mysql-client git -y
```

### Download and install composer on target VM
```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

php composer-setup.php

php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer
```

### Деплой приложения (в соответствии с параметрами, установленными в конфигах данного репозитория)
```
cap production deploy 
```

### Конфигурация nginx после deploy на целевой ВМ
> $ ip=(curl 2ip.ru)

```
echo "server {
    listen 8080;

    server_name $ip;

    root /var/www/symfony/current/public;

    location / {
        try_files \$uri /index.php\$is_args\$args;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT \$realpath_root;
        internal;
    }

    location ~ \.php$ {
        return 404;
    }

}
" | sudo tee /etc/nginx/sites-available/symfony
```

### Link for nginx
```
sudo ln -s /etc/nginx/sites-available/symfony /etc/nginx/sites-enabled/

sudo service nginx reload
```
