// server.js
const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'driver_app'
});

db.connect(err => {
  if (err) throw err;
  console.log('MySQL Connected...');
});

app.post('/driver', (req, res) => {
  let driver = req.body;
  let sql = `INSERT INTO drivers SET ? ON DUPLICATE KEY UPDATE ?`;
  db.query(sql, [driver, driver], (err, result) => {
    if (err) throw err;
    res.send('Driver saved...');
  });
});

app.post('/activeDriver', (req, res) => {
  let location = req.body;
  let sql = `INSERT INTO activeDrivers SET ? ON DUPLICATE KEY UPDATE ?`;
  db.query(sql, [location, location], (err, result) => {
    if (err) throw err;
    res.send('Location updated...');
  });
});

app.delete('/activeDriver/:id', (req, res) => {
  let sql = `DELETE FROM activeDrivers WHERE driver_id = ?`;
  db.query(sql, [req.params.id], (err, result) => {
    if (err) throw err;
    res.send('Driver removed...');
  });
});

app.listen(8080, () => {
  console.log('Server started on port 8080');
});
