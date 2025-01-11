const { Student } = require("../models/user");

const cured = async (req, res) => {
  try {
    const { student_emis_id } = req.body;
    if (!student_emis_id) {
      return res.status(400).json({
        msg: "Please provide the student_emis_id.",
      });
    }
    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      return res.status(404).json({ msg: "Student not found." });
    }
    student.anxiety = false;
    student.depression = false;
    student.aggression_violence = false;
    student.selfharm_suicide = false;
    student.sexual_abuse = false;
    student.stress = false;
    student.loss_grief = false;
    student.relationship = false;
    student.bodyimage_selflisten = false;
    student.sleep = false;
    student.conduct_delinquency = false;
    student.approval = false;
    student.referal_bool = false;
    student.referal = "null";
    student.Medicine_bool = false;
    student.Medicine = "";
    student.Case_Status = "completed"; // Set Case_Status to "completed"
    await student.save();
    res.status(200).json({
      msg: "Student fields reset successfully.",
      data: student,
    });
  } catch (err) {
    console.error("Error resetting student fields:", err);
    res.status(500).json({ msg: "An error occurred while resetting student fields.", error: err.message });
  }
};

module.exports = cured;