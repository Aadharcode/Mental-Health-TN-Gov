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

const getStudentsByZone = async (req, res) => {
  try {
    // Trim and case-insensitive comparison
    const zone = req.body.zone ? req.body.zone.trim().toUpperCase() : null;
    // Zone check
    if (!zone || !zoneSchoolMapping[zone]) {
      return res.status(400).json({ msg: "Invalid zone provided." });
    }
    // Get the list of schools for the given zone
    const schools = zoneSchoolMapping[zone];
    // Create a case-insensitive regex for the school names
    const regexSchools = schools.map(school => new RegExp(`^${school}$`, 'i'));
    const students = await Student.find({
      school_name: { $in: regexSchools }
    });
    if (!students || students.length === 0) {
      return res.status(404).json({ msg: "No students found for the specified zone." });
    }

    res.status(200).json({
      msg: "Students fetched successfully.",
      data: students,
    });
  } catch (err) {
    console.error("Error fetching students by zone:", err);
    res.status(500).json({
      msg: "An error occurred while fetching students.",
      error: err.message,
    });
  }
};

module.exports = getStudentsByZone;