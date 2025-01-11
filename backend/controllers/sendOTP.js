require("dotenv").config();
const apiKey = process.env.API_KEY;
const { Teacher, School, Psychiatrist, Admin, Ms } = require("../models/user");

// Helper function to send OTP
const sendOTPphone = async (number) => {
    const otpUrl = `https://2factor.in/API/V1/${apiKey}/SMS/+91${number}/AUTOGEN/OTP1`;
    const response = await fetch(otpUrl);
    const data = await response.json();
    return data;
};
const sendOTPemail = async (email) => {
    const otpUrl = `https://2factor.in/API/V1/${apiKey}/EMAIL/${email}/AUTOGEN`;
    const response = await fetch(otpUrl);
    console.log(response);
    const data = await response.json();
    return data;
};

const sendOTP = async (req, res) => {
    try {
      console.log("Incoming req:", req.body);
      let { role, uniqueField } = req.body;
      if (!role || !uniqueField) {
        return res.status(400).json({ msg: "Please provide all required fields (role, uniqueField)." });
      }
      // Transform uniqueField based on role
      if (role === "teacher") {
        uniqueField = uniqueField.charAt(0).toUpperCase() + uniqueField.slice(1).toLowerCase();
        console.log("Transformed teacher uniqueField:", uniqueField);
      } else if (role === "psychiatrist") {
        uniqueField = uniqueField.toUpperCase();
        console.log("Transformed psychiatrist uniqueField:", uniqueField);
      } else if (role === "admin" || role === "ms") {
        uniqueField = uniqueField.toLowerCase();
        console.log("Transformed admin/ms uniqueField:", uniqueField);
      }
      // Select the appropriate model based on the role
      let userModel;
      switch (role) {
        case "teacher":
          userModel = Teacher;
          break;
        case "hs-ms":
          userModel = School;
          break;
        case "psychiatrist":
          userModel = Psychiatrist;
          break;
        case "admin":
          userModel = Admin;
          break;
        case "ms":
          userModel = Ms;
          break;
        default:
          console.log("Invalid role specified:", role); // For debugging role
          return res.status(400).json({ msg: "Invalid role specified!" });
      }
      // Build the query based on the role
      let query, contactInfo;
    switch (role) {
      case "teacher":
        query = { district: uniqueField };
        contactInfo = "mobile_number"; // Ensure these variables are defined correctly
        break;
      case "hs-ms":
        query = { udise_no: uniqueField };
        contactInfo = "HM_MOBILE_NO";
        break;
      case "psychiatrist":
        query = { district: uniqueField };
        contactInfo = "Mobile_number";
        break;
      case "admin":
        query = { email: uniqueField };
        contactInfo = "email";
        break;
      case "ms":
        query = { email: uniqueField };
        contactInfo = "email";
        break;
      default:
        return res.status(400).json({ msg: "Invalid role specified!" });
    }
      console.log("Query being executed:", query); 
      // Find the user in the appropriate collection
      const user = await userModel.findOne(query);
      console.log("User retrieved:", user); // User retrieved
      if (!user) {
        console.log("User not found in collection:", role);
        return res.status(400).json({ msg: "User not found!" });
      }
    const contactValue = user[contactInfo];
    console.log("Contact value retrieved:", contactValue);
    if (!contactValue) {
        return res.status(400).json({ msg: "Contact information not found!" });
    }
    const data = role === "admin" || role === "ms" ? await sendOTPemail(contactValue) : await sendOTPphone(contactValue);
      if (data && data.Status === "Success") {
        return res.status(200).json({ msg: "OTP sent successfully", sessionId: data.Details });
      } else {
        throw new Error("Failed to send OTP");
      }
    } catch (err) {
      console.error("Signup Error:", err.message);
      res.status(500).json({ error: err.message });
    }
}

module.exports = sendOTP;