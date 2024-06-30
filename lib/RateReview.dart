import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger_app/tabpages/ride_history.dart';
 // Import the ActivityPage

class RateReviewPage extends StatelessWidget {
  final String driverName;
  final String vehicleModel;
  final String vehiclePlate;
  final GeoPoint pickupLocation;
  final GeoPoint destinationLocation;
  final String status;

  RateReviewPage({
    required this.driverName,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.status,
  });

  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3;

  void _submitReview(BuildContext context) async {
    String review = _reviewController.text;

    // Add the review to Firestore
    await FirebaseFirestore.instance.collection('reviews').add({
      'driverName': driverName,
      'vehicleModel': vehicleModel,
      'vehiclePlate': vehiclePlate,
      'rating': _rating,
      'review': review,
      'pickupLocation': pickupLocation,
      'destinationLocation': destinationLocation,
      'status': status,
      'timestamp': Timestamp.now(),
    });

    // Navigate back to Activity Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ActivityPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate or Review"),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How was your experience with",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Driver: $driverName',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              'Vehicle: $vehicleModel',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              'Plate: $vehiclePlate ?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Rate the Driver",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            SizedBox(height: 20),
            Text(
              "Write a Review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your feedback here",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitReview(context),
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB8E2F2),
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
