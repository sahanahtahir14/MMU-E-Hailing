import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../driverDetails.dart';

class ConfirmBooking extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String rideType;
  final double fare;
  final String rideId;

  ConfirmBooking({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.rideType,
    required this.fare,
    required this.rideId,
  });

  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  bool _isLoading = false;
  Stream<DocumentSnapshot>? _rideStream;

  @override
  void initState() {
    super.initState();
    _rideStream = FirebaseFirestore.instance.collection('rides').doc(widget.rideId).snapshots();
    _watchRide();
  }

  void _watchRide() {
    _rideStream?.listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data['status'] == 'accepted' && data.containsKey('driverDetails')) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DriverDetails(
                pickupLocation: widget.pickupLocation,
                destinationLocation: widget.destinationLocation,
                rideType: widget.rideType,
                fare: widget.fare,
                driverName: data['driverDetails']['name'],
                vehicleModel: data['driverDetails']['vehicleModel'],
                vehiclePlate: data['driverDetails']['vehiclePlate'],
                rideId: widget.rideId,
                //  driverId: data['driverDetails']['driverId']
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("pickup"),
        position: widget.pickupLocation,
        infoWindow: const InfoWindow(title: 'Pick-up Location'),
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position: widget.destinationLocation,
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    };

    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: [widget.pickupLocation, widget.destinationLocation],
        width: 4,
        color: Colors.blue,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Booking"),
        centerTitle: true,
        backgroundColor: const Color(0xFFB8E2F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  (widget.pickupLocation.latitude + widget.destinationLocation.latitude) / 2,
                  (widget.pickupLocation.longitude + widget.destinationLocation.longitude) / 2,
                ),
                zoom: 15,
              ),
              markers: markers,
              polylines: polylines,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
              boxShadow: [
                const BoxShadow(
                  color: Color(0xFFB8E2F2),
                  blurRadius: 3.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Calculated Fare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.rideType,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      'RM ${widget.fare.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () => _bookRide(context),
                  child: const Text('Book Ride'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8E2F2),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _bookRide(BuildContext context) {
    setState(() {
      _isLoading = true;
    });

    // Update ride status to "requested"
    FirebaseFirestore.instance.collection('rides').doc(widget.rideId).set({
      'pickupLocation': GeoPoint(widget.pickupLocation.latitude, widget.pickupLocation.longitude),
      'destinationLocation': GeoPoint(widget.destinationLocation.latitude, widget.destinationLocation.longitude),
      'rideType': widget.rideType,
      'fare': widget.fare,
      'status': 'requested'
    }).then((_) {
      setState(() {
        _isLoading = false;
      });

      // Continue to watch the ride for status updates
      _watchRide();
    });
  }
}
