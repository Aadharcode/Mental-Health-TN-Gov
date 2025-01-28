const jwt = require("jsonwebtoken");
const { Psychiatrist, Teacher, Student, School, Admin, Ms , CIF , ASA , RC , Warden } = require("../models/user");
const bcryptjs = require("bcryptjs");

const signin = async (req, res) => {
  try {
    console.log("Incoming request body:", req.body); // Log the request body

    let { role, email, password } = req.body;

    if (!role || !email || !password) {
      return res.status(400).json({ msg: "Please provide all required fields (role, email, password)." });
    }

    // Transform username based on role
    if (role === "teacher") {
      email = email.charAt(0).toUpperCase() + email.slice(1).toLowerCase();
      console.log("Transformed teacher username:", email);
    } else if (role === "psychiatrist") {
      email = email.toUpperCase();
      console.log("Transformed psychiatrist username:", email);
    }else if (role === "admin" || role === "ms"|| role ==="rc") {
      email = email.toLowerCase();
      console.log("Transformed admin/ms username:", email);
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
      case "hs-ms":
        userModel = School;
        break;
      case "ms":
        userModel = Ms;
        break;
      case "psychiatrist":
        userModel = Psychiatrist;
        break;
      case "admin":
        userModel = Admin;
        break;
      case "asa":
        userModel = ASA;
        break;
      case "cif":
        userModel = CIF;
        break;
      case "rc":
        userModel = RC;
        break;
      case "warden":
        userModel = Warden;
        break;
      default:
        console.log("Invalid role specified:", role); // For debugging role
        return res.status(400).json({ msg: "Invalid role specified!" });
    }
    // console.log("Accessing collection for role:", role);
    let query;
    switch (role) {
      case "student":
        query = { student_emis_id: email }; // Students identified by EMIS ID
        break;
      case "teacher":
        query = { district: email }; // Teachers identified by district
        break;
      case "hs-ms":
        query = { udise_no: email }; // Schools identified by udise ID
        break;
      case "ms":
        query = { udise_no: email }; // Schools identified by udise ID
        break;
      case "psychiatrist":
        query = { district: email }; // Psychiatrists identified by district
        break;
      case "admin":
        query = { email }; // Admins identified by email
        break;
      case "ms":
        query = { email }; // MSs identified by email
        break;
      case "asa":
        query = { mobile_number: email }; // ASAs identified by mobile number
        break;
      case "cif":
        query = { mobile_number: email }; // CIFs identified by mobile number
        break;  
      case "rc":
        query = { email }; // CIFs identified by email
        break;
      case "warden":
        query = { mobile_number: email }; // ASAs identified by mobile number
        break;
    }
    console.log("Query being executed:", query); 
    // Find the user in the appropriate collection
    const user = await userModel.findOne(query);
    console.log("User retrieved:", user); // User retrieved
    if (!user) {
      console.log("User not found in collection:", role);
      return res.status(400).json({ msg: "User not found!" });
    }
    // user object to verify structure
    console.log("User object structure:", user);
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }
    // return res.status(400).json({ msg: "Done Password checking" });
    const token = jwt.sign({ id: user._id, role }, process.env.JWT_SECRET, { expiresIn: "1h" });
    // Send back the user data along with the token
    res.json({
      token,
      user,
    });
  } catch (e) {
    console.error("Error in signin process:", e);
    res.status(500).json({ error: e.message });
  }
};

module.exports = signin;
