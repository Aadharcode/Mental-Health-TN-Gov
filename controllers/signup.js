const bcryptjs = require("bcryptjs");
const User = require("../models/user");

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

    let user = new User({
      email,
      name,
      school,
      password: hashedPassword,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = signup; 