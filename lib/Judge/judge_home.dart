import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judica/Judge/bail_page.dart';
import 'package:judica/Judge/chat_bot_judge.dart';
import 'package:judica/Judge/chatapp.dart';
import 'package:judica/common_pages/profile.dart';


class AdvocateHome extends StatefulWidget {
  const AdvocateHome({super.key});

  @override
  State<AdvocateHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<AdvocateHome> {
  int _selectedIndex = 0; // Tracks the selected tab
  bool _isUserDataChecked = false; // Flag to track if user data has been checked

  // Define the pages for navigation
  static final List<Widget> _pages = <Widget>[
    const Bailpage(), // FIR-related component
    const ChatScreenjudge(),
    OpenChatRoomView(),// Placeholder for Home Page
    const ProfilePage(),

  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Check user data in Firestore
  Future<void> _checkUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !_isUserDataChecked) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.email);
      final docSnapshot = await userDoc.get();

      // If document exists and all required data is present, set to Home page
      if (docSnapshot.exists &&
          docSnapshot.data()?['Mobile Number'] != null &&
          docSnapshot.data()?['email'] != null &&
          docSnapshot.data()?['username'] != null && // Fixed typo ('usernanme' to 'username')
          docSnapshot.data()?['role'] != null) {
        // User has complete data, stay on Home page
        setState(() {
          _selectedIndex = 0; // Set to Home tab if data is valid
          _isUserDataChecked = true;
        });
      } else {
        // If any data is missing, set to Profile page
        setState(() {
          _selectedIndex = 2; // Navigate to Profile Page if data is incomplete
          _isUserDataChecked = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserDetails(); // Check user details only once during initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // Updated icon for FIR
            label: 'Bail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
        currentIndex: _selectedIndex, // Highlight the selected tab
        selectedItemColor: Colors.black, // Selected icon color
        unselectedItemColor: Colors.black54, // Unselected icon color
        onTap: _onItemTapped, // Handle tab selection
      ),
    );
  }
}
