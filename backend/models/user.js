const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

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
    // validate: {
    //   validator: (value) => /^[0-9]{10}$/.test(value),
    //   message: "Please enter a valid mobile number",
    // },
  },
  SATELLITE_PSYCHIATRIST_NAME: {
    required: true,
    type: String,
    trim: true,
  },
  SATELLITE_mobile_number: {
    required: true,
    type: String,
    // validate: {
    //   validator: (value) => /^[0-9]{10}$/.test(value),
    //   message: "Please enter a valid mobile number",
    // },
  },
  // entryTime: {
  //   type: Date,
  // },
  // exitTime: {
  //   type: Date,
  // },
  averageTime: {
    type: Number,
    default: 0,
  },
  NoOfVisits: {
    type: Number,
    default: 0,
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
    type: String,
  },
  gender: {
    required: true,
    type: String,
    enum: ["Male", "Female", "Other"],
  },
  class: {
    required: true,
    type: String,
  },
  group_code: {
    //required: true,
    type: String,
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
  anxiety: {
    type: Boolean,
    default: false,
  },
  depression: {
    type: Boolean,
    default: false,
  },
  aggresion_violence: {
    type: Boolean,
    default: false,
  },
  selfharm_suicide: {
    type: Boolean,
    default: false,
  },
  sexual_abuse: {
    type: Boolean,
    default: false,
  },
  stress: {
    type: Boolean,
    default: false,
  },
  loss_grief: {
    type: Boolean,
    default: false,
  },
  relationship: {
    type: Boolean,
    default: false,
  },
  bodyimage_selflisten: {
    type: Boolean,
    default: false,
  },
  sleep: {
    type: Boolean,
    default: false,
  },
  conduct_delinquency: {
    type: Boolean,
    default: false,
  },
  approval: {
    type: Boolean,
    default: false,
  },
  referal_bool: {
    type: Boolean,
    default: false,
  },
  referal: {
    type: String,
    enum: ["null","district","others"],
    default: "null",
  },
  Case_Status:{
    type: String,
    enum: ["none","ongoing","completed","reject"],
    default: "none",
  },
  Medicine_bool: {
    type: Boolean,
    default: false,
  },
  Medicine:{
    type: String,
    trim: true,
    default: "",
  },
  Reject:{
    type: String,
    trim: true,
    default: "",
  }
},{ versionKey: false });

const victimSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  age: {
    required: true,
    type: String,
    trim: true,
  },
  sex: {
    required: true,
    type: String,
    enum: ["Male", "Female", "Other"],
  },
  emis_id: {
    required: true,
    type: String,
    trim: true,
  },
  Location:{
    type: String,
    trim: true,
    default: "",
  },
  Time:{
    type: String,
    trim: true,
    default: "",
  },
  Date:{
    type: Date,
    default: null,
  },
  Details:{
    type: String,
    trim: true,
    default: "",
  },
  // inappropriateTouching: {
  //   type: Boolean,
  //   default: false,
  // },
  // sexualAdvances: {
  //   type: Boolean,
  //   default: false,
  // },
  // physicalAbuse: {
  //   type: Boolean,
  //   default: false,
  // },
  // onlineHarassment: {
  //   type: Boolean,
  //   default: false,
  // },
  // showingInappropriateContent: {
  //   type: Boolean,
  //   default: false,
  // },
  type: {
    type: String,
    trim: true,
    default: "",
  },
  level: {
    enum: ["Emergency","NON-Emergency"],
    default: "",
  }
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
    // validate: {
    //   validator: (value) => /^[0-9]{10}$/.test(value),
    //   message: "Please enter a valid mobile number",
    // },
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

const ASASchema = mongoose.Schema({
  School_Name: {
    required: true,
    type: String,
  },
  ASA_Mail_id: {
    required: true,
    type: String,
  },
  ASA_Name: {
    required: true,
    type: String,
  },
  mobile_number: {
    required: true,
    type: String,
  },
  Phase: {
    required: true,
    type: String,
  },
  RC: {
    required: true,
    type: String,
  },
  Willing_to_join_CUG: {
    required: true,
    type: String,
  },
  password: {
    required: true,
    type: String,
  },
  role: {
    type: String,
    enum: ["asa"],
    default: "asa",
  },
},{ versionKey: false });

const CIFSchema = mongoose.Schema({
  School_Name: {
    required: true,
    type: String,
  },
  CIF_Mail_id: {
    required: true,
    type: String,
  },
  CIF_Name: {
    required: true,
    type: String,
  },
  mobile_number: {
    required: true,
    type: String,
  },
  Phase: {
    required: true,
    type: String,
  },
  RC: {
    required: true,
    type: String,
  },
  Willing_to_join_CUG: {
    required: true,
    type: String,
  },
  password: {
    required: true,
    type: String,
  },
  role: {
    type: String,
    enum: ["cif"],
    default: "cif",
  },
},{ versionKey: false });

const RegionalCoordSchema = mongoose.Schema({
  Zone: {
    required: true,
    type: String,
  },
  email: {
    required: true,
    type: String,
  },
  Name: {
    required: true,
    type: String,
  },
  mobile_number: {
    required: true,
    type: String,
  },
  password: {
    required: true,
    type: String,
  },
  role: {
    type: String,
    enum: ["rc"],
    default: "rc",
  },
},{ versionKey: false });

const wardenSchema = mongoose.Schema({
  DISTRICT: {
    required: true,
    type: String,
  },
  NAME: {
    required: true,
    type: String,
  },
  GENDER: {
    required: true,
    type: String,
  },
  DESIGNATION: {
    required: true,
    type: String,
  },
  mobile_number: {
    required: true,
    type: String,
  },
  Email: {
    type: String,
  },
  password: {
    required: true,
    type: String,
  },
  role: {
    type: String,
    enum: ["warden"],
    default: "warden",
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

const msSchema = mongoose.Schema({
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
    enum: ["ms"],
    default: "ms",
  },
},{ versionKey: false });

const stateCoordSchema = mongoose.Schema({
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
    enum: ["sc"],
    default: "sc",
  },
},{ versionKey: false });

const timeSlotSchema = mongoose.Schema({
  timeSlot: {
    required: true,
    type: mongoose.Schema.Types.Date,    
  },
  timespan:{
    type: String,
  },
  School_Name: {
    required: true,
    type: String,
  },
  status: {
    type: Boolean,
    default: false,
  },
},{ versionKey: false });

const feedbackSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  feedback: {
    required: true,
    type: String,
    trim: true,
  },
  role: {
    type: String,
    enum: ["ms", "psychiatrist","hs-ms"],
    default: "ms",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
},{ versionKey: false });

const attendanceSchema = mongoose.Schema({
  psychiatristName: {
    required: true,
    type: String,
    trim: true,
  },
  latitude: {
    required: true,
    type: String,
    trim: true,
  },
  longitude: {
    required: true,
    type: String,
    trim: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  entryExit: {
    enum:["entry","exit"],
    // required: true,
  },
},{ versionKey: false });

// Hashing before password saved to db
psychiatristSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

teacherSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

studentSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

schoolSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

ASASchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

CIFSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

adminSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

msSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

stateCoordSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

wardenSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

RegionalCoordSchema.pre('save', async function(next) {
  if (this.isModified('password')) { 
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

const Psychiatrist = mongoose.model("Psychiatrist", psychiatristSchema);
const Teacher = mongoose.model("Teacher", teacherSchema);
const Student = mongoose.model("Student", studentSchema);
const School = mongoose.model("School", schoolSchema);
const Admin = mongoose.model("Admin", adminSchema);
const Ms = mongoose.model("Ms", msSchema);
const Warden = mongoose.model("Warden", wardenSchema);
const Feedback = mongoose.model("Feedback", feedbackSchema);
const Attendance = mongoose.model("Attendance", attendanceSchema);
const ASA = mongoose.model("ASA", ASASchema);
const CIF = mongoose.model("CIF", CIFSchema);
const RC = mongoose.model("RC",RegionalCoordSchema);
const timeSlot = mongoose.model("timeSlot",timeSlotSchema);
const stateCoord = mongoose.model("stateCoord", stateCoordSchema);
const victim = mongoose.model("victim", victimSchema);

module.exports = { Psychiatrist, Teacher, Student, School, Admin, Ms, Feedback, Attendance, ASA, CIF , RC , timeSlot , Warden ,stateCoord , victim};
