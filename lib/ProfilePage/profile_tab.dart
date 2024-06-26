import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tabpages/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userProfile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (user != null) {
      var profileData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userProfile = profileData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Color(0xFFB8E2F2),

      ),
      body: userProfile == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          SizedBox(height: 24),
          detailItem("Name", userProfile!['username']),
          detailItem("Email", user!.email!),
          detailItem("Phone Number", userProfile!['phone']),
          SizedBox(height: 24),
          logoutButton(context),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget detailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService.logout();
        Navigator.of(context).pushReplacementNamed('/login');
      },
      child: Text('Logout'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
