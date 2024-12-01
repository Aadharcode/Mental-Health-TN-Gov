const jwt = require("jsonwebtoken");

const tokenIsValid = async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, process.env.JWT_SECRET);
    if (!verified) return res.json(false);

    res.json(true); // Token is valid
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = tokenIsValid;
