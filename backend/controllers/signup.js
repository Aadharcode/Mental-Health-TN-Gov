const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const jwt = require("jsonwebtoken");

const signup = async (req, res) => {
  try {
    const { name, school, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 10);
    const token = jwt.sign({ id: email }, process.env.JWT_SECRET, {
      expiresIn: "7d", // Token expiration time
    });

    let user = new User({
      email,
      name,
      school,
      password: hashedPassword,
      token, // Store the JWT token in the database
    });
    user = await user.save();
    res.json({ user});
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = signup; 