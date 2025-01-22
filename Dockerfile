# Step 1: Use Node.js to build the Ionic app
FROM node:16 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install -g @ionic/cli @capacitor/cli
RUN npm install

# Copy the app source code
COPY . .

# Build the Ionic app
RUN ionic build --prod

# Step 2: Use Nginx to serve the built app
FROM nginx:alpine

# Copy the build output to Nginx's default directory
COPY --from=build /app/www /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]