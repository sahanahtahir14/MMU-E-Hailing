const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root', // replace with your MySQL username
    password: 'password', // replace with your MySQL password
    database: 'ridesharing'
});

db.connect(err => {
    if (err) throw err;
    console.log('MySQL Connected...');
});

app.post('/bookRide', (req, res) => {
    const { pickupLocation, destinationLocation, rideType } = req.body;

    // Find the nearest active driver
    const query = `
        SELECT id, name, vehicle_model, vehicle_plate,
               (6371 * acos(cos(radians(?)) * cos(radians(latitude))
               * cos(radians(longitude) - radians(?)) + sin(radians(?))
               * sin(radians(latitude)))) AS distance
        FROM drivers
        WHERE is_active = 1
        HAVING distance < 10
        ORDER BY distance
        LIMIT 1`;

    db.query(query, [pickupLocation.latitude, pickupLocation.longitude, pickupLocation.latitude], (err, results) => {
        if (err) throw err;

        if (results.length > 0) {
            const driver = results[0];
            const insertQuery = `
                INSERT INTO rideRequests (passenger_name, pickup_location, destination, ride_type, driver_id)
                VALUES ('Passenger', ?, ?, ?, ?)
            `;
            db.query(insertQuery, [JSON.stringify(pickupLocation), JSON.stringify(destinationLocation), rideType, driver.id], (err, result) => {
                if (err) throw err;
                res.json({
                    driverName: driver.name,
                    vehicleModel: driver.vehicle_model,
                    vehiclePlate: driver.vehicle_plate
                });
            });
        } else {
            res.status(404).json({ message: 'No available drivers found' });
        }
    });
});

app.get('/rideRequests', (req, res) => {
    db.query("SELECT * FROM rideRequests WHERE status = 'pending'", (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.post('/acceptRide', (req, res) => {
    const { requestId } = req.body;
    db.query("UPDATE rideRequests SET status = 'accepted' WHERE id = ?", [requestId], (err, result) => {
        if (err) throw err;
        res.json({ message: 'Ride accepted' });
    });
});

app.post('/rejectRide', (req, res) => {
    const { requestId } = req.body;
    db.query("UPDATE rideRequests SET status = 'rejected' WHERE id = ?", [requestId], (err, result) => {
        if (err) throw err;
        res.json({ message: 'Ride rejected' });
    });
});

app.listen(3007, () => {
    console.log('Server running on port 3007...');
});