const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const { Psychiatrist, Teacher, Student, School, Admin } = require("./models/user");

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
      "mongodb://emotionalwellbeingtnmss2024:FocBAqms1qchIFvO@tnmss-shard-00-00.z7chu.mongodb.net:27017,tnmss-shard-00-01.z7chu.mongodb.net:27017,tnmss-shard-00-02.z7chu.mongodb.net:27017/?replicaSet=atlas-z05rhn-shard-0&ssl=true&authSource=admin",
      { useNewUrlParser: true, useUnifiedTopology: true }
    );
    console.log("Connected to MongoDB!");

    // Update passwords for each model
    await updatePasswords(Psychiatrist, "Psychiatrist");
    await updatePasswords(Teacher, "Teacher");
    await updatePasswords(Student, "Student");
    await updatePasswords(School, "School");
    await updatePasswords(Admin, "Admin");

    console.log("Password updates completed for all models!");
  } catch (error) {
    console.error("Error connecting to MongoDB:", error);
  } finally {
    mongoose.disconnect(); // Disconnect from DB
  }
})();
