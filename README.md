![Docker Pulls](https://img.shields.io/docker/pulls/d3fk/whalecome) ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/d3fk/whalecome) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/d3fk/whalecome) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/d3fk/whalecome) ![Docker Stars](https://img.shields.io/docker/stars/d3fk/whalecome) [![GitHub license](https://img.shields.io/github/license/Angatar/whalecome)](https://github.com/Angatar/whalecome/blob/master/LICENSE)
# whalecome (Angatar> d3fk/whalecome)
A small container (alpine based) to serve as training material for a "ProDev" training class on Docker.

Contains a few additional packages + a small sh script that displays a Whalecome message and allows the user to display a "Hello world!" in different ways by using the container.  

Through the use of this container in its 2 versions (cf available tags) the user can understand:
- basic docker run commands
- the containers lifecycles run stop start rm
- how to make a container continues running by using a pending command
- basic docker exec commands
- how to get information on a container content by using docker history
- the use of CMD in Dockerfile
- interactions with the container through CMD on run
- the use of ENTRYPOINT in Dockerfile
- interactions with the container by overwriting the entrypoint on run
- the use of ENV
- interactions with the container by overwriting the ENV variables on run
- copy content from the container
- use of volumes to add contents to the container
- the use of image tags
- how to clean the mess: remove stopped containers, unused images ...
- how to build his own image from an existing image


## Docker image
pre-build from Docker hub with "automated build" option.

image name **d3fk/whalecome**

`docker pull d3fk/whalecome`

Docker hub repository: https://hub.docker.com/r/d3fk/whalecome/


## Available tags
- d3fk/whalecome:latest this image makes use of ENTRYPOINT and CMD
- d3fk/whalecome:cmd this image makes use of CMD only


## Basic usage

```sh
docker run d3fk/whalecome
```

## whalecome learning steps 

0. basic:
-- View avail
```sh
docker --help
```

1. basic run of a container:
```sh
docker run d3fk/whalecome
```
2. containers stop when their running process ends
```sh
docker ps
```
shows nothing
```sh
docker ps -f "status=exited"
```
shows our container stopped

3. Trying to understand how the image of the container was build
```sh
docker history d3fk/whalecome
```
We can see the different instructions that were used to build the intermediary layers of the image
to get the complete instructions used by each layer use
```sh
docker history --no-trunc d3fk/whalecome
```

4. interacting with the container by overwitting the CMD instruction
```sh
docker run d3fk/whalecome world !
```
The unicorn now says "Hello world ! !"

5. interacting with the container by changing an ENV variable
-- Changing the default message for a 'Hello World !'
```sh
docker run --env MESSAGE='Hello World !' d3fk/whalecome
```
6. bis interacting with the container by changing an ENV variable
-- This whale is too gentle we need a more serious whale:
```sh
docker run d3fk/whalecome world !
```

5. making d3fk/whalecome container pending by changing the CMD
```sh
docker run d3fk/whalecome tail -f /dev/null
```
our command is stuck waiting the end of process: we need to open a new console
```sh
docker ps
```
we can see our container running

```sh
docker ps -a 
```
We can see our running and stopped containers

4. enter into
5. 
6.


[![GitHub license](https://img.shields.io/github/license/Angatar/whalecome)](https://github.com/Angatar/whalecome/blob/master/LICENSE)

