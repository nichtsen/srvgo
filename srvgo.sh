#!/bin/bash

function catch() {
	if [ $err -ne 0 ]; then
		echo "Error:" $err 
		exit 1
	fi
}
function getGolang() {
	wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
	err=$?
	catch
	tar -C /usr/local -xzf go1.12*.tar.gz
	err=$?
	catch
	echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
	err=$?
	catch
	export PATH=$PATH:/usr/local/go/bin
	err=$?
	catch
	mkdir /home/go
	err=$?
	catch
        export GOPATH=/home/go
	err=$?
	catch
        rm go1.*
}
function getDocker() {
	sudo apt-get install \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common
	err=$?
	catch
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	err=$?
	catch
	# sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/debian \
		$(lsb_release -cs) \
		stable"
	err=$?
	catch
	sudo apt-get update
        #sudo apt-get install docker-ce docker-ce-cli containerd.io
	err=$?
	catch
	sudo apt-get install \
		docker-ce=5:18.09.1~3-0~debian-stretch \
		docker-ce-cli=5:18.09.1~3-0~debian-stretch \
		containerd.io
	err=$?
	catch
	sudo docker run hello-world
	err=$?
	catch
}
function preGet() {
	sudo --version
	if [ $? -ne 0 ]; then
		apt-get install sudo
		err=$?
		catch
	fi
	git --version 
	if [ $? -ne 0 ]; then
		sudo apt-get install git
		err=$?
		catch
	fi
	# optional:
	# git config user.name
	# git config user.email
}	

function getSrvgo() {
	go get github.com/nichtsen/srvgo
        ln -s /home/go/src/github.com/nichtsen link
	err=$?
	catch
        mv link /root
        cd /root/link/srvgo
        cp -r dk ~/dk
	err=$?
	catch
        cd /root/link/srvgo/server
        go build -o /root/dk/xf
        err=$?
	catch
	cd /root/link/srvgo/client
	go build -o /root/cli
        err=$?
	catch
	cd /root/dk
	docker build -t tcpsrv:v1 .
	err=$?
	catch
        #docker image ls
        docker swarm init
	err=$?
	catch
        docker stack deploy -c docker-compose.yml srv
        docker service ls
	# docker stack rm srv
}
echo "########################################"
echo "####### step1: check git and sudo ######"
echo "########################################"
preGet
echo "#########################################"
echo "###### step2: check and get Golang ######"
echo "#########################################"
go version
if [ $? -ne 0 ]; then
	getGolang
fi
echo "#########################################"
echo "###### step3: check and get Docker ######"
echo "#########################################"
docker --version
if [ $? -ne 0 ]; then
	getDocker
fi
echo "#############################################"
echo "###### step4: set up the srvgo service ######"
echo "#############################################"
getSrvgo

