const { Student } = require("../models/user");

const handleApproval = async (req, res) => {
  try {
    const { student_emis_id, approve } = req.body;
    if (!student_emis_id || typeof approve !== "boolean") {
      return res.status(400).json({ msg: "Please provide a valid EMIS ID and approval status (approve as true/false)." });
    }

    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      return res.status(404).json({ msg: "Student with the given EMIS ID not found." });
    }

    if (approve) {
      student.approval = true; 
    }

    if (!approve) {
      student.approval = false; 
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
      redFlagFields.forEach((field) => {
        student[field] = false;
      });
    }
    
    await student.save();

    res.status(200).json({
      msg: approve
        ? "Red flag status approved "
        : "Red flag status disapproved",
      data: student,
    });
  } catch (err) {
    console.error("Error handling approval:", err);
    res.status(500).json({ msg: "An error occurred while handling approval/disapproval.", error: err.message });
  }
};

module.exports = handleApproval;
