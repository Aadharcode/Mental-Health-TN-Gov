const express = require("express");
const authRouter = express.Router();
const auth = require("../middleware/auth");
//const signup = require("../controllers/signup");
const createTeacher = require("../controllers/createTeacher");
const signin = require("../controllers/signin");
const tokenIsValid = require("../middleware/tokenIsValid");
const getData = require("../middleware/getData");
const createStudent = require("../controllers/createStudent");
const createSchool = require("../controllers/createSchool");
const createPsychiatrist = require("../controllers/createPsychiatrist");
const updateRedflags = require("../controllers/redflag");
const handleApproval = require("../controllers/approve");
require('dotenv').config();

//authRouter.post("/api/signup", signup);   // Sign Up
//authRouter.post("/create-user", createUser);  //Creating user
authRouter.post("/api/signin", signin);   // Sign In
authRouter.post("/createTeacher", createTeacher);  // new Teacher user
authRouter.post("/createStudent", createStudent);  // new Student user
authRouter.post("/createSchool", createSchool); // new School
authRouter.post("/createPsychiatrist", createPsychiatrist); // new Psychiatrist user
authRouter.post("/api/redflags", updateRedflags); //Redflags API
authRouter.post("/api/approval", handleApproval); //Redflags Approval
authRouter.post("/tokenIsValid", tokenIsValid);   // Token validation
authRouter.get("/", auth, getData);  // get user data

module.exports = authRouter;