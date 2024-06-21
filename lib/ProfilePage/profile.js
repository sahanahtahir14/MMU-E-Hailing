const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'profile'
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting:', err);
    return;
  }
  console.log('Connected to the database');
});

// Endpoint to get user profile without requiring authentication
app.get('/user/profile', (req, res) => {
  const userId = '1';  // This can be dynamic based on your app's needs
  const query = 'SELECT userId, name, email, phone FROM users WHERE userId = ?';
  db.query(query, [userId], (err, results) => {
    if (err) {
      res.status(500).send('Error fetching user details');
      return;
    }
    if (results.length === 0) {
      res.status(404).send('User not found');
      return;
    }
    res.json(results[0]);
  });
});

const PORT = 4001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
