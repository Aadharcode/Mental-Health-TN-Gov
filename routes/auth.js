const express = require("express");
const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middleware/auth");
const signup = require("../controllers/signup");
const signin = require("../controllers/signin");
const tokenIsValid = require("../middleware/tokenIsValid");
const getData = require("../middleware/getData");
require('dotenv').config();

authRouter.post("/api/signup", signup);   // Sign Up
authRouter.post("/api/signin", signin);   // Sign In
authRouter.post("/tokenIsValid", tokenIsValid);   // Token validation
authRouter.get("/", auth, getData);  // get user data

// Sign Up
// authRouter.post("/api/signup", async (req, res) => {
//   try {
//     const { name , school , email, password } = req.body;

//     const existingUser = await User.findOne({ email });
//     if (existingUser) {
//       return res
//         .status(400)
//         .json({ msg: "User with same email already exists!" });
//     }

//     const hashedPassword = await bcryptjs.hash(password, 10);

//     let user = new User({
//       email,
//       name,
//       school,
//       password: hashedPassword,
//     });
//     user = await user.save();
//     res.json(user);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// Sign In

// authRouter.post("/api/signin", async (req, res) => {
//   try {
//     const { email, password } = req.body;

//     const user = await User.findOne({ email });
//     if (!user) {
//       return res
//         .status(400)
//         .json({ msg: "User with this email does not exist!" });
//     }

//     const isMatch = await bcryptjs.compare(password, user.password);
//     if (!isMatch) {
//       return res.status(400).json({ msg: "Incorrect password." });
//     }

//     const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
//     res.json({ token, ...user._doc });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// authRouter.post("/tokenIsValid", async (req, res) => {
//   try {
//     const token = req.header("x-auth-token");
//     if (!token) return res.json(false);
//     const verified = jwt.verify(token, process.env.JWT_SECRET);
//     if (!verified) return res.json(false);

//     const user = await User.findById(verified.id);
//     if (!user) return res.json(false);
//     res.json(true);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// get user data
// authRouter.get("/", auth, async (req, res) => {
//   const user = await User.findById(req.user);
//   res.json({ ...user._doc, token: req.token });
// });

module.exports = authRouter;