const { Student } = require("../models/user");

// Route to create a new student
const createStudent = async (req, res) => {
  try {
    // Extract student details from the request body
    const { school_name, student_emis_id, student_name, date_of_birth, gender, class: studentClass, group_code, group_name, medium, password } = req.body;

    // Validate the required fields
    if (!school_name || !student_emis_id || !student_name || !date_of_birth || !gender || !studentClass || !medium || !password) {
      return res.status(400).json({ msg: "Please provide all required fields." });
    }

    // Check if the student already exists (same student_emis_id)
    const existingStudent = await Student.findOne({ student_emis_id });
    if (existingStudent) {
      return res.status(400).json({ msg: "A student with the same EMIS ID already exists." });
    }

    // Create a new student document
    const newStudent = await Student.create({
      school_name,
      student_emis_id,
      student_name,
      date_of_birth,
      gender,
      class: studentClass,
      group_code,
      group_name,
      medium,
      password,
    });

    // Send a success response
    res.status(201).json({
      msg: "Student created successfully!",
      data: newStudent,
    });
  } catch (err) {
    console.error("Error creating student:", err);
    res.status(500).json({ msg: "An error occurred while creating the student.", error: err.message });
  }
};

module.exports = createStudent;
