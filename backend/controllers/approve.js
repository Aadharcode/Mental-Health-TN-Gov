const { Student } = require("../models/user");


const handleApproval = async (req, res) => {
  try {
    const { student_emis_id, approve } = req.body;
    // Validate required fields
    if (!student_emis_id || typeof approve !== "boolean") {
      return res.status(400).json({ msg: "Please provide a valid EMIS ID and approval status (approve as true/false)." });
    }
    // Fetch the student by EMIS ID
    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      return res.status(404).json({ msg: "Student with the given EMIS ID not found." });
    }

    // Update red flags only if `approve` is false
    if (!approve) {
      const redFlagFields = [
        "anxiety",
        "depression",
        "aggresion_violence",
        "selfharm_suicide",
        "sexual_abuse",
        "stress",
        "loss_grief",
        "relationship",
        "bodyimage_selflisten",
        "sleep",
        "conduct_delinquency",
      ];

      // Reset all red flag values to false for the student
      redFlagFields.forEach((field) => {
        student[field] = false;
      });
      await student.save(); // Save updated student 
    }

    res.status(200).json({
      msg: approve
        ? "Red flag status approved and retained."
        : "Red flag status disapproved and reset to default.",
      data: student,
    });
  } catch (err) {
    console.error("Error handling approval:", err);
    res.status(500).json({ msg: "An error occurred while handling approval/disapproval.", error: err.message });
  }
};

module.exports = handleApproval;
