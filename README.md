# Link to tutorial: https://www.udemy.com/course/docker-and-kubernetes-the-complete-developers-guide/ 

# Important 
For windows use  wsl2 and activate in Docker Desktop in Settings->Ressources->Check Debian distro.

# Install Docker
https://docs.docker.com/desktop/install/windows-install/ 
https://www.youtube.com/watch?v=_9AWYlt86B8&t=487s 

### Check version docker + Kubernetes
```docker -v```  
```kubectl -v```

### Start node project
```node index.js```

## Runs scripts in package.json “scripts => start”
```npm run start```

### SSH into container (/bin/bash or /bin/sh)
```docker exec -it container_name /bin/bash```

# BUILD Image
“t” is the tag name of the image
“.” specifies the place where the Dockerfile lives
```docker build -t image_name .```

### Build image using specific file for DEV environnement
```docker build -t nodeapp:v3 -f Dockerfile.dev .```

### List images
```docker images```

### DELETE image
```docker image rm image_name ```

### List running docker containers
```docker ps```  
```docker container ls –all```
 
### CREATE CONTAINER : Run image + Port mapping
```docker run --name container_name -p local_port:container_port image_name```  
```docker run --name container_name -p 8000:3000 image_name```  
https://localhost:8000 

### STOP and then DELETE container (stop it before removing it)
```docker stop container_name```  
```docker rm container_name container_name2```

#Volume : Bind Mount : syncing code with container
“v“ is a volume called bind mount
###  Linux / Windows PowerShell
```docker run --name container_name -p 8000:3000 -v ${pwd}:/usr/src/app image_name```
### Windows cmd
```docker run --name container_name -p 8000:3000 -v "path_project_in_qoutes":/usr/src/app image_name```
### WSL/CMD DEBIAN 
```docker run --name container_name -p 8000:3000 -v ${PWD}:/usr/src/app image_name```

Ex: docker run --name my-app -p 8000:3000 -v ${PWD}:/usr/src/app nodeapp:v3
#Volume : Anonymous Volume
Run image but don’t overwrite files in the container 
### Anonymous volume => -v /usr/src/app/node_modules
This will create an empty node_modules folder in the local repository
```docker run --name container_name -p 8000:3000 -v ${pwd}:/usr/src/app -v /usr/src/app/node_modules image_name```

```docker build -t nodeapp:v3 .```
```docker run --name my-node-app-v3 -p 8000:3000 -v ${PWD}:/usr/src/app -v /usr/src/app/node_modules nodeapp:v3```
https://github.com/microsoft/WSL/issues/6255 

# Nodemon
Dependency to see changes in the browser without restarting the Node.js server
Add it in package.json

# Dockerfile vs Dockerfile.dev
Create Dockerfile.dev file for the DEV environnement.  
The only difference is the start:dev
CMD ["npm", "run", "start:dev"]  
When we build the image we specifiy we want to use the .dev file.  
docker build -t nodeapp:v3 -f Dockerfile.dev .  

# Docker Ignore files
Ignore files that should not be copied to docker container (like the Dockerfile)  
Create .dockerignore file at root lvl of project

# Control Plane
## Install Control Plane
https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl
https://docs.controlplane.com/reference/cli
``` nvm install --lts ```  
``` npm install -g @controlplane/cli ```  

## Push image to control plane
https://docs.controlplane.com/guides/push-image
### Create and configure profile
``` cpln profile login ```  
``` cpln profile update default --org bogdan ```  
``` cpln profile update default --gvc default ```  
``` cpln profile set-default default ```  

### Connect
``` cpln image docker-login --org ORG_NAME ```  

### Build and push
```docker build -t bogdan.registry.cpln.io/nodeapp:v1 .```  
```docker push bogdan.registry.cpln.io/nodeapp:v1```


# Building a MULTI container app (React, NodeJs + Mongo DB)

## Mongo DB Container
This will create a MongoDB container with a mongo image downloaded from DockerHub
```docker run mongo```
--rm    => will remove the container after you stop using it
-d      => deamon mode
--name  => give a name
```docker run --name mongodb -d --rm mongo``` 

## NodeJs Backend Container 
``` docker build -t todoapp . ```
``` docker run --name todo-app todoapp ```

## Connect MongoDB container with NodeJS Container
```docker run --name mongodb -d --rm -p 27017:27017 mongo ```

Inspect mongodb container to search for IP so as to connect the 2 containers
```docker container inspect mongodb ```

Create network
```docker network create todo-net ```

List networks
```docker network ls ```

Create mongodb container and Add it to the network
```docker run --network todo-net --name mongodb -d --rm mongo ```

Create backend nodejs app container and Add it to the network
```docker run --network todo-net --name todo-app --rm -p 8000:8000 todoapp ```

Create frontend ReactJS and Add it to the network
it => interactive mode flag for ReactApp
```docker build -t frontend . ```
```docker run -name frontend-todo --rm -p 3000:3000 -it frontend ```

## ADD HOT reload (live update of local folder with container)
### DB container
Use a named volume DOCKERDB
/data/db is the directory where the database is the mongodb container (we can't choose it)
```docker run --name mongodb --network todo-net -v DOCKERDB:/data/db mongo ```

### Back end container
```docker run --name todo-app --rm -p 8000:8000 --network todo-net -v ${PWD}/src:/app/src todoapp ```

### Front end container
```docker run --name react-todo --rm -it -p 3000:3000 -v ${PWD}/src:/app/src frontend ```

