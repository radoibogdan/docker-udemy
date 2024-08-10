# Link to tutorial: https://www.udemy.com/course/docker-and-kubernetes-the-complete-developers-guide/ 

# Important 
For windows use  wsl2 and activate in Docker Desktop in Settings->Ressources->Check Debian distro.

# Install Docker
https://docs.docker.com/desktop/install/windows-install/ 
https://www.youtube.com/watch?v=_9AWYlt86B8&t=487s 

### Check version docker + Kubernetes
docker -v
kubectl -v

### Start node project
node index.js

## Runs scripts in package.json “scripts => start”
npm run start

### SSH into container (/bin/bash or /bin/sh)
docker exec -it container_name /bin/bash

# Build Image
“t” is the tag name of the image
“.” specifies the place where the Dockerfile lives
docker build -t image_name .

### Build image using specific file for DEV environnement
docker build -t nodeapp:v3 -f Dockerfile.dev .

### List images
docker images

### List running docker containers
docker ps
docker container ls –all
 
### Run image + Port mapping
docker run --name container_name -p local_port:container_port image_name
docker run --name container_name -p 8000:3000 image_name
https://localhost:8000 

### Stop and then Delete container (stop it before removing it)
docker stop container_name
docker rm container_name container_name2



#Volume : Bind Mount : syncing code with container
“v“ is a volume called bind mount
###  Linux / Windows PowerShell
docker run --name container_name -p 8000:3000 -v ${pwd}:/usr/src/app image_name
### Windows cmd
docker run --name container_name -p 8000:3000 -v "path_project_in_qoutes":/usr/src/app image_name
### WSL/CMD DEBIAN 
docker run --name container_name -p 8000:3000 -v ${PWD}:/usr/src/app image_name

Ex: docker run --name my-app -p 8000:3000 -v ${PWD}:/usr/src/app nodeapp:v3
#Volume : Anonymous Volume
Run image but don’t overwrite files in the container 
### Anonymous volume => -v /usr/src/app/node_modules
This will create an empty node_modules folder in the local repository
docker run --name container_name -p 8000:3000 -v ${pwd}:/usr/src/app -v /usr/src/app/node_modules image_name

docker build -t nodeapp:v3 .
docker run --name my-node-app-v3 -p 8000:3000 -v ${PWD}:/usr/src/app -v /usr/src/app/node_modules nodeapp:v3
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

#Docker Ignore files
Ignore files that should not be copied to docker container (like the Dockerfile)
Create .dockerignore file at root lvl of project

