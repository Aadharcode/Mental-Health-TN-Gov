const { Psychiatrist, Teacher, Student, School, Admin, Ms } = require("../models/user");

const deleteUser = async (req, res) => {
  try {
    let { role, email } = req.body;

    // Validate required fields
    if (!role || !email) {
      return res.status(400).json({ msg: "Please provide both role and uniqueField." });
    }
    // Transform username based on role
    if (role === "teacher") {
        email = email.charAt(0).toUpperCase() + email.slice(1).toLowerCase();
        console.log("Transformed teacher username:", email);
    } else if (role === "psychiatrist") {
        email = email.toUpperCase();
        console.log("Transformed psychiatrist username:", email);
    }else if (role === "admin" || role === "ms") {
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
      case "psychiatrist":
        userModel = Psychiatrist;
        break;
      case "hs-ms":
        userModel = School;
        break;
      case "ms":
        userModel = Ms;
        break;
      default:
        return res.status(400).json({ msg: "Invalid role specified!" });
    }
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
      case "psychiatrist":
        query = { district: email }; // Psychiatrists identified by district
        break;
      case "admin":
        query = { email }; // Admins identified by email
        break;
      case "ms":
        query = { email }; // MSs identified by email
        break;
    }
    // Find the user by uniqueField
    const user = await userModel.findOne(query);
    console.log("User retrieved:", user);
    if (!user) {
      return res.status(404).json({ msg: "User not found." });
    }

    // Delete the user
    await userModel.deleteOne({ _id: user._id });

    res.status(200).json({ msg: `${role.charAt(0).toUpperCase() + role.slice(1)} deleted successfully.` });
  } catch (err) {
    console.error("Error deleting user:", err);
    res.status(500).json({ msg: "An error occurred while deleting the user.", error: err.message });
  }
};

module.exports = deleteUser;