// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// // User Model
// class UserModel {
//   final String userId;
//   final String email;
//   final String name;
//   final String profile;
//
//   UserModel({
//     required this.userId,
//     required this.email,
//     required this.name,
//     required this.profile,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'email': email,
//       'name': name,
//       'profile': profile,
//     };
//   }
//
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       userId: map['userId'] ?? '',
//       email: map['email'] ?? '',
//       name: map['name'] ?? '',
//       profile: map['profile'] ?? '',
//     );
//   }
// }
//
// class OpenChatRoomView extends StatefulWidget {
//   const OpenChatRoomView({super.key});
//
//   @override
//   State<OpenChatRoomView> createState() => _OpenChatRoomViewState();
// }
//
// class _OpenChatRoomViewState extends State<OpenChatRoomView> {
//   User? currentUser;
//   Future<List<UserModel>>? advocatesListFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentUserAndAdvocates();
//   }
//
//   Future<void> _loadCurrentUserAndAdvocates() async {
//     try {
//       currentUser = FirebaseAuth.instance.currentUser;
//
//       if (currentUser != null) {
//         advocatesListFuture = FirebaseFirestore.instance
//             .collection('users')
//             .where('role', isEqualTo: 'Citizen')
//             .get()
//             .then((querySnapshot) {
//           return querySnapshot.docs.map((doc) {
//             var userData = doc.data();
//             return UserModel(
//               userId: doc.id,
//               email: userData['email'] ?? '',
//               name: userData['username'] ?? 'Unknown',
//               profile: userData['profile'] ?? '',
//             );
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print("Error loading advocates: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<UserModel>>(
//         future: advocatesListFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.hasData && snapshot.data != null) {
//             var advocates = snapshot.data!;
//
//             if (advocates.isEmpty) {
//               return const Center(child: Text('No citizens found'));
//             }
//
//             return Stack(
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage("assets/ChatBotBackground.jpg"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ListView.builder(
//                     itemCount: advocates.length,
//                     itemBuilder: (context, index) {
//                       var advocate = advocates[index];
//
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                           leading: CircleAvatar(
//                             radius: 30,
//                             backgroundImage: NetworkImage(
//                               advocate.profile.isNotEmpty
//                                   ? advocate.profile
//                                   : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
//                             ),
//                           ),
//                           title: Text(
//                             advocate.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: Colors.deepPurple,
//                             ),
//                           ),
//                           trailing: const Icon(
//                             Icons.chat_bubble_outline,
//                             color: Colors.deepPurple,
//                           ),
//                           onTap: () async {
//                             if (currentUser != null) {
//                               // Get current user data
//                               final currentUserDoc = await FirebaseFirestore
//                                   .instance
//                                   .collection('users')
//                                   .doc(currentUser!.email)
//                                   .get();
//
//                               final currentUserData = currentUserDoc.data();
//                               final currentUserModel = UserModel(
//                                 userId: currentUser!.email!,
//                                 email: currentUser!.email!,
//                                 name: currentUserData?['username'] ?? 'You',
//                                 profile: currentUserData?['profile'] ?? '',
//                               );
//
//                               if (context.mounted) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ChatRoomView(
//                                       senderMember: currentUserModel,
//                                       receiverMember: advocate,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//
//           return const Center(child: Text('No citizens found'));
//         },
//       ),
//     );
//   }
// }
//
// // Chat Room View Implementation
// class ChatRoomView extends StatefulWidget {
//   final UserModel senderMember;
//   final UserModel receiverMember;
//
//   const ChatRoomView({
//     super.key,
//     required this.senderMember,
//     required this.receiverMember,
//   });
//
//   @override
//   State<ChatRoomView> createState() => _ChatRoomViewState();
// }
//
// class _ChatRoomViewState extends State<ChatRoomView> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   String? chatRoomId;
//
//   @override
//   void initState() {
//     super.initState();
//     chatRoomId = _getChatRoomId(
//       widget.senderMember.userId,
//       widget.receiverMember.userId,
//     );
//   }
//
//   String _getChatRoomId(String user1, String user2) {
//     // Create consistent chatroom ID regardless of sender/receiver order
//     List<String> users = [user1, user2];
//     users.sort();
//     return '${users[0]}_${users[1]}';
//   }
//
//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
//
//     try {
//       final message = _messageController.text.trim();
//       _messageController.clear();
//
//       await FirebaseFirestore.instance
//           .collection('ChatRooms')
//           .doc(chatRoomId)
//           .collection('messages')
//           .add({
//         'text': message,
//         'senderId': widget.senderMember.userId,
//         'senderName': widget.senderMember.name,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       // Update last message in chat room
//       await FirebaseFirestore.instance
//           .collection('ChatRooms')
//           .doc(chatRoomId)
//           .set({
//         'participants': [
//           widget.senderMember.userId,
//           widget.receiverMember.userId
//         ],
//         'lastMessage': message,
//         'lastMessageTime': FieldValue.serverTimestamp(),
//         'senderInfo': widget.senderMember.toMap(),
//         'receiverInfo': widget.receiverMember.toMap(),
//       }, SetOptions(merge: true));
//
//       _scrollToBottom();
//     } catch (e) {
//       print("Error sending message: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send message: $e')),
//         );
//       }
//     }
//   }
//
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(
//                 widget.receiverMember.profile.isNotEmpty
//                     ? widget.receiverMember.profile
//                     : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
//               ),
//             ),
//             const SizedBox(width: 10),
//             Text('Chat with ${widget.receiverMember.name}'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('ChatRooms')
//                   .doc(chatRoomId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Text('No messages yet. Start the conversation!'),
//                   );
//                 }
//
//                 final messages = snapshot.data!.docs;
//
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _scrollToBottom();
//                 });
//
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final messageData =
//                     messages[index].data() as Map<String, dynamic>;
//                     final isMe = messageData['senderId'] ==
//                         widget.senderMember.userId;
//
//                     return Align(
//                       alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: isMe
//                               ? const Color.fromARGB(255, 42, 217, 202)
//                               : const Color.fromARGB(255, 255, 195, 0),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.7,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               messageData['text'] ?? '',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               messageData['timestamp'] != null
//                                   ? _formatTimestamp(
//                                   messageData['timestamp'] as Timestamp)
//                                   : 'Sending...',
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                     ),
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white),
//                     onPressed: _sendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatTimestamp(Timestamp timestamp) {
//     final date = timestamp.toDate();
//     final now = DateTime.now();
//     final difference = now.difference(date);
//
//     if (difference.inDays == 0) {
//       return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// User Model
class UserModel {
  final String userId;
  final String email;
  final String name;
  final String profile;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.profile,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'profile': profile,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profile: map['profile'] ?? '',
    );
  }
}

class OpenChatRoomView extends StatefulWidget {
  const OpenChatRoomView({super.key});

  @override
  State<OpenChatRoomView> createState() => _OpenChatRoomViewState();
}

class _OpenChatRoomViewState extends State<OpenChatRoomView> {
  User? currentUser;
  Future<List<UserModel>>? citizensListFuture;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndCitizens();
  }

  Future<void> _loadCurrentUserAndCitizens() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // NOTE: Assuming `participants` stores user emails or a unique identifier.
        // The current implementation is searching for ChatRooms where the current
        // user's email is a participant.
        citizensListFuture = FirebaseFirestore.instance
            .collection('ChatRooms')
            .where('participants', arrayContains: currentUser!.email)
            .get()
            .then((querySnapshot) async {
          List<UserModel> citizensList = [];

          for (var doc in querySnapshot.docs) {
            var participants = doc['participants'] as List<dynamic>;

            // Find the other participant's ID (email in this case)
            String citizenId = participants.firstWhere(
                    (p) => p != currentUser!.email,
                orElse: () => '' // Handle case where list only contains current user (unlikely for a chat room)
            );

            if (citizenId.isNotEmpty) {
              // Get citizen user data using the email as the document ID
              final citizenDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(citizenId) // Using email as doc ID
                  .get();

              if (citizenDoc.exists) {
                var userData = citizenDoc.data();
                citizensList.add(UserModel(
                  userId: citizenDoc.id, // Email
                  email: userData?['email'] ?? '',
                  name: userData?['username'] ?? 'Unknown',
                  profile: userData?['profile'] ?? '',
                ));
              }
            }
          }

          return citizensList;
        });
      }
    } catch (e) {
      // In a real app, you might use a logging library instead of print
      print("Error loading citizens: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: citizensListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            var citizens = snapshot.data!;

            if (citizens.isEmpty) {
              return const Center(
                child: Text('No messages from citizens yet'),
              );
            }

            // --- FIX APPLIED HERE ---
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/ChatBotBackground.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: citizens.length,
                  itemBuilder: (context, index) {
                    var citizen = citizens[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            citizen.profile.isNotEmpty
                                ? citizen.profile
                                : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
                          ),
                        ),
                        title: Text(
                          citizen.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepPurple,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.deepPurple,
                        ),
                        onTap: () async {
                          if (currentUser != null) {
                            // Get current user data
                            // NOTE: Assuming the current user's document ID in 'users' is their email
                            final currentUserDoc = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(currentUser!.email)
                                .get();

                            final currentUserData = currentUserDoc.data();
                            final currentUserModel = UserModel(
                              userId: currentUser!.email!, // Use email as userId
                              email: currentUser!.email!,
                              name: currentUserData?['username'] ?? 'You',
                              profile: currentUserData?['profile'] ?? '',
                            );

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoomView(
                                    senderMember: currentUserModel,
                                    receiverMember: citizen,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ); // Correct closing parenthesis and semicolon
          } // Correct closing brace for the if block

          return const Center(child: Text('No messages from citizens yet'));
        },
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Chat Room View Implementation
class ChatRoomView extends StatefulWidget {
  final UserModel senderMember;
  final UserModel receiverMember;

  const ChatRoomView({
    super.key,
    required this.senderMember,
    required this.receiverMember,
  });

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    // The userId is the unique identifier (email in this case)
    chatRoomId = _getChatRoomId(
      widget.senderMember.userId,
      widget.receiverMember.userId,
    );
  }

  String _getChatRoomId(String user1, String user2) {
    // Create consistent chatroom ID regardless of sender/receiver order
    List<String> users = [user1, user2];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final message = _messageController.text.trim();
      _messageController.clear();

      // 1. Add the message to the chat room's subcollection
      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'text': message,
        'senderId': widget.senderMember.userId,
        'senderName': widget.senderMember.name,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Update the chat room document with last message info
      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .set({
        'participants': [
          widget.senderMember.userId,
          widget.receiverMember.userId
        ],
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        // Storing basic info for easy display in chat list (optional but common)
        'senderInfo': widget.senderMember.toMap(),
        'receiverInfo': widget.receiverMember.toMap(),
      }, SetOptions(merge: true));

      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    // Wait for the next frame to ensure the new message is rendered and maxScrollExtent is updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                widget.receiverMember.profile.isNotEmpty
                    ? widget.receiverMember.profile
                    : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.receiverMember.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ChatRooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data?.docs ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 60,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start a conversation with ${widget.receiverMember.name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Call _scrollToBottom() after the data is loaded to keep the view updated
                // We call it here only on initial load or data change, not every build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                    messages[index].data() as Map<String, dynamic>;
                    final isMe = messageData['senderId'] ==
                        widget.senderMember.userId;

                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color.fromARGB(255, 42, 217, 202)
                              : const Color.fromARGB(255, 255, 195, 0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messageData['text'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              messageData['timestamp'] != null
                                  ? _formatTimestamp(
                                  messageData['timestamp'] as Timestamp)
                                  : 'Sending...',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: SafeArea( // Use SafeArea to avoid bottom notch/gesture area
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}