const { ASA } = require("../models/user");

const updateASA = async (req, res) => {
  try {
    const { mobile_number, School_Name, ASA_Name, Phase, RC, Willing_to_join_CUG , ASA_Mail_id } = req.body;

    // Validate required fields
    if (!ASA_Mail_id) {
      return res.status(400).json({
        msg: "Please provide the ASA_Mail_id.",
      });
    }

    // Find the ASA by mobile number
    const asa = await ASA.findOne({ ASA_Mail_id });
    if (!asa) {
      return res.status(404).json({ msg: "ASA not found." });
    }

    // Create an object to hold the updates
    const updates = {};
    if (mobile_number) updates.mobile_number = mobile_number;
    if (School_Name) updates.School_Name = School_Name;
    if (ASA_Mail_id) updates.ASA_Mail_id = ASA_Mail_id;
    if (ASA_Name) updates.ASA_Name = ASA_Name;
    if (Phase) updates.Phase = Phase;
    if (RC) updates.RC = RC;
    if (Willing_to_join_CUG) updates.Willing_to_join_CUG = Willing_to_join_CUG;

    // Update the fields in the ASA document
    Object.keys(updates).forEach((key) => {
      asa[key] = updates[key];
    });

    await asa.save();
    res.status(200).json({
      msg: "ASA details updated successfully.",
      data: asa,
    });
  } catch (err) {
    console.error("Error updating ASA:", err);
    res.status(500).json({ msg: "An error occurred while updating the ASA.", error: err.message });
  }
};

module.exports = updateASA;