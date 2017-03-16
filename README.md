# Set up a private geth network using Docker containers and docker compose

This runs a container with private ethereum chain with some precreates accounts and preallocated balances.

There are two ways to get the system running:
## Docker container

Use the build-image script to build the image from scratch or the following command:
```
  docker build -t chrysalis/gethimage:1.2 .
```
## Preallocated account info

The ```ethereum/keystore``` folder contains the private keys that are preallocated with a lot of ether. All the accounts have the same password stored in the ```ethereum/geth.password``` file.

## Docker compose

Clone this repository and

```
  docker-compose up -d
  docker-compose --verbose -f docker-compose.yml up
  
 ```
 
 ### Stop and Delete all the containers
 ```
 docker stop $(docker ps -q -f
 docker rm $(docker ps -aq -f)
```

### Credits
The steps described in this thread :http://ethereum.stackexchange.com/questions/1516/how-can-i-completely-automate-a-docker-image-and-dockerfile-for-a-geth-test-netw
