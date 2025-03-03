const { Student , victim } = require("../models/user"); 

const getStudent = async (req, res) => {
  try {
    const {student_emis_id} = req.body;

    // Validate required fields
    if (!student_emis_id) {
      return res.status(400).json({
        msg: "Please provide the student_emis_id",
      });
    }
    // Find the student by EMIS ID
    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      return res.status(404).json({ msg: "Student not found." });
    }
    const Victim = await victim.findOne({ emis_id: student_emis_id });
    // Return the student details
    res.status(200).json({
        msg: "Student fetched successfully.",
        data: {
          student,
          Victim: Victim || null,
        }
      });
    
  } catch (err) {
    console.error("Error fetching student details:", err);
    res.status(500).json({
      msg: "An error occurred while fetching the student.",
      error: err.message,
    });
  }
};

module.exports = getStudent;
