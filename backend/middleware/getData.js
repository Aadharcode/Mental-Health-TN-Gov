const User = require("../models/user");

const getData = async (req, res) => {
    const user = await User.findById(req.user);
    res.json({ ...user._doc, token: req.token });
};

module.exports = getData;