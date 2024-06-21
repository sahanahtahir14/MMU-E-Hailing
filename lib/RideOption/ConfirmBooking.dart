import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:passenger_app/driverDetails.dart';

class ConfirmBooking extends StatelessWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String rideType;
  final double fare;

  ConfirmBooking({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.rideType,
    required this.fare,
  });

  Future<void> bookRide(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.193.106.152:3007/bookRide'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'pickupLocation': {
          'latitude': pickupLocation.latitude,
          'longitude': pickupLocation.longitude,
        },
        'destinationLocation': {
          'latitude': destinationLocation.latitude,
          'longitude': destinationLocation.longitude,
        },
        'rideType': rideType,
      }),
    );

    if (response.statusCode == 200) {
      final driverDetails = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDetails(
            pickupLocation: pickupLocation,
            destinationLocation: destinationLocation,
            rideType: rideType,
            fare: fare,
            driverName: driverDetails['driverName'],
            vehicleModel: driverDetails['vehicleModel'],
            vehiclePlate: driverDetails['vehiclePlate'],
          ),
        ),
      );
    } else {
      // Handle error
      print('Failed to book ride');
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
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
    };
    Set<Polyline> polylines = {
      Polyline(
        polylineId: PolylineId("route"),
        points: [pickupLocation, destinationLocation],
        width: 4,
        color: Colors.blue,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Booking"),
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
              markers: markers,
              polylines: polylines,
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
                  'Calculated Fare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rideType,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      'RM ${fare.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => bookRide(context),
                  child: Text('Book Ride'),
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
