
const express = require('express');

// Import dotenv
require('dotenv').config({ path: './config/.env' });


const port = process.env.PORT || 3000;

console.log(`Server is running on port ${port}`);

const app = express();


app.get('/', (req, res) => {
    res.send('Hello from Express!');
  });

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
  });