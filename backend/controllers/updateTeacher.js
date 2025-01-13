const { Teacher } = require("../models/user");

const updateTeacher = async (req, res) => {
  try {
    const { district, School_name, Teacher_Name, mobile_number } = req.body;
    if (!district) {
      return res.status(400).json({
        msg: "Please provide the district.",
      });
    }
    const teacher = await Teacher.findOne({ district });
    if (!teacher) {
      return res.status(404).json({ msg: "Teacher not found." });
    }
    // Update the fields in the database, excluding the district
    const allowedFields = [
      "School_name",
      "Teacher_Name",
      "mobile_number",
    ];

    // Create an object to hold the updates
    const updates = {};

    // Check which fields are provided and are allowed
    if (School_name) updates.School_name = School_name;
    if (Teacher_Name) updates.Teacher_Name = Teacher_Name;
    if (mobile_number) updates.mobile_number = mobile_number;

    // Update the fields in the teacher document
    Object.keys(updates).forEach((key) => {
      teacher[key] = updates[key];
    });

    await teacher.save();
    res.status(200).json({
      msg: "Teacher details updated successfully.",
      data: teacher,
    });
  } catch (err) {
    console.error("Error updating teacher:", err);
    res.status(500).json({ msg: "An error occurred while updating the teacher.", error: err.message });
  }
};

module.exports = updateTeacher;