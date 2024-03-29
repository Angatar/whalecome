![Docker Pulls](https://img.shields.io/docker/pulls/d3fk/whalecome) ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/d3fk/whalecome) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/d3fk/whalecome) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/d3fk/whalecome) ![Docker Stars](https://img.shields.io/docker/stars/d3fk/whalecome) [![GitHub license](https://img.shields.io/github/license/Angatar/whalecome)](https://github.com/Angatar/whalecome/blob/master/LICENSE)
# whalecome (Angatar> d3fk/whalecome)
A small container (alpine based) to serve as training material for training classes on Docker (ProDev, CESAR, CNRS DR12) with almost no code (text/ascii files are mainly manipulated).

It contains a few additional packages + a small sh script that displays a Whalecome message and allows the user to display a "Hello world!" in different ways.

Through the use of this container in its 2 versions (cf available tags) the user/student is invited to understand:
- basic docker run commands
- the containers lifecycles: run, stop, start, rm
- how to make a container continues running by using a pending command
- basic docker exec commands
- how to get information on a container image layers by using docker history
- the use of CMD in Dockerfile
- interactions with the container through CMD on run
- the use of ENTRYPOINT in Dockerfile
- interactions with the container by overriding the entrypoint on run
- the use of ENV
- interactions with the container by overriding the ENV variables on run
- how to use docker inspect to get information
- copy content from a container
- the use of volumes to add contents to the container
- the use of images tags
- how to clean the mess: remove stopped containers, unused images ...
- how to build his own image from an existing image


## Docker image
pre-build from Docker hub with "automated build" option.

image name **d3fk/whalecome**

`docker pull d3fk/whalecome`

Docker hub repository: https://hub.docker.com/r/d3fk/whalecome/


## Available tags
- **d3fk/whalecome:latest** this image makes use of ENTRYPOINT and CMD
- **d3fk/whalecome:master** this image is simply another tag for **d3fk/whalecome:latest**, they are identical images
- **d3fk/whalecome:cmd** this image makes use of CMD only


## Basic usage

```sh
docker run d3fk/whalecome
```

## Initiation to Docker: learning steps

0. **basics**

  - **View available commands**
  ```sh
  docker --help
  ```

  - **View subcommands details**
  ```sh
  docker {command} --help
  ```
  e.g:

  ```sh
  docker run --help
  ```

1. **basic run of a container**
```sh
docker run d3fk/whalecome
```
Note: if no image tag is mentioned, the **:latest** image tag is automatically used

2. **containers stop when their running process ends**
```sh
docker ps
```
...shows nothing
```sh
docker ps -f "status=exited"
```
...shows our container that is stopped

3. **Trying to understand how the image of the container was created**
```sh
docker history d3fk/whalecome
```
We can see the different instructions that were used to build the intermediary layers of the image.

To get the complete instructions used by each layer, use

```sh
docker history --no-trunc d3fk/whalecome
```

4. **interacting with the container by overriding the CMD instruction**
```sh
docker run d3fk/whalecome world !
```
The unicorn now says "Hello world ! !"

5. **interacting with the container by changing an ENV variable**
    - Changing the default message for a 'Hello World !'
```sh
docker run --env MESSAGE='Hello World !' d3fk/whalecome
```
5. **bis: interacting with the container by changing another ENV variable**
    - This whale is too gentle, we need a more serious whale:
```sh
docker run --env WHALE_DRAWN=serious_whale.ascii d3fk/whalecome serious whale !
```

6. **importing data: first use of volumes**
The serious whale do not looks like the official Docker whale:

It seems the file is well in this repo but not in the container:
  - 0. **Create a whalecome dir and cd into it**
  - 1. **We need to get the file from the repo:**
  As you have docker installed you are at 1 docker command to run any containerized program that run on Linux (since we are only using Linux container in this training class) ... so you also can use a containerized git
  ```sh
  docker run --name git alpine/git clone https://github.com/Angatar/whalecome
  ```
  Note that we have used the --name option here to give a name to our container

  - 2. **Great! It says ```Cloning into 'whalecome'...``` but where is my cloned repo?**
  Answer: it is into "the container" (namely git), as a property of containers is to be isolated and can't have access by default to the host's file system.

  A Bind mount of the host path into the container would have permit to get the cloned repo in our file system

  - 3. **Do we need to make use of volumes or bind mounts to get the repo in our file system?**
  Usually yes(cf alpine/git description), but in this case NO since we only need to get 1 file from this repo.

  We are going to copy it from the stopped container... but we need to have more information
  ```sh
  docker history alpine/git
  ```
  ... the image history says that the the workdir is /git so we can expect to find our cloned repo in /git/whalecome/

  ```sh
  docker cp git:/git/whalecome/docker_whale.ascii .
  ```
  Note that having named our container allows us to call it with its known name... otherwise the container ID or its random Name should have been retrieved from ```docker ps -a``` to be used here.

  - 4. **Use a bind mount to import data into a container**
  The file is now on your host file system and we are going to use a bind mount to mount it into our d3fk/whalecome container.

  Let say the Docker whale is also a gentle whale
  ```sh
  docker run -v $(pwd)/docker_whale.ascii:gentle_whale.ascii d3fk/whalecome docker whale !
  ```
  Note: in PowerShell replace `$(pwd)/` by `${pwd}\`

  - 4. **bis** use a volume to add content in the container
  The history of the alpine/git repo also shows that an unnamed volume is automatically created when running the alpine/git container.

  Lets see if we can use this volume
  ```sh
  docker inspect git
  ```
  As it is an unnamed volume a random name is generated by Docker ... get this name in the section
  ```sh
  "Mounts":[
    {
       "Type": "volume",
               "Name": "28100632badb865e174533cfe00e9d40300d0c1364b5ff8372582394606a77ef",
  ...
  ```
  For reading purpose of the next docker command we'll define here a shell var (use the name of your volume as value)
on Linux shell
  ```sh
  GIT_VOLUME="28100632badb865e174533cfe00e9d40300d0c1364b5ff8372582394606a77ef"
  ```
  or on PowerShell an env var
  ```sh
  $ENV:GIT_VOLUME="28100632badb865e174533cfe00e9d40300d0c1364b5ff8372582394606a77ef"
  ```
  Then we can run a new container with the GIT_VOLUME mounted where we want

  ```sh
  docker run -v $GIT_VOLUME:/repo/ --env WHALE_DRAWN='/repo/whalecome/docker_whale.ascii' d3fk/whalecome docker whale !
  ```
  on PowerShell replace `$GIT_VOLUME` by `${ENV:GIT_VOLUME}`

  Volumes can only be fully mounted in the container but you can choose their destinations.

7. **Wait a minute! Have a look at our stopped containers, we need to clean this mess before going further!**
  - 0. **display all containers**
  ```sh
  docker ps -a
  ```
  - 1. **clean all the stopped containers**
  ```sh
  docker rm  $(docker ps -aq -f "status=exited")
  ```
  Note:```docker rm -f (...``` would also force all running containers to stop and remove them)

  ...If you have a recent docker-engine use the container manager (you can use -f to not have the confirmation prompt):
  ```sh
  docker container prune
  ```
  Why prune?: because it is well known that the prunes help to clean the system ;)

  - 2. **and the volumes?**
  ```sh
  docker volume ls
  ```
  You can remove the volumes you want by using
  ```sh
  docker volume rm VOLUME_NAME
  ```
  Note: Several volume names can be listed for removal

  You can also use the prune to remove all unused local Volumes
  ```sh
  docker volume prune -a
  ```
  - 3. **and the images?**
  as well ... to list them
  ```sh
  docker images
  ```
  ... and to remove all images (the -f force removal)

  ```sh
  docker rmi -f $(docker images -q)
  ```

  If you have a docker engine with image manager there is also a prune option to remove unused images only
  ```sh
  docker image prune -a
  ```
  Note "image" here instead of image**s** (the -f here will only avoid prompt)

8. **You've lost your d3fk/whalecome image? Don't worry we can download it or update it by pull**
```sh
docker pull d3fk/whalecome
```
Does it still work?

Note: To avoid to have to clean too often our stopped containers we'll now use the --rm option of the run command)
```sh
docker run --rm d3fk/whalecome again
```

9. **The container default entrypoint can be overriden on run**
```sh
docker run --rm --entrypoint echo d3fk/whalecome I can take control ...
```

10. **docker images can exists in different versions (tag)**
The d3fk/whalecome:cmd images do not makes use of an entrypoint but only CMD, allowing you to override easily the default CMD by passing a command after the name of the container
```sh
docker run --rm d3fk/whalecome:cmd figlet -k Docker rocks !
```

11. **making d3fk/whalecome:cmd container pending by changing the CMD**
```sh
docker run --rm -d --name whalecome d3fk/whalecome:cmd tail -f /dev/null
```
Note the **-d** option (detach) otherwise our command would have been stuck waiting the end of process: ( in that case you would have need to open a new console)
Note the **--name** option
```sh
docker ps
```
We can see our container running ... it will run until its process ends (tail -f)

12. **Interacting with a running container**
It is possible to interact/enter into a running container with the "docker exec" command e.g.

```sh
docker exec whalecome ls
```
**whalecome**, here, is the name of the running container and not the image

We can see the content of the WORKDIR (/files)

We could also break into the container with a shell terminal

```sh
docker exec -it whalecome sh
```
Note the **-it** options that means respectively interactive(allow stdin) and terminal (including session and prompt)
You are in a shell terminal into the  and see the process running into the container

```sh
$ ps
```
and kill the running process which would stop the container and as the --rm option was provided to the run command the container would be completely removed

The normal cycle of the container is run, stop, start (restart) the stopped container, and finally be removed

to exit the container's terminal, type
```sh
$ exit
```

stop the container
```sh
docker stop whalecome
```

Check that no container remains either running or stopped

13. **Create your own container image**
In order to create your own whalecome image you have to create a Dockerfile that will detail how the image will be created.
...Guess what you can use to edit the Dockerfile ... docker, of course (e.g.: the busybox container contains a set of lightweight linux tools, including one of the best code editor ever = vi )
```sh
docker run -v $(pwd):/tmp -w /tmp -it busybox vi Dockerfile
```
Note: in PowerShell replace `$(pwd)/` by `${pwd}\`
Note2: we are using -v to create a bind mount with the current host's directory to /tmp in the container
Note3: as busybox does not declare a workdir, we use the **-w** option to define it ... at the same place we have created the bind mount in the container so that our command passed to the container will take effect in this directory = in our current directory
... if you are not comfortable with vi/vim, you can of course use your favorite code editor.

Add to the files the following instructions to the Dockerfile (feel free to adapt to your needs)
```dockerfile
FROM d3fk/whalecome:cmd
COPY docker_whale.ascii /files/
ENV MESSAGE="Whalecome among Docker users !"
ENV FONT_NAME="big"
ENV WHALE_DRAWN=docker_whale.ascii
```
Our image starts from the container indicated in the **FROM** line and so it will inherit of its characteristics.
We only overwritte or add instructions to addapt our container from the **FROM** image.
type ```:wq``` to save and quit 'vi' and so exit the container(since the pending process will end)

In order to build your image you'll have to use ```docker build``` command
```sh
docker build -t whalecome:me .
```
Great! you have created your first docker image(a whalecome image with the tag **me**), it is stored with your local images; to list them type
```sh
docker images
```
or
```sh
docker image ls
```

You can now use **your own** whalecome image
```sh
docker run --rm whalecome:me
```

In case you wish to add your image to a docker registry (public or private) you will need to log in with your credential by using
```sh
docker login
```
The local image you will share on the registry also needs to be named properly to be placed in **your** repository on the registry

```sh
docker tag whalecome:me (REGISTRY/PATH/USER_ID)/whalecome:me
```
If you are using the default public registry (Docker Hub) the ```USER_ID/whalecome:me``` information is sufficient.

Note: the **:tag** information of the image is not compulsory, it case it is not indicated, the **:latest** tag is automatically attributed to the image.

Now push it to share it on your registry
```sh
docker push (REGISTRY/PATH/USER_ID)/whalecome:me
```
----
## CONGRATULATION!
You are ready for the next level :)

We have now enough explored the d3fk/whalecome containers, lets now see another one :"d3fk/asciinematic"



[![GitHub license](https://img.shields.io/github/license/Angatar/whalecome)](https://github.com/Angatar/whalecome/blob/master/LICENSE)

