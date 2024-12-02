const { Teacher } = require("../models/user"); // Ensure the correct path to your schema file

const createTeacher = async (req, res) => {
  try {
    // Extract teacher details from the request body
    const { district, School_name, Teacher_Name, mobile_number, password } = req.body;

    // Validate the required fields
    if (!district || !School_name || !Teacher_Name || !mobile_number || !password) {
      return res.status(400).json({ msg: "Please provide all required fields: district, School_name, Teacher_Name, mobile_number, and password." });
    }

    // Check for valid mobile number format
    // if (!/^[0-9]{10}$/.test(mobile_number)) {
    //   return res.status(400).json({ msg: "Please provide a valid 10-digit mobile number." });
    // }

    const existingTeacher = await Teacher.findOne({ district, mobile_number });
    if (existingTeacher) {
      return res.status(400).json({ msg: "A teacher with the same district and mobile number already exists." });
    }

    // Create a new teacher document
    const newTeacher = await Teacher.create({
      district,
      School_name,
      Teacher_Name,
      mobile_number,
      password,
    });

    // Send a success response
    res.status(201).json({
      msg: "Teacher created successfully!",
      data: newTeacher,
    });
  } catch (err) {
    console.error("Error creating teacher:", err);
    res.status(500).json({ msg: "An error occurred while creating the teacher.", error: err.message });
  }
};

module.exports = createTeacher;  // Export the function instead of router
