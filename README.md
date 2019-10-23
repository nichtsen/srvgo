# sevgo
> A C/S architecture practisinig with docker service
## Installation
```
git clone https://github.com/nichtsen/srvgo.git
cd srvgo
chmod u+x srvgo.sh
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
