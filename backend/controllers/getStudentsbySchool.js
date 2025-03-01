const { Student } = require("../models/user");

const getStudentsBySchool = async (req, res) => {
  try {
    const { school_name } = req.body;
    if (!school_name) {
      return res.status(400).json({
        msg: "Please provide the school name.",
      });
    }
    const lowerSchoolName = school_name.toLowerCase();const students = await Student.find({
      school_name: { $regex: `^${lowerSchoolName}$`, $options: 'i' },
    });
    if (!students || students.length === 0) {
      return res.status(404).json({ msg: "No students found for the specified school." });
    }
    res.status(200).json({
      msg: "Students fetched successfully.",
      data: students,
    });
  } catch (err) {
    console.error("Error fetching students by school name:", err);
    res.status(500).json({
      msg: "An error occurred while fetching students.",
      error: err.message,
    });
  }
};

module.exports = getStudentsBySchool;