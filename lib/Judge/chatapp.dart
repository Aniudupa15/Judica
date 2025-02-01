import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:judica/Judge/chatapp.dart';
import 'package:judica/auth/firebase_options.dart';

class OpenChatRoomViewa extends StatefulWidget {
  const OpenChatRoomViewa({super.key});

  @override
  State<OpenChatRoomViewa> createState() => _OpenChatRoomViewaState();
}

class _OpenChatRoomViewaState extends State<OpenChatRoomViewa> {
  User? currentUser;
  Future<DocumentSnapshot?>? currentUserDocFuture;

  UserModel otherUser = UserModel(
    userId: 'other@example.com',
    email: 'other@example.com',
    name: 'John Doe',
    profile: 'https://www.example.com/profile.jpg',
  );

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      currentUserDocFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) => doc.exists ? doc : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot?>(
        future: currentUserDocFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;

            UserModel currentUserModel = UserModel(
              userId: currentUser!.email!,
              email: currentUser!.email!,
              name: userData['name'] ?? 'User',
              profile: userData['profile'] ?? '',
            );

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('senderId', isEqualTo: currentUser!.email!)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (messageSnapshot.hasError) {
                  return Center(child: Text('Error: ${messageSnapshot.error}'));
                }

                if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages found'));
                }

                var messages = messageSnapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(messageData['message'] ?? ''),
                      subtitle: Text(messageData['timestamp'].toDate().toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomView(
                              imageDownloadButton: true,
                              senderMember: currentUserModel,
                              receiverMember: otherUser,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          return Center(child: Text('User not found'));
        },
      ),
    );
  }
}
