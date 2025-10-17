import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judica/common_pages/profile.dart';
import 'package:judica/police/chat_bot_police.dart';
import 'package:judica/police/engagement.dart';
import 'package:judica/police/police_complaint_dashboard.dart';
import '../l10n/app_localizations.dart';
import 'fir_page.dart'; // Import your FIR page

class PoliceHome extends StatefulWidget {
  const PoliceHome({super.key});

  @override
  State<PoliceHome> createState() => _PoliceHomeState();
}

class _PoliceHomeState extends State<PoliceHome> {
  int _selectedIndex = 0; // Tracks the selected tab
  bool _isUserDataChecked = false; // Flag to track if user data has been checked

  // Define the pages for navigation
  static final List<Widget> _pages = <Widget>[
    FirComponent(), // FIR-related component
    const ChatScreenPolice(), // ChatBot Page
    ComplaintManagementDashboard(),
    PoliceEngagementScreen(),
    const ProfilePage(),
    // Profile Page
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
          docSnapshot.data()?['username'] != null &&
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
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.judica ?? 'Judica'), // Use fallback text if null
        backgroundColor: const Color.fromRGBO(255, 165, 89, 1), // Lighter orange
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ChatBotBackground.jpg'), // Path to your background image
            fit: BoxFit.cover, // Make sure the image covers the whole screen
          ),
        ),
        child: _pages[_selectedIndex], // Display the selected page
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: const Color.fromRGBO(255, 165, 89, 1), // Set background color here
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment), // Updated icon for FIR
              label: 'FIR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: appLocalizations?.chatbot ?? 'Chatbot', // Use fallback text if null
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: appLocalizations?.main ?? 'Main', // Use fallback text if null
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_from_queue_sharp),
              label: appLocalizations?.create ?? 'Create', // Use fallback text if null
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: appLocalizations?.profile ?? 'Profile', // Use fallback text if null
            ),
          ],
          currentIndex: _selectedIndex, // Highlight the selected tab
          selectedItemColor: Colors.white, // Selected icon color
          unselectedItemColor: Colors.black54, // Unselected icon color
          onTap: _onItemTapped, // Handle tab selection
        ),
      ),
    );
  }
}
