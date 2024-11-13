const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
require('dotenv').config();

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRouter);

const DB = "mongodb+srv://fiitjeeb02:fBSM4PJq2WXHzsfr@cluster0.0zinx.mongodb.net/auth";

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});