const { timeSlot: TimeSlot } = require("../models/user"); // Ensure the correct model is imported

const getAllTimeSlots = async (req, res) => {
    try {
        const timeSlots = await TimeSlot.find(); // Fetch all time slots from the database

        if (timeSlots.length === 0) {
            return res.status(404).json({ msg: "No time slots found." });
        }

        res.status(200).json({
            msg: "Time slots retrieved successfully.",
            data: timeSlots,
        });
    } catch (error) {
        console.error("Error fetching time slots:", error);
        res.status(500).json({
            msg: "An error occurred while fetching time slots.",
            error: error.message,
        });
    }
}

module.exports = getAllTimeSlots;
