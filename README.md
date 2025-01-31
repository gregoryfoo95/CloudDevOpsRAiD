# 🛠️ Developer Setup Guide

A comprehensive guide to setting up development tools and workflows for your TypeScript project.

---

## 📚 Table of Contents

1. [Setting Up Husky](#1-setting-up-husky-🐕)
2. [GitHub Workflows](#2-github-workflows-🔄)
3. [Markdown Preview in VS Code](#3-markdown-preview-in-vs-code)

---

# 1. Setting Up Husky 🐕

## Prerequisites 📋

Before you begin, ensure you have:

- [Node.js](https://nodejs.org/) (with npm) ⚙️  
- Git 🌿  

---

## Installation Steps 📥

### Step 1: Fork & Clone 🔄

1. Fork the repository.
2. Clone your fork:

   ```bash
   git clone <your-forked-repo-url>
   cd <repository-name>
   ```

3. Install dependencies:

   ```bash
   npm install
   ```

---

### Step 2: Install Husky 🐶

Install Husky for managing Git hooks:

```bash
npm install husky --save-dev
```

---

### Step 3: Configure Husky ⚙️

Initialize Husky:

```bash
npx husky init
```

Add a pre-commit hook:

```bash
echo "npm run format && npm run lint" > .husky/pre-commit
```

---

### Step 4: Configure Scripts 📝

Update your `package.json` to include:

```json
{
  "scripts": {
    "build": "tsc",
    "build:watch": "tsc -w",
    "serve": "nodemon server.ts",
    "dev": "concurrently \"npm run build:watch\" \"npm run serve\"",
    "test:coverage": "jest --coverage --passWithNoTests",
    "lint": "eslint \"**/*.{js,jsx,ts,tsx}\"",
    "prepare": "husky install",
    "format": "prettier --write .",
    "test": "jest"
  }
}
```

Install additional dependencies:

```bash
npm install concurrently nodemon --save-dev
```

---

### Step 5: Verify Setup ✅

Test your configuration:

```bash
npm run lint    # Check linting
npm test        # Run tests
git add .       # Stage changes
git commit -m "Test commit"  # Test pre-commit hook
```

---

## Pro Tips 💡

- Customize `.eslintrc.js` for your coding standards 📐  
- Use Prettier with ESLint for consistent formatting ✨  
- Keep Jest tests up-to-date 🧪  

---

# 2. GitHub Workflows 🔄

## Automated CI Pipeline Setup 🚀

Create `.github/workflows/build-and-save-artifacts.yml`:

```yaml
name: Build and Save Artifacts

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code 📥
        uses: actions/checkout@v3

      - name: Setup Node.js ⚙️
        uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install dependencies 📦
        run: npm ci

      - name: Run tests with coverage 🧪
        run: npm run test:coverage

      - name: Upload coverage report 📊
        uses: actions/upload-artifact@v3
        with:
          name: coverage-report
          path: coverage/

      - name: Build project 🏗️
        run: npm run build

      - name: Upload build artifacts 📤
        uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: dist/
```

---

## Workflow Breakdown 📋

### 1. Trigger Events 🎯
- **Push**: Runs on pushes to the `main` branch.
- **Pull Requests**: Runs on pull requests targeting `main`.

---

### 2. Job Steps 📝

#### Step 1: Checkout Code 📥  
Clones the repository into the runner to access project files.

#### Step 2: Node.js Setup ⚙️  
Installs Node.js (`v18`) using `actions/setup-node@v3`.

#### Step 3: Install Dependencies 📦  
Runs `npm ci` for a clean installation based on `package-lock.json`.

#### Step 4: Run Tests with Coverage 🧪  
Executes tests and generates a coverage report using `npm run test:coverage`.

#### Step 5: Upload Coverage Report 📊  
Uploads the `coverage/` folder as a downloadable artifact.

#### Step 6: Build Project 🏗️  
Runs `npm run build` to generate production-ready assets in the `dist/` directory.

#### Step 7: Upload Build Artifacts 📤  
Uploads the `dist/` directory as a downloadable artifact.

---

### Benefits of This Workflow ✅

1. **Automation**: Ensures code quality and builds are consistent with every push or pull request.  
2. **Artifacts**: Provides downloadable coverage reports and built files for deployment or review.  
3. **Reusability**: Centralized CI/CD pipeline setup saves time and effort.  

---

### Next Steps 🔧

1. Save the workflow file in `.github/workflows/build-and-save-artifacts.yml`.  
2. Push code to see the workflow in action.  
3. Review logs and artifacts under the **Actions** tab in GitHub.  

---

# 3. Setting Up Docker 🐳

## Prerequisites 📋
Before starting, ensure you have:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed 🖥️
- Docker Engine running ⚙️

## Installation Steps 📥

### Step 1: Verify Docker Installation ✅
```bash
docker --version
```

### Step 2: Create Docker Configuration Files 📝

#### Create Dockerfile 📄
Create a `Dockerfile` in your project root:

```dockerfile
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
```

#### Create docker-compose.yml 📄
Create a `docker-compose.yml` in your project root:

```yaml
version: "3.8"

services:
  # Database Service 🗄️
  postgres:
    image: postgres:15
    container_name: postgres_container
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-myuser}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-mypassword}
      POSTGRES_DB: ${POSTGRES_DB:-mydatabase}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydatabase"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Application Service 🚀
  server:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: server_container
    environment:
      DATABASE_URL: postgres://myuser:mypassword@postgres:5432/mydatabase
      NODE_ENV: development
    ports:
      - "${SERVER_PORT:-3001}:3001"
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules
    working_dir: /app
    command: bash -c "npm install && nodemon --watch . --legacy-watch server.ts"

volumes:
  postgres_data:
    name: postgres_data
```

### Step 3: Running Docker Services 🚀

#### Start Services
```bash
# Build and start containers & run in detached mode
docker-compose up --build -d
```

#### Stop Services
```bash
docker-compose down
```

### Step 4: Verify Running Containers 🔍
```bash
# List running containers
docker ps

# View container logs
docker-compose logs -f
```

## Docker Configuration Breakdown 📋

### Dockerfile Explained 🔧
- `FROM node:18`: Uses Node.js v18 as base image
- `WORKDIR /app`: Sets working directory
- `COPY package*.json ./`: Copies package files for dependency installation
- `RUN npm install`: Installs dependencies
- `EXPOSE ${SERVER_PORT}`: Exposes application port
- `CMD ["nodemon", ...]`: Runs server with hot-reload

### docker-compose.yml Explained 🔧
- **Postgres Service** 🗄️
  - Uses PostgreSQL 15
  - Configurable through environment variables
  - Persistent data storage
  - Health checks for dependency management

- **Server Service** 🚀
  - Built from local Dockerfile
  - Connected to PostgreSQL
  - Volume mapping for live code updates
  - Hot-reload enabled

## Pro Tips 💡
- Use `.dockerignore` to exclude unnecessary files 📝
- Set up environment variables in `.env` file 🔐
- Monitor container health with `docker stats` 📊
- Use `docker-compose logs` for debugging 🔍

## Troubleshooting 🔧

### Common Issues and Solutions ⚠️

1. **Port Conflicts** 🔌
   ```bash
   # Check ports in use
   lsof -i :<port-number>
   
   # Kill process using port
   kill $(lsof -t -i:<port-number>)
   ```

2. **Container Access** 🖥️
   ```bash
   # Access container shell
   docker exec -it <container-name> bash
   
   # View container logs
   docker logs <container-name>
   ```

3. **Volume Issues** 💾
   ```bash
   # List volumes
   docker volume ls
   
   # Clean unused volumes
   docker volume prune
   ```

---

Happy Containerizing! 🎉
With this setup, your TypeScript project will maintain high standards and efficient workflows. 🚀✨

