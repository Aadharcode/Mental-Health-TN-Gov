const { Student } = require("../models/user"); // Ensure correct path to the Student model

// Controller to update redflag fields in a student's document
const updateRedflags = async (req, res) => {
  try {
    const { student_emis_id, updates } = req.body;

    // Validate required fields
    if (!student_emis_id || !updates || typeof updates !== "object") {
      return res.status(400).json({
        msg: "Please provide the student_emis_id and updates object.",
      });
    }

    // Find the student by EMIS ID
    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      return res.status(404).json({ msg: "Student not found." });
    }

    // Validate that updates only include valid redflag fields
    const allowedFields = [
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

    const updateKeys = Object.keys(updates);
    const invalidFields = updateKeys.filter((key) => !allowedFields.includes(key));

    if (invalidFields.length > 0) {
      return res.status(400).json({
        msg: "Invalid fields in updates object.",
        invalidFields,
      });
    }
    // Update the fields in the database
    updateKeys.forEach((key) => {
      student[key] = updates[key];
    });

    await student.save();
    res.status(200).json({
      msg: "Redflag fields updated successfully.",
      data: student,
    });
  } catch (err) {
    console.error("Error updating redflag fields:", err);
    res.status(500).json({
      msg: "An error occurred while updating redflag fields.",
      error: err.message,
    });
  }
};

module.exports = updateRedflags;
