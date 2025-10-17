// // import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:judica/common_pages/profile.dart';
// // import 'package:judica/user/chat_bot_user.dart';
// // import 'package:judica/user/chatapp.dart';
// // import 'package:judica/user/filing_case.dart';
// // import 'package:judica/user/govscheme.dart';
// //
// // class UserHome extends StatefulWidget {
// //   const UserHome({super.key});
// //
// //   @override
// //   State<UserHome> createState() => _UserHomeState();
// // }
// //
// // class _UserHomeState extends State<UserHome> {
// //   int _selectedIndex = 0; // Tracks the selected tab
// //   bool _isUserDataChecked = false; // Flag to track if user data has been checked
// //
// //   // Define the pages for navigation
// //   static final List<Widget> _pages = <Widget>[
// //     const ChatScreenUser(),
// //      ComplaintForm(),// ChatBot Page
// //     OpenChatRoomView(),
// //     ProfilePage(),
// //   ];
// //
// //   // Function to handle tab selection
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   // Check user data in Firestore
// //   Future<void> _checkUserDetails() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //
// //     if (user != null && !_isUserDataChecked) {
// //       final userDoc =
// //       FirebaseFirestore.instance.collection('users').doc(user.email);
// //       final docSnapshot = await userDoc.get();
// //
// //       // If document exists and all required data is present, set to Home page
// //       if (docSnapshot.exists &&
// //           docSnapshot.data()?['Mobile Number'] != null &&
// //           docSnapshot.data()?['email'] != null &&
// //           docSnapshot.data()?['username'] != null &&
// //           docSnapshot.data()?['role'] != null) {
// //         // User has complete data, stay on Home page
// //         setState(() {
// //           _selectedIndex = 0; // Set to Home tab if data is valid
// //           _isUserDataChecked = true;
// //         });
// //       } else {
// //         // If any data is missing, set to Profile page
// //         setState(() {
// //           _selectedIndex = 1; // Navigate to Profile Page if data is incomplete
// //           _isUserDataChecked = true;
// //         });
// //       }
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkUserDetails(); // Check user details only once during initialization
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Judica"),
// //         backgroundColor: const Color.fromRGBO(255, 165, 89, 1), // AppBar color
// //         automaticallyImplyLeading: false,
// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               showDialog(context: context, builder: (context) => GovernmentInfo());
// //             },
// //             icon: Icon(Icons.notifications),
// //           )
// //         ], // Removes the back button
// //       ),
// //       body: _pages[_selectedIndex], // Display the selected page
// //       bottomNavigationBar: Container(
// //         color: Color(0xFFFFA559),  // Set the color here
// //         child: BottomNavigationBar(
// //           items: const <BottomNavigationBarItem>[
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.account_box_rounded),
// //               label: 'ChatBot',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.file_present),
// //               label: 'Complaint',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.chat),
// //               label: 'Chat',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.person),
// //               label: 'Profile',
// //             ),
// //           ],
// //           currentIndex: _selectedIndex, // Highlight the selected tab
// //           selectedItemColor: Colors.black, // Selected icon color
// //           unselectedItemColor: Colors.black54, // Unselected icon color
// //           onTap: _onItemTapped, // Handle tab selection
// //         ),
// //       ),
// //       backgroundColor: Colors.white,  // Ensure the background of the Scaffold is white
// //     );
// //
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // Note: Assuming these imports point to the correct files you previously provided or exist.
// import 'package:judica/common_pages/profile.dart';
// import 'package:judica/user/chat_bot_user.dart';
// import 'package:judica/user/chatapp.dart';
// import 'package:judica/user/filing_case.dart';
// import 'package:judica/user/govscheme.dart';
//
// // Use the correct class names from the previous context
// // Assuming:
// // ChatScreenUser is the ChatBot
// // ComplaintForm is the Complaint Filing form
// // OpenChatRoomView is the main chat list/rooms view
// // ProfilePage is the user profile management page
// // GovernmentInfo is the Notifications/Surveys/Announcements page
//
// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   int _selectedIndex = 0; // Tracks the selected tab
//   // Use a nullable state for initial data loading instead of just a bool flag
//   bool? _isUserDataComplete;
//
//   // Define the pages for navigation
//   // Make this list a constant field if possible, or initialize it within initState
//   // if pages require context, but keeping it simple here as per the original.
//   static final List<Widget> _pages = <Widget>[
//     const ChatScreenUser(),
//     ComplaintForm(),
//     OpenChatRoomView(),
//     ProfilePage(),
//   ];
//
//   // Function to handle tab selection
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   // Check user data in Firestore
//   Future<void> _checkUserDetails() async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user == null || !mounted) return; // Exit if no user or widget disposed
//
//     // Assume user is identified by email, but check for UID fallback for robustness
//     final userId = user.email ?? user.uid;
//
//     if (userId.isEmpty) {
//       if (mounted) {
//         setState(() {
//           _isUserDataComplete = false; // Cannot check user data
//         });
//       }
//       return;
//     }
//
//     // Use the primary identifier (email) to get the user document
//     final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
//     final docSnapshot = await userDoc.get();
//
//     // Define the required fields for profile completion
//     const requiredFields = ['Mobile Number', 'email', 'username', 'role'];
//
//     // Check if the document exists AND all required fields are present and non-null
//     final isComplete = docSnapshot.exists && requiredFields.every((field) =>
//     docSnapshot.data()?.containsKey(field) == true && docSnapshot.data()![field] != null
//     );
//
//     if (mounted) {
//       setState(() {
//         _isUserDataComplete = isComplete;
//         // Logic to navigate: 0 for ChatBot (Home), 3 for Profile
//         _selectedIndex = isComplete ? 0 : 3;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Use WidgetsBinding to run the check after the build process starts,
//     // ensuring context is fully available if needed later, though not strictly required here.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkUserDetails();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Show a loading indicator until the user data check is complete
//     if (_isUserDataComplete == null) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(
//             // Matching the theme orange color
//             color: Color.fromRGBO(255, 165, 89, 1),
//           ),
//         ),
//       );
//     }
//
//     // Once data check is done, show the main UI
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Judica"),
//         backgroundColor: const Color.fromRGBO(255, 165, 89, 1), // AppBar color
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Using showDialog to display GovernmentInfo as a modal
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Dialog(
//                       // Wrap in a Dialog to control size and appearance
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         height: MediaQuery.of(context).size.height * 0.8,
//                         child: GovernmentInfo(),
//                       ),
//                     );
//                   }
//               );
//             },
//             icon: const Icon(Icons.notifications),
//           )
//         ],
//       ),
//       body: _pages[_selectedIndex], // Display the selected page
//       bottomNavigationBar: Container(
//         color: const Color(0xFFFFA559), // Set the container color explicitly
//         child: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.account_box_rounded),
//               label: 'ChatBot',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.file_present),
//               label: 'Complaint',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.chat),
//               label: 'Chat',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//           currentIndex: _selectedIndex, // Highlight the selected tab
//           selectedItemColor: Colors.black, // Selected icon color
//           unselectedItemColor: Colors.black54, // Unselected icon color
//           backgroundColor: const Color(0xFFFFA559), // Ensure item background matches container
//           type: BottomNavigationBarType.fixed, // Ensure all items are shown
//           onTap: _onItemTapped, // Handle tab selection
//         ),
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judica/common_pages/profile.dart';
import 'package:judica/user/chat_bot_user.dart';
import 'package:judica/user/chatapp.dart';
import 'package:judica/user/filing_case.dart';
import 'package:judica/user/govscheme.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;
  bool? _isUserDataComplete;

  // Function to switch to Chat tab (index 2)
  void _navigateToChat() {
    setState(() {
      _selectedIndex = 2; // Chat tab index
    });
  }

  // Define the pages for navigation with callback
  List<Widget> _getPages() {
    return <Widget>[
      ChatScreenUser(onNavigateToChat: _navigateToChat), // Pass callback
      ComplaintForm(),
      OpenChatRoomView(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || !mounted) return;

    final userId = user.email ?? user.uid;

    if (userId.isEmpty) {
      if (mounted) {
        setState(() {
          _isUserDataComplete = false;
        });
      }
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final docSnapshot = await userDoc.get();

    const requiredFields = ['Mobile Number', 'email', 'username', 'role'];

    final isComplete = docSnapshot.exists && requiredFields.every((field) =>
    docSnapshot.data()?.containsKey(field) == true && docSnapshot.data()![field] != null
    );

    if (mounted) {
      setState(() {
        _isUserDataComplete = isComplete;
        _selectedIndex = isComplete ? 0 : 3;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUserDataComplete == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(255, 165, 89, 1),
          ),
        ),
      );
    }

    final pages = _getPages();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Judica"),
        backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: GovernmentInfo(),
                      ),
                    );
                  }
              );
            },
            icon: const Icon(Icons.notifications),
          )
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFFFFA559),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: 'ChatBot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_present),
              label: 'Complaint',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          backgroundColor: const Color(0xFFFFA559),
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}