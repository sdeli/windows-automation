# INSTALLING WSL

**Before reinstalling backup:**

- .zsh_history/.bash_history
- mysql full db
- /var/www/html folder
- db:

  mysqldump -u root -p --opt --all-databases > alldb.sql
  mysqldump -u root -p --all-databases --skip-lock-tables > alldb.sql

- backup: /etc/apache2/sites-available/000-default.conf
  **get 'Ubuntu 18.04.5 LTS' from microsoft store**
  **open cmd and hit: ubuntu1804**

## UPDATE DEPENDENCY MANAGERS

    sudo apt update && sudo apt upgrade
    sudo apt-get update
    sudo apt-get upgrade
    sudo add-apt-repository ppa:ondrej/php

## INSTALLING APACHE2

    sudo apt install apache2 -y
    sudo service apache2 start
    sudo systemctl enable apache2.service

    sudo chown [username]:[username] /var/www/html

**restore '/etc/apache2/sites-available/000-default.conf' file**

**or if you dont have it then put code into the '<VirtualHost \*:80>' tag in '/etc/apache2/sites-available/000-default.conf' :** [https://needlify.com/post/install-and-configure-a-fully-functionnal-web-server-on-wsl-2-b1aa0954](https://needlify.com/post/install-and-configure-a-fully-functionnal-web-server-on-wsl-2-b1aa0954)

**additionally you can define links for your project installations with this snippet:**

    # /etc/apache2/sites-available/000-default.conf
    <VirtualHost *:80>
      ServerName test-wp.localhost
      ## rest of your config
      ## e.g. ServerAlias my.website.on.the.internet.com
      DocumentRoot /Users/sdeli/Projects/test-wp/wp
    </VirtualHost>

```html
<Directory /var/www/html>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride all
    Order allow,deny
    Allow from all
</Directory>
```

**then restart apache**

## INSTALL ZSH

    sudo apt-get install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

**restart terminal**

    cd /var/www/html
    git clone https://github.com/sdeli/windows-automation.git
    cd ./windows-automation
    ./configure-zshell.sh

**restart terminal**

    cd ~/

# INSTALLING MYSQL

    sudo apt install software-properties-common
    sudo apt install mysql-server

**if the next command throws this error:**

> Starting MySQL database server mysqld No directory, logging in with HOME=/
> mkdir: cannot create directory ???//.cache???: Permission denied
> -su: 19: /etc/profile.d/wsl-integration.sh: cannot create //.cache/wslu/integration: Directory nonexistent

**in that case just run it again and it will work**

    sudo service mysql start

**first answer is: no , then set password for root, then the rest should be just no**

    sudo mysql_secure_installation

**Log into mysql and create new user**

    sudo mysql
    CREATE USER 'sandor'@'localhost' IDENTIFIED BY 'pass';
    GRANT ALL ON *.* TO 'sandor'@'localhost';
    FLUSH PRIVILEGES;
    exit

## INSTALLING PHP 8.0

    sudo apt install php8.0 php8.0-common php8.0-fpm php8.0-mysql php8.0-gmp php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-mbstring php8.0-gd php8.0-dev php8.0-imap php8.0-opcache php8.0-readline php8.0-soap php8.0-zip php8.0-intl php8.0-cli libapache2-mod-php8.0

**check php version**

    php -v

**then:**

    sudo a2enmod php8.0
    sudo service apache2 restart

**NOTE: Change php version to 7.4: https://ostechnix.com/how-to-switch-between-multiple-php-versions-in-ubuntu/**

    sudo a2dismod php8.0
    sudo service apache2 restart

    sudo apt install php7.4
    sudo apt install -y php7.4-{bcmath,bz2,intl,gd,mbstring,mysql,zip,common}
    sudo a2enmod php7.4
    sudo update-alternatives --config php

**if above code doenst work:**

    sudo update-alternatives --set php /usr/bin/php7.4
    sudo service apache2 restart

## INSTALL PHPMYADMIN

download it (https://www.phpmyadmin.net/downloads/) then put it into /var/www/html

you may need this:
sudo find /var/www/html -name "\*:Zone.Identifier" -type f -delete

## INSTALL NODE: https://github.com/nvm-sh/nvm

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

    source ~/.zshrc

**or**

    source ~/.bashrc

    command -v nvm
    nvm install v16.15.1
    nvm alias default v16.15.1

## WP CLI: [https://wp-cli.org/](https://wp-cli.org/)

    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    php wp-cli.phar --info
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp

## IMPORTANT UTILITIES

    sudo apt-get install -y zip
    npm install -g typescript

**install composer: https://getcomposer.org/download/**

    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"

    sudo mv composer.phar /usr/local/bin/composer

**important commands here:**

wp search-replace 'http://localhost/test-wp/wp' 'http://test-wp.localhost'

## DOCKER

**!Important: start up DOCKER DESKTOP app**

    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker ${USER}
    sudo service docker start
    sudo chmod 666 /var/run/docker.sock
    docker run hello-world

## KUBERNETES: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    kubectl version --client

# REINSTALL ENV

To destroy the instance open cmd terminal:

    wsl --unregister Ubuntu-18.04

To reinstall, put this into cmd

    ubuntu1804
