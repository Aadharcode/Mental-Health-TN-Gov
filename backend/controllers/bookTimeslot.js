const { timeSlot: TimeSlot } = require("../models/user");

const bookTimeSlot = async (req, res) => {
    try {
        console.log("Request body:", req.body);
        const { timeSlot, School_Name, status, timespan } = req.body;
        if (!timeSlot || !School_Name || !status) {
            console.log("Missing required fields:", { timeSlot, School_Name, status });
            return res.status(400).json({ msg: "Please provide School_Name, timeSlot and status." });
        }
        const newTimeSlot = new TimeSlot({
            timeSlot,
            timespan,
            School_Name,
            status,
        });
        console.log("New TimeSlot object:", newTimeSlot);
        await newTimeSlot.save();
        console.log("TimeSlot saved successfully!");
        res.status(201).json({
            msg: "TimeSlot saved successfully!",
            data: newTimeSlot,
        });
    } catch (error) {
        console.error("Error booking timeslot:", error);
        res.status(500).json({
            msg: "An error occurred while booking timeslot.",
            error: error.message,
        });
    }
}


module.exports = bookTimeSlot ;