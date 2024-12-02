const { Student } = require("../models/user"); // Ensure correct path to the Student model

const getStudentsBySchoolAndDistrict = async (req, res) => {
  try {
    const { school_name, district} = req.body;

    // Validate required fields
    if (!school_name || !district ) {
      return res.status(400).json({
        msg: "Please provide both school_name and district.",
      });
    }

    // Convert both input and database values to lowercase for case-insensitive comparison
    const lowerSchoolName = school_name.toLowerCase();
    const lowerDistrict = district.toLowerCase();

    // Build the query for students who have at least one true value in the boolean fields
    const boolFields = [
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
      "conduct_delinquency"
    ];

    // Query the database for students matching the given school_name and district (case-insensitive)
    const students = await Student.find({
      school_name: { $regex: `^${lowerSchoolName}$`, $options: 'i' },
      district: { $regex: `^${lowerDistrict}$`, $options: 'i' },
      $or: boolFields.map(field => ({ [field]: true })) // Check if any boolean field is true
    });

    if (!students || students.length === 0) {
      return res.status(404).json({ msg: "No students from this school has any redflag condition" });
    }

    // Return the matching students
    res.status(200).json({
      msg: "Students fetched successfully.",
      data: students,
    });
  } catch (err) {
    console.error("Error fetching students by school, district, and redflag conditions:", err);
    res.status(500).json({
      msg: "An error occurred while fetching students.",
      error: err.message,
    });
  }
};

module.exports = getStudentsBySchoolAndDistrict;
