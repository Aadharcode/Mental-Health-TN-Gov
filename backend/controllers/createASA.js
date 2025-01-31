const { ASA } = require("../models/user");

const createASA = async(req,res) => {
    try{
        const {School_Name , ASA_Mail_id , ASA_Name , mobile_number , Phase , RC , Willing_to_join_CUG , password} = req.body;
        if (!School_Name || !ASA_Mail_id || !ASA_Name || !mobile_number || !Phase || !RC || !Willing_to_join_CUG || !password) {
            return res.status(400).json({ msg: "Please provide all required fields." });
        }
        const existingASA = await ASA.findOne({ mobile_number });
        if (existingASA) {
            return res.status(400).json({ msg: "ASA with sane email already exists." });
        }
        const newASA = await ASA.create({
            School_Name ,
            ASA_Mail_id ,
            ASA_Name ,
            mobile_number ,
            Phase ,
            RC ,
            Willing_to_join_CUG ,
            password,
        });
        res.status(201).json({
            msg: "ASA created successfully!",
            data: newASA,
          });
    }catch(err){
        console.error("Error creating ASA:", err);
        res.status(500).json({ msg: "An error occurred while creating the ASA.", error: err.message });
    }
}

module.exports = createASA;