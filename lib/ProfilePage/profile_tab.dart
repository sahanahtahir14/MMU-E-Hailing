import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      // Change the endpoint URL to your actual Node.js server's endpoint
      var response = await http.get(Uri.parse('http://10.193.106.152:4001/user/profile'));

      if (response.statusCode == 200) {
        setState(() {
          userProfile = jsonDecode(response.body);
        });
      } else {
        print('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: userProfile == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          /*
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                userProfile!['photoUrl'] ?? 'path_to_default_image'),
          ),
          SizedBox(height: 20),
           */
          buildDetailItem('User ID', userProfile!['userId']),
          buildDetailItem('Name', userProfile!['name']),
          buildDetailItem('Email', userProfile!['email']),
          buildDetailItem('Phone Number', userProfile!['phone']),
        ],
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
