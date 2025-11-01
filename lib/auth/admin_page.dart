// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// //
// // class AdminPage extends StatefulWidget {
// //   const AdminPage({super.key});
// //
// //   @override
// //   State<AdminPage> createState() => _AdminPageState();
// // }
// //
// // class _AdminPageState extends State<AdminPage> {
// //   String selectedTab = 'pending'; // pending, approved, rejected
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Admin Panel"),
// //         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
// //       ),
// //       body: Column(
// //         children: [
// //           _buildTabBar(),
// //           Expanded(
// //             child: _buildUserList(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTabBar() {
// //     return Container(
// //       color: Colors.grey[200],
// //       child: Row(
// //         children: [
// //           _buildTab('Pending', 'pending'),
// //           _buildTab('Approved', 'approved'),
// //           _buildTab('Rejected', 'rejected'),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTab(String label, String value) {
// //     bool isSelected = selectedTab == value;
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () {
// //           setState(() {
// //             selectedTab = value;
// //           });
// //         },
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(vertical: 16),
// //           decoration: BoxDecoration(
// //             color: isSelected ? const Color.fromRGBO(255, 165, 89, 1) : Colors.transparent,
// //             border: Border(
// //               bottom: BorderSide(
// //                 color: isSelected ? const Color.fromRGBO(255, 125, 41, 1) : Colors.transparent,
// //                 width: 3,
// //               ),
// //             ),
// //           ),
// //           child: Text(
// //             label,
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// //               color: isSelected ? Colors.white : Colors.black87,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserList() {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: FirebaseFirestore.instance
// //           .collection('users')
// //           .where('approvalStatus', isEqualTo: selectedTab)
// //           .orderBy('createdAt', descending: true)
// //           .snapshots(),
// //       builder: (context, snapshot) {
// //         if (snapshot.hasError) {
// //           return Center(child: Text('Error: ${snapshot.error}'));
// //         }
// //
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //
// //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   _getEmptyIcon(),
// //                   size: 80,
// //                   color: Colors.grey[400],
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   _getEmptyMessage(),
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //
// //         return ListView.builder(
// //           padding: const EdgeInsets.all(8),
// //           itemCount: snapshot.data!.docs.length,
// //           itemBuilder: (context, index) {
// //             var doc = snapshot.data!.docs[index];
// //             Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
// //             return _buildUserCard(userData, doc.id);
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   IconData _getEmptyIcon() {
// //     switch (selectedTab) {
// //       case 'pending':
// //         return Icons.pending_actions;
// //       case 'approved':
// //         return Icons.check_circle_outline;
// //       case 'rejected':
// //         return Icons.cancel_outlined;
// //       default:
// //         return Icons.inbox;
// //     }
// //   }
// //
// //   String _getEmptyMessage() {
// //     switch (selectedTab) {
// //       case 'pending':
// //         return 'No pending approvals';
// //       case 'approved':
// //         return 'No approved users';
// //       case 'rejected':
// //         return 'No rejected users';
// //       default:
// //         return 'No users found';
// //     }
// //   }
// //
// //   Widget _buildUserCard(Map<String, dynamic> userData, String docId) {
// //     String username = userData['username'] ?? 'Unknown';
// //     String email = userData['email'] ?? 'No email';
// //     String role = userData['role'] ?? 'Unknown';
// //
// //     // Only show Judge and Police users
// //     if (role != 'Judge' && role != 'Police') {
// //       return const SizedBox.shrink();
// //     }
// //
// //     Timestamp? createdAt = userData['createdAt'] as Timestamp?;
// //     String formattedDate = createdAt != null
// //         ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
// //         : 'Unknown date';
// //
// //     return Card(
// //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
// //       elevation: 3,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 CircleAvatar(
// //                   backgroundColor: _getRoleColor(role),
// //                   child: Text(
// //                     username[0].toUpperCase(),
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         username,
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       Text(
// //                         email,
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           color: Colors.grey[600],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 _buildInfoChip('Role', role, _getRoleColor(role)),
// //                 const SizedBox(width: 8),
// //                 _buildInfoChip('Registered', formattedDate, Colors.blue),
// //               ],
// //             ),
// //             if (selectedTab == 'pending') ...[
// //               const SizedBox(height: 16),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   ElevatedButton.icon(
// //                     onPressed: () => _updateApprovalStatus(docId, email, false),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.red,
// //                       foregroundColor: Colors.white,
// //                     ),
// //                     icon: const Icon(Icons.close, size: 18),
// //                     label: const Text('Reject'),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   ElevatedButton.icon(
// //                     onPressed: () => _updateApprovalStatus(docId, email, true),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.green,
// //                       foregroundColor: Colors.white,
// //                     ),
// //                     icon: const Icon(Icons.check, size: 18),
// //                     label: const Text('Approve'),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //             if (selectedTab == 'approved' || selectedTab == 'rejected') ...[
// //               const SizedBox(height: 16),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   TextButton.icon(
// //                     onPressed: () => _revertToPending(docId, email),
// //                     icon: const Icon(Icons.undo, size: 18),
// //                     label: const Text('Reset to Pending'),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoChip(String label, String value, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: color.withOpacity(0.3)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(
// //             '$label: ',
// //             style: TextStyle(
// //               fontSize: 12,
// //               color: color,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 12,
// //               color: color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Color _getRoleColor(String role) {
// //     switch (role) {
// //       case 'Judge':
// //         return Colors.purple;
// //       case 'Police':
// //         return Colors.blue;
// //       case 'Citizen':
// //         return Colors.green;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// //
// //   Future<void> _updateApprovalStatus(String docId, String email, bool approve) async {
// //     try {
// //       await FirebaseFirestore.instance.collection('users').doc(docId).update({
// //         'isApproved': approve,
// //         'approvalStatus': approve ? 'approved' : 'rejected',
// //       });
// //
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(
// //               approve
// //                   ? 'User approved successfully!'
// //                   : 'User rejected successfully!',
// //             ),
// //             backgroundColor: approve ? Colors.green : Colors.red,
// //             duration: const Duration(seconds: 2),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error: ${e.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     }
// //   }
// //
// //   Future<void> _revertToPending(String docId, String email) async {
// //     try {
// //       await FirebaseFirestore.instance.collection('users').doc(docId).update({
// //         'isApproved': false,
// //         'approvalStatus': 'pending',
// //       });
// //
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('User status reset to pending'),
// //             backgroundColor: Colors.orange,
// //             duration: Duration(seconds: 2),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error: ${e.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     }
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:judica/common_pages/profile.dart';
//
// class AdminPage extends StatefulWidget {
//   const AdminPage({super.key});
//
//   @override
//   State<AdminPage> createState() => _AdminPageState();
// }
//
// class _AdminPageState extends State<AdminPage> {
//   int _selectedIndex = 0;
//   String selectedTab = 'pending'; // pending, approved, rejected
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_selectedIndex == 0 ? "Admin Panel" : "Profile"),
//         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
//       ),
//       body: _selectedIndex == 0 ? _buildAdminPanel() : ProfilePage(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         selectedItemColor: const Color.fromRGBO(255, 165, 89, 1),
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.admin_panel_settings),
//             label: 'Admin Panel',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAdminPanel() {
//     return Column(
//       children: [
//         _buildTabBar(),
//         Expanded(
//           child: _buildUserList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProfileItem(IconData icon, String label, String value) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: const Color.fromRGBO(255, 165, 89, 1),
//             size: 24,
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabBar() {
//     return Container(
//       color: Colors.grey[200],
//       child: Row(
//         children: [
//           _buildTab('Pending', 'pending'),
//           _buildTab('Approved', 'approved'),
//           _buildTab('Rejected', 'rejected'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTab(String label, String value) {
//     bool isSelected = selectedTab == value;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedTab = value;
//           });
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//             color: isSelected ? const Color.fromRGBO(255, 165, 89, 1) : Colors.transparent,
//             border: Border(
//               bottom: BorderSide(
//                 color: isSelected ? const Color.fromRGBO(255, 125, 41, 1) : Colors.transparent,
//                 width: 3,
//               ),
//             ),
//           ),
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               color: isSelected ? Colors.white : Colors.black87,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .where('approvalStatus', isEqualTo: selectedTab)
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   _getEmptyIcon(),
//                   size: 80,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _getEmptyMessage(),
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             var doc = snapshot.data!.docs[index];
//             Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
//             return _buildUserCard(userData, doc.id);
//           },
//         );
//       },
//     );
//   }
//
//   IconData _getEmptyIcon() {
//     switch (selectedTab) {
//       case 'pending':
//         return Icons.pending_actions;
//       case 'approved':
//         return Icons.check_circle_outline;
//       case 'rejected':
//         return Icons.cancel_outlined;
//       default:
//         return Icons.inbox;
//     }
//   }
//
//   String _getEmptyMessage() {
//     switch (selectedTab) {
//       case 'pending':
//         return 'No pending approvals';
//       case 'approved':
//         return 'No approved users';
//       case 'rejected':
//         return 'No rejected users';
//       default:
//         return 'No users found';
//     }
//   }
//
//   Widget _buildUserCard(Map<String, dynamic> userData, String docId) {
//     String username = userData['username'] ?? 'Unknown';
//     String email = userData['email'] ?? 'No email';
//     String role = userData['role'] ?? 'Unknown';
//
//     // Only show Judge and Police users
//     if (role != 'Judge' && role != 'Police') {
//       return const SizedBox.shrink();
//     }
//
//     Timestamp? createdAt = userData['createdAt'] as Timestamp?;
//     String formattedDate = createdAt != null
//         ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
//         : 'Unknown date';
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: _getRoleColor(role),
//                   child: Text(
//                     username[0].toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         username,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         email,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 _buildInfoChip('Role', role, _getRoleColor(role)),
//                 const SizedBox(width: 8),
//                 _buildInfoChip('Registered', formattedDate, Colors.blue),
//               ],
//             ),
//             if (selectedTab == 'pending') ...[
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _updateApprovalStatus(docId, email, false),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                     ),
//                     icon: const Icon(Icons.close, size: 18),
//                     label: const Text('Reject'),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton.icon(
//                     onPressed: () => _updateApprovalStatus(docId, email, true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                     icon: const Icon(Icons.check, size: 18),
//                     label: const Text('Approve'),
//                   ),
//                 ],
//               ),
//             ],
//             if (selectedTab == 'approved' || selectedTab == 'rejected') ...[
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton.icon(
//                     onPressed: () => _revertToPending(docId, email),
//                     icon: const Icon(Icons.undo, size: 18),
//                     label: const Text('Reset to Pending'),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoChip(String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontSize: 12,
//               color: color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getRoleColor(String role) {
//     switch (role) {
//       case 'Judge':
//         return Colors.purple;
//       case 'Police':
//         return Colors.blue;
//       case 'Citizen':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Future<void> _updateApprovalStatus(String docId, String email, bool approve) async {
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(docId).update({
//         'isApproved': approve,
//         'approvalStatus': approve ? 'approved' : 'rejected',
//       });
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               approve
//                   ? 'User approved successfully!'
//                   : 'User rejected successfully!',
//             ),
//             backgroundColor: approve ? Colors.green : Colors.red,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _revertToPending(String docId, String email) async {
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(docId).update({
//         'isApproved': false,
//         'approvalStatus': 'pending',
//       });
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('User status reset to pending'),
//             backgroundColor: Colors.orange,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:judica/common_pages/profile.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String selectedTab = 'pending';
  late AnimationController _animationController;

  final List<NavigationConfig> _navConfigs = [
    NavigationConfig(
      icon: Icons.admin_panel_settings_outlined,
      activeIcon: Icons.admin_panel_settings,
      label: 'Admin',
      color: const Color(0xFFEF4444),
      gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFF87171)]),
    ),
    NavigationConfig(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      color: const Color(0xFF10B981),
      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentConfig = _navConfigs[_selectedIndex];

    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                _buildModernAppBar(context, currentConfig),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedIndex == 0 ? _buildAdminPanel() : const ProfilePage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildModernBottomNav(context),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.gavel,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
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
                  _selectedIndex == 0 ? 'Admin Portal' : 'Profile',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                const Icon(
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
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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

  Widget _buildAdminPanel() {
    return Column(
      children: [
        _buildModernTabBar(),
        Expanded(
          child: _buildUserList(),
        ),
      ],
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Pending', 'pending', Icons.pending_actions, const Color(0xFFF59E0B)),
          _buildTab('Approved', 'approved', Icons.check_circle, const Color(0xFF10B981)),
          _buildTab('Rejected', 'rejected', Icons.cancel, const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String value, IconData icon, Color color) {
    bool isSelected = selectedTab == value;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedTab = value;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                colors: [color, color.withOpacity(0.8)],
              )
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('approvalStatus', isEqualTo: selectedTab)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

            String role = userData['role'] ?? 'Unknown';
            if (role != 'Judge' && role != 'Police') {
              return const SizedBox.shrink();
            }

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 50)),
              curve: Curves.easeOutCubic,
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: _buildUserCard(userData, doc.id),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFF87171)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading users...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    Color iconColor;
    switch (selectedTab) {
      case 'pending':
        iconColor = const Color(0xFFF59E0B);
        break;
      case 'approved':
        iconColor = const Color(0xFF10B981);
        break;
      case 'rejected':
        iconColor = const Color(0xFFEF4444);
        break;
      default:
        iconColor = Colors.grey;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.1),
                  iconColor.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getEmptyIcon(),
              size: 80,
              color: iconColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _getEmptyMessage(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: const Color(0xFFEF4444).withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEmptyIcon() {
    switch (selectedTab) {
      case 'pending':
        return Icons.pending_actions;
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.inbox;
    }
  }

  String _getEmptyMessage() {
    switch (selectedTab) {
      case 'pending':
        return 'No pending approvals';
      case 'approved':
        return 'No approved users';
      case 'rejected':
        return 'No rejected users';
      default:
        return 'No users found';
    }
  }

  Widget _buildUserCard(Map<String, dynamic> userData, String docId) {
    String username = userData['username'] ?? 'Unknown';
    String email = userData['email'] ?? 'No email';
    String role = userData['role'] ?? 'Unknown';

    Timestamp? createdAt = userData['createdAt'] as Timestamp?;
    String formattedDate = createdAt != null
        ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
        : 'Unknown date';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_getRoleColor(role), _getRoleColor(role).withOpacity(0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getRoleColor(role).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 28,
                    child: Text(
                      username[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip('Role', role, _getRoleColor(role), _getRoleIcon(role)),
                _buildInfoChip('Registered', formattedDate, const Color(0xFF3B82F6), Icons.calendar_today),
              ],
            ),
            if (selectedTab == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Reject',
                      icon: Icons.close_rounded,
                      color: const Color(0xFFEF4444),
                      onPressed: () => _updateApprovalStatus(docId, email, false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Approve',
                      icon: Icons.check_rounded,
                      color: const Color(0xFF10B981),
                      onPressed: () => _updateApprovalStatus(docId, email, true),
                    ),
                  ),
                ],
              ),
            ],
            if (selectedTab == 'approved' || selectedTab == 'rejected') ...[
              const SizedBox(height: 16),
              _buildActionButton(
                label: 'Reset to Pending',
                icon: Icons.refresh_rounded,
                color: const Color(0xFFF59E0B),
                onPressed: () => _revertToPending(docId, email),
                isOutlined: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: !isOutlined
                ? LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            )
                : null,
            color: isOutlined ? color.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(12),
            border: isOutlined ? Border.all(color: color.withOpacity(0.5)) : null,
            boxShadow: !isOutlined
                ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isOutlined ? color : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isOutlined ? color : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Judge':
        return const Color(0xFF8B5CF6);
      case 'Police':
        return const Color(0xFF3B82F6);
      case 'Citizen':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Judge':
        return Icons.gavel;
      case 'Police':
        return Icons.local_police;
      case 'Citizen':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _updateApprovalStatus(String docId, String email, bool approve) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'isApproved': approve,
        'approvalStatus': approve ? 'approved' : 'rejected',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  approve ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    approve ? 'User approved successfully!' : 'User rejected successfully!',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: approve ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _revertToPending(String docId, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'isApproved': false,
        'approvalStatus': 'pending',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.refresh, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'User status reset to pending',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFF59E0B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
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