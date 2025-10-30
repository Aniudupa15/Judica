// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class AdminPage extends StatefulWidget {
//   const AdminPage({super.key});
//
//   @override
//   State<AdminPage> createState() => _AdminPageState();
// }
//
// class _AdminPageState extends State<AdminPage> {
//   String selectedTab = 'pending'; // pending, approved, rejected
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Panel"),
//         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
//       ),
//       body: Column(
//         children: [
//           _buildTabBar(),
//           Expanded(
//             child: _buildUserList(),
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
import 'package:judica/common_pages/profile.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;
  String selectedTab = 'pending'; // pending, approved, rejected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Admin Panel" : "Profile"),
        backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
      ),
      body: _selectedIndex == 0 ? _buildAdminPanel() : ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color.fromRGBO(255, 165, 89, 1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin Panel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildAdminPanel() {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: _buildUserList(),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromRGBO(255, 165, 89, 1),
            size: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          _buildTab('Pending', 'pending'),
          _buildTab('Approved', 'approved'),
          _buildTab('Rejected', 'rejected'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String value) {
    bool isSelected = selectedTab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color.fromRGBO(255, 165, 89, 1) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color.fromRGBO(255, 125, 41, 1) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black87,
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
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getEmptyIcon(),
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _getEmptyMessage(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
            return _buildUserCard(userData, doc.id);
          },
        );
      },
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

    // Only show Judge and Police users
    if (role != 'Judge' && role != 'Police') {
      return const SizedBox.shrink();
    }

    Timestamp? createdAt = userData['createdAt'] as Timestamp?;
    String formattedDate = createdAt != null
        ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
        : 'Unknown date';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getRoleColor(role),
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Role', role, _getRoleColor(role)),
                const SizedBox(width: 8),
                _buildInfoChip('Registered', formattedDate, Colors.blue),
              ],
            ),
            if (selectedTab == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _updateApprovalStatus(docId, email, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _updateApprovalStatus(docId, email, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                  ),
                ],
              ),
            ],
            if (selectedTab == 'approved' || selectedTab == 'rejected') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _revertToPending(docId, email),
                    icon: const Icon(Icons.undo, size: 18),
                    label: const Text('Reset to Pending'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Judge':
        return Colors.purple;
      case 'Police':
        return Colors.blue;
      case 'Citizen':
        return Colors.green;
      default:
        return Colors.grey;
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
            content: Text(
              approve
                  ? 'User approved successfully!'
                  : 'User rejected successfully!',
            ),
            backgroundColor: approve ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
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
          const SnackBar(
            content: Text('User status reset to pending'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}