# Base image
FROM node:18

# Environment variables
ENV SERVER_PORT=3001

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Install global packages
RUN npm install -g nodemon

# Expose port
EXPOSE ${SERVER_PORT}

# Start command
CMD ["nodemon", "--watch", ".", "--legacy-watch", "server.ts"]