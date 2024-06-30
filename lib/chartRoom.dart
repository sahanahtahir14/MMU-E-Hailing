import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _sendMessage(String userId, String username) async {
    if (_controller.text.isNotEmpty) {
      await _firestore.collection('chats').add({
        'text': _controller.text,
        'createdAt': Timestamp.now(),
        'userId': userId,
        'username': username,
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('In-app Message Box'),
      ),
      body: currentUser == null
          ? Center(child: Text('No user logged in'))
          : StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(currentUser.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final userData = userSnapshot.data!;
          final String userId = userData.id;
          final String username = userData['username'];

          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _firestore.collection('chats').orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                    if (!chatSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final messages = chatSnapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text(message['username']),
                          subtitle: Text(message['text']),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Message here',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _sendMessage(userId, username),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
