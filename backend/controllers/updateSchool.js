const { School } = require("../models/user");

const updateSchool = async (req, res) => {
  try {
    const { udise_no, SCHOOL_NAME, DISTRICT, SCHOOL_MAIL_ID, HM_NAME, HM_MOBILE_NO } = req.body;

    // Validate required fields
    if (!udise_no) {
      return res.status(400).json({
        msg: "Please provide the udise_no.",
      });
    }

    // Find the school by UDISE number
    const school = await School.findOne({ udise_no });
    if (!school) {
      return res.status(404).json({ msg: "School not found." });
    }

    // Update the fields in the database, excluding the udise_no
    const allowedFields = [
      "SCHOOL_NAME",
      "DISTRICT",
      "SCHOOL_MAIL_ID",
      "HM_NAME",
      "HM_MOBILE_NO",
    ];

    // Create an object to hold the updates
    const updates = {};

    // Check which fields are provided and are allowed
    if (SCHOOL_NAME) updates.SCHOOL_NAME = SCHOOL_NAME;
    if (DISTRICT) updates.DISTRICT = DISTRICT;
    if (SCHOOL_MAIL_ID) updates.SCHOOL_MAIL_ID = SCHOOL_MAIL_ID;
    if (HM_NAME) updates.HM_NAME = HM_NAME;
    if (HM_MOBILE_NO) updates.HM_MOBILE_NO = HM_MOBILE_NO;

    // Update the fields in the school document
    Object.keys(updates).forEach((key) => {
      school[key] = updates[key];
    });

    await school.save();
    res.status(200).json({
      msg: "School details updated successfully.",
      data: school,
    });
  } catch (err) {
    console.error("Error updating school:", err);
    res.status(500).json({ msg: "An error occurred while updating the school.", error: err.message });
  }
};

module.exports = updateSchool;