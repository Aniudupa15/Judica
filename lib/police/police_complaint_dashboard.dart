// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // import '../l10n/app_localizations.dart';
// //
// // class ComplaintManagementDashboard extends StatefulWidget {
// //   @override
// //   _ComplaintManagementDashboardState createState() =>
// //       _ComplaintManagementDashboardState();
// // }
// //
// // class _ComplaintManagementDashboardState
// //     extends State<ComplaintManagementDashboard> with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   String _selectedPriority = "All";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //   }
// //
// //   Stream<QuerySnapshot> _getFilteredComplaints(String priority, bool isResolved) {
// //     Query query = FirebaseFirestore.instance.collection('complaints');
// //
// //     if (priority != 'All') {
// //       query = query.where('priority', isEqualTo: priority);
// //     }
// //
// //     if (isResolved) {
// //       query = query.where('status', isEqualTo: 'Resolved');
// //     } else {
// //       query = query.where('status', isNotEqualTo: 'Resolved');
// //     }
// //
// //     return query.orderBy('priority', descending: true).snapshots();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(kToolbarHeight),
// //         child: AppBar(
// //           title: null,
// //           bottom: TabBar(
// //             controller: _tabController,
// //             tabs: [
// //               Tab(text: AppLocalizations.of(context)?.active ?? 'Active'),
// //               Tab(text: AppLocalizations.of(context)?.resolvedcomplaints ?? 'Resolved'),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: TabBarView(
// //         controller: _tabController,
// //         children: [
// //           _buildComplaintsTab(false),
// //           _buildComplaintsTab(true),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildComplaintsTab(bool isResolved) {
// //     return Column(
// //       children: [
// //         if (!isResolved) _buildPriorityFilters(),
// //         Expanded(
// //           child: StreamBuilder<QuerySnapshot>(
// //             stream: _getFilteredComplaints(_selectedPriority, isResolved),
// //             builder: (context, snapshot) {
// //               if (snapshot.connectionState == ConnectionState.waiting) {
// //                 return Center(child: CircularProgressIndicator());
// //               }
// //
// //               if (snapshot.hasError) {
// //                 return Center(child: Text("Error: ${snapshot.error}"));
// //               }
// //
// //               final complaints = snapshot.data?.docs ?? [];
// //
// //               return ListView.builder(
// //                 itemCount: complaints.length,
// //                 itemBuilder: (context, index) {
// //                   final complaint = complaints[index].data() as Map<String, dynamic>;
// //                   final timestamp = complaint['timestamp'];
// //
// //                   return _buildComplaintCard(complaint, timestamp);
// //                 },
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildPriorityFilters() {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //       child: Row(
// //         children: ['All', 'High', 'Medium', 'Low'].map((priority) {
// //           return Padding(
// //             padding: EdgeInsets.only(right: 8),
// //             child: ElevatedButton(
// //               onPressed: () => setState(() => _selectedPriority = priority),
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.white,
// //                 backgroundColor: _selectedPriority == priority ? Colors.blue : Colors.grey,
// //               ),
// //               child: Text(AppLocalizations.of(context)?.all ?? priority),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildComplaintCard(Map<String, dynamic> complaint, dynamic timestamp) {
// //     return Card(
// //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //       child: ListTile(
// //         title: Text(
// //           complaint['description'] ?? 'No description',
// //           maxLines: 2,
// //           overflow: TextOverflow.ellipsis,
// //         ),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildInfoText('Priority', complaint['priority'] ?? 'No priority'),
// //             _buildInfoText('Status', complaint['status'] ?? 'No status'),
// //             _buildInfoText(
// //               'Submitted by',
// //               '${complaint['userName'] ?? 'Unknown'}, Phone: ${complaint['userPhone'] ?? 'Unknown'}',
// //             ),
// //             _buildInfoText(
// //               'Timestamp',
// //               timestamp != null
// //                   ? (timestamp as Timestamp).toDate().toLocal().toString()
// //                   : 'N/A',
// //             ),
// //           ],
// //         ),
// //         onTap: () => _openComplaintDetails(context, complaint, timestamp),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoText(String label, String value) {
// //     return Padding(
// //       padding: EdgeInsets.only(bottom: 4),
// //       child: Text(
// //         '$label: $value',
// //         maxLines: 1,
// //         overflow: TextOverflow.ellipsis,
// //       ),
// //     );
// //   }
// //
// //   void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       builder: (BuildContext context) {
// //         return DraggableScrollableSheet(
// //           initialChildSize: 0.9,
// //           minChildSize: 0.5,
// //           maxChildSize: 0.95,
// //           builder: (_, controller) {
// //             return Container(
// //               padding: EdgeInsets.all(16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       IconButton(
// //                         icon: Icon(Icons.close),
// //                         onPressed: () => Navigator.pop(context),
// //                       ),
// //                       Expanded(
// //                         child: Text(
// //                           'Complaint Details',
// //                           style: Theme.of(context).textTheme.titleLarge,
// //                           textAlign: TextAlign.center,
// //                         ),
// //                       ),
// //                       SizedBox(width: 48), // Balance the close button
// //                     ],
// //                   ),
// //                   Expanded(
// //                     child: ListView(
// //                       controller: controller,
// //                       children: [
// //                         if (complaint['fileUrl'] != null)
// //                           AspectRatio(
// //                             aspectRatio: 16 / 9,
// //                             child: Image.network(
// //                               complaint['fileUrl']!,
// //                               fit: BoxFit.cover,
// //                               loadingBuilder: (context, child, loadingProgress) {
// //                                 if (loadingProgress == null) return child;
// //                                 return Center(child: CircularProgressIndicator());
// //                               },
// //                               errorBuilder: (context, error, stackTrace) =>
// //                                   Center(child: Icon(Icons.error)),
// //                             ),
// //                           ),
// //                         SizedBox(height: 16),
// //                         _buildDetailItem(
// //                           'Description',
// //                           complaint['description'] ?? 'No description',
// //                           isMultiLine: true,
// //                         ),
// //                         _buildDetailItem('Priority', complaint['priority'] ?? 'No priority'),
// //                         _buildDetailItem('Status', complaint['status'] ?? 'No status'),
// //                         _buildDetailItem('Submitted by', complaint['userName'] ?? 'Unknown'),
// //                         _buildDetailItem('Phone', complaint['userPhone'] ?? 'Unknown'),
// //                         _buildDetailItem(
// //                           'Timestamp',
// //                           timestamp != null
// //                               ? (timestamp as Timestamp).toDate().toLocal().toString()
// //                               : 'N/A',
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildDetailItem(String label, String value, {bool isMultiLine = false}) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 8),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(
// //               fontSize: 14,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.grey[600],
// //             ),
// //           ),
// //           SizedBox(height: 4),
// //           Text(
// //             value,
// //             style: TextStyle(fontSize: 16),
// //             maxLines: isMultiLine ? null : 1,
// //             overflow: isMultiLine ? null : TextOverflow.ellipsis,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../l10n/app_localizations.dart';
//
// class ComplaintManagementDashboard extends StatefulWidget {
//   @override
//   _ComplaintManagementDashboardState createState() =>
//       _ComplaintManagementDashboardState();
// }
//
// class _ComplaintManagementDashboardState
//     extends State<ComplaintManagementDashboard> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _selectedPriority = "All";
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Stream<QuerySnapshot> _getFilteredComplaints(String priority, bool isResolved) {
//     Query query = FirebaseFirestore.instance.collection('complaints');
//
//     if (priority != 'All') {
//       query = query.where('priority', isEqualTo: priority);
//     }
//
//     if (isResolved) {
//       query = query.where('status', isEqualTo: 'Resolved');
//     } else {
//       query = query.where('status', isNotEqualTo: 'Resolved');
//     }
//
//     return query.orderBy('priority', descending: true).snapshots();
//   }
//
//   // Get localized text for priority
//   String _getPriorityText(String priority) {
//     switch (priority) {
//       case 'All':
//         return AppLocalizations.of(context)?.all ?? 'All';
//       case 'High':
//         return AppLocalizations.of(context)?.high ?? 'High';
//       case 'Medium':
//         return AppLocalizations.of(context)?.medium ?? 'Medium';
//       case 'Low':
//         return AppLocalizations.of(context)?.low ?? 'Low';
//       default:
//         return priority;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: AppBar(
//           title: null,
//           bottom: TabBar(
//             controller: _tabController,
//             tabs: [
//               Tab(text: AppLocalizations.of(context)?.active ?? 'Active'),
//               Tab(text: AppLocalizations.of(context)?.resolvedcomplaints ?? 'Resolved'),
//             ],
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildComplaintsTab(false),
//           _buildComplaintsTab(true),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildComplaintsTab(bool isResolved) {
//     return Column(
//       children: [
//         if (!isResolved) _buildPriorityFilters(),
//         Expanded(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: _getFilteredComplaints(_selectedPriority, isResolved),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               if (snapshot.hasError) {
//                 return Center(child: Text("Error: ${snapshot.error}"));
//               }
//
//               final complaints = snapshot.data?.docs ?? [];
//
//               if (complaints.isEmpty) {
//                 return Center(
//                   child: Text(
//                     isResolved
//                         ? 'No resolved complaints'
//                         : 'No active complaints',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 itemCount: complaints.length,
//                 itemBuilder: (context, index) {
//                   final complaint = complaints[index].data() as Map<String, dynamic>;
//                   final timestamp = complaint['timestamp'];
//
//                   return _buildComplaintCard(complaint, timestamp);
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPriorityFilters() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Row(
//         children: ['All', 'High', 'Medium', 'Low'].map((priority) {
//           return Padding(
//             padding: EdgeInsets.only(right: 8),
//             child: ElevatedButton(
//               onPressed: () => setState(() => _selectedPriority = priority),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: _selectedPriority == priority ? Colors.blue : Colors.grey,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//               child: Text(_getPriorityText(priority)),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildComplaintCard(Map<String, dynamic> complaint, dynamic timestamp) {
//     // Get priority color
//     Color priorityColor = Colors.grey;
//     switch (complaint['priority']) {
//       case 'High':
//         priorityColor = Colors.red;
//         break;
//       case 'Medium':
//         priorityColor = Colors.orange;
//         break;
//       case 'Low':
//         priorityColor = Colors.green;
//         break;
//     }
//
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       elevation: 2,
//       child: ListTile(
//         leading: Container(
//           width: 4,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             color: priorityColor,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         title: Text(
//           complaint['description'] ?? 'No description',
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 _buildChip(
//                   _getPriorityText(complaint['priority'] ?? 'No priority'),
//                   priorityColor,
//                 ),
//                 SizedBox(width: 8),
//                 _buildChip(
//                   complaint['status'] ?? 'No status',
//                   Colors.blue,
//                 ),
//               ],
//             ),
//             SizedBox(height: 4),
//             _buildInfoText('Submitted by', complaint['userName'] ?? 'Unknown'),
//             _buildInfoText('Phone', complaint['userPhone'] ?? 'Unknown'),
//             _buildInfoText(
//               'Date',
//               timestamp != null
//                   ? _formatDate((timestamp as Timestamp).toDate())
//                   : 'N/A',
//             ),
//           ],
//         ),
//         onTap: () => _openComplaintDetails(context, complaint, timestamp),
//         trailing: Icon(Icons.chevron_right),
//       ),
//     );
//   }
//
//   Widget _buildChip(String label, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoText(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 2),
//       child: Text(
//         '$label: $value',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(fontSize: 13, color: Colors.grey[700]),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
//
//     if (difference.inDays == 0) {
//       return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays} days ago';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
//
//   void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.9,
//           minChildSize: 0.5,
//           maxChildSize: 0.95,
//           builder: (_, controller) {
//             return Container(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       Expanded(
//                         child: Text(
//                           'Complaint Details',
//                           style: Theme.of(context).textTheme.titleLarge,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       SizedBox(width: 48),
//                     ],
//                   ),
//                   Divider(),
//                   Expanded(
//                     child: ListView(
//                       controller: controller,
//                       children: [
//                         if (complaint['fileUrl'] != null)
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: AspectRatio(
//                               aspectRatio: 16 / 9,
//                               child: Image.network(
//                                 complaint['fileUrl']!,
//                                 fit: BoxFit.cover,
//                                 loadingBuilder: (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Center(child: CircularProgressIndicator());
//                                 },
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Center(child: Icon(Icons.error)),
//                               ),
//                             ),
//                           ),
//                         SizedBox(height: 16),
//                         _buildDetailItem(
//                           'Description',
//                           complaint['description'] ?? 'No description',
//                           isMultiLine: true,
//                         ),
//                         _buildDetailItem('Priority', _getPriorityText(complaint['priority'] ?? 'No priority')),
//                         _buildDetailItem('Status', complaint['status'] ?? 'No status'),
//                         _buildDetailItem('Submitted by', complaint['userName'] ?? 'Unknown'),
//                         _buildDetailItem('Phone', complaint['userPhone'] ?? 'Unknown'),
//                         _buildDetailItem(
//                           'Timestamp',
//                           timestamp != null
//                               ? (timestamp as Timestamp).toDate().toLocal().toString()
//                               : 'N/A',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailItem(String label, String value, {bool isMultiLine = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(fontSize: 16),
//             maxLines: isMultiLine ? null : 1,
//             overflow: isMultiLine ? null : TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../l10n/app_localizations.dart';

class ComplaintManagementDashboard extends StatefulWidget {
  @override
  _ComplaintManagementDashboardState createState() =>
      _ComplaintManagementDashboardState();
}

class _ComplaintManagementDashboardState
    extends State<ComplaintManagementDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPriority = "All";
  Position? _policeLocation;
  final double _radiusInKm = 2.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _policeLocation = position;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) *
            cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  bool _isWithinRadius(double complaintLat, double complaintLon) {
    if (_policeLocation == null) return true;

    double distance = _calculateDistance(
      _policeLocation!.latitude,
      _policeLocation!.longitude,
      complaintLat,
      complaintLon,
    );

    return distance <= _radiusInKm;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getFilteredComplaints(String priority, bool isResolved) {
    Query query = FirebaseFirestore.instance.collection('complaints');

    if (priority != 'All') {
      query = query.where('priority', isEqualTo: priority);
    }

    if (isResolved) {
      query = query.where('status', isEqualTo: 'Resolved');
    } else {
      query = query.where('status', isNotEqualTo: 'Resolved');
    }

    return query.orderBy('priority', descending: true).snapshots();
  }

  // Get localized text for priority
  String _getPriorityText(String priority) {
    switch (priority) {
      case 'All':
        return AppLocalizations.of(context)?.all ?? 'All';
      case 'High':
        return AppLocalizations.of(context)?.high ?? 'High';
      case 'Medium':
        return AppLocalizations.of(context)?.medium ?? 'Medium';
      case 'Low':
        return AppLocalizations.of(context)?.low ?? 'Low';
      default:
        return priority;
    }
  }

  // Open location on map
  Future<void> _openMap(double latitude, double longitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open map: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 50),
        child: AppBar(
          title: null,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: AppLocalizations.of(context)?.active ?? 'Active'),
              Tab(text: AppLocalizations.of(context)?.resolvedcomplaints ?? 'Resolved'),
            ],
          ),
        ),
      ),
      body: Column(
          children: [
          if (_policeLocation != null)
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //   color: Colors.blue.withOpacity(0.1),
            //   child: Row(
            //     children: [
            //       Icon(Icons.my_location, color: Colors.blue, size: 20),
            //       SizedBox(width: 8),
            //       Expanded(
            //         child: Text(
            //           'Showing complaints within ${_radiusInKm.toStringAsFixed(1)} km radius',
            //           style: TextStyle(
            //             color: Colors.blue[700],
            //             fontWeight: FontWeight.w500,
            //             fontSize: 13,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildComplaintsTab(false),
                _buildComplaintsTab(true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsTab(bool isResolved) {
    return Column(
      children: [
        if (!isResolved) _buildPriorityFilters(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _getFilteredComplaints(_selectedPriority, isResolved),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              var complaints = snapshot.data?.docs ?? [];

              // Filter by radius if location is available
              if (_policeLocation != null) {
                complaints = complaints.where((doc) {
                  final complaint = doc.data() as Map<String, dynamic>;
                  final location = complaint['location'];
                  if (location == null) return false;

                  final lat = location['latitude'] as double?;
                  final lon = location['longitude'] as double?;
                  if (lat == null || lon == null) return false;

                  return _isWithinRadius(lat, lon);
                }).toList();
              }

              if (complaints.isEmpty) {
                return Center(
                  child: Text(
                    _policeLocation != null
                        ? 'No complaints within ${_radiusInKm.toStringAsFixed(1)} km'
                        : (isResolved ? 'No resolved complaints' : 'No active complaints'),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final complaint = complaints[index].data() as Map<String, dynamic>;
                  final timestamp = complaint['timestamp'];

                  return _buildComplaintCard(complaint, timestamp);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: ['All', 'High', 'Medium', 'Low'].map((priority) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () => setState(() => _selectedPriority = priority),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _selectedPriority == priority ? Colors.blue : Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(_getPriorityText(priority)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint, dynamic timestamp) {
    // Get priority color
    Color priorityColor = Colors.grey;
    switch (complaint['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 4,
          height: double.infinity,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          complaint['description'] ?? 'No description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                _buildChip(
                  _getPriorityText(complaint['priority'] ?? 'No priority'),
                  priorityColor,
                ),
                SizedBox(width: 8),
                _buildChip(
                  complaint['status'] ?? 'No status',
                  Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 4),
            _buildInfoText('Submitted by', complaint['userName'] ?? 'Unknown'),
            _buildInfoText('Phone', complaint['userPhone'] ?? 'Unknown'),
            _buildInfoText(
              'Date',
              timestamp != null
                  ? _formatDate((timestamp as Timestamp).toDate())
                  : 'N/A',
            ),
          ],
        ),
        onTap: () => _openComplaintDetails(context, complaint, timestamp),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Text(
        '$label: $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Complaint Details',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        if (complaint['fileUrl'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                complaint['fileUrl']!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        SizedBox(height: 16),
                        _buildDetailItem(
                          'Description',
                          complaint['description'] ?? 'No description',
                          isMultiLine: true,
                        ),
                        _buildDetailItem('Priority', _getPriorityText(complaint['priority'] ?? 'No priority')),
                        _buildDetailItem('Status', complaint['status'] ?? 'No status'),
                        _buildDetailItem('Submitted by', complaint['userName'] ?? 'Unknown'),
                        _buildDetailItem('Phone', complaint['userPhone'] ?? 'Unknown'),
                        _buildDetailItem(
                          'Timestamp',
                          timestamp != null
                              ? (timestamp as Timestamp).toDate().toLocal().toString()
                              : 'N/A',
                        ),
                        // Location Section
                        if (complaint['location'] != null) ...[
                          SizedBox(height: 16),
                          Divider(),
                          SizedBox(height: 8),
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildLocationCard(
                            complaint['location']['latitude'] ?? 0.0,
                            complaint['location']['longitude'] ?? 0.0,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLocationCard(double latitude, double longitude) {
    return GestureDetector(
      onTap: () => _openMap(latitude, longitude),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latitude',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    latitude.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Longitude',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    longitude.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
            maxLines: isMultiLine ? null : 1,
            overflow: isMultiLine ? null : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}