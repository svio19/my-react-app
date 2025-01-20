# Stage 1: Build React App
FROM node:18 AS build-stage

# Set working directory inside the container
WORKDIR /app

# Copy React app files
COPY client/package.json client/package-lock.json ./client/
RUN cd client && npm install

COPY client ./client
RUN cd client && npm run build

# Stage 2: Set Up Node.js Server and Serve React App
FROM node:18 AS production-stage

# Set working directory inside the container
WORKDIR /app

# Copy server files
COPY server/package.json server/package-lock.json ./server/
RUN cd server && npm install

# Copy built React app from Stage 1 to the public directory in the server
COPY --from=build-stage /app/client/build ./server/public

# Expose the server port
EXPOSE 3000

# Start the Node.js server
CMD ["node", "server/index.js"]
