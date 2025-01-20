# Stage 1: Build React App
FROM node:18 AS build-stage

# Set working directory
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install ALL dependencies including web-vitals
RUN npm install web-vitals
RUN npm install

# Copy the rest of the application
COPY . .

# Build React app
RUN npm run build

# Stage 2: Production with Nginx
FROM nginx:alpine

# Copy built files from build stage
COPY --from=build-stage /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
