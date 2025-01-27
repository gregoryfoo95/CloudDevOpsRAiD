# Use Node.js as the base image
FROM node:18

# Environment variable for the server port
ENV SERVER_PORT=3001

# Set the working directory
WORKDIR /app

# Install dependencies first to optimize builds
COPY package*.json ./
RUN npm install

# Install nodemon globally for live reloading
RUN npm install -g nodemon

# Expose the application port
EXPOSE ${SERVER_PORT}

# Start the server with nodemon
CMD ["nodemon", "--watch", ".", "server.ts"]
