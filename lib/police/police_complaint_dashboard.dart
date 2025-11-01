// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // //
// // // import '../l10n/app_localizations.dart';
// // //
// // // class ComplaintManagementDashboard extends StatefulWidget {
// // //   @override
// // //   _ComplaintManagementDashboardState createState() =>
// // //       _ComplaintManagementDashboardState();
// // // }
// // //
// // // class _ComplaintManagementDashboardState
// // //     extends State<ComplaintManagementDashboard> with SingleTickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   String _selectedPriority = "All";
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 2, vsync: this);
// // //   }
// // //
// // //   Stream<QuerySnapshot> _getFilteredComplaints(String priority, bool isResolved) {
// // //     Query query = FirebaseFirestore.instance.collection('complaints');
// // //
// // //     if (priority != 'All') {
// // //       query = query.where('priority', isEqualTo: priority);
// // //     }
// // //
// // //     if (isResolved) {
// // //       query = query.where('status', isEqualTo: 'Resolved');
// // //     } else {
// // //       query = query.where('status', isNotEqualTo: 'Resolved');
// // //     }
// // //
// // //     return query.orderBy('priority', descending: true).snapshots();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: PreferredSize(
// // //         preferredSize: Size.fromHeight(kToolbarHeight),
// // //         child: AppBar(
// // //           title: null,
// // //           bottom: TabBar(
// // //             controller: _tabController,
// // //             tabs: [
// // //               Tab(text: AppLocalizations.of(context)?.active ?? 'Active'),
// // //               Tab(text: AppLocalizations.of(context)?.resolvedcomplaints ?? 'Resolved'),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //       body: TabBarView(
// // //         controller: _tabController,
// // //         children: [
// // //           _buildComplaintsTab(false),
// // //           _buildComplaintsTab(true),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildComplaintsTab(bool isResolved) {
// // //     return Column(
// // //       children: [
// // //         if (!isResolved) _buildPriorityFilters(),
// // //         Expanded(
// // //           child: StreamBuilder<QuerySnapshot>(
// // //             stream: _getFilteredComplaints(_selectedPriority, isResolved),
// // //             builder: (context, snapshot) {
// // //               if (snapshot.connectionState == ConnectionState.waiting) {
// // //                 return Center(child: CircularProgressIndicator());
// // //               }
// // //
// // //               if (snapshot.hasError) {
// // //                 return Center(child: Text("Error: ${snapshot.error}"));
// // //               }
// // //
// // //               final complaints = snapshot.data?.docs ?? [];
// // //
// // //               return ListView.builder(
// // //                 itemCount: complaints.length,
// // //                 itemBuilder: (context, index) {
// // //                   final complaint = complaints[index].data() as Map<String, dynamic>;
// // //                   final timestamp = complaint['timestamp'];
// // //
// // //                   return _buildComplaintCard(complaint, timestamp);
// // //                 },
// // //               );
// // //             },
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildPriorityFilters() {
// // //     return SingleChildScrollView(
// // //       scrollDirection: Axis.horizontal,
// // //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// // //       child: Row(
// // //         children: ['All', 'High', 'Medium', 'Low'].map((priority) {
// // //           return Padding(
// // //             padding: EdgeInsets.only(right: 8),
// // //             child: ElevatedButton(
// // //               onPressed: () => setState(() => _selectedPriority = priority),
// // //               style: ElevatedButton.styleFrom(
// // //                 foregroundColor: Colors.white,
// // //                 backgroundColor: _selectedPriority == priority ? Colors.blue : Colors.grey,
// // //               ),
// // //               child: Text(AppLocalizations.of(context)?.all ?? priority),
// // //             ),
// // //           );
// // //         }).toList(),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildComplaintCard(Map<String, dynamic> complaint, dynamic timestamp) {
// // //     return Card(
// // //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// // //       child: ListTile(
// // //         title: Text(
// // //           complaint['description'] ?? 'No description',
// // //           maxLines: 2,
// // //           overflow: TextOverflow.ellipsis,
// // //         ),
// // //         subtitle: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             _buildInfoText('Priority', complaint['priority'] ?? 'No priority'),
// // //             _buildInfoText('Status', complaint['status'] ?? 'No status'),
// // //             _buildInfoText(
// // //               'Submitted by',
// // //               '${complaint['userName'] ?? 'Unknown'}, Phone: ${complaint['userPhone'] ?? 'Unknown'}',
// // //             ),
// // //             _buildInfoText(
// // //               'Timestamp',
// // //               timestamp != null
// // //                   ? (timestamp as Timestamp).toDate().toLocal().toString()
// // //                   : 'N/A',
// // //             ),
// // //           ],
// // //         ),
// // //         onTap: () => _openComplaintDetails(context, complaint, timestamp),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildInfoText(String label, String value) {
// // //     return Padding(
// // //       padding: EdgeInsets.only(bottom: 4),
// // //       child: Text(
// // //         '$label: $value',
// // //         maxLines: 1,
// // //         overflow: TextOverflow.ellipsis,
// // //       ),
// // //     );
// // //   }
// // //
// // //   void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
// // //     showModalBottomSheet(
// // //       context: context,
// // //       isScrollControlled: true,
// // //       builder: (BuildContext context) {
// // //         return DraggableScrollableSheet(
// // //           initialChildSize: 0.9,
// // //           minChildSize: 0.5,
// // //           maxChildSize: 0.95,
// // //           builder: (_, controller) {
// // //             return Container(
// // //               padding: EdgeInsets.all(16),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Row(
// // //                     children: [
// // //                       IconButton(
// // //                         icon: Icon(Icons.close),
// // //                         onPressed: () => Navigator.pop(context),
// // //                       ),
// // //                       Expanded(
// // //                         child: Text(
// // //                           'Complaint Details',
// // //                           style: Theme.of(context).textTheme.titleLarge,
// // //                           textAlign: TextAlign.center,
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: 48), // Balance the close button
// // //                     ],
// // //                   ),
// // //                   Expanded(
// // //                     child: ListView(
// // //                       controller: controller,
// // //                       children: [
// // //                         if (complaint['fileUrl'] != null)
// // //                           AspectRatio(
// // //                             aspectRatio: 16 / 9,
// // //                             child: Image.network(
// // //                               complaint['fileUrl']!,
// // //                               fit: BoxFit.cover,
// // //                               loadingBuilder: (context, child, loadingProgress) {
// // //                                 if (loadingProgress == null) return child;
// // //                                 return Center(child: CircularProgressIndicator());
// // //                               },
// // //                               errorBuilder: (context, error, stackTrace) =>
// // //                                   Center(child: Icon(Icons.error)),
// // //                             ),
// // //                           ),
// // //                         SizedBox(height: 16),
// // //                         _buildDetailItem(
// // //                           'Description',
// // //                           complaint['description'] ?? 'No description',
// // //                           isMultiLine: true,
// // //                         ),
// // //                         _buildDetailItem('Priority', complaint['priority'] ?? 'No priority'),
// // //                         _buildDetailItem('Status', complaint['status'] ?? 'No status'),
// // //                         _buildDetailItem('Submitted by', complaint['userName'] ?? 'Unknown'),
// // //                         _buildDetailItem('Phone', complaint['userPhone'] ?? 'Unknown'),
// // //                         _buildDetailItem(
// // //                           'Timestamp',
// // //                           timestamp != null
// // //                               ? (timestamp as Timestamp).toDate().toLocal().toString()
// // //                               : 'N/A',
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildDetailItem(String label, String value, {bool isMultiLine = false}) {
// // //     return Padding(
// // //       padding: EdgeInsets.symmetric(vertical: 8),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             label,
// // //             style: TextStyle(
// // //               fontSize: 14,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.grey[600],
// // //             ),
// // //           ),
// // //           SizedBox(height: 4),
// // //           Text(
// // //             value,
// // //             style: TextStyle(fontSize: 16),
// // //             maxLines: isMultiLine ? null : 1,
// // //             overflow: isMultiLine ? null : TextOverflow.ellipsis,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
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
// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
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
// //   // Get localized text for priority
// //   String _getPriorityText(String priority) {
// //     switch (priority) {
// //       case 'All':
// //         return AppLocalizations.of(context)?.all ?? 'All';
// //       case 'High':
// //         return AppLocalizations.of(context)?.high ?? 'High';
// //       case 'Medium':
// //         return AppLocalizations.of(context)?.medium ?? 'Medium';
// //       case 'Low':
// //         return AppLocalizations.of(context)?.low ?? 'Low';
// //       default:
// //         return priority;
// //     }
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
// //               if (complaints.isEmpty) {
// //                 return Center(
// //                   child: Text(
// //                     isResolved
// //                         ? 'No resolved complaints'
// //                         : 'No active complaints',
// //                     style: TextStyle(fontSize: 16, color: Colors.grey),
// //                   ),
// //                 );
// //               }
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
// //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //               ),
// //               child: Text(_getPriorityText(priority)),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildComplaintCard(Map<String, dynamic> complaint, dynamic timestamp) {
// //     // Get priority color
// //     Color priorityColor = Colors.grey;
// //     switch (complaint['priority']) {
// //       case 'High':
// //         priorityColor = Colors.red;
// //         break;
// //       case 'Medium':
// //         priorityColor = Colors.orange;
// //         break;
// //       case 'Low':
// //         priorityColor = Colors.green;
// //         break;
// //     }
// //
// //     return Card(
// //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //       elevation: 2,
// //       child: ListTile(
// //         leading: Container(
// //           width: 4,
// //           height: double.infinity,
// //           decoration: BoxDecoration(
// //             color: priorityColor,
// //             borderRadius: BorderRadius.circular(2),
// //           ),
// //         ),
// //         title: Text(
// //           complaint['description'] ?? 'No description',
// //           maxLines: 2,
// //           overflow: TextOverflow.ellipsis,
// //           style: TextStyle(fontWeight: FontWeight.w600),
// //         ),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             SizedBox(height: 8),
// //             Row(
// //               children: [
// //                 _buildChip(
// //                   _getPriorityText(complaint['priority'] ?? 'No priority'),
// //                   priorityColor,
// //                 ),
// //                 SizedBox(width: 8),
// //                 _buildChip(
// //                   complaint['status'] ?? 'No status',
// //                   Colors.blue,
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 4),
// //             _buildInfoText('Submitted by', complaint['userName'] ?? 'Unknown'),
// //             _buildInfoText('Phone', complaint['userPhone'] ?? 'Unknown'),
// //             _buildInfoText(
// //               'Date',
// //               timestamp != null
// //                   ? _formatDate((timestamp as Timestamp).toDate())
// //                   : 'N/A',
// //             ),
// //           ],
// //         ),
// //         onTap: () => _openComplaintDetails(context, complaint, timestamp),
// //         trailing: Icon(Icons.chevron_right),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildChip(String label, Color color) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: color.withOpacity(0.3)),
// //       ),
// //       child: Text(
// //         label,
// //         style: TextStyle(
// //           color: color,
// //           fontSize: 12,
// //           fontWeight: FontWeight.bold,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoText(String label, String value) {
// //     return Padding(
// //       padding: EdgeInsets.only(bottom: 2),
// //       child: Text(
// //         '$label: $value',
// //         maxLines: 1,
// //         overflow: TextOverflow.ellipsis,
// //         style: TextStyle(fontSize: 13, color: Colors.grey[700]),
// //       ),
// //     );
// //   }
// //
// //   String _formatDate(DateTime date) {
// //     final now = DateTime.now();
// //     final difference = now.difference(date);
// //
// //     if (difference.inDays == 0) {
// //       return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
// //     } else if (difference.inDays == 1) {
// //       return 'Yesterday';
// //     } else if (difference.inDays < 7) {
// //       return '${difference.inDays} days ago';
// //     } else {
// //       return '${date.day}/${date.month}/${date.year}';
// //     }
// //   }
// //
// //   void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
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
// //                       SizedBox(width: 48),
// //                     ],
// //                   ),
// //                   Divider(),
// //                   Expanded(
// //                     child: ListView(
// //                       controller: controller,
// //                       children: [
// //                         if (complaint['fileUrl'] != null)
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(12),
// //                             child: AspectRatio(
// //                               aspectRatio: 16 / 9,
// //                               child: Image.network(
// //                                 complaint['fileUrl']!,
// //                                 fit: BoxFit.cover,
// //                                 loadingBuilder: (context, child, loadingProgress) {
// //                                   if (loadingProgress == null) return child;
// //                                   return Center(child: CircularProgressIndicator());
// //                                 },
// //                                 errorBuilder: (context, error, stackTrace) =>
// //                                     Center(child: Icon(Icons.error)),
// //                               ),
// //                             ),
// //                           ),
// //                         SizedBox(height: 16),
// //                         _buildDetailItem(
// //                           'Description',
// //                           complaint['description'] ?? 'No description',
// //                           isMultiLine: true,
// //                         ),
// //                         _buildDetailItem('Priority', _getPriorityText(complaint['priority'] ?? 'No priority')),
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
//
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:geolocator/geolocator.dart';
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
//   Position? _policeLocation;
//   final double _radiusInKm = 2.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _requestLocationPermission();
//   }
//
//   Future<void> _requestLocationPermission() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         setState(() {
//           _policeLocation = position;
//         });
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const p = 0.017453292519943295;
//     final a = 0.5 -
//         cos((lat2 - lat1) * p) / 2 +
//         cos(lat1 * p) *
//             cos(lat2 * p) *
//             (1 - cos((lon2 - lon1) * p)) /
//             2;
//     return 12742 * asin(sqrt(a));
//   }
//
//   bool _isWithinRadius(double complaintLat, double complaintLon) {
//     if (_policeLocation == null) return true;
//
//     double distance = _calculateDistance(
//       _policeLocation!.latitude,
//       _policeLocation!.longitude,
//       complaintLat,
//       complaintLon,
//     );
//
//     return distance <= _radiusInKm;
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
//   // Open location on map
//   Future<void> _openMap(double latitude, double longitude) async {
//     final String googleMapsUrl =
//         'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//
//     try {
//       await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open map: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight + 50),
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
//       body: Column(
//           children: [
//           if (_policeLocation != null)
//             // Container(
//             //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             //   color: Colors.blue.withOpacity(0.1),
//             //   child: Row(
//             //     children: [
//             //       Icon(Icons.my_location, color: Colors.blue, size: 20),
//             //       SizedBox(width: 8),
//             //       Expanded(
//             //         child: Text(
//             //           'Showing complaints within ${_radiusInKm.toStringAsFixed(1)} km radius',
//             //           style: TextStyle(
//             //             color: Colors.blue[700],
//             //             fontWeight: FontWeight.w500,
//             //             fontSize: 13,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildComplaintsTab(false),
//                 _buildComplaintsTab(true),
//               ],
//             ),
//           ),
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
//               var complaints = snapshot.data?.docs ?? [];
//
//               // Filter by radius if location is available
//               if (_policeLocation != null) {
//                 complaints = complaints.where((doc) {
//                   final complaint = doc.data() as Map<String, dynamic>;
//                   final location = complaint['location'];
//                   if (location == null) return false;
//
//                   final lat = location['latitude'] as double?;
//                   final lon = location['longitude'] as double?;
//                   if (lat == null || lon == null) return false;
//
//                   return _isWithinRadius(lat, lon);
//                 }).toList();
//               }
//
//               if (complaints.isEmpty) {
//                 return Center(
//                   child: Text(
//                     _policeLocation != null
//                         ? 'No complaints within ${_radiusInKm.toStringAsFixed(1)} km'
//                         : (isResolved ? 'No resolved complaints' : 'No active complaints'),
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
//                         // Location Section
//                         if (complaint['location'] != null) ...[
//                           SizedBox(height: 16),
//                           Divider(),
//                           SizedBox(height: 8),
//                           Text(
//                             'Location',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 12),
//                           _buildLocationCard(
//                             complaint['location']['latitude'] ?? 0.0,
//                             complaint['location']['longitude'] ?? 0.0,
//                           ),
//                         ],
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
//   Widget _buildLocationCard(double latitude, double longitude) {
//     return GestureDetector(
//       onTap: () => _openMap(latitude, longitude),
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.blue.withOpacity(0.3)),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.location_on, color: Colors.blue, size: 28),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Latitude',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Text(
//                     latitude.toString(),
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     'Longitude',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Text(
//                     longitude.toString(),
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.open_in_new, color: Colors.blue),
//           ],
//         ),
//       ),
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../l10n/app_localizations.dart';

class ComplaintManagementDashboard extends StatefulWidget {
  @override
  _ComplaintManagementDashboardState createState() =>
      _ComplaintManagementDashboardState();
}

class _ComplaintManagementDashboardState
    extends State<ComplaintManagementDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPriority = "All";
  Position? _policeLocation;
  final double _radiusInKm = 2.0;
  bool _isLoading = true;

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
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _isLoading = false;
      });
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

  Stream<QuerySnapshot> _getFilteredComplaints(
      String priority, bool isResolved) {
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

  Future<void> _openMap(double latitude, double longitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      await launchUrl(Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open map: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Tab Bar
          _buildTabBar(),
          // Content
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

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pending_actions, size: 18),
                SizedBox(width: 8),
                Text(AppLocalizations.of(context)?.active ?? 'Active'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 18),
                SizedBox(width: 8),
                Text(AppLocalizations.of(context)?.resolvedcomplaints ?? 'Resolved'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsTab(bool isResolved) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {});
      },
      color: Color(0xFF6366F1),
      child: Column(
        children: [
          if (!isResolved) _buildPriorityFilters(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredComplaints(_selectedPriority, isResolved),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoading();
                }

                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                var complaints = snapshot.data?.docs ?? [];

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
                  return _buildEmptyState(isResolved);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint =
                    complaints[index].data() as Map<String, dynamic>;
                    final timestamp = complaint['timestamp'];

                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween<double>(begin: 0, end: 1),
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
                      child: _buildComplaintCard(complaint, timestamp, index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityFilters() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: ['All', 'High', 'Medium', 'Low'].map((priority) {
            final isSelected = _selectedPriority == priority;
            Color filterColor;

            switch (priority) {
              case 'High':
                filterColor = Color(0xFFEF4444);
                break;
              case 'Medium':
                filterColor = Color(0xFFF59E0B);
                break;
              case 'Low':
                filterColor = Color(0xFF10B981);
                break;
              default:
                filterColor = Color(0xFF6366F1);
            }

            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _selectedPriority = priority),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        colors: [filterColor, filterColor.withOpacity(0.8)],
                      )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected
                            ? filterColor
                            : Colors.grey[300]!,
                        width: isSelected ? 0 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: filterColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        Text(
                          _getPriorityText(priority),
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(
      Map<String, dynamic> complaint, dynamic timestamp, int index) {
    Color priorityColor = Colors.grey;
    IconData priorityIcon = Icons.remove;

    switch (complaint['priority']) {
      case 'High':
        priorityColor = Color(0xFFEF4444);
        priorityIcon = Icons.arrow_upward_rounded;
        break;
      case 'Medium':
        priorityColor = Color(0xFFF59E0B);
        priorityIcon = Icons.remove_rounded;
        break;
      case 'Low':
        priorityColor = Color(0xFF10B981);
        priorityIcon = Icons.arrow_downward_rounded;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openComplaintDetails(context, complaint, timestamp),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [priorityColor, priorityColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        priorityIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint['description'] ?? 'No description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildModernChip(
                      _getPriorityText(complaint['priority'] ?? 'No priority'),
                      priorityColor,
                      priorityIcon,
                    ),
                    _buildModernChip(
                      complaint['status'] ?? 'No status',
                      Color(0xFF3B82F6),
                      Icons.info_outline,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Divider(height: 1, color: Colors.grey[200]),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        Icons.person_outline,
                        complaint['userName'] ?? 'Unknown',
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoRow(
                        Icons.access_time,
                        timestamp != null
                            ? _formatDate((timestamp as Timestamp).toDate())
                            : 'N/A',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernChip(String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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

  void _openComplaintDetails(
      BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black54,
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: ComplaintDetailsSheet(
              complaint: complaint,
              timestamp: timestamp,
              onOpenMap: _openMap,
              getPriorityText: _getPriorityText,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildShimmerBox(40, 40, 12),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(double.infinity, 16, 4),
                        SizedBox(height: 8),
                        _buildShimmerBox(200, 12, 4),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildShimmerBox(80, 24, 12),
                  SizedBox(width: 8),
                  _buildShimmerBox(80, 24, 12),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox(double width, double height, double borderRadius) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.3, end: 1.0),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value > 0.6 ? 1.0 - value + 0.6 : value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );
      },
      onEnd: () {
        setState(() {});
      },
    );
  }

  Widget _buildEmptyState(bool isResolved) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 600),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isResolved ? Icons.check_circle_outline : Icons.inbox_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            _policeLocation != null
                ? 'No complaints within ${_radiusInKm.toStringAsFixed(1)} km'
                : (isResolved ? 'No resolved complaints' : 'No active complaints'),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
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
          Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444).withOpacity(0.6)),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
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
}

class ComplaintDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> complaint;
  final dynamic timestamp;
  final Function(double, double) onOpenMap;
  final String Function(String) getPriorityText;

  const ComplaintDetailsSheet({
    Key? key,
    required this.complaint,
    required this.timestamp,
    required this.onOpenMap,
    required this.getPriorityText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color priorityColor = Colors.grey;
    switch (complaint['priority']) {
      case 'High':
        priorityColor = Color(0xFFEF4444);
        break;
      case 'Medium':
        priorityColor = Color(0xFFF59E0B);
        break;
      case 'Low':
        priorityColor = Color(0xFF10B981);
        break;
    }

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [priorityColor, priorityColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.description, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Complaint Details',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  if (complaint['fileUrl'] != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          complaint['fileUrl']!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(Icons.error, color: Colors.grey[400]),
                                ),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                  _buildDetailSection(
                    icon: Icons.description_outlined,
                    title: 'Description',
                    content: complaint['description'] ?? 'No description',
                    isMultiLine: true,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailSection(
                          icon: Icons.flag_outlined,
                          title: 'Priority',
                          content: getPriorityText(complaint['priority'] ?? 'No priority'),
                          color: priorityColor,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailSection(
                          icon: Icons.info_outline,
                          title: 'Status',
                          content: complaint['status'] ?? 'No status',
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildDetailSection(
                    icon: Icons.person_outline,
                    title: 'Submitted by',
                    content: complaint['userName'] ?? 'Unknown',
                  ),
                  SizedBox(height: 16),
                  _buildDetailSection(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    content: complaint['userPhone'] ?? 'Unknown',
                  ),
                  SizedBox(height: 16),
                  _buildDetailSection(
                    icon: Icons.access_time_outlined,
                    title: 'Timestamp',
                    content: timestamp != null
                        ? (timestamp as Timestamp).toDate().toLocal().toString()
                        : 'N/A',
                  ),
                  if (complaint['location'] != null) ...[
                    SizedBox(height: 20),
                    _buildLocationCard(
                      complaint['location']['latitude'] ?? 0.0,
                      complaint['location']['longitude'] ?? 0.0,
                      context,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
    bool isMultiLine = false,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.05) ?? Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color?.withOpacity(0.2) ?? Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color ?? Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: color ?? Colors.grey[800],
              height: 1.4,
            ),
            maxLines: isMultiLine ? null : 2,
            overflow: isMultiLine ? null : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(double latitude, double longitude, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onOpenMap(latitude, longitude),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View Location',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap to open in maps',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}