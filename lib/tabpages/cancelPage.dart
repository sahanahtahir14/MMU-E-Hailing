import 'package:flutter/material.dart';

class CancellationReason extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancellation Reason"),
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
                "Why are you canceling?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildReasonButton(context, "Pick-up point"),
              buildReasonButton(context, "Payment method"),
              buildReasonButton(context, "Driver is too far"),
              buildReasonButton(context, "Driver asked to cancel"),
              buildReasonButton(context, "Changed my mind"),
              buildReasonButton(context, "Others"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReasonButton(BuildContext context, String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle the cancellation reason here
          Navigator.popUntil(context, ModalRoute.withName('/confirmBooking')); // Go back to the previous page
        },
        child: Text(reason),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFB8E2F2),
          foregroundColor: Colors.black,
          minimumSize: Size(double.infinity, 50),
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
