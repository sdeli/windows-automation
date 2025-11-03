# INSTALLING WSL

**Before reinstalling backup:**

- .zsh_history/.bash_history
- mysql full db\
- certs
- /var/www/html folder
- db:

    mysqldump -u root -p --opt --all-databases > alldb.sql
    
    mysqldump -u root -p --all-databases --skip-lock-tables > alldb.sql

- backup: /etc/apache2/sites-available/000-default.conf
  **get 'Ubuntu 18.04.5 LTS' from microsoft store**
  **open cmd and hit: ubuntu1804**
  
## ADD CERTIFICATE TO CURL
    
    sudo cp /home/[username]/ZscalerRootCertificate-2048-SHA256.crt /usr/local/share/ca-certificates/
    sudo update-ca-certificates
    
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

    sudo cp /var/www/html/000-deault.conf /etc/apache2/sites-available/000-default.conf

**or if you dont have it then put code into the '<VirtualHost \*:80>' tag in '/etc/apache2/sites-available/000-default.conf' :** [https://needlify.com/post/install-and-configure-a-fully-functionnal-web-server-on-wsl-2-b1aa0954](https://needlify.com/post/install-and-configure-a-fully-functionnal-web-server-on-wsl-2-b1aa0954)

**additionally you can define links for your project installations with this snippet:**

    # /etc/apache2/sites-available/000-default.conf
    <VirtualHost *:80>
      ServerName test-wp.localhost
      ## rest of your config
      ## e.g. ServerAlias my.website.on.the.internet.com
      DocumentRoot /Users/sdeli/Projects/test-wp/wp
    </VirtualHost>

**You may need these line for mode_rewrite**
```html
<Directory /var/www/html>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride all
    Order allow,deny
    Allow from all
</Directory>
```

  sudo a2enmod rewrite

**then restart apache**

## INSTALL ZSH

    sudo apt-get install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

**restart terminal**

    cd /var/www/html
    git clone https://github.com/sdeli/windows-automation.git
    cd ./windows-automation
    ./configure-zshell.sh

**you may want to adjust fzf search settings in .zshrc:**

    export FZF_CTRL_T_COMMAND='find /var/www/ /home /mnt/c/Projects/ /mnt/c/Users/delis/Downloads/ /mnt/c/Users/delis/Documents /mnt/c/Users/delis/Desktop'

    

**restart terminal**

    cd ~/

## INSTALLING MYSQL

    sudo apt install software-properties-common
    sudo apt install mysql-server

**if the next command throws this error:**

> Starting MySQL database server mysqld No directory, logging in with HOME=/
> mkdir: cannot create directory ‘//.cache’: Permission denied
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
**You may need these lines too, if it throws some auth error:**
Put these lines at the end of the file /etc/mysql/my.cnf:

    [mysqld]                                                                                                                
    bind-address = 0.0.0.0                       
    user=root          
    pid-file     = /var/run/mysqld/mysqld.pid
    socket       = /var/run/mysqld/mysqld.sock 
    port         = 3306             

    [client]                             
    port         = 3306                             
    socket       = /var/run/mysqld/mysqld.sock
    
**Then put these commands on terminal (NOTE: if dir is not there then create one):**

    sudo chmod 777 -R /var/run/mysqld
    sudo chmod 777 -R /var/lib/mysql
    sudo chmod 777 -R /var/log/mysql

**If mysql wasn't working check out:** /var/log/mysql/error.log

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
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

    sudo mv composer.phar /usr/local/bin/composer

**XDEBUG**

- install it by this url: https://xdebug.org/wizard
- Dont forget to **restart apache** after having done commands

you may need these lines into /etc/php/8.0/apache2/conf.d/99-xdebug.ini

    zend_extension=xdebug.so
    xdebug.mode = debug
    xdebug.client_host = 127.0.0.1
    xdebug.client_port = 9003
    xdebug.start_with_request=yes
    xdebug.log="/var/log/nginx/xdebug.log"
    xdebug.idekey = PHPSTORM
    xdebug.discover_client_host=false

## Commands you will use for sure:

Search and replace url in wp database:

    wp search-replace 'http://localhost/test-wp/wp' 'http://test-wp.localhost'

Cache for 1 week (passwords for example):

    git config --global credential.helper "cache --timeout=604800"

Disable tracking file permissions in repos

    git config core.fileMode false

Check what got inserted into the db after an action

    mysqldump -p -usandor wordpress_test | sed 's$),($),\n($g' > db_before.sql
    mysqldump -p -usandor wordpress_test | sed 's$),($),\n($g' > db_after.sql
    sort db_before.sql db_before.sql db_after.sql | uniq -u > diff.csv

Watch file changes in folder

    watch --interval=1 'ls -ARrtd $(find /var/www/html/some-folder -type f) | echo $(find . -type f | wc -l) $(tail -n 1)'
    
Install things in pod

    apt-get update && apt install nano
    apt-get install -y git curl libmcrypt-dev default-mysql-client
    apt install mariadb-client
    curl -O -k https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    apt install mc

## DOCKER

**!Important: start up DOCKER DESKTOP app ** and enable ubuntu under settings/Resources/Wsl Integration

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

## REINSTALL ENV

To destroy the instance open cmd terminal:

    wsl --unregister Ubuntu-18.04

To reinstall, put this into cmd

    ubuntu1804



