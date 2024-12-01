const { Psychiatrist, Teacher, Student, School, Admin } = require("../models/user");

const getData = async (req, res) => {
  try {
    const { id, role } = req.user;

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
      default:
        return res.status(400).json({ msg: "Invalid role!" });
    }

    // Fetch user details
    const user = await userModel.findById(id);
    if (!user) {
      return res.status(400).json({ msg: "User not found!" });
    }

    res.json({ ...user._doc, token: req.token });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = getData;
