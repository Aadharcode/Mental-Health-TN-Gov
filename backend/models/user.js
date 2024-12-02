const mongoose = require("mongoose");

const psychiatristSchema = mongoose.Schema({
  district: {
    required: true,
    type: String,
    trim: true,
  },
  DISTRICT_PSYCHIATRIST_NAME: {
    required: true,
    type: String,
    trim: true,
  },
  Mobile_number: {
    required: true,
    type: String,
    validate: {
      validator: (value) => /^[0-9]{10}$/.test(value),
      message: "Please enter a valid mobile number",
    },
  },
  SATELLITE_PSYCHIATRIST_NAME: {
    required: true,
    type: String,
    trim: true,
  },
  SATELLITE_mobile_number: {
    required: true,
    type: String,
    validate: {
      validator: (value) => /^[0-9]{10}$/.test(value),
      message: "Please enter a valid mobile number",
    },
  },
  password: {
    required: true,
    type: String,
  },
  Role: {
    type: String,
    enum: ["psychiatrist"],
    default: "psychiatrist",
  },
},{ versionKey: false });

const teacherSchema = mongoose.Schema({
  district: {
    required: true,
    type: String,
    trim: true,
  },
  School_name: {
    required: true,
    type: String,
    trim: true,
  },
  Teacher_Name: {
    required: true,
    type: String,
    trim: true,
  },
  mobile_number: {
    required: true,
    type: String,
  },
  password: {
    //required: true,
    type: String,
  },
  Role: {
    type: String,
    enum: ["teacher"],
    default: "teacher",
  },
},{ versionKey: false });

const studentSchema = mongoose.Schema({
  school_name: {
    required: true,
    type: String,
    trim: true,
  },
  student_emis_id: {
    required: true,
    type: String,
    trim: true,
  },
  student_name: {
    required: true,
    type: String,
    trim: true,
  },
  date_of_birth: {
    required: true,
    type: Date,
  },
  gender: {
    required: true,
    type: String,
    enum: ["Male", "Female", "Other"],
  },
  class: {
    required: true,
    type: Number,
  },
  group_code: {
    //required: true,
    type: Number,
  },
  group_name: {
    //required: true,
    type: String,
    trim: true,
  },
  medium: {
    required: true,
    type: String,
    trim: true,
  },
  password: {
    required: true,
    type: String,
  },
  role: {
    type: String,
    enum: ["student"],
    default: "student",
  },
},{ versionKey: false });

const schoolSchema = mongoose.Schema({
  SCHOOL_NAME: {
    required: true,
    type: String,
    trim: true,
  },
  DISTRICT: {
    required: true,
    type: String,
    trim: true,
  },
  udise_no: {
    required: true,
    type: String,
    trim: true,
  },
  SCHOOL_MAIL_ID: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/.test(value),
      message: "Please enter a valid email address",
    },
  },
  HM_NAME: {
    required: true,
    type: String,
    trim: true,
  },
  HM_MOBILE_NO: {
    required: true,
    type: String,
    validate: {
      validator: (value) => /^[0-9]{10}$/.test(value),
      message: "Please enter a valid mobile number",
    },
  },
  password: {
    required: true,
    type: String,
  },
  Role: {
    type: String,
    enum: ["hs-ms"],
    default: "hs-ms",
  },
},{ versionKey: false });

const adminSchema = mongoose.Schema({
  email: {
    required: true,
    type: String,
    trim: true,
    unique: true,
    validate: {
      validator: (value) => /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/.test(value),
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
  },
  role: {
    type: String,
    enum: ["admin"],
    default: "admin",
  },
},{ versionKey: false });

const Psychiatrist = mongoose.model("Psychiatrist", psychiatristSchema);
const Teacher = mongoose.model("Teacher", teacherSchema);
const Student = mongoose.model("Student", studentSchema);
const School = mongoose.model("School", schoolSchema);
const Admin = mongoose.model("Admin", adminSchema);

module.exports = { Psychiatrist, Teacher, Student, School, Admin };
