import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../driverDetails.dart';

class SearchingForDriverPage extends StatelessWidget {
  final String rideId;

  SearchingForDriverPage({required this.rideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searching for Driver'),
        backgroundColor: Color(0xFFB8E2F2),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('rides').doc(rideId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          if (data['status'] == 'accepted' && data.containsKey('driverDetails')) {
            return DriverDetails(
              pickupLocation: LatLng(data['pickupLocation'].latitude, data['pickupLocation'].longitude),
              destinationLocation: LatLng(data['destinationLocation'].latitude, data['destinationLocation'].longitude),
              rideType: data['rideType'],
              fare: data['fare'],
              driverName: data['driverDetails']['name'],
              vehicleModel: data['driverDetails']['vehicleModel'],
              vehiclePlate: data['driverDetails']['vehiclePlate'],
            );
          }

          return Center(
            child: Text('Searching for a driver...'),
          );
        },
      ),
    );
  }
}
