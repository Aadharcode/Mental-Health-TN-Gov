const { Student } = require("../models/user");

const zoneSchoolMapping = {
  "NORTHERN ZONE": [
    "Center Of Academic Excellence Chennai",
    "CHENALPATTU DISTRICT GOVERNMENT MODEL SCHOOL",
    "KANCHEEPURAM DISTRICT GOVERNMENT MODEL SCHOOL",
    "THIRUVALLUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "KALLAKURICHI DISTRICT GOVERNMENT MODEL SCHOOL",
    "VILLUPURAM DISTRICT GOVERNMENT MODEL SCHOOL",
    "CUDDALORE DISTRICT GOVERNMENT MODEL SCHOOL",
    "CHENNAI DISTRICT GOVERNMENT MODEL SCHOOL"
  ],
  "NORTH WESTERN ZONE": [
    "DHARMAPURI DISTRICT GOVERNMENT MODEL SCHOOL",
    "KRISHNAGIRI DISTRICT GOVERNMENT MODEL SCHOOL",
    "RANIPET DISTRICT GOVERNMENT MODEL SCHOOL",
    "THIRUVANNAMALAI DISTRICT GOVERNMENT MODEL SCHOOL",
    "TIRUPATHUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "VELLORE DISTRICT GOVERNMENT MODEL SCHOOL"
  ],
  "WESTERN ZONE": [
    "SALEM DISTRICT GOVERNMENT MODEL SCHOOL",
    "ERODE DISTRICT GOVERNMENT MODEL SCHOOL",
    "COIMBATORE DISTRICT GOVERNMENT MODEL SCHOOL",
    "TIRUPPUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "NAMAKKAL DISTRICT GOVERNMENT MODEL SCHOOL",
    "THE NILGIRIS DISTRICT GOVERNMENT MODEL SCHOOL"
  ],
  "EASTERN ZONE": [
    "ARIYALUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "MAYILADUDURAI DISTRICT GOVERNMENT MODEL SCHOOL",
    "NAGAPATTINAM DISTRICT GOVERNMENT MODEL SCHOOL",
    "PERAMBALUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "THANJAVUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "TIRUCHIRAPPALLI DISTRICT GOVERNMENT MODEL SCHOOL",
    "TIRUVARUR DISTRICT GOVERNMENT MODEL SCHOOL"
  ],
  "CENTRAL ZONE": [
    "KARUR DISTRICT GOVERNMENT MODEL SCHOOL",
    "DINDIGUL DISTRICT GOVERNMENT MODEL SCHOOL",
    "MADURAI DISTRICT GOVERNMENT MODEL SCHOOL",
    "SIVAGANGAI DISTRICT GOVERNMENT MODEL SCHOOL",
    "PUDUKKOTTAI DISTRICT GOVERNMENT MODEL SCHOOL",
    "THENI DISTRICT GOVERNMENT MODEL SCHOOL"
  ],
  "SOUTHERN ZONE": [
    "KANNIYAKUMARI DISTRICT GOVERNMENT MODEL SCHOOL",
    "TIRUNELVELI GOVERNMENT MODEL SCHOOL",
    "THOOTHUKUDI GOVERNMENT MODEL SCHOOL",
    "VIRUTHUNAGER GOVERNMENT MODEL SCHOOL",
    "TENKASI GOVERNMENT MODEL SCHOOL",
    "RAMANATHAPURAM GOVERNMENT MODEL SCHOOL"
  ]
};

const getAllStudent = async (req, res) => {
  try {
    const { district } = req.query;

    let students = [];

    if (district && district !== "All") {
      if (zoneSchoolMapping[district.toUpperCase()]) {
        // If district is a zone, fetch all students from the schools in that zone
        const zoneSchools = zoneSchoolMapping[district.toUpperCase()];
        students = await Student.find({ school_name: { $in: zoneSchools } });
      } else {
        // Otherwise, fetch students for a specific district
        students = await Student.find({ school_name: district });
      }
    } else {
      // If no district is specified, fetch all students
      students = await Student.find();
    }

    const totalStudents = students.length;
    let totalRedFlags = 0;
    let recoveredByDMHP = 0;
    let ongoingCases = 0;
    let completedCases = 0;
    let referrals = 0;
    let rejected = 0;

    const redFlagStudents = [];
    const recoveredStudents = [];
    const ongoingStudents = [];
    const completedStudents = [];
    const referralStudents = [];
    const rejectedStudents = [];

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
      if (student.Case_Status === "reject") {
        rejected++;
        rejectedStudents.push(student);
      }
      if (student.referal_bool === true) {
        referrals++;
        referralStudents.push(student);
      }
    });

    res.status(200).json({
      msg: "Student statistics fetched successfully.",
      totalStudents,
      totalRedFlags,
      redFlagStudents,
      recoveredByDMHP,
      recoveredStudents,
      ongoingCases,
      ongoingStudents,
      completedCases,
      completedStudents,
      referrals,
      referralStudents,
      rejected,
      rejectedStudents,
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
