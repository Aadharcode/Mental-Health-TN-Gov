const { RC } = require("../models/user");

const createRC = async(req,res) => {
    try{
        const {Zone , Name , mobile_number , email , password} = req.body;
        if (!email || !password || !Zone || !Name ||!mobile_number ) {
            return res.status(400).json({ msg: "Please provide all required fields." });
        }
        const existingRC = await RC.findOne({ email });
        if (existingRC) {
            return res.status(400).json({ msg: "RC with sane email already exists." });
        }
        const newRC = await RC.create({
            Zone ,
            Name ,
            mobile_number ,
            email,
            password,
        });
        res.status(201).json({
            msg: "RC created successfully!",
            data: newRC,
          });
    }catch(err){
        console.error("Error creating RC:", err);
        res.status(500).json({ msg: "An error occurred while creating the RC.", error: err.message });
    }
}

module.exports = createRC;