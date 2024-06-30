import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('reviews').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var review = snapshot.data!.docs[index];
                      var reviewData = review.data() as Map<String, dynamic>;

                      GeoPoint? pickupLocation = reviewData['pickupLocation'];
                      GeoPoint? destinationLocation = reviewData['destinationLocation'];

                      return Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Driver: ${reviewData['driverName']}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Vehicle: ${reviewData['vehicleModel']}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            Text(
                              'Plate: ${reviewData['vehiclePlate']}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rating: ${reviewData['rating']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Review: ${reviewData['review']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Pickup: ${pickupLocation != null ? '(${pickupLocation.latitude}, ${pickupLocation.longitude})' : 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Destination: ${destinationLocation != null ? '(${destinationLocation.latitude}, ${destinationLocation.longitude})' : 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Status: ${reviewData['status']}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Date: ${reviewData['timestamp'].toDate()}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
