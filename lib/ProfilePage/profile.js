import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFB8E2F2),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            buildDetailItem('User ID', '123456'),
            buildDetailItem('Name', 'John Doe'),
            buildDetailItem('Email', 'john.doe@example.com'),
            buildDetailItem('Phone Number', '0123456789'),
            buildDetailItem('Other Details', 'Additional Info 1'),
            buildDetailItem('Other Details', 'Additional Info 2'),
          ],
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 4,
            child: Text(value, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

