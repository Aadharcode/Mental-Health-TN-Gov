const { Feedback } = require("../models/user");

const getFeedback = async (req, res) => {
    try {
        // Fetch all feedback from the database
        const feedbacks = await Feedback.find();       //if u want in based on oldest
        // const feedbacks = await Feedback.find().sort({ createdAt: -1 });   //if u want in based on latest
        res.status(200).json({
            msg: "Feedback retrieved successfully!",
            data: feedbacks,
        });
    } catch (error) {
        console.error("Error retrieving feedback:", error);
        res.status(500).json({
            msg: "An error occurred while retrieving feedback.",
            error: error.message,
        });
    }
};

module.exports = getFeedback;
