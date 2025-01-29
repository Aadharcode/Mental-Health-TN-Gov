const { Warden } = require("../models/user");

const updateWarden = async (req, res) => {
  try {
    const { DESIGNATION, DISTRICT, NAME, GENDER, mobile_number, Email } = req.body;

    // Validate required fields
    if (!mobile_number) {
      return res.status(400).json({
        msg: "Please provide the udise_no.",
      });
    }

    // Find the warden by UDISE number
    const warden = await Warden.findOne({ mobile_number });
    if (!warden) {
      return res.status(404).json({ msg: "Warden not found." });
    }

    // Update the fields in the database, excluding the udise_no
    const allowedFields = [
      "DISTRICT",
      "NAME",
      "GENDER",
      "DESIGNATION",
      "Email",
    ];

    // Create an object to hold the updates
    const updates = {};

    // Check which fields are provided and are allowed
    if (DISTRICT) updates.DISTRICT = DISTRICT;
    if (NAME) updates.NAME = NAME;
    if (GENDER) updates.GENDER = GENDER;
    if (mobile_number) updates.mobile_number = mobile_number;
    if (Email) updates.Email = Email;

    // Update the fields in the warden document
    Object.keys(updates).forEach((key) => {
      warden[key] = updates[key];
    });

    await warden.save();
    res.status(200).json({
      msg: "Warden details updated successfully.",
      data: warden,
    });
  } catch (err) {
    console.error("Error updating warden:", err);
    res.status(500).json({ msg: "An error occurred while updating the warden.", error: err.message });
  }
};

module.exports = updateWarden;