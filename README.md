```markdown
# Ionic Capacitor with Docker

This guide explains how to set up Docker support for an Ionic Capacitor project, including optional Docker Compose usage.

---

## 1. Prepare Your Ionic Capacitor Project
First, create a new Ionic project and enable Capacitor integration:

```bash
ionic start myApp blank --type=angular
cd myApp
ionic integrations enable capacitor
```

---

## 2. Add Docker Support

### Step 1: Create a Dockerfile
In the root directory of your project, create a `Dockerfile`. Below is an example of a basic Dockerfile for an Ionic Capacitor app:

```Dockerfile
# Use Node.js as the base image
FROM node:alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the project files into the container
COPY . .

# Build the Ionic app
RUN npm run build

# Use Nginx to serve the built app
FROM nginx:alpine

# Copy the built app from the build stage
COPY --from=build /app/www /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
```

---

### Step 2: Create a `.dockerignore` File
To optimize the Docker image size, exclude unnecessary files by creating a `.dockerignore` file in the root directory with the following content:

```plaintext
node_modules
platforms
android
ios
build
```

---

## 3. Build and Run the Docker Container

### Step 1: Build the Docker Image
Build the Docker image with the following command:

```bash
docker build -t ionic-capacitor-app .
```

### Step 2: Run the Docker Container
Run the Docker container and map port 8080 to port 80:

```bash
docker run -p 8080:80 ionic-capacitor-app
```

The app will now be accessible at:

```plaintext
http://localhost:8080
```

---

## 4. Optional: Add Docker-Compose
To simplify the build and run process, you can use `docker-compose`. Create a `docker-compose.yml` file with the following content:

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:80"
```

Run the app using Docker Compose:

```bash
docker-compose up --build
```

---

1. Clean Up Unused Docker Images, Containers, Volumes, and Networks
To remove all unused images, containers, volumes, and networks (dangling resources), use the following command:

docker system prune -a
This will:

Remove all stopped containers
Remove all unused networks
Remove all dangling images (images not tagged or not used by any container)
Remove all unused volumes (volumes that are not referenced by any containers)
Warning: This will delete a lot of data, including unused images, which might take up considerable space.

2. Remove Only Dangling Images
To remove dangling (unused) images only (images that are not associated with a container):

docker image prune
To also remove unused images (not just dangling images), use the -a flag:

docker image prune -a
3. Remove Unused Containers
To remove stopped containers:

docker container prune
4. Remove Unused Volumes
To remove unused volumes:

docker volume prune
5. Remove Unused Networks
To remove unused networks:

docker network prune
6. Remove All Unused Data
If you want to ensure that everything unused is removed, you can use the following:

docker system prune --volumes
This will remove all unused containers, networks, images, and volumes.

## Summary
- Use Docker to containerize your Ionic Capacitor app.
- Serve the app using Nginx inside a Docker container.
- Optionally, use Docker Compose for simplified management.

Enjoy building your Ionic Capacitor project with Docker!
```
