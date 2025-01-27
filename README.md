# Setting Up Husky, ESLint, and Jest for Your TypeScript Project ✨

This guide walks you through the step-by-step process of setting up **Husky**, **ESLint**, **Prettier** and **Jest** for a TypeScript project. These tools help ensure code quality and maintainability while enforcing consistent coding standards. 🛠️

---

## Prerequisites 🧰

Make sure you have the following installed:

- [Node.js](https://nodejs.org/) (with npm or Yarn)
- Git

---

## Step 1: Fork the Repository 🚀

Start by forking the repository that already contains the Express and TypeScript setup:

1. Visit the repository URL and click the **Fork** button.
2. Clone your forked repository to your local machine:

```bash
git clone <your-forked-repo-url>
cd <repository-name>
```

3. Install the dependencies:

```bash
npm install
```

Your project is now ready with a pre-configured Express and TypeScript setup. 📦

---

## Step 2: Install Additional Dependencies 🛒

Ensure you have the necessary additional dependencies for linting, testing, and Git hooks:

### ESLint

Install ESLint and TypeScript-specific ESLint plugins:

```bash
npm install eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin --save-dev
```

### Jest

Install Jest along with TypeScript support:

```bash
npm install jest @types/jest ts-jest --save-dev
```

### Husky

Install Husky to manage Git hooks:

```bash
npm install husky --save-dev
```

### Optional: Prettier

For consistent code formatting, consider using Prettier:

```bash
npm install prettier eslint-config-prettier eslint-plugin-prettier --save-dev
```

---

## Step 3: Configure ESLint 🧹

```javascript
module.exports = {
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: "module",
  },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier",
  ],
  rules: {
    // Add custom rules here
  },
};
```

---

## Step 4: Configure Jest ✅

Ensure Jest is configured in the `jest.config.js` file. If it is not present, create one with the following content:

```javascript
module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  moduleFileExtensions: ["ts", "js"],
  testMatch: ["**/__tests__/**/*.test.ts"],
  transform: {
    "^.+\.ts$": "ts-jest",
  },
};
```

Add the following script to your `package.json` if not already present:

```json
"scripts": {
  "test": "jest"
}
```

---

## Step 5: Set Up Husky 🐶

### Enable Git Hooks

Run the following command to set up Husky:

```bash
npx husky install
```

This creates a `.husky/` directory. 📁

### Add a Pre-Commit Hook

To run ESLint checks before each commit, add a pre-commit hook:

```bash
npx husky add .husky/pre-commit "npm run lint"
```

### Add a Commit Message Hook

To ensure commit messages follow a consistent style, you can add a commit-msg hook:

```bash
npx husky add .husky/commit-msg "npx --no-install commitlint --edit $1"
```

---

## Step 6: Add ESLint and Test Scripts 🛠️

Update your `package.json` scripts to include:

```json
"scripts": {
  "lint": "eslint . --ext .ts",
  "test": "jest",
  "build": "tsc",
  "prepare": "husky install"
}
```

---

## Step 7: Verify the Setup 🔍

### Run ESLint

Check for linting issues:

```bash
npm run lint
```

### Run Tests

Run your tests using Jest:

```bash
npm test
```

### Test Pre-Commit Hook

Make a change, stage it, and commit. The pre-commit hook should run ESLint before allowing the commit.

```bash
git add .
git commit -m "Test commit"
```

---

## Additional Tips 💡

- Customize your `.eslintrc.js` file to match your project's coding standards.
- Use Prettier along with ESLint for consistent code formatting.
- Keep your `jest` tests up-to-date to ensure code reliability.

With these tools set up, your TypeScript project will maintain high code quality and consistency, enabling better collaboration and fewer bugs. Happy coding! 🎉
