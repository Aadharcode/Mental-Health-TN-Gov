const jwt = require("jsonwebtoken");
const { Psychiatrist, Teacher, Student, School, Admin } = require("../models/user");
const bcryptjs = require("bcryptjs");

const signin = async (req, res) => {
  try {
    console.log("Incoming request body:", req.body); // Log the request body

    const { role, email, password } = req.body;

    if (!role || !email || !password) {
      return res.status(400).json({ msg: "Please provide all required fields (role, email, password)." });
    }

    // Select the appropriate model based on the role
    let userModel;
    switch (role) {
      case "student":
        userModel = Student;
        break;
      case "teacher":
        userModel = Teacher;
        break;
      case "hm":
        userModel = School;
        break;
      case "ms":
        userModel = School;
        break;
      case "psychiatrist":
        userModel = Psychiatrist;
        break;
      case "admin":
        userModel = Admin;
        break;
      default:
        console.log("Invalid role specified:", role); // Debug role
        return res.status(400).json({ msg: "Invalid role specified!" });
    }

    console.log("Accessing collection for role:", role); // Verify the collection based on role

    // Prepare the query based on the role
    let query;
    switch (role) {
      case "student":
        query = { student_emis_id: email }; // Students identified by EMIS ID
        break;
      case "teacher":
        query = { district: email }; // Teachers identified by mobile number
        break;
      case "hm":
        query = { udise_no: email }; // Schools identified by udise ID
        break;
      case "ms":
        query = { udise_no: email }; // Schools identified by udise ID
        break;
      case "psychiatrist":
        query = { district: email }; // Psychiatrists identified by district (update here)
        break;
      case "admin":
        query = { email }; // Admins identified by email
        break;
    }

    console.log("Query being executed:", query); // Log the query

    // Find the user in the appropriate collection
    const user = await userModel.findOne(query);
    console.log("User retrieved:", user); // Log the user retrieved

    if (!user) {
      console.log("User not found in collection:", role);
      return res.status(400).json({ msg: "User not found!" });
    }

    // Log the user object to verify the structure
    console.log("User object structure:", user);

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    // // Check if the password matches
    // if (user.password !== password) { // Use `Password` as it is in the DB
    //   return res.status(400).json({ msg: "Wrong password." });
    // }

    // Generate a JWT token
    const token = jwt.sign({ id: user._id, role }, process.env.JWT_SECRET, { expiresIn: "1h" });

    // Send back the user data along with the token
    res.json({
      token,
      user,
    });
  } catch (e) {
    console.error("Error in signin process:", e); // Log the error
    res.status(500).json({ error: e.message });
  }
};

module.exports = signin;
