import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driverDetails.dart';

class RideWatcher extends StatefulWidget {
  final String rideId;

  RideWatcher({Key? key, required this.rideId}) : super(key: key);

  @override
  _RideWatcherState createState() => _RideWatcherState();
}

class _RideWatcherState extends State<RideWatcher> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('rides').doc(widget.rideId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return CircularProgressIndicator();
        }

        var rideData = snapshot.data!.data() as Map<String, dynamic>;
        var status = rideData['status'];

        if (status == 'accepted') {
          // Navigate to the DriverDetails page with necessary details
          Future.microtask(() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DriverDetails(
                pickupLocation: LatLng(rideData['pickupLocation'].latitude, rideData['pickupLocation'].longitude),
                destinationLocation: LatLng(rideData['destinationLocation'].latitude, rideData['destinationLocation'].longitude),
                rideType: rideData['rideType'],
                fare: rideData['fare'],
                driverName: rideData['driverDetails']['name'],
                vehicleModel: rideData['driverDetails']['vehicleModel'],
                vehiclePlate: rideData['driverDetails']['vehiclePlate'],
              ),
            ),
          ));

          return Text("Driver has accepted your ride!");
        }

        return Text("Waiting for driver acceptance...");
      },
    );
  }
}
