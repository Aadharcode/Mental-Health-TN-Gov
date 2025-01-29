const { timeSlot: TimeSlot } = require("../models/user");

const getTimeSlotsBySchoolName = async (req, res) => {
    try {
        const { School_Name } = req.body; 
        if (!School_Name) {
            return res.status(400).json({ msg: "School name is required." });
        }

        const trimmedSchoolName = School_Name.trim();
        console.log("🔍 Searching for school name:", trimmedSchoolName);

        // Fetch only time slots where status is false (available)
        const timeSlots = await TimeSlot.find({ 
            School_Name: { $regex: new RegExp(trimmedSchoolName, "i") },
            status: false
        });

        if (timeSlots.length === 0) {
            return res.status(404).json({ msg: "No available time slots found for this school." });
        }

        res.status(200).json({
            msg: "Available time slots retrieved successfully.",
            data: timeSlots,
        });
    } catch (error) {
        console.error("❌ Error fetching time slots:", error);
        res.status(500).json({
            msg: "An error occurred while fetching time slots.",
            error: error.message,
        });
    }
};

module.exports =  getTimeSlotsBySchoolName ;
