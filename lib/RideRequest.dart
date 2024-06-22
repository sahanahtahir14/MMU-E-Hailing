import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequest {
  final String id;
  final String passengerName;
  final String pickupLocation;
  final String destination;
  final DateTime requestedTime;

  RideRequest({
    required this.id,
    required this.passengerName,
    required this.pickupLocation,
    required this.destination,
    required this.requestedTime,
  });

  factory RideRequest.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return RideRequest(
      id: doc.id,
      passengerName: data['passengerName'] ?? '',
      pickupLocation: data['pickupLocation'] ?? '',
      destination: data['destination'] ?? '',
      requestedTime: (data['requestedTime'] as Timestamp).toDate(),
    );
  }
}
