const { Psychiatrist } = require("../models/user");

const updatePsychiatrist = async (req, res) => {
  try {
    const { district, DISTRICT_PSYCHIATRIST_NAME, Mobile_number, SATELLITE_PSYCHIATRIST_NAME, SATELLITE_mobile_number,entryTime,exitTime,averageTime,NoOfVisits} = req.body;

    // Validate required fields
    if (!district) {
      return res.status(400).json({
        msg: "Please provide the district.",
      });
    }

    // Find the psychiatrist by district
    const psychiatrist = await Psychiatrist.findOne({ district });
    if (!psychiatrist) {
      return res.status(404).json({ msg: "Psychiatrist not found." });
    }

    // Update the fields in the database, excluding the district
    const allowedFields = [
      "DISTRICT_PSYCHIATRIST_NAME",
      "Mobile_number",
      "SATELLITE_PSYCHIATRIST_NAME",
      "SATELLITE_mobile_number",
      "entryTime",
      "exitTime",
      "averageTime",
      "NoOfVisits",
    ];

    // Create an object to hold the updates
    const updates = {};

    // Check which fields are provided and are allowed
    if (DISTRICT_PSYCHIATRIST_NAME) updates.DISTRICT_PSYCHIATRIST_NAME = DISTRICT_PSYCHIATRIST_NAME;
    if (Mobile_number) updates.Mobile_number = Mobile_number;
    if (SATELLITE_PSYCHIATRIST_NAME) updates.SATELLITE_PSYCHIATRIST_NAME = SATELLITE_PSYCHIATRIST_NAME;
    if (SATELLITE_mobile_number) updates.SATELLITE_mobile_number = SATELLITE_mobile_number;
    if(entryTime) updates.entryTime = entryTime;
    if(exitTime) updates.exitTime = exitTime;
    if(averageTime) updates.averageTime = averageTime;
    if(NoOfVisits) updates.NoOfVisits = NoOfVisits;

    // Update the fields in the psychiatrist document
    Object.keys(updates).forEach((key) => {
      psychiatrist[key] = updates[key];
    });

    await psychiatrist.save();
    res.status(200).json({
      msg: "Psychiatrist details updated successfully.",
      data: psychiatrist,
    });
  } catch (err) {
    console.error("Error updating psychiatrist:", err);
    res.status(500).json({ msg: "An error occurred while updating the psychiatrist.", error: err.message });
  }
};

module.exports = updatePsychiatrist;