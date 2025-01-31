const { Warden } = require("../models/user"); 

const createWarden = async (req, res) => {
  try {
    const { DISTRICT, NAME, GENDER,DESIGNATION, mobile_number,Email , password } = req.body;

    // Validate the required fields
    if (!DISTRICT || !NAME || !GENDER || !DESIGNATION || !mobile_number || !Email|| !password) {
      return res.status(400).json({ msg: "Please provide all required fields: district, School_name, Teacher_Name, mobile_number, and password." });
    }


    const existingWarden = await Warden.findOne({ mobile_number });
    if (existingWarden) {
      return res.status(400).json({ msg: "A teacher with the same district and mobile number already exists." });
    }

    // Create a new teacher document
    const newWarden = await Warden.create({
        DISTRICT,
        NAME,
        GENDER,
        DESIGNATION,
        mobile_number,
        Email,
        password,
    });

    // Send a success response
    res.status(201).json({
      msg: "Warden created successfully!",
      data: newWarden,
    });
  } catch (err) {
    console.error("Error creating teacher:", err);
    res.status(500).json({ msg: "An error occurred while creating the warden.", error: err.message });
  }
};

module.exports = createWarden;  // Export the function instead of router
