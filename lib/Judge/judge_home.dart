// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:judica/Judge/bail_page.dart';
// import 'package:judica/Judge/chat_bot_judge.dart';
// import 'package:judica/Judge/chatapp.dart';
// import 'package:judica/common_pages/profile.dart';
//
//
// class AdvocateHome extends StatefulWidget {
//   const AdvocateHome({super.key});
//
//   @override
//   State<AdvocateHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<AdvocateHome> {
//   int _selectedIndex = 0; // Tracks the selected tab
//   bool _isUserDataChecked = false; // Flag to track if user data has been checked
//
//   // Define the pages for navigation
//   static final List<Widget> _pages = <Widget>[
//     const Bailpage(), // FIR-related component
//     const ChatScreenjudge(),
//     OpenChatRoomView(),// Placeholder for Home Page
//     const ProfilePage(),
//
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
//     if (user != null && !_isUserDataChecked) {
//       final userDoc = FirebaseFirestore.instance.collection('users').doc(user.email);
//       final docSnapshot = await userDoc.get();
//
//       // If document exists and all required data is present, set to Home page
//       if (docSnapshot.exists &&
//           docSnapshot.data()?['Mobile Number'] != null &&
//           docSnapshot.data()?['email'] != null &&
//           docSnapshot.data()?['username'] != null && // Fixed typo ('usernanme' to 'username')
//           docSnapshot.data()?['role'] != null) {
//         // User has complete data, stay on Home page
//         setState(() {
//           _selectedIndex = 0; // Set to Home tab if data is valid
//           _isUserDataChecked = true;
//         });
//       } else {
//         // If any data is missing, set to Profile page
//         setState(() {
//           _selectedIndex = 2; // Navigate to Profile Page if data is incomplete
//           _isUserDataChecked = true;
//         });
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkUserDetails(); // Check user details only once during initialization
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex], // Display the selected page
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assignment), // Updated icon for FIR
//             label: 'Bail',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_box_rounded),
//             label: 'ChatBot',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat_bubble),
//             label: 'chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//
//         ],
//         currentIndex: _selectedIndex, // Highlight the selected tab
//         selectedItemColor: Colors.black, // Selected icon color
//         unselectedItemColor: Colors.black54, // Unselected icon color
//         onTap: _onItemTapped, // Handle tab selection
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:judica/Judge/bail_page.dart';
import 'package:judica/Judge/chat_bot_judge.dart';
import 'package:judica/Judge/chatapp.dart';
import 'package:judica/common_pages/profile.dart';

class AdvocateHome extends StatefulWidget {
  const AdvocateHome({super.key});

  @override
  State<AdvocateHome> createState() => _AdvocateHomeState();
}

class _AdvocateHomeState extends State<AdvocateHome> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isUserDataChecked = false;
  late AnimationController _fabController;
  late AnimationController _navController;
  late Animation<double> _fabAnimation;

  static final List<Widget> _pages = <Widget>[
    const Bailpage(),
    const ChatScreenjudge(),
    OpenChatRoomView(),
    const ProfilePage(),
  ];

  // Navigation item configurations with colors and gradients
  final List<NavigationConfig> _navConfigs = [
    NavigationConfig(
      icon: Icons.gavel_outlined,
      activeIcon: Icons.gavel,
      label: 'Bail',
      color: const Color(0xFF8B5CF6),
      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
    ),
    NavigationConfig(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'ChatBot',
      color: const Color(0xFF3B82F6),
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)]),
    ),
    NavigationConfig(
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
      label: 'Chat',
      color: const Color(0xFF10B981),
      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
    ),
    NavigationConfig(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      color: const Color(0xFFF59E0B),
      gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _navController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
    _checkUserDetails();
    _navController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _navController.dispose();
    super.dispose();
  }

  Future<void> _checkUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !_isUserDataChecked) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.email);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists &&
          docSnapshot.data()?['Mobile Number'] != null &&
          docSnapshot.data()?['email'] != null &&
          docSnapshot.data()?['username'] != null &&
          docSnapshot.data()?['role'] != null) {
        setState(() {
          _selectedIndex = 0;
          _isUserDataChecked = true;
        });
      } else {
        setState(() {
          _selectedIndex = 3; // Profile page
          _isUserDataChecked = true;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _fabController.forward().then((_) => _fabController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentConfig = _navConfigs[_selectedIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  currentConfig.color.withOpacity(0.1),
                  currentConfig.color.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Modern App Bar
                _buildModernAppBar(context, currentConfig),
                // Page Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(_selectedIndex),
                      child: _pages[_selectedIndex],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildModernBottomNav(context),
      floatingActionButton: _selectedIndex == 0
          ? ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            _showQuickActionDialog(context);
          },
          backgroundColor: currentConfig.color,
          elevation: 8,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Quick Action',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildModernAppBar(BuildContext context, NavigationConfig config) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Judica logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.gavel,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Judica',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Advocate Portal',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Notification icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: List.generate(
            _navConfigs.length,
                (index) => _buildNavItem(index),
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: _navConfigs[_selectedIndex].color,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.roboto(
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(int index) {
    final config = _navConfigs[index];
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: isSelected ? config.gradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: config.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Icon(
          isSelected ? config.activeIcon : config.icon,
          color: isSelected ? Colors.white : Colors.grey[400],
          size: isSelected ? 26 : 24,
        ),
      ),
      label: config.label,
    );
  }

  void _showQuickActionDialog(BuildContext context) {
    final config = _navConfigs[_selectedIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuickActionButton(
              icon: Icons.add_box,
              title: 'New Bail Application',
              subtitle: 'File a new bail request',
              color: const Color(0xFF8B5CF6),
              onTap: () {
                Navigator.pop(context);
                // Navigate to new bail application
              },
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              icon: Icons.search,
              title: 'Search Cases',
              subtitle: 'Find existing cases',
              color: const Color(0xFF3B82F6),
              onTap: () {
                Navigator.pop(context);
                // Navigate to search
              },
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              icon: Icons.calendar_today,
              title: 'View Schedule',
              subtitle: 'Check court dates',
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.pop(context);
                // Navigate to schedule
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationConfig {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;
  final Gradient gradient;

  NavigationConfig({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
    required this.gradient,
  });
}