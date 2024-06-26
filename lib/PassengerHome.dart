import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PassengerHome extends StatefulWidget {
  final String rideId;

  PassengerHome({required this.rideId});

  @override
  _PassengerHomeState createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  @override
  void initState() {
    super.initState();
    _listenToRideStatus();
  }

  void _listenToRideStatus() {
    FirebaseFirestore.instance.collection('rides').doc(widget.rideId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data['status'] == 'near_completion') {
          _showNearDestinationAlert();
        }
      }
    });
  }

  void _showNearDestinationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Brace yourself"),
          content: Text("You're very close to your destination. Please prepare your payment."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Home'),
      ),
      body: Center(
        child: Text('Welcome to Passenger Home'),
      ),
    );
  }
}
