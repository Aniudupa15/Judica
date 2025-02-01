import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ComplaintManagementDashboard extends StatefulWidget {
  @override
  _ComplaintManagementDashboardState createState() =>
      _ComplaintManagementDashboardState();
}

class _ComplaintManagementDashboardState
    extends State<ComplaintManagementDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPriority = 'All'; // Default filter for all priorities

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs: Active, Resolved
  }

  // Function to filter complaints by priority and status
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Remove extra height
        child: AppBar(
          title: null, // Remove the title from the AppBar
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.active), // Tab with text for Active Complaints
              Tab(text: AppLocalizations.of(context)!.resolvedcomplaints), // Tab with text for Resolved Complaints
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Complaints Tab
          Column(
            children: [
              // Priority filter buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPriority = 'All';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _selectedPriority == 'All' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(AppLocalizations.of(context)!.all),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPriority = 'High';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _selectedPriority == 'High' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(AppLocalizations.of(context)!.high),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPriority = 'Medium';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _selectedPriority == 'Medium' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(AppLocalizations.of(context)!.medium),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPriority = 'Low';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _selectedPriority == 'Low' ? Colors.blue : Colors.grey,
                      ),
                      child: Text(AppLocalizations.of(context)!.low),
                    ),
                  ],
                ),
              ),
              // StreamBuilder with filtered complaints
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getFilteredComplaints(_selectedPriority, false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final complaints = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        final complaint = complaints[index].data() as Map<String, dynamic>;
                        final complaintId = complaints[index].id;
                        final description = complaint['description'];
                        final priority = complaint['priority'];
                        final status = complaint['status'];
                        final userName = complaint['userName'];
                        final userPhone = complaint['userPhone'];
                        final timestamp = (complaint['timestamp'] as Timestamp?)?.toDate();

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Priority: $priority'),
                                Text('Status: $status'),
                                Text('Submitted by: $userName, Phone: $userPhone'),
                                Text('Timestamp: ${timestamp?.toLocal()}'),
                              ],
                            ),
                            onTap: () => _openComplaintDetails(context, complaint),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Resolved Complaints Tab
          Column(
            children: [
              // StreamBuilder for resolved complaints
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getFilteredComplaints(_selectedPriority, true),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final complaints = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        final complaint = complaints[index].data() as Map<String, dynamic>;
                        final complaintId = complaints[index].id;
                        final description = complaint['description'];
                        final priority = complaint['priority'];
                        final status = complaint['status'];
                        final userName = complaint['userName'];
                        final userPhone = complaint['userPhone'];
                        final timestamp = (complaint['timestamp'] as Timestamp?)?.toDate();

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Priority: $priority'),
                                Text('Status: $status'),
                                Text('Submitted by: $userName, Phone: $userPhone'),
                                Text('Timestamp: ${timestamp?.toLocal()}'),
                              ],
                            ),
                            onTap: () => _openComplaintDetails(context, complaint),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to open the bottom sheet to show complaint details
  void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);  // Close the bottom sheet
                    },
                  ),
                ),
                // Display the complaint image
                complaint['fileUrl'] != null
                    ? Image.network(complaint['fileUrl'])
                    : SizedBox.shrink(),
                SizedBox(height: 16),
                Text(
                  'Description: ${complaint['description']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Priority: ${complaint['priority']}'),
                Text('Status: ${complaint['status']}'),
                Text('Submitted by: ${complaint['userName']}'),
                Text('Phone: ${complaint['userPhone']}'),
                Text('Timestamp: ${complaint['timestamp']}'),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
