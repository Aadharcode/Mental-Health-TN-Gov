const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const { Student ,Psychiatrist, Teacher,  School, Admin, Ms } = require("./models/user");
const {  ASA , CIF , RC, Warden , stateCoord } = require("./models/user");

// Function to hash and update passwords
const updatePasswords = async (model, modelName) => {
  try {
    console.log(`Starting password update for ${modelName}...`);

    const users = await model.find(); // Fetch all documents in the collection
    for (const user of users) {
      if (user.password && !user.password.startsWith("$2b$")) { // Check if password is already hashed
        const salt = await bcrypt.genSalt(); // Generate salt
        const hashedPassword = await bcrypt.hash(user.password, salt); // Hash the password
        await model.updateOne({ _id: user._id }, { password: hashedPassword });
        console.log(`Password updated for ${modelName}: ${user._id}`);
      }
    }

    console.log(`Password update completed for ${modelName}!`);
  } catch (error) {
    console.error(`Error updating passwords for ${modelName}:`, error);
  }
};

// Main function to connect to DB and update passwords for all models
(async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(
      // process.env.DB_CONNECTION,
      { useNewUrlParser: true, useUnifiedTopology: true }
    );
    console.log("Connected to MongoDB!");

    // Update passwords for each model
    await updatePasswords(Psychiatrist, "Psychiatrist");
    // await updatePasswords(Teacher, "Teacher");
    // await updatePasswords(Student, "Student");
    // await updatePasswords(School, "School");
    // await updatePasswords(Admin, "Admin");
    // await updatePasswords(Ms, "Ms");
    // await updatePasswords(ASA, "ASA");
    // await updatePasswords(CIF, "CIF");
    // await updatePasswords(stateCoord, "stateCoord");

    console.log("Password updates completed for all models!");
  } catch (error) {
    console.error("Error connecting to MongoDB:", error);
  } finally {
    mongoose.disconnect(); // Disconnect from DB
  }
})();
