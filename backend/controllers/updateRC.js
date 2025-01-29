const { RC } = require("../models/user");

const updateRC = async (req, res) => {
  try {
    const { Zone, Name, mobile_number, email } = req.body;

    // Validate required fields
    if (!email) {
      return res.status(400).json({
        msg: "Please provide the email.",
      });
    }

    // Find the RC by mobile number
    const rc = await RC.findOne({ email });
    if (!rc) {
      return res.status(404).json({ msg: "RC not found." });
    }

    // Create an object to hold the updates
    const updates = {};
    if (mobile_number) updates.mobile_number = mobile_number;
    if (Zone) updates.Zone = Zone;
    if (Name) updates.Name = Name;
    if (email) updates.email = email;

    // Update the fields in the RC document
    Object.keys(updates).forEach((key) => {
      rc[key] = updates[key];
    });

    await rc.save();
    res.status(200).json({
      msg: "RC details updated successfully.",
      data: rc,
    });
  } catch (err) {
    console.error("Error updating RC:", err);
    res.status(500).json({ msg: "An error occurred while updating the RC.", error: err.message });
  }
};

module.exports = updateRC;