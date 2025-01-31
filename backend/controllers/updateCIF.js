const { CIF } = require("../models/user");

const updateCIF = async (req, res) => {
  try {
    const { mobile_number, School_Name, CIF_Name, Phase, RC, Willing_to_join_CUG , CIF_Mail_id } = req.body;

    // Validate required fields
    if (!CIF_Mail_id) {
      return res.status(400).json({
        msg: "Please provide the CIF_Mail_id.",
      });
    }

    // Find the CIF by mobile number
    const cif = await CIF.findOne({ CIF_Mail_id });
    if (!cif) {
      return res.status(404).json({ msg: "CIF not found." });
    }

    // Create an object to hold the updates
    const updates = {};
    if (mobile_number) updates.mobile_number = mobile_number;
    if (School_Name) updates.School_Name = School_Name;
    if (CIF_Mail_id) updates.CIF_Mail_id = CIF_Mail_id;
    if (CIF_Name) updates.CIF_Name = CIF_Name;
    if (Phase) updates.Phase = Phase;
    if (RC) updates.RC = RC;
    if (Willing_to_join_CUG) updates.Willing_to_join_CUG = Willing_to_join_CUG;

    // Update the fields in the CIF document
    Object.keys(updates).forEach((key) => {
      cif[key] = updates[key];
    });

    await cif.save();
    res.status(200).json({
      msg: "CIF details updated successfully.",
      data: cif,
    });
  } catch (err) {
    console.error("Error updating CIF:", err);
    res.status(500).json({ msg: "An error occurred while updating the CIF.", error: err.message });
  }
};

module.exports = updateCIF;