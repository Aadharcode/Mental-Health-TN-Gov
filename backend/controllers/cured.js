const { Student } = require("../models/user");

const cured = async (req, res) => {
  try {
    const { 
      student_emis_id, 
      Case_Status, 
      medicine_bool, 
      medicine, 
      referal_bool, 
      referal 
    } = req.body;

    console.log("Received request body:", req.body);

    // Validate required fields
    if (!student_emis_id || !Case_Status) {
      console.log("Validation failed: Missing student_emis_id or Case_Status");
      return res.status(400).json({
        msg: "Please provide the student_emis_id and Case_Status.",
      });
    }

    console.log("Fetching student with EMIS ID:", student_emis_id);
    // Fetch the student
    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      console.log("Student not found for EMIS ID:", student_emis_id);
      return res.status(404).json({ msg: "Student not found." });
    }

    console.log("Student found:", student);

    // Handle Case_Status logic
    if (Case_Status.toLowerCase() === "completed") {
      console.log("Case status is 'completed'. Updating fields to false.");
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
    }

    // Update common fields
    student.Case_Status = Case_Status.toLowerCase();
    student.Medicine_bool = medicine_bool ?? student.medicine_bool; // Update if provided
    student.Medicine = medicine ?? student.medicine; // Update if provided
    student.referal_bool = referal_bool ?? student.referal_bool; // Update if provided
    student.referal = referal ?? student.referal; // Update if provided

    console.log("Updated student fields:", {
      Case_Status: student.Case_Status,
      Medicine_bool: student.Medicine_bool,
      Medicine: student.Medicine,
      referal_bool: student.referal_bool,
      referal: student.referal,
    });

    // Save the updated student document
    await student.save();
    console.log("Student document saved successfully.");

    res.status(200).json({
      msg: "Student fields updated successfully.",
      data: student,
    });
  } catch (err) {
    console.error("Error updating student fields:", err);
    res.status(500).json({
      msg: "An error occurred while updating student fields.",
      error: err.message,
    });
  }
};

module.exports = cured;
