// import 'package:firebase_realtime_chat/model/user.dart';
// import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class OpenChatRoomViewa extends StatefulWidget {
//   @override
//   _OpenChatRoomViewaState createState() => _OpenChatRoomViewaState();
// }
//
// class _OpenChatRoomViewaState extends State<OpenChatRoomViewa> {
//   User? currentUser;
//   Future<DocumentSnapshot?>? currentUserDocFuture;
//
//   // Example other user (replace with actual data)
//   UserModel otherUser = UserModel(
//     userId: 'other@example.com',
//     email: 'other@example.com',
//     name: 'John Doe',
//     profile: 'https://www.example.com/profile.jpg',
//   );
//
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentUser();
//   }
//
//   Future<void> _loadCurrentUser() async {
//     try {
//       currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         currentUserDocFuture = FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentUser!.email)
//             .get()
//             .then((doc) => doc.exists ? doc : null);
//       }
//     } catch (e) {
//       print("Error loading current user: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<DocumentSnapshot?>(
//         future: currentUserDocFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             print("Snapshot error: ${snapshot.error}");
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.hasData && snapshot.data != null) {
//             var userData = snapshot.data!.data() as Map<String, dynamic>;
//             UserModel currentUserModel = UserModel(
//               userId: currentUser!.email!,
//               email: currentUser!.email!,
//               name: userData['username'] ?? 'User',
//               profile: userData['profile'] ?? '',
//             );
//
//             return Column(
//               children: [
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('ChatRooms')
//                         .where('participants', arrayContains: currentUser!.email!)
//                         .orderBy('timestamp', descending: true)
//                         .snapshots(),
//                     builder: (context, messageSnapshot) {
//                       if (messageSnapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }
//
//                       if (messageSnapshot.hasError) {
//                         print("Message snapshot error: ${messageSnapshot.error}");
//                         return Center(child: Text('Error: ${messageSnapshot.error}'));
//                       }
//
//                       if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
//                         return Center(child: Text('No messages found'));
//                       }
//
//                       var messages = messageSnapshot.data!.docs;
//                       return ListView.builder(
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           var messageData = messages[index].data() as Map<String, dynamic>;
//                           return ListTile(
//                             title: Text(messageData['message'] ?? ''),
//                             subtitle: Text(messageData['timestamp'].toDate().toString()),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ChatRoomView(
//                                     imageDownloadButton: true,
//                                     senderMember: currentUserModel,
//                                     receiverMember: otherUser,
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//
//           return Center(child: Text('User not found'));
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_realtime_chat/firebase_realtime_chat.dart'; // Ensure this package is correctly imported

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
    _loadCurrentUserAndAdvocates();
  }

  // Fetch the current user and the list of advocates from Firestore
  Future<void> _loadCurrentUserAndAdvocates() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        advocatesListFuture = FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Citizen') // Fetch only users with role 'Judge'
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
    } catch (e) {
      print("Error loading advocates: $e");
      // Handle the error (e.g., show a snackbar or dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: advocatesListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            var advocates = snapshot.data!;

            if (advocates.isEmpty) {
              return Center(child: Text('No judges found'));
            }

            return Stack(
              children: [
                // Background image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ChatBotBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // List of advocates
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
                                    ownerBubbleColor: Color.fromARGB(255, 42, 217, 202),
                                    otherBubbleColor: Color.fromARGB(255, 255, 195, 0),
                                    defaultImage: "https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain",
                                    appBar: AppBar(
                                      backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
                                      title: Text('Chat with ${advocate.name}'),
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
            );
          }

          return Center(child: Text('No judges found'));
        },
      ),
    );
  }
}