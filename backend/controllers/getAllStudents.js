const { Student } = require("../models/user");

const getAllStudent = async (req, res) => {
  try {
    const { district } = req.query; // Get district from the query parameters

    // Fetch students, filtered by district if specified and not "All"
    const students =
      district && district !== "All"
        ? await Student.find({ school_name: district })
        : await Student.find();

    // Initialize counters and lists
    const totalStudents = students.length;
    let totalRedFlags = 0;
    let recoveredByDMHP = 0;
    let ongoingCases = 0;
    let completedCases = 0;
    let referrals = 0;

    const redFlagStudents = [];
    const recoveredStudents = [];
    const ongoingStudents = [];
    const completedStudents = [];
    const referralStudents = [];

    // Process students to calculate statistics and build lists
    students.forEach((student) => {
      if (student.Case_Status !== "none") {
        totalRedFlags++;
        redFlagStudents.push(student);
      }
      if (student.Case_Status === "completed" && student.referal_bool === false) {
        recoveredByDMHP++;
        recoveredStudents.push(student);
      }
      if (student.Case_Status === "ongoing") {
        ongoingCases++;
        ongoingStudents.push(student);
      }
      if (student.Case_Status === "completed") {
        completedCases++;
        completedStudents.push(student);
      }
      if (student.referal_bool === true) {
        referrals++;
        referralStudents.push(student);
      }
    });

    // Ensure the numeric fields are returned as integers
    res.status(200).json({
      msg: "Student statistics fetched successfully.",
      totalStudents: totalStudents, // already an integer
      totalRedFlags: totalRedFlags, // already an integer
      redFlagStudents,
      recoveredByDMHP: recoveredByDMHP, // already an integer
      recoveredStudents,
      ongoingCases: ongoingCases, // already an integer
      ongoingStudents,
      completedCases: completedCases, // already an integer
      completedStudents,
      referrals: referrals, // already an integer
      referralStudents,
    });
  } catch (err) {
    console.error("Error fetching student details:", err);
    res.status(500).json({
      msg: "An error occurred while fetching student statistics.",
      error: err.message,
    });
  }
};

module.exports = getAllStudent;
