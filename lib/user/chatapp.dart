  // // import 'package:firebase_auth/firebase_auth.dart';
  // // import 'package:cloud_firestore/cloud_firestore.dart';
  // // import 'package:flutter/material.dart';
  // //
  // // // User Model
  // // class UserModel {
  // //   final String userId;
  // //   final String email;
  // //   final String name;
  // //   final String profile;
  // //
  // //   UserModel({
  // //     required this.userId,
  // //     required this.email,
  // //     required this.name,
  // //     required this.profile,
  // //   });
  // //
  // //   Map<String, dynamic> toMap() {
  // //     return {
  // //       'userId': userId,
  // //       'email': email,
  // //       'name': name,
  // //       'profile': profile,
  // //     };
  // //   }
  // //
  // //   factory UserModel.fromMap(Map<String, dynamic> map) {
  // //     return UserModel(
  // //       userId: map['userId'] ?? '',
  // //       email: map['email'] ?? '',
  // //       name: map['name'] ?? '',
  // //       profile: map['profile'] ?? '',
  // //     );
  // //   }
  // // }
  // //
  // // class OpenChatRoomView extends StatefulWidget {
  // //   const OpenChatRoomView({super.key});
  // //
  // //   @override
  // //   State<OpenChatRoomView> createState() => _OpenChatRoomViewState();
  // // }
  // //
  // // class _OpenChatRoomViewState extends State<OpenChatRoomView> {
  // //   User? currentUser;
  // //   Future<List<UserModel>>? advocatesListFuture;
  // //
  // //   @override
  // //   void initState() {
  // //     super.initState();
  // //     _loadCurrentUserAndAdvocates();
  // //   }
  // //
  // //   Future<void> _loadCurrentUserAndAdvocates() async {
  // //     try {
  // //       currentUser = FirebaseAuth.instance.currentUser;
  // //
  // //       if (currentUser != null) {
  // //         advocatesListFuture = FirebaseFirestore.instance
  // //             .collection('users')
  // //             .where('role', isEqualTo: 'Citizen')
  // //             .get()
  // //             .then((querySnapshot) {
  // //           return querySnapshot.docs.map((doc) {
  // //             var userData = doc.data();
  // //             return UserModel(
  // //               userId: doc.id,
  // //               email: userData['email'] ?? '',
  // //               name: userData['username'] ?? 'Unknown',
  // //               profile: userData['profile'] ?? '',
  // //             );
  // //           }).toList();
  // //         });
  // //       }
  // //     } catch (e) {
  // //       print("Error loading advocates: $e");
  // //     }
  // //   }
  // //
  // //   @override
  // //   Widget build(BuildContext context) {
  // //     return Scaffold(
  // //       body: FutureBuilder<List<UserModel>>(
  // //         future: advocatesListFuture,
  // //         builder: (context, snapshot) {
  // //           if (snapshot.connectionState == ConnectionState.waiting) {
  // //             return const Center(child: CircularProgressIndicator());
  // //           }
  // //
  // //           if (snapshot.hasError) {
  // //             return Center(child: Text('Error: ${snapshot.error}'));
  // //           }
  // //
  // //           if (snapshot.hasData && snapshot.data != null) {
  // //             var advocates = snapshot.data!;
  // //
  // //             if (advocates.isEmpty) {
  // //               return const Center(child: Text('No citizens found'));
  // //             }
  // //
  // //             return Stack(
  // //               children: [
  // //                 Container(
  // //                   decoration: const BoxDecoration(
  // //                     image: DecorationImage(
  // //                       image: AssetImage("assets/ChatBotBackground.jpg"),
  // //                       fit: BoxFit.cover,
  // //                     ),
  // //                   ),
  // //                 ),
  // //                 Padding(
  // //                   padding: const EdgeInsets.all(16.0),
  // //                   child: ListView.builder(
  // //                     itemCount: advocates.length,
  // //                     itemBuilder: (context, index) {
  // //                       var advocate = advocates[index];
  // //
  // //                       return Card(
  // //                         margin: const EdgeInsets.symmetric(vertical: 8),
  // //                         elevation: 5,
  // //                         shape: RoundedRectangleBorder(
  // //                           borderRadius: BorderRadius.circular(15),
  // //                         ),
  // //                         child: ListTile(
  // //                           contentPadding: const EdgeInsets.symmetric(
  // //                               horizontal: 16, vertical: 12),
  // //                           leading: CircleAvatar(
  // //                             radius: 30,
  // //                             backgroundImage: NetworkImage(
  // //                               advocate.profile.isNotEmpty
  // //                                   ? advocate.profile
  // //                                   : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
  // //                             ),
  // //                           ),
  // //                           title: Text(
  // //                             advocate.name,
  // //                             style: const TextStyle(
  // //                               fontWeight: FontWeight.bold,
  // //                               fontSize: 16,
  // //                               color: Colors.deepPurple,
  // //                             ),
  // //                           ),
  // //                           trailing: const Icon(
  // //                             Icons.chat_bubble_outline,
  // //                             color: Colors.deepPurple,
  // //                           ),
  // //                           onTap: () async {
  // //                             if (currentUser != null) {
  // //                               // Get current user data
  // //                               final currentUserDoc = await FirebaseFirestore
  // //                                   .instance
  // //                                   .collection('users')
  // //                                   .doc(currentUser!.email)
  // //                                   .get();
  // //
  // //                               final currentUserData = currentUserDoc.data();
  // //                               final currentUserModel = UserModel(
  // //                                 userId: currentUser!.email!,
  // //                                 email: currentUser!.email!,
  // //                                 name: currentUserData?['username'] ?? 'You',
  // //                                 profile: currentUserData?['profile'] ?? '',
  // //                               );
  // //
  // //                               if (context.mounted) {
  // //                                 Navigator.push(
  // //                                   context,
  // //                                   MaterialPageRoute(
  // //                                     builder: (context) => ChatRoomView(
  // //                                       senderMember: currentUserModel,
  // //                                       receiverMember: advocate,
  // //                                     ),
  // //                                   ),
  // //                                 );
  // //                               }
  // //                             }
  // //                           },
  // //                         ),
  // //                       );
  // //                     },
  // //                   ),
  // //                 ),
  // //               ],
  // //             );
  // //           }
  // //
  // //           return const Center(child: Text('No citizens found'));
  // //         },
  // //       ),
  // //     );
  // //   }
  // // }
  // //
  // // // Chat Room View Implementation
  // // class ChatRoomView extends StatefulWidget {
  // //   final UserModel senderMember;
  // //   final UserModel receiverMember;
  // //
  // //   const ChatRoomView({
  // //     super.key,
  // //     required this.senderMember,
  // //     required this.receiverMember,
  // //   });
  // //
  // //   @override
  // //   State<ChatRoomView> createState() => _ChatRoomViewState();
  // // }
  // //
  // // class _ChatRoomViewState extends State<ChatRoomView> {
  // //   final TextEditingController _messageController = TextEditingController();
  // //   final ScrollController _scrollController = ScrollController();
  // //   String? chatRoomId;
  // //
  // //   @override
  // //   void initState() {
  // //     super.initState();
  // //     chatRoomId = _getChatRoomId(
  // //       widget.senderMember.userId,
  // //       widget.receiverMember.userId,
  // //     );
  // //   }
  // //
  // //   String _getChatRoomId(String user1, String user2) {
  // //     // Create consistent chatroom ID regardless of sender/receiver order
  // //     List<String> users = [user1, user2];
  // //     users.sort();
  // //     return '${users[0]}_${users[1]}';
  // //   }
  // //
  // //   Future<void> _sendMessage() async {
  // //     if (_messageController.text.trim().isEmpty) return;
  // //
  // //     try {
  // //       final message = _messageController.text.trim();
  // //       _messageController.clear();
  // //
  // //       await FirebaseFirestore.instance
  // //           .collection('ChatRooms')
  // //           .doc(chatRoomId)
  // //           .collection('messages')
  // //           .add({
  // //         'text': message,
  // //         'senderId': widget.senderMember.userId,
  // //         'senderName': widget.senderMember.name,
  // //         'timestamp': FieldValue.serverTimestamp(),
  // //       });
  // //
  // //       // Update last message in chat room
  // //       await FirebaseFirestore.instance
  // //           .collection('ChatRooms')
  // //           .doc(chatRoomId)
  // //           .set({
  // //         'participants': [
  // //           widget.senderMember.userId,
  // //           widget.receiverMember.userId
  // //         ],
  // //         'lastMessage': message,
  // //         'lastMessageTime': FieldValue.serverTimestamp(),
  // //         'senderInfo': widget.senderMember.toMap(),
  // //         'receiverInfo': widget.receiverMember.toMap(),
  // //       }, SetOptions(merge: true));
  // //
  // //       _scrollToBottom();
  // //     } catch (e) {
  // //       print("Error sending message: $e");
  // //       if (mounted) {
  // //         ScaffoldMessenger.of(context).showSnackBar(
  // //           SnackBar(content: Text('Failed to send message: $e')),
  // //         );
  // //       }
  // //     }
  // //   }
  // //
  // //   void _scrollToBottom() {
  // //     if (_scrollController.hasClients) {
  // //       _scrollController.animateTo(
  // //         _scrollController.position.maxScrollExtent,
  // //         duration: const Duration(milliseconds: 300),
  // //         curve: Curves.easeOut,
  // //       );
  // //     }
  // //   }
  // //
  // //   @override
  // //   Widget build(BuildContext context) {
  // //     return Scaffold(
  // //       appBar: AppBar(
  // //         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
  // //         title: Row(
  // //           children: [
  // //             CircleAvatar(
  // //               radius: 20,
  // //               backgroundImage: NetworkImage(
  // //                 widget.receiverMember.profile.isNotEmpty
  // //                     ? widget.receiverMember.profile
  // //                     : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
  // //               ),
  // //             ),
  // //             const SizedBox(width: 10),
  // //             Text('Chat with ${widget.receiverMember.name}'),
  // //           ],
  // //         ),
  // //       ),
  // //       body: Column(
  // //         children: [
  // //           Expanded(
  // //             child: StreamBuilder<QuerySnapshot>(
  // //               stream: FirebaseFirestore.instance
  // //                   .collection('ChatRooms')
  // //                   .doc(chatRoomId)
  // //                   .collection('messages')
  // //                   .orderBy('timestamp', descending: false)
  // //                   .snapshots(),
  // //               builder: (context, snapshot) {
  // //                 if (snapshot.connectionState == ConnectionState.waiting) {
  // //                   return const Center(child: CircularProgressIndicator());
  // //                 }
  // //
  // //                 if (snapshot.hasError) {
  // //                   return Center(child: Text('Error: ${snapshot.error}'));
  // //                 }
  // //
  // //                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  // //                   return const Center(
  // //                     child: Text('No messages yet. Start the conversation!'),
  // //                   );
  // //                 }
  // //
  // //                 final messages = snapshot.data!.docs;
  // //
  // //                 WidgetsBinding.instance.addPostFrameCallback((_) {
  // //                   _scrollToBottom();
  // //                 });
  // //
  // //                 return ListView.builder(
  // //                   controller: _scrollController,
  // //                   padding: const EdgeInsets.all(16),
  // //                   itemCount: messages.length,
  // //                   itemBuilder: (context, index) {
  // //                     final messageData =
  // //                     messages[index].data() as Map<String, dynamic>;
  // //                     final isMe = messageData['senderId'] ==
  // //                         widget.senderMember.userId;
  // //
  // //                     return Align(
  // //                       alignment:
  // //                       isMe ? Alignment.centerRight : Alignment.centerLeft,
  // //                       child: Container(
  // //                         margin: const EdgeInsets.symmetric(vertical: 4),
  // //                         padding: const EdgeInsets.symmetric(
  // //                             horizontal: 16, vertical: 10),
  // //                         decoration: BoxDecoration(
  // //                           color: isMe
  // //                               ? const Color.fromARGB(255, 42, 217, 202)
  // //                               : const Color.fromARGB(255, 255, 195, 0),
  // //                           borderRadius: BorderRadius.circular(20),
  // //                         ),
  // //                         constraints: BoxConstraints(
  // //                           maxWidth: MediaQuery.of(context).size.width * 0.7,
  // //                         ),
  // //                         child: Column(
  // //                           crossAxisAlignment: CrossAxisAlignment.start,
  // //                           children: [
  // //                             Text(
  // //                               messageData['text'] ?? '',
  // //                               style: const TextStyle(
  // //                                 fontSize: 16,
  // //                                 color: Colors.black87,
  // //                               ),
  // //                             ),
  // //                             const SizedBox(height: 4),
  // //                             Text(
  // //                               messageData['timestamp'] != null
  // //                                   ? _formatTimestamp(
  // //                                   messageData['timestamp'] as Timestamp)
  // //                                   : 'Sending...',
  // //                               style: const TextStyle(
  // //                                 fontSize: 10,
  // //                                 color: Colors.black54,
  // //                               ),
  // //                             ),
  // //                           ],
  // //                         ),
  // //                       ),
  // //                     );
  // //                   },
  // //                 );
  // //               },
  // //             ),
  // //           ),
  // //           Container(
  // //             padding: const EdgeInsets.all(8),
  // //             decoration: BoxDecoration(
  // //               color: Colors.white,
  // //               boxShadow: [
  // //                 BoxShadow(
  // //                   color: Colors.grey.withOpacity(0.3),
  // //                   spreadRadius: 1,
  // //                   blurRadius: 5,
  // //                 ),
  // //               ],
  // //             ),
  // //             child: Row(
  // //               children: [
  // //                 Expanded(
  // //                   child: TextField(
  // //                     controller: _messageController,
  // //                     decoration: InputDecoration(
  // //                       hintText: 'Type a message...',
  // //                       border: OutlineInputBorder(
  // //                         borderRadius: BorderRadius.circular(25),
  // //                       ),
  // //                       contentPadding: const EdgeInsets.symmetric(
  // //                         horizontal: 16,
  // //                         vertical: 10,
  // //                       ),
  // //                     ),
  // //                     onSubmitted: (_) => _sendMessage(),
  // //                   ),
  // //                 ),
  // //                 const SizedBox(width: 8),
  // //                 CircleAvatar(
  // //                   backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
  // //                   child: IconButton(
  // //                     icon: const Icon(Icons.send, color: Colors.white),
  // //                     onPressed: _sendMessage,
  // //                   ),
  // //                 ),
  // //               ],
  // //             ),
  // //           ),
  // //         ],
  // //       ),
  // //     );
  // //   }
  // //
  // //   String _formatTimestamp(Timestamp timestamp) {
  // //     final date = timestamp.toDate();
  // //     final now = DateTime.now();
  // //     final difference = now.difference(date);
  // //
  // //     if (difference.inDays == 0) {
  // //       return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  // //     } else if (difference.inDays == 1) {
  // //       return 'Yesterday';
  // //     } else {
  // //       return '${date.day}/${date.month}/${date.year}';
  // //     }
  // //   }
  // //
  // //   @override
  // //   void dispose() {
  // //     _messageController.dispose();
  // //     _scrollController.dispose();
  // //     super.dispose();
  // //   }
  // // }
  //
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
  //             .where('role', isEqualTo: 'Judge')
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
  //               return const Center(child: Text('No advocates found'));
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
  //           return const Center(child: Text('No advocates found'));
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
  //             Text(widget.receiverMember.name),
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
  import 'dart:math' as math;

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

  class _OpenChatRoomViewState extends State<OpenChatRoomView> with SingleTickerProviderStateMixin {
    User? currentUser;
    Future<List<UserModel>>? advocatesListFuture;
    late AnimationController _animationController;

    @override
    void initState() {
      super.initState();
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat();
      _loadCurrentUserAndAdvocates();
    }

    @override
    void dispose() {
      _animationController.dispose();
      super.dispose();
    }

    Future<void> _loadCurrentUserAndAdvocates() async {
      try {
        currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          advocatesListFuture = FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'Judge')
              .get()
              .then((querySnapshot) {
            return querySnapshot.docs.map((doc) {
              var userData = doc.data();
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
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Legal Experts',
            style: TextStyle(
              color: Color(0xFF2D3142),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: FutureBuilder<List<UserModel>>(
          future: advocatesListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animationController.value * 2 * math.pi,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.gavel, color: Colors.white, size: 30),
                      ),
                    );
                  },
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data != null) {
              var advocates = snapshot.data!;

              if (advocates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF667EEA).withOpacity(0.1),
                              const Color(0xFF764BA2).withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No advocates available',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: advocates.length,
                itemBuilder: (context, index) {
                  var advocate = advocates[index];
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: _buildAdvocateCard(advocate),
                  );
                },
              );
            }

            return const Center(child: Text('No advocates found'));
          },
        ),
      );
    }

    Widget _buildAdvocateCard(UserModel advocate) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFFAFBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              if (currentUser != null) {
                final currentUserDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.email)
                    .get();

                final currentUserData = currentUserDoc.data();
                final currentUserModel = UserModel(
                  userId: currentUser!.email!,
                  email: currentUser!.email!,
                  name: currentUserData?['username'] ?? 'You',
                  profile: currentUserData?['profile'] ?? '',
                );

                if (context.mounted) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ChatRoomView(
                            senderMember: currentUserModel,
                            receiverMember: advocate,
                          ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeOutCubic));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Hero(
                    tag: 'avatar_${advocate.userId}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                          advocate.profile.isNotEmpty
                              ? advocate.profile
                              : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advocate.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B95A5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

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

  class _ChatRoomViewState extends State<ChatRoomView>
      with TickerProviderStateMixin {
    final TextEditingController _messageController = TextEditingController();
    final ScrollController _scrollController = ScrollController();
    final FocusNode _focusNode = FocusNode();
    String? chatRoomId;
    bool _isTyping = false;
    late AnimationController _typingAnimationController;

    @override
    void initState() {
      super.initState();
      chatRoomId = _getChatRoomId(
        widget.senderMember.userId,
        widget.receiverMember.userId,
      );
      _typingAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat();

      _messageController.addListener(() {
        setState(() {
          _isTyping = _messageController.text.isNotEmpty;
        });
      });
    }

    @override
    void dispose() {
      _messageController.dispose();
      _scrollController.dispose();
      _focusNode.dispose();
      _typingAnimationController.dispose();
      super.dispose();
    }

    String _getChatRoomId(String user1, String user2) {
      List<String> users = [user1, user2];
      users.sort();
      return '${users[0]}_${users[1]}';
    }

    Future<void> _sendMessage() async {
      if (_messageController.text.trim().isEmpty) return;

      try {
        final message = _messageController.text.trim();
        _messageController.clear();
        _focusNode.unfocus();

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
          'senderInfo': widget.senderMember.toMap(),
          'receiverInfo': widget.receiverMember.toMap(),
        }, SetOptions(merge: true));

        _scrollToBottom();
      } catch (e) {
        print("Error sending message: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Failed to send message: $e')),
                ],
              ),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    }

    void _scrollToBottom() {
      if (_scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF667EEA),
                size: 18,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Hero(
                tag: 'avatar_${widget.receiverMember.userId}',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.receiverMember.profile.isNotEmpty
                          ? widget.receiverMember.profile
                          : 'https://th.bing.com/th/id/OIP.eL0lZacXCPliDOObUuM8nwAAAA?w=271&h=267&rs=1&pid=ImgDetMain',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.receiverMember.name,
                      style: const TextStyle(
                        color: Color(0xFF2D3142),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Online',
                          style: TextStyle(
                            color: Color(0xFF8B95A5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF667EEA),
                  size: 20,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
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
                    return Center(
                      child: AnimatedBuilder(
                        animation: _typingAnimationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _typingAnimationController.value * 2 * math.pi,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(Icons.chat, color: Colors.white, size: 24),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF667EEA).withOpacity(0.1),
                                  const Color(0xFF764BA2).withOpacity(0.1),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Color(0xFF667EEA),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Start the conversation',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Send a message to begin',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B95A5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs;

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

                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: _buildMessageBubble(messageData, isMe),
                      );
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      );
    }

    Widget _buildMessageBubble(Map<String, dynamic> messageData, bool isMe) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isMe ? 60 : 0,
            right: isMe ? 0 : 60,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : const LinearGradient(
              colors: [Colors.white, Colors.white],
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isMe ? 20 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: isMe
                    ? const Color(0xFF667EEA).withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageData['text'] ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : const Color(0xFF2D3142),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    messageData['timestamp'] != null
                        ? _formatTimestamp(messageData['timestamp'] as Timestamp)
                        : 'Sending...',
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF8B95A5),
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildInputArea() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            color: Color(0xFF8B95A5),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF2D3142),
                          fontSize: 15,
                        ),
                        maxLines: null,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.attach_file_rounded,
                        color: Color(0xFF8B95A5),
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isTyping ? _sendMessage : null,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: _isTyping
                          ? const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      )
                          : LinearGradient(
                        colors: [
                          const Color(0xFF8B95A5).withOpacity(0.3),
                          const Color(0xFF8B95A5).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: _isTyping
                          ? [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
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
  }