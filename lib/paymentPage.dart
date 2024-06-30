import 'package:flutter/material.dart';
import 'RateReview.dart'; // Import the Rate/Review page
import 'package:cloud_firestore/cloud_firestore.dart'; // Import GeoPoint

class PaymentPage extends StatelessWidget {
  final String driverName;
  final String vehicleModel;
  final String vehiclePlate;
  final GeoPoint pickupLocation;
  final GeoPoint destinationLocation;
  final String status;

  PaymentPage({
    required this.driverName,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passenger Payment"),
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
              "Payment Methods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RateReviewPage(
                      driverName: driverName,
                      vehicleModel: vehicleModel,
                      vehiclePlate: vehiclePlate,
                      pickupLocation: pickupLocation,
                      destinationLocation: destinationLocation,
                      status: status,
                    ), // Navigate to the Rate/Review page
                  ),
                );
              },
              icon: Icon(Icons.money),
              label: Text('Cash'),
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
