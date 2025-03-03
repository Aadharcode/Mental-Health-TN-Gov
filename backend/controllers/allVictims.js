const { victim } = require("../models/user"); 

const getAllVictims = async (req, res) => {
  try {
    const Victims = await victim.find({});
    if (!Victims ||Victims.length === 0) {
      return res.status(404).json({ msg: "No victims found." });
    }
    res.status(200).json({
      msg: "Victims fetched successfully.",
      data: Victims,
    });
  } catch (err) {
    console.error("Error fetching victims:", err);
    res.status(500).json({
      msg: "An error occurred while fetching victims.",
      error: err.message,
    });
  }
};

module.exports = getAllVictims;