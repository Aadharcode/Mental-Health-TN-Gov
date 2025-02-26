const { Psychiatrist } = require("../models/user");

const visitedPsych = async (req, res) => {
  try {
    const { district } = req.body;
    const psychiatrist = await Psychiatrist.findOne({ district });
    if (!psychiatrist) {
      return res.status(404).json({ msg: "Psychiatrist not found." });
    }
    psychiatrist.NoOfVisits += 1;
    await psychiatrist.save();

    res.status(200).json({
      msg: "Visit recorded successfully.",
      data: psychiatrist,
    });
  } catch (err) {
    console.error("Error recording visit:", err);
    res.status(500).json({
      msg: "An error occurred while recording the visit.",
      error: err.message,
    });
  }
};

module.exports = visitedPsych;