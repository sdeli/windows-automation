# adduser sandor; usermod -aG sudo sandor
# change default user => ubuntu1804 config --default-user sandor

sudo git clone https://github.com/sdeli/usr-local-bin.git /usr/local/bin
sudo find /usr/local/bin -exec chmod 774 {} \;

mkdir /home/sandor/Projects /home/sandor/Documents /home/sandor/Downloads
chmod 774 /home/sandor/Projects /home/sandor/Documents /home/sandor/Downloads

cd /home/sandor/

sudo apt-get install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
