const { Student } = require("../models/user");

const fetchAllRedflagStudents = async (req, res) => {
  try {
    const redflagFields = [
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

    const studentsWithRedflags = await Student.find({
      $or: redflagFields.map((field) => ({ [field]: true })),
    });

    if (!studentsWithRedflags || studentsWithRedflags.length === 0) {
      return res.status(404).json({ msg: "No students with redflag conditions found." });
    }

    // Return the matching students
    res.status(200).json({
      msg: "Students with redflag conditions fetched successfully.",
      data: studentsWithRedflags,
    });
  } catch (err) {
    console.error("Error fetching students with redflag conditions:", err);
    res.status(500).json({
      msg: "An error occurred while fetching students.",
      error: err.message,
    });
  }
};

module.exports = fetchAllRedflagStudents;
