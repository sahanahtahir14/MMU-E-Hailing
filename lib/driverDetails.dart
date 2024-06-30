import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger_app/paymentPage.dart';
import 'package:passenger_app/tabpages/cancelPage.dart';
import 'chartRoom.dart';

class DriverDetails extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String rideType;
  final double fare;
  final String driverName;
  final String vehicleModel;
  final String vehiclePlate;

  final String rideId;

  DriverDetails({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.rideType,
    required this.fare,
    required this.driverName,
    required this.vehicleModel,
    required this.vehiclePlate,

    required this.rideId
  });

  @override
  _DriverDetailsState createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  LatLng? driverCurrentLocation;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchDriverCurrentLocation();
  }

  Future<void> _fetchDriverCurrentLocation() async {
    final DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .doc(user!.uid)
        .get();

    if (driverSnapshot.exists) {
      GeoPoint location = driverSnapshot['currentLocation'];
      setState(() {
        driverCurrentLocation = LatLng(location.latitude, location.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver's Details"),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
              markers: {
                if (driverCurrentLocation != null)
                  Marker(
                    markerId: MarkerId("driver"),
                    position: driverCurrentLocation!,
                    infoWindow: InfoWindow(title: 'Driver Current Location'),
                  ),
                Marker(
                  markerId: MarkerId("pickup"),
                  position: widget.pickupLocation,
                  infoWindow: InfoWindow(title: 'Pick-up Location'),
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: widget.destinationLocation,
                  infoWindow: InfoWindow(title: 'Destination'),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: [widget.pickupLocation, widget.destinationLocation],
                  width: 4,
                  color: Colors.blue,
                ),
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFB8E2F2),
                  blurRadius: 3.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Driver Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vehicle: ${widget.vehicleModel}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      'Plate: ${widget.vehiclePlate}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Driver: ${widget.driverName}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                      icon: Icon(Icons.chat),
                      label: Text('Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB8E2F2),
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CancellationReason(),
                      ),
                    );
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    GeoPoint pickupGeoPoint = GeoPoint(
                        widget.pickupLocation.latitude,
                        widget.pickupLocation.longitude);
                    GeoPoint destinationGeoPoint = GeoPoint(
                        widget.destinationLocation.latitude,
                        widget.destinationLocation.longitude);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          driverName: widget.driverName,
                          vehicleModel: widget.vehicleModel,
                          vehiclePlate: widget.vehiclePlate,
                          pickupLocation: pickupGeoPoint,
                          destinationLocation: destinationGeoPoint,
                          status: 'completed',
                        ),
                      ),
                    );
                  },
                  child: Text('Proceed to Payment'),
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
        ],
      ),
    );
  }
}
