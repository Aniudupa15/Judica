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
  String _selectedPriority = "All";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComplaintsTab(false),
          _buildComplaintsTab(true),
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

              final complaints = snapshot.data?.docs ?? [];

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
              ),
              child: Text(AppLocalizations.of(context)?.all ?? priority),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint, dynamic timestamp) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          complaint['description'] ?? 'No description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoText('Priority', complaint['priority'] ?? 'No priority'),
            _buildInfoText('Status', complaint['status'] ?? 'No status'),
            _buildInfoText(
              'Submitted by',
              '${complaint['userName'] ?? 'Unknown'}, Phone: ${complaint['userPhone'] ?? 'Unknown'}',
            ),
            _buildInfoText(
              'Timestamp',
              timestamp != null
                  ? (timestamp as Timestamp).toDate().toLocal().toString()
                  : 'N/A',
            ),
          ],
        ),
        onTap: () => _openComplaintDetails(context, complaint, timestamp),
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _openComplaintDetails(BuildContext context, Map<String, dynamic> complaint, dynamic timestamp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                      SizedBox(width: 48), // Balance the close button
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        if (complaint['fileUrl'] != null)
                          AspectRatio(
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
                        SizedBox(height: 16),
                        _buildDetailItem(
                          'Description',
                          complaint['description'] ?? 'No description',
                          isMultiLine: true,
                        ),
                        _buildDetailItem('Priority', complaint['priority'] ?? 'No priority'),
                        _buildDetailItem('Status', complaint['status'] ?? 'No status'),
                        _buildDetailItem('Submitted by', complaint['userName'] ?? 'Unknown'),
                        _buildDetailItem('Phone', complaint['userPhone'] ?? 'Unknown'),
                        _buildDetailItem(
                          'Timestamp',
                          timestamp != null
                              ? (timestamp as Timestamp).toDate().toLocal().toString()
                              : 'N/A',
                        ),
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