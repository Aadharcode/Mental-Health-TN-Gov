const { Ms } = require("../models/user");

const createMS = async(req,res) => {
    try{
        const {email , password} = req.body;
        if (!email || !password) {
            return res.status(400).json({ msg: "Please provide all required fields." });
        }
        const existingMS = await Ms.findOne({ email });
        if (existingMS) {
            return res.status(400).json({ msg: "MS with sane email already exists." });
        }
        const newMS = await Ms.create({
            email,
            password,
        });
        res.status(201).json({
            msg: "MS created successfully!",
            data: newMS,
          });
    }catch(err){
        console.error("Error creating MS:", err);
        res.status(500).json({ msg: "An error occurred while creating the MS.", error: err.message });
    }
}

module.exports = createMS;