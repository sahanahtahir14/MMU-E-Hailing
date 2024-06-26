import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/tabpages/cancelPage.dart';

class DriverDetails extends StatelessWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String rideType;
  final double fare;
  final String driverName;
  final String vehicleModel;
  final String vehiclePlate;

  DriverDetails({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.rideType,
    required this.fare,
    required this.driverName,
    required this.vehicleModel,
    required this.vehiclePlate,
    required String rideId,
    required driverId,
  });

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
                  (pickupLocation.latitude + destinationLocation.latitude) / 2,
                  (pickupLocation.longitude + destinationLocation.longitude) / 2,
                ),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("pickup"),
                  position: pickupLocation,
                  infoWindow: InfoWindow(title: 'Pick-up Location'),
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: destinationLocation,
                  infoWindow: InfoWindow(title: 'Destination'),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: [pickupLocation, destinationLocation],
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
                      'Vehicle: $vehicleModel',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      'Plate: $vehiclePlate',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Driver: $driverName',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implement chat functionality
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
