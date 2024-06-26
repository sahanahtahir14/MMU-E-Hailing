import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addBooking({
    required GeoPoint pickupLocation,
    required GeoPoint destinationLocation,
    required String rideType,
    required double fare,
    required String status,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    DocumentReference booking = firestore.collection('bookings').doc();

    await booking.set({
      'pickupLocation': pickupLocation,
      'destinationLocation': destinationLocation,
      'rideType': rideType,
      'fare': fare,
      'userId': user.uid,
      'status': status,
    });
  }
}
