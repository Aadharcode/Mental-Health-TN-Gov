const { Attendance } = require("../models/user");

const psychAttendance = async (req, res) => {
    try {
        console.log("Request body:", req.body);

        const { psychiatristName, latitude, longitude } = req.body;
        if (!psychiatristName|| !latitude || !longitude) {
            console.log("Missing required fields:", { psychiatristName, latitude, longitude });
            return res.status(400).json({ msg: "Please provide name, latitude and longitude." });
        }
        const newAttendance = new Attendance({
            psychiatristName,
            latitude,
            longitude,
        });

        console.log("New Attendance object:", newAttendance);

        // Save the attendance to the database
        await newAttendance.save();

        console.log("Attendance saved successfully!");
        res.status(201).json({
            msg: "Attendance saved successfully!",
            data: newAttendance,
        });
    } catch (error) {
        console.error("Error saving attendance:", error);
        res.status(500).json({
            msg: "An error occurred while saving attendance.",
            error: error.message,
        });
    }
}


module.exports = psychAttendance;