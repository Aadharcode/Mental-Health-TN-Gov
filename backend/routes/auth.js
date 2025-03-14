const express = require("express");
const fetchDetails = require("../controllers/getDetails");
const authRouter = express.Router();
const auth = require("../middleware/auth");
const createTeacher = require("../controllers/createTeacher");
const signin = require("../controllers/signin");
const tokenIsValid = require("../middleware/tokenIsValid");
const getData = require("../middleware/getData");
const createStudent = require("../controllers/createStudent");
const createSchool = require("../controllers/createSchool");
const createPsychiatrist = require("../controllers/createPsychiatrist");
const updateRedflags = require("../controllers/redflag");
const handleApproval = require("../controllers/approve");
const getStudent = require("../controllers/getStudent");
const getStudentsBySchoolAndDistrict = require("../controllers/hsmsFetch");
const getApprovedStudents = require("../controllers/getApprovedStudents");
const fetchAllRedflagStudents = require("../controllers/allfetchMS");
const getSchool = require("../controllers/getSchools");
const feedBack = require("../controllers/feedback");
const getFeedback = require("../controllers/getFeedback");
const getAllStudent = require("../controllers/getAllStudents");
const psychAttendance = require("../controllers/attendance");
const getAttendance = require("../controllers/getAttendance");
const updatePasswords = require("../controllers/updatePassword");
const sendOTP = require("../controllers/sendOTP");
const verifyOTP = require("../controllers/verifyOTP");
const createMS = require("../controllers/createMS");
const deleteUser = require("../controllers/deleteUser");
const updateStudent = require("../controllers/updateStudent");
const updateTeacher = require("../controllers/updateTeacher");
const updateSchool = require("../controllers/updateSchool");
const updatePsychiatrist = require("../controllers/updatePsychiatrist");
const cured = require("../controllers/cured");
const createASA = require("../controllers/createASA");
const createCIF = require("../controllers/createCIF");
const createRC = require("../controllers/createRC");
const bookTimeSlot = require("../controllers/bookTimeslot");
const getTimeSlotsBySchoolName = require("../controllers/getTimeSlot");
const getAllTimeSlots = require("../controllers/getAllTimeSlots");
const filterAndUpdateTimeSlot = require("../controllers/filterAndUpdateTimeSlot");
const getStudentsByZone = require("../controllers/getStudentbyZone");
const createWarden = require("../controllers/createWarden");
const updateWarden = require("../controllers/updateWarden");
const updateASA = require("../controllers/updateASA");
const updateCIF = require("../controllers/updateCIF");
const updateRC = require("../controllers/updateRC");
const visitedPsych = require("../controllers/visitedPsych");
const getSchoolsByZone = require("../controllers/getSchoolsbyZone");
const getStudentsBySchool = require("../controllers/getStudentsbySchool");
const createVictim = require("../controllers/createVictim");
const getAllVictims = require("../controllers/allVictims");
require('dotenv').config();

authRouter.post("/api/signin", signin);   // Sign In
authRouter.post("/createTeacher", createTeacher);  // new Teacher user
authRouter.post("/createStudent", createStudent);  // new Student user
authRouter.post("/createWarden", createWarden);  // new Warden user
authRouter.post("/createMS", createMS);  // new MS user
authRouter.post("/createRC", createRC);  // new RC user
authRouter.post("/createASA", createASA);  // new ASA user
authRouter.post("/createCIF", createCIF);  // new CIF user
authRouter.post("/createSchool", createSchool); // new School
authRouter.post("/createPsychiatrist", createPsychiatrist); // new Psychiatrist user
authRouter.post("/createVictim", createVictim); //new victim case
authRouter.post("/getStudent", getStudent); //fetch student data
authRouter.post("/api/redflags", updateRedflags); //Redflags API
authRouter.post("/api/hsmsFetch", getStudentsBySchoolAndDistrict);  //fetching students based on their school and district with redflags
authRouter.post("/api/approval", handleApproval); //Redflags Approval
authRouter.post("/api/feedback", feedBack);  // post the feedback 
authRouter.post("/api/attendance", psychAttendance);  // post the attendance of Psychiatrist
authRouter.post("/api/cured", cured); // Route to reset student fields for cured students
authRouter.post("/tokenIsValid", tokenIsValid);   // Token validation
authRouter.post("/api/sendOTP", sendOTP); // Route to send OTP
authRouter.post("/api/verifyOTP", verifyOTP); // Route to verify OTP
authRouter.post("/api/bookTimeSlot", bookTimeSlot); // Route to book time slot
authRouter.put("/api/updatePassword", updatePasswords); // Update password route
authRouter.put("/api/updateStudent", updateStudent); // Route to update student details
authRouter.put("/api/updateTeacher", updateTeacher); // Route to update teacher details
authRouter.put("/api/updateSchool", updateSchool); // Route to update school details
authRouter.put("/api/updateWarden", updateWarden); // Route to update warden details
authRouter.put("/api/updateASA", updateASA); // Route to update ASA details
authRouter.put("/api/updateCIF", updateCIF); // Route to update CIF details
authRouter.put("/api/updateRC", updateRC); // Route to update RC details
authRouter.put("/api/updatePsychiatrist", updatePsychiatrist); // Route to update psychiatrist details
authRouter.get("/api/msFetch", fetchAllRedflagStudents);  // get all red flag student data for MS
authRouter.get("/api/getFeedback", getFeedback);  // get all the feedbacksorted date wise
authRouter.get("/api/getAttendance", getAttendance);  // get all the attendance of psychiatrist date wise
authRouter.get("/api/getSchool", getSchool);  // get all school(name and district) data for MS
authRouter.get("/getAllStudent", getAllStudent); //fetch student data
authRouter.post("/getStudentsBySchool", getStudentsBySchool); //fetch student data based on their school
authRouter.get("/getStudentsByZone", getStudentsByZone); //fetch student data based on their zone
authRouter.get("/getSchoolsByZone", getSchoolsByZone); //fetch school name based on their zone
authRouter.get("/approvedStudents", getApprovedStudents);  //To fetch the approved students for the psychiatrist
authRouter.post("/getTimeSlotsBySchoolName" , getTimeSlotsBySchoolName); // To fetch timeslot based on school name
authRouter.get("/getAllTimeSlots" , getAllTimeSlots); // To fetch all time slots
authRouter.get("/getAllVictims" , getAllVictims); // To fetch all victims
authRouter.post("/updateTimeSlot" , filterAndUpdateTimeSlot); // To update time slots by _id
authRouter.get("/", auth, getData);  // get user data
authRouter.delete("/api/deleteUser", deleteUser); // Route to delete a user
authRouter.post('/fetch-all', fetchDetails);
authRouter.post("/markVisit",visitedPsych); //to add number of visits by 1


module.exports = authRouter;