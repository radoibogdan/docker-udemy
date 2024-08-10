# Specify a base image
FROM node:alpine

# Create directory inside container
WORKDIR /usr/src/app

# CACHE OPTIMIZATION
COPY ./package.json .

# Command runned after COPY ?
RUN npm install

# Copy everything in this directory in the WORKDIR of the container
COPY . .

# Run the application on this port
EXPOSE 3000

# When its done building the image it will run command "npm run start"
CMD ["npm", "run", "start"]