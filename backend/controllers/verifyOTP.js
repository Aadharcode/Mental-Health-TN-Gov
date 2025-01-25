require("dotenv").config();
const apiKey = process.env.API_KEY;
// const { Teacher, School, Psychiatrist, Admin, Ms , CIF , ASA } = require("../models/user");

// Helper function to verify OTP
const verifyOTPphone = async (number, otp) => {
    const verifyUrl = `https://2factor.in/API/V1/${apiKey}/SMS/VERIFY3/+91${number}/${otp}`;
    const response = await fetch(verifyUrl);
    const data = await response.json();
    return data;
  };
const verifyOTPemail = async (email, otp) => {
    const verifyUrl = `https://2factor.in/API/V1/${apiKey}/EMAIL/VERIFY/${email}/${otp}`;
    const response = await fetch(verifyUrl);
    const data = await response.json();
    return data;
  };

const verifyOTP = async(req,res) => {
    try {
        const { otp, number , role } = req.body;
        if (!otp || !number || !role) {
        return res.status(400).json({ msg: "OTP, role and number are required" });
        }
        const data = role === "admin" || role === "ms" ? await verifyOTPemail(number, otp) : await verifyOTPphone(number, otp);
        if (data.Status === "Success" && data.Details === "OTP Matched"){
            return res.status(200).json({ msg: "OTP verified successfully" });
        }else{
            return res.status(400).json({ msg: "Incorrect OTP" });
        }
    }catch(err) {
      console.error("OTP Verification Error:", err.message);
      res.status(500).json({ error: err.message });
    }
};

module.exports = verifyOTP;