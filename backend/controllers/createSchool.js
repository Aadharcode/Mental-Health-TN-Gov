const express = require("express");
const { School } = require("../models/user");
const router = express.Router();

// Route to create a new school
const createSchool = async (req, res) => {
  try {
    // Extract school details from the request body
    const { SCHOOL_NAME, DISTRICT, udise_no, SCHOOL_MAIL_ID, HM_NAME, HM_MOBILE_NO, password } = req.body;

    // Validate the required fields
    if (!SCHOOL_NAME || !DISTRICT || !udise_no || !SCHOOL_MAIL_ID || !HM_NAME || !HM_MOBILE_NO || !password) {
      return res.status(400).json({ msg: "Please provide all required fields." });
    }

    // Check if the school already exists (same udise_no)
    const existingSchool = await School.findOne({ udise_no });
    if (existingSchool) {
      return res.status(400).json({ msg: "A school with the same UDISE number already exists." });
    }

    // Create a new school document
    const newSchool = await School.create({
      SCHOOL_NAME,
      DISTRICT,
      udise_no,
      SCHOOL_MAIL_ID,
      HM_NAME,
      HM_MOBILE_NO,
      password,
    });

    // Send a success response
    res.status(201).json({
      msg: "School created successfully!",
      data: newSchool,
    });
  } catch (err) {
    console.error("Error creating school:", err);
    res.status(500).json({ msg: "An error occurred while creating the school.", error: err.message });
  }
};

module.exports = createSchool;
