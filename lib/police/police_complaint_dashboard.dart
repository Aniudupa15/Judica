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
      query = query.where('status', isEqualTo: 'Completed');
    } else {
      query = query.where('status', isNotEqualTo: 'Completed');
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

  Future<void> _updateComplaintStatus(String complaintId, String newStatus, {String? completionInfo}) async {
    try {
      Map<String, dynamic> updateData = {
        'status': newStatus,
        'statusUpdatedAt': FieldValue.serverTimestamp(),
      };

      if (newStatus == 'Completed' && completionInfo != null && completionInfo.isNotEmpty) {
        updateData['completionInfo'] = completionInfo;
        updateData['completedAt'] = FieldValue.serverTimestamp();
      }

      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(complaintId)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  void _showStatusUpdateDialog(String complaintId, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) => StatusUpdateDialog(
        complaintId: complaintId,
        currentStatus: currentStatus,
        onUpdateStatus: _updateComplaintStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildTabBar(),
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
                Text(AppLocalizations.of(context)?.resolvedcomplaints ?? 'Completed'),
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
                    final doc = complaints[index];
                    final complaint = doc.data() as Map<String, dynamic>;
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
                      child: _buildComplaintCard(doc.id, complaint, timestamp, index),
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
                        color: isSelected ? filterColor : Colors.grey[300]!,
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
      String complaintId, Map<String, dynamic> complaint, dynamic timestamp, int index) {
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

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.info_outline;

    switch (complaint['status']) {
      case 'Pending':
        statusColor = Color(0xFFF59E0B);
        statusIcon = Icons.pending_outlined;
        break;
      case 'In Process':
        statusColor = Color(0xFF3B82F6);
        statusIcon = Icons.autorenew;
        break;
      case 'Completed':
        statusColor = Color(0xFF10B981);
        statusIcon = Icons.check_circle_outline;
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
          onTap: () => _openComplaintDetails(context, complaintId, complaint, timestamp),
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
                      statusColor,
                      statusIcon,
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
                if (complaint['status'] != 'Completed') ...[
                  SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey[200]),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showStatusUpdateDialog(complaintId, complaint['status'] ?? 'Pending'),
                    icon: Icon(Icons.edit_outlined, size: 18),
                    label: Text('Update Status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
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
      BuildContext context, String complaintId, Map<String, dynamic> complaint, dynamic timestamp) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black54,
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: ComplaintDetailsSheet(
              complaintId: complaintId,
              complaint: complaint,
              timestamp: timestamp,
              onOpenMap: _openMap,
              onUpdateStatus: _showStatusUpdateDialog,
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
                : (isResolved ? 'No completed complaints' : 'No active complaints'),
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

class StatusUpdateDialog extends StatefulWidget {
  final String complaintId;
  final String currentStatus;
  final Function(String, String, {String? completionInfo}) onUpdateStatus;

  const StatusUpdateDialog({
    Key? key,
    required this.complaintId,
    required this.currentStatus,
    required this.onUpdateStatus,
  }) : super(key: key);

  @override
  _StatusUpdateDialogState createState() => _StatusUpdateDialogState();
}

class _StatusUpdateDialogState extends State<StatusUpdateDialog> {
  String? _selectedStatus;
  final TextEditingController _completionInfoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _completionInfoController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (_selectedStatus == null) return;

    if (_selectedStatus == 'Completed' && _completionInfoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide completion information'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await widget.onUpdateStatus(
      widget.complaintId,
      _selectedStatus!,
      completionInfo: _selectedStatus == 'Completed' ? _completionInfoController.text.trim() : null,
    );

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Color(0xFFF59E0B);
      case 'In Process':
        return Color(0xFF3B82F6);
      case 'Completed':
        return Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.pending_outlined;
      case 'In Process':
        return Icons.autorenew;
      case 'Completed':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.edit_outlined, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Update Status',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Status',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 12),
                  ...['Pending', 'In Process', 'Completed'].map((status) {
                    final isSelected = _selectedStatus == status;
                    final statusColor = _getStatusColor(status);
                    final statusIcon = _getStatusIcon(status);

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _selectedStatus = status),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? statusColor.withOpacity(0.1)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? statusColor
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    statusIcon,
                                    color: statusColor,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    status,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? statusColor
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: statusColor,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  if (_selectedStatus == 'Completed') ...[
                    SizedBox(height: 16),
                    Text(
                      'Completion Information *',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _completionInfoController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Provide details about the resolution...',
                        hintStyle: GoogleFonts.roboto(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF10B981),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Color(0xFF6366F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                              : Text(
                            'Update',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintDetailsSheet extends StatelessWidget {
  final String complaintId;
  final Map<String, dynamic> complaint;
  final dynamic timestamp;
  final Function(double, double) onOpenMap;
  final Function(String, String) onUpdateStatus;
  final String Function(String) getPriorityText;

  const ComplaintDetailsSheet({
    Key? key,
    required this.complaintId,
    required this.complaint,
    required this.timestamp,
    required this.onOpenMap,
    required this.onUpdateStatus,
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

    Color statusColor = Colors.grey;
    switch (complaint['status']) {
      case 'Pending':
        statusColor = Color(0xFFF59E0B);
        break;
      case 'In Process':
        statusColor = Color(0xFF3B82F6);
        break;
      case 'Completed':
        statusColor = Color(0xFF10B981);
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
                          color: statusColor,
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
                  if (complaint['completionInfo'] != null && complaint['completionInfo'].toString().isNotEmpty) ...[
                    SizedBox(height: 16),
                    _buildDetailSection(
                      icon: Icons.check_circle_outline,
                      title: 'Completion Information',
                      content: complaint['completionInfo'],
                      isMultiLine: true,
                      color: Color(0xFF10B981),
                    ),
                  ],
                  if (complaint['completedAt'] != null) ...[
                    SizedBox(height: 16),
                    _buildDetailSection(
                      icon: Icons.event_available,
                      title: 'Completed At',
                      content: (complaint['completedAt'] as Timestamp).toDate().toLocal().toString(),
                      color: Color(0xFF10B981),
                    ),
                  ],
                  if (complaint['location'] != null) ...[
                    SizedBox(height: 20),
                    _buildLocationCard(
                      complaint['location']['latitude'] ?? 0.0,
                      complaint['location']['longitude'] ?? 0.0,
                      context,
                    ),
                  ],
                  if (complaint['status'] != 'Completed') ...[
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onUpdateStatus(complaintId, complaint['status'] ?? 'Pending');
                      },
                      icon: Icon(Icons.edit_outlined, size: 20),
                      label: Text('Update Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
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