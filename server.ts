import { Request, Response } from "express";

const express = require("express");
const app = express();

const serverPort = process.env.SERVER_PORT || 3000;

// Middleware to parse JSON
app.use(express.json());

// Define a route
app.get("/", (req: Request, res: Response) => {
  res.status(200).json("Hello, TypeScript with Express");
});

process.env.NODE_ENV !== "test" &&
  app.listen(serverPort, () => {
    // eslint-disable-next-line security-node/detect-crlf
    console.log("Server is running on port", serverPort);
  });

module.exports = app;
