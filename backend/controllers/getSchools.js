const { School } = require("../models/user");

const getSchool = async (req, res) => {
    try {
        const schools = await School.find({}, 'SCHOOL_NAME DISTRICT'); // Fetched only SCHOOL_NAME and DISTRICT
        return res.status(200).json({
            msg: "Schools fetched successfully",
            data: schools,
        });
        
    } catch (err) {
        console.error("Error fetching schools:", err);
        res.status(500).json({
            msg: "An error occurred while fetching schools",
            error: err.message,
        });
    }
  };
  
  module.exports = getSchool;
  