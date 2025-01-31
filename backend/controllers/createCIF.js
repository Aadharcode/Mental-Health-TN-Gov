const { CIF } = require("../models/user");

const createCIF = async(req,res) => {
    try{
        const {School_Name , CIF_Mail_id , CIF_Name , mobile_number , Phase , RC , Willing_to_join_CUG , password} = req.body;
        if (!School_Name || !CIF_Mail_id || !CIF_Name || !mobile_number || !Phase || !RC || !Willing_to_join_CUG || !password) {
            return res.status(400).json({ msg: "Please provide all required fields." });
        }
        const existingCIF = await CIF.findOne({ mobile_number });
        if (existingCIF) {
            return res.status(400).json({ msg: "CIF with same email already exists." });
        }
        const newCIF = await CIF.create({
            School_Name ,
            CIF_Mail_id ,
            CIF_Name ,
            mobile_number ,
            Phase ,
            RC ,
            Willing_to_join_CUG ,
            password,
        });
        res.status(201).json({
            msg: "CIF created successfully!",
            data: newCIF,
          });
    }catch(err){
        console.error("Error creating CIF:", err);
        res.status(500).json({ msg: "An error occurred while creating the CIF.", error: err.message });
    }
}

module.exports = createCIF;