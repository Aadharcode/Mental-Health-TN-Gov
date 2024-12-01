const express = require("express");
const authRouter = express.Router();
const auth = require("../middleware/auth");
const signup = require("../controllers/signup");
const signin = require("../controllers/signin");
const tokenIsValid = require("../middleware/tokenIsValid");
const getData = require("../middleware/getData");
require('dotenv').config();

//authRouter.post("/api/signup", signup);   // Sign Up
authRouter.post("/api/signin", signin);   // Sign In
authRouter.post("/tokenIsValid", tokenIsValid);   // Token validation
authRouter.get("/", auth, getData);  // get user data

module.exports = authRouter;