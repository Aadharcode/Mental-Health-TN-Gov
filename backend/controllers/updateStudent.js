const { Student } = require("../models/user");

const updateStudent = async (req, res) => {
  try {
    const {
      student_emis_id,
      school_name,
      student_name,
      date_of_birth,
      gender,
      class: studentClass,
      group_code,
      group_name,
      medium,
      anxiety,
      depression,
      aggression_violence,
      selfharm_suicide,
      sexual_abuse,
      stress,
      loss_grief,
      relationship,
      bodyimage_selflisten,
      sleep,
      conduct_delinquency,
      approval,
      referal_bool,
      referal,
      Case_Status,
      Medicine_bool,
      Medicine
    } = req.body;

    if (!student_emis_id) {
      return res.status(400).json({
        msg: "Please provide the student_emis_id.",
      });
    }

    const student = await Student.findOne({ student_emis_id });
    if (!student) {
      return res.status(404).json({ msg: "Student not found." });
    }

    const allowedFields = [
      "school_name",
      "student_name",
      "date_of_birth",
      "gender",
      "class",
      "group_code",
      "group_name",
      "medium",
      "anxiety",
      "depression",
      "aggression_violence",
      "selfharm_suicide",
      "sexual_abuse",
      "stress",
      "loss_grief",
      "relationship",
      "bodyimage_selflisten",
      "sleep",
      "conduct_delinquency",
      "approval",
      "referal_bool",
      "referal",
      "Case_Status",
      "Medicine_bool",
      "Medicine",
    ];

    const updates = {};

    allowedFields.forEach((field) => {
      if (req.body.hasOwnProperty(field)) {
        updates[field] = req.body[field];
      }
    });

    Object.keys(updates).forEach((key) => {
      student[key] = updates[key];
    });

    await student.save();
    res.status(200).json({
      msg: "Student details updated successfully.",
      data: student,
    });
  } catch (err) {
    console.error("Error updating student:", err);
    res.status(500).json({ msg: "An error occurred while updating the student.", error: err.message });
  }
};

module.exports = updateStudent;
