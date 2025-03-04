const { victim } = require("../models/user"); 

const createVictim = async (req, res) => {
  try {
    const { name, age, sex, emis_id, Date, Time } = req.body;
    if (!name || !age || !sex || !emis_id || !Date || !Time) {
      return res.status(400).json({
        msg: "Please provide all required fields: name, age, sex, emis_id, Date, and Time.",
      });
    }
    const newVictim = new victim({
      name,
      age,
      sex,
      emis_id,
      Date,
      Time,
      // Optional fields
      Location: req.body.Location || "",
      Details: req.body.Details || "",
      inappropriateTouching: req.body.inappropriateTouching || false,
      sexualAdvances: req.body.sexualAdvances || false,
      physicalAbuse: req.body.physicalAbuse || false,
      onlineHarassment: req.body.onlineHarassment || false,
      showingInappropriateContent: req.body.showingInappropriateContent || false,
      others: req.body.others || "",
    });
    await newVictim.save();
    res.status(201).json({
      msg: "Victim created successfully.",
      data: newVictim,
    });
  } catch (err) {
    console.error("Error creating victim:", err);
    res.status(500).json({
      msg: "An error occurred while creating the victim.",
      error: err.message,
    });
  }
};
//comment
module.exports = createVictim;