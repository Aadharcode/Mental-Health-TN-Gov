const { Feedback } = require("../models/user"); // Ensure the correct path to your schema file

const feedBack = async (req, res) => {
    try {
        const { name, role, feedback } = req.body;
        if (!name || !role || !feedback) {
            return res.status(400).json({ msg: "Please provide username, role, and feedback." });
        }
        const newFeedback = new Feedback({
            name,
            role,
            feedback,
        });

        // Save the feedback to the database
        await newFeedback.save();

        res.status(201).json({
            msg: "Feedback submitted successfully!",
            data: newFeedback,
        });
    } catch (error) {
        console.error("Error submitting feedback:", error);
        res.status(500).json({
            msg: "An error occurred while submitting feedback.",
            error: error.message,
        });
    }
}

module.exports = feedBack;
