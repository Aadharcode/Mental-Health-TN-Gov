const { timeSlot: TimeSlot } = require("../models/user");

const filterAndUpdateTimeSlot = async (req, res) => {
    try {
        const { slotId } = req.body; // Extract _id from request body

        if (!slotId) {
            return res.status(400).json({ msg: "Time slot ID is required." });
        }

        console.log("🔍 Searching for Time Slot ID:", slotId);

        // Find the time slot by _id and status = false
        const slot = await TimeSlot.findOne({ _id: slotId, status: false });

        if (!slot) {
            return res.status(404).json({ msg: "No available time slot found with this ID." });
        }

        // Mark the slot as booked (status: true)
        slot.status = true;
        await slot.save();

        res.status(200).json({
            msg: "Time slot updated successfully.",
            data: slot,
        });
    } catch (error) {
        console.error("❌ Error updating time slot:", error);
        res.status(500).json({
            msg: "An error occurred while booking the time slot.",
            error: error.message,
        });
    }
};

module.exports =  filterAndUpdateTimeSlot ;
