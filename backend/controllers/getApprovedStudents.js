const { Student } = require("../models/user");  

const getApprovedStudents = async (req, res) => {
  try {
    const approvedStudents = await Student.find({ approval: true });

    if (!approvedStudents || approvedStudents.length === 0) {
      return res.status(404).json({ msg: "No approved students found." });
    }

    res.status(200).json({
      msg: "Approved students fetched successfully.",
      data: approvedStudents,
    });
  } catch (err) {
    console.error("Error fetching approved students:", err);
    res.status(500).json({
      msg: "An error occurred while fetching approved students.",
      error: err.message,
    });
  }
};

module.exports = getApprovedStudents;
