const { Attendance } = require("../models/user");

const getAttendance = async (req, res) => {
    try {
        // Fetch all attendance from the database
        const attendances = await Attendance.find();       //if u want in based on oldest
        // const feedbacks = await Feedback.find().sort({ createdAt: -1 });   //if u want in based on latest
        res.status(200).json({
            msg: "Attendance retrieved successfully!",
            data: attendances,
        });
    } catch (error) {
        console.error("Error retrieving feedback:", error);
        res.status(500).json({
            msg: "An error occurred while retrieving feedback.",
            error: error.message,
        });
    }
};

module.exports = getAttendance;
