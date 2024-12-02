const express = require("express");
const { Psychiatrist } = require("../models/user");
const router = express.Router();

// Route to create a new psychiatrist
const createPsychiatrist =  async (req, res) => {
  try {
    // Extract psychiatrist details from the request body
    const { district, DISTRICT_PSYCHIATRIST_NAME, Mobile_number, SATELLITE_PSYCHIATRIST_NAME, SATELLITE_mobile_number, password } = req.body;

    // Validate the required fields
    if (!district || !DISTRICT_PSYCHIATRIST_NAME || !Mobile_number || !SATELLITE_PSYCHIATRIST_NAME || !SATELLITE_mobile_number || !password) {
      return res.status(400).json({ msg: "Please provide all required fields." });
    }

    // Check if the psychiatrist already exists (same district and Mobile_number)
    const existingPsychiatrist = await Psychiatrist.findOne({ district, Mobile_number });
    if (existingPsychiatrist) {
      return res.status(400).json({ msg: "A psychiatrist with the same district and mobile number already exists." });
    }

    // Create a new psychiatrist document
    const newPsychiatrist = await Psychiatrist.create({
      district,
      DISTRICT_PSYCHIATRIST_NAME,
      Mobile_number,
      SATELLITE_PSYCHIATRIST_NAME,
      SATELLITE_mobile_number,
      password,
    });

    // Send a success response
    res.status(201).json({
      msg: "Psychiatrist created successfully!",
      data: newPsychiatrist,
    });
  } catch (err) {
    console.error("Error creating psychiatrist:", err);
    res.status(500).json({ msg: "An error occurred while creating the psychiatrist.", error: err.message });
  }
};

module.exports = createPsychiatrist;
