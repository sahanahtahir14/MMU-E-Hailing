import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RideService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRideRequest({
    required GeoPoint pickupLocation,
    required GeoPoint destinationLocation,
    required String rideType,
    required double fare,
  }) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user currently logged in.");
    }

    await _firestore.collection('rides').add({
      'passengerId': currentUser.uid,
      'pickupLocation': pickupLocation,
      'destinationLocation': destinationLocation,
      'rideType': rideType,
      'fare': fare,
      'requestedTime': FieldValue.serverTimestamp(),
      'status': 'waiting',
      'driverId': null,
    });
  }
}
