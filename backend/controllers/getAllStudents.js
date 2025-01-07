const { Student } = require("../models/user"); 

const getAllStudent = async (req, res) => {
  try {
    //Fetch all students from database
    const student = await Student.find();
    // Return the student details
    res.status(200).json({
        msg: "Student fetched successfully.",
        data: student,
      });
    
  } catch (err) {
    console.error("Error fetching student details:", err);
    res.status(500).json({
      msg: "An error occurred while fetching students.",
      error: err.message,
    });
  }
};

module.exports = getAllStudent;
