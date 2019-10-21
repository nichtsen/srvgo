wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.12*.tar.gz
nano /etc/profile
//export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/go/bin
mkdir /home/go
nano ~/.bash_profile
//export GOPATH=/home/go
rm go1.*

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
   //sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo apt-get install \
    docker-ce=5:18.09.1~3-0~debian-stretch \
    docker-ce-cli=5:18.09.1~3-0~debian-stretch \
    containerd.io
sudo docker run hello-world
apt-get install git
apt-get install sudo
//git config user.name
//git config user.email 
go get github.com/nichtsen/srvgo.git
ln -s /home/go/src/github.com/nichtsen link
mv link /root
cd /root/link/srvgo
cp -r dk ~/dk
cd /root/link/srvgo/server
go build -o ~/dk/xf
cd /root/link/srvgo/client
go build -o ~/cli
cd ~/dk
docker build -t tcpsrv:v1 .
docker image ls
docker swarm init
docker stack deploy -c docker-compose.yml srv
docker service ls
cd ..
./cli
//docker stack rm srv
