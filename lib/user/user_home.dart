
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judica/common_pages/profile.dart';
import 'package:judica/user/chat_bot_user.dart';
import 'package:judica/user/chatapp.dart';
import 'package:judica/user/filing_case.dart';

import 'govscheme.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;
  bool? _isUserDataComplete;

  void _navigateToChat() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  List<Widget> _getPages() {
    return <Widget>[
      ChatScreenUser(onNavigateToChat: _navigateToChat),
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

    final isComplete = docSnapshot.exists &&
        requiredFields.every((field) =>
        docSnapshot.data()?.containsKey(field) == true &&
            docSnapshot.data()![field] != null);

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
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4A5FE8),
          ),
        ),
      );
    }

    final pages = _getPages();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A5FE8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.gavel,
                color: Color(0xFF4A5FE8),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Judica',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: GovernmentInfo(),
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 26,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'ChatBot',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.file_copy_outlined,
                  activeIcon: Icons.file_copy,
                  label: 'Complaint',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.forum_outlined,
                  activeIcon: Icons.forum,
                  label: 'Chat',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A5FE8).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFF4A5FE8) : Colors.grey.shade600,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF4A5FE8),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}