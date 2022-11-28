# INSTALLING WSL

__Before reinstalling backup .zsh_history/.bash_history, mysql full db, /var/www/html folder__

    mysqldump -u root -p --opt --all-databases > alldb.sql
    mysqldump -u root -p --all-databases --skip-lock-tables > alldb.sql

__get 'Ubuntu 18.04.5 LTS' from microsoft store__
__open cmd and hit: ubuntu1804__
 
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

__put code into the '<VirtualHost *:80>' tag in '/etc/apache2/sites-available/000-default.conf' :__ [https://needlify.com/post/install-and-configure-a-fully-functionnal-web-server-on-wsl-2-b1aa0954](https://needlify.com/post/install-and-configure-a-fully-functionnal-web-server-on-wsl-2-b1aa0954)
```html
<Directory /var/www/html>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride all
    Order allow,deny
    Allow from all
</Directory>
```
__then restart apache__
## INSTALL ZSH
    sudo apt-get install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

__restart terminal__

    cd /var/www/html
    git clone https://github.com/sdeli/windows-automation.git
    cd ./windows-automation
    ./configure-zshell.sh

__restart terminal__

    cd ~/

# INSTALLING MYSQL
    sudo apt install software-properties-common
    sudo apt install mysql-server
 
__if the next command throws this error:__
> Starting MySQL database server mysqld No directory, logging in with HOME=/ 
mkdir: cannot create directory ‘//.cache’: Permission denied
-su: 19: /etc/profile.d/wsl-integration.sh: cannot create //.cache/wslu/integration: Directory nonexistent

__in that case just run it again and it will work__

    sudo service mysql start
 
__first answer is: no , then set password for root, then the rest should be just no__

    sudo mysql_secure_installation
 
__Log into mysql and create new user__

    sudo mysql
    CREATE USER 'sandor'@'localhost' IDENTIFIED BY 'pass';
    GRANT ALL ON *.* TO 'sandor'@'localhost';
    FLUSH PRIVILEGES;
    exit
 
 ## INSTALLING PHP 8.0
    sudo apt install php8.0 php8.0-common php8.0-fpm php8.0-mysql php8.0-gmp php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-mbstring php8.0-gd php8.0-dev php8.0-imap php8.0-opcache php8.0-readline php8.0-soap php8.0-zip php8.0-intl php8.0-cli libapache2-mod-php8.0

__check php version__

    php -v

__then:__

    sudo a2enmod php8.0
    sudo service apache2 restart
 
__NOTE: Change php version to 7.4: https://ostechnix.com/how-to-switch-between-multiple-php-versions-in-ubuntu/__

    sudo a2dismod php8.0
    sudo service apache2 restart

    sudo apt install php7.4
    sudo apt install -y php7.4-{bcmath,bz2,intl,gd,mbstring,mysql,zip,common}
    sudo a2enmod php7.4
    sudo update-alternatives --config php

__if above code doenst work:__

    sudo update-alternatives --set php /usr/bin/php7.4
    sudo service apache2 restart

## INSTALL PHPMYADMIN
download it (https://www.phpmyadmin.net/downloads/) then put it into /var/www/html

## INSTALL NODE: https://github.com/nvm-sh/nvm

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

    source ~/.zshrc
__or__

    source ~/.bashrc

    command -v nvm
    nvm install v16.15.1
    nvm alias default v16.15.1
 
## IMPORTANT UTILITIES
    sudo apt-get install -y zip
    npm install -g typescript
 
__install composer: https://getcomposer.org/download/__

    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"

    sudo mv composer.phar /usr/local/bin/composer

## DOCKER
__!Important: start up DOCKER DESKTOP app__

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