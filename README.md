# srvgo
> A C/S architecture testing with docker service
## Installation
```
git clone https://github.com/nichtsen/srvgo.git
cd srvgo
chmod +x setup.sh
./srvgo.sh
```
To check the running docker services:
```
docker service ls
```
Note that 3 replicas are supposed to be running by default

To take down the srvgo service:
```
docker stack rm srv
```
