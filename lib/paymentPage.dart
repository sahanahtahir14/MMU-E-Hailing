import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String rideId;

  PaymentPage({required this.rideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Payment'),
        backgroundColor: Color(0xFFB8E2F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                "Payment Methods",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle cash payment
                },
                child: Text('Cash'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB8E2F2),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
