# Specify a base image
FROM node:alpine

# Create directory inside container
WORKDIR /usr/src/app

# CACHE OPTIMIZATION
## By doing this we avoid doing the npm install if we change the code
## Together with the next step, these 2 steps will be executed only on package.json change
COPY ./package.json .

# CACHE OPTIMIZATION
RUN npm install

# Copy everything in this directory in the WORKDIR of the container
COPY . .

# Run the application on this port
EXPOSE 3000

# When its done building the image it will run command "npm run start"
CMD ["npm", "run", "start"]