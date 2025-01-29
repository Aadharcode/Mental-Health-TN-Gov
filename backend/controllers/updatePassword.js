const jwt = require("jsonwebtoken");
const { Psychiatrist, Teacher, Student, School, Admin, Ms , ASA , CIF , RC , Warden } = require("../models/user");
const bcryptjs = require("bcryptjs");

const updatePasswords = async (req, res) => {
  try {
    console.log("Incoming req:", req.body);
    let { role, uniqueField, password } = req.body;
    if (!role || !uniqueField || !password) {
      return res.status(400).json({ msg: "Please provide all required fields (role, uniqueField, password)." });
    }
    // Transform uniqueField based on role
    if (role === "teacher") {
      uniqueField = uniqueField.charAt(0).toUpperCase() + uniqueField.slice(1).toLowerCase();
      console.log("Transformed teacher uniqueField:", uniqueField);
    } else if (role === "psychiatrist") {
      uniqueField = uniqueField.toUpperCase();
      console.log("Transformed psychiatrist uniqueField:", uniqueField);
    } else if (role === "admin" || role === "ms" || role ==="rc") {
      uniqueField = uniqueField.toLowerCase();
      console.log("Transformed admin/ms uniqueField:", uniqueField);
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
      case "psychiatrist":
        userModel = Psychiatrist;
        break;
      case "admin":
        userModel = Admin;
        break;
      case "ms":
        userModel = Ms;
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
    // Build the query based on the role
    let query;
    switch (role) {
      case "student":
        query = { student_emis_id: uniqueField }; // Students identified by EMIS ID
        break;
      case "teacher":
        query = { district: uniqueField }; // Teachers identified by district
        break;
      case "hs-ms":
        query = { udise_no: uniqueField }; // Schools identified by udise ID
        break;
      case "psychiatrist":
        query = { district: uniqueField }; // Psychiatrists identified by district
        break;
      case "admin":
        query = { email: uniqueField }; // Admins identified by email
        break;
      case "ms":
        query = { email: uniqueField }; // MSs identified by email
        break;
      case "asa":
        query = { mobile_number: uniqueField };
        break;
      case "cif":
        query = { mobile_number: uniqueField };
        break;
      case "rc":
        query = { email: uniqueField };
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
    // Hash the new password
    // const hashedPassword = await bcryptjs.hash(password, 10);

    // Update the user's password
    // user.password = hashedPassword;
    user.password = password;
    await user.save();

    console.log("Password updated successfully for user:", user);
    res.status(200).json({ msg: "Password updated successfully!" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = updatePasswords;