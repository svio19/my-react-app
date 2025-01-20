# Stage 1: Build React App
FROM node:18 AS build-stage

# Set working directory
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build React app
RUN npm run build

# Stage 2: Production
FROM node:18 AS production-stage

WORKDIR /app

# Copy built files from build stage
COPY --from=build-stage /app/build ./build

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm install --production

# Expose port
EXPOSE 3000

# Start the server
CMD ["npm", "start"]
