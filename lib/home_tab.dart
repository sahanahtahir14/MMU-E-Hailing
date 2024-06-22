import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequests extends StatefulWidget {
  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Requests"),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('rides').where('status', isEqualTo: 'pending').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              GeoPoint pickupLocation = data['pickupLocation'];
              GeoPoint destinationLocation = data['destinationLocation'];

              return ListTile(
                title: Text("Ride from ${pickupLocation.latitude}, ${pickupLocation.longitude} to ${destinationLocation.latitude}, ${destinationLocation.longitude}"),
                subtitle: Text("Fare: RM ${data['fare']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => updateRideStatus(document.id, 'accepted'),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () => updateRideStatus(document.id, 'rejected'),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> updateRideStatus(String docId, String status) async {
    try {
      await _firestore.collection('rides').doc(docId).update({
        'status': status,
        'driverId': status == 'accepted' ? _firestore.app.options.appId : null,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update status: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
