import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:judica/auth/firebase_options.dart';
import 'package:firebase_realtime_chat/firebase_realtime_chat.dart';

class OpenChatRoomView extends StatefulWidget {
  const OpenChatRoomView({super.key});

  @override
  State<OpenChatRoomView> createState() => _OpenChatRoomViewState();
}

class _OpenChatRoomViewState extends State<OpenChatRoomView> {
  User? currentUser;
  Future<List<UserModel>>? advocatesListFuture;

  @override
  void initState() {
    super.initState();
    _loadAdvocates();
  }

  // Fetch the list of advocates from Firestore
  Future<void> _loadAdvocates() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      advocatesListFuture = FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Judge') // Fetch only users with role 'Judge'
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          var userData = doc.data() as Map<String, dynamic>;
          return UserModel(
            userId: doc.id,
            email: userData['email'] ?? '',
            name: userData['username'] ?? 'Unknown',
            profile: userData['profile'] ?? '',
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: advocatesListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          var advocates = snapshot.data!;

          return Scaffold(

            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ChatBotBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: advocates.length,
                    itemBuilder: (context, index) {
                      var advocate = advocates[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              advocate.profile.isNotEmpty
                                  ? advocate.profile
                                  : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain', // Default image
                            ),
                          ),
                          title: Text(
                            advocate.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),

                          trailing: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.deepPurple,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatRoomView(
                                    ownerBubbleColor: Color.fromARGB(
                                        255, 42, 217, 202),
                                    otherBubbleColor: Color.fromARGB(
                                        255, 255, 195, 0),
                                    defaultImage: "https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain",
                                    appBar: AppBar(
                                      backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
                                    ),
                                    imageDownloadButton: true,
                                    senderMember: UserModel(
                                      userId: currentUser!.email!,
                                      email: currentUser!.email!,
                                      name: 'You',
                                      profile: '', // Use current user's profile if needed
                                    ),
                                    receiverMember: advocate, // The selected advocate
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Center(child: Text('No advocates found')),
        );
      },
    );
  }
}
