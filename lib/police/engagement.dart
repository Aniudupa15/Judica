// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../l10n/app_localizations.dart';
//
// class PoliceEngagementScreen extends StatefulWidget {
//   @override
//   _PoliceEngagementScreenState createState() => _PoliceEngagementScreenState();
// }
//
// class _PoliceEngagementScreenState extends State<PoliceEngagementScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   // Survey creation controllers
//   TextEditingController _surveyTitleController = TextEditingController();
//   TextEditingController _surveyQuestionController = TextEditingController();
//   TextEditingController _surveyOptionController = TextEditingController();
//   List<Map<String, dynamic>> _questions = [];
//   List<String> _surveyOptions = [];
//
//   // Announcement creation controllers
//   TextEditingController _announcementTitleController = TextEditingController();
//   TextEditingController _announcementDescriptionController = TextEditingController();
//   TextEditingController _announcementSchemeController = TextEditingController();
//   TextEditingController _announcementRegistrationLinkController = TextEditingController();
//   TextEditingController _announcementInstructionsController = TextEditingController();
//
//   // To hold the created surveys list from Firestore
//
//   // To hold the survey responses list from Firestore
//   List<Map<String, dynamic>> _surveyResponsesList = [];
//
//   // Fetch created surveys from Firestore
//   void _fetchSurveys() async {
//     await FirebaseFirestore.instance.collection('surveys').get();
//     setState(() {
//     });
//   }
//
//   // Fetch survey responses from Firestore
//   void _fetchSurveyResponses() async {
//     final responsesSnapshot = await FirebaseFirestore.instance.collection('survey_responses').get();
//     setState(() {
//       _surveyResponsesList = responsesSnapshot.docs.map((doc) {
//         return {
//           'surveyId': doc['surveyId'],
//           'userEmail': doc['userEmail'] ?? 'N/A', // Handling null value for email
//           'userName': doc['userName'] ?? 'Anonymous', // Handling null value for name
//           'timestamp': doc['timestamp'] ?? FieldValue.serverTimestamp(), // Handling null timestamp
//           'responses': doc['responses'] ?? {}, // Null safe responses
//         };
//       }).toList();
//     });
//   }
//
//   // Submit Survey with Multiple Questions and Options
//   void _submitSurvey() {
//     if (_surveyTitleController.text.isEmpty || _questions.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.pleaseentertitle ?? 'Please enter a title')));
//       return;
//     }
//
//     // Save survey to Firebase
//     FirebaseFirestore.instance.collection('surveys').add({
//       'title': _surveyTitleController.text,
//       'questions': _questions.map((question) {
//         return {
//           'question': question['question'],
//           'options': question['options'],
//         };
//       }).toList(),
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       _surveyTitleController.clear();
//       _questions.clear();
//       _surveyOptions.clear();
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.surveycreatedsuccessfully ?? 'Survey created successfully')));
//   }
//
//   // Submit Public Announcement
//   void _submitAnnouncement() {
//     if (_announcementTitleController.text.isEmpty ||
//         _announcementDescriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.plscmpltannouncement ?? 'Please complete the announcement')));
//       return;
//     }
//
//     // Save announcement to Firebase
//     FirebaseFirestore.instance.collection('announcements').add({
//       'title': _announcementTitleController.text,
//       'description': _announcementDescriptionController.text,
//       'scheme': _announcementSchemeController.text,
//       'registrationLink': _announcementRegistrationLinkController.text,
//       'instructions': _announcementInstructionsController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       _announcementTitleController.clear();
//       _announcementDescriptionController.clear();
//       _announcementSchemeController.clear();
//       _announcementRegistrationLinkController.clear();
//       _announcementInstructionsController.clear();
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.announcementcreatedsuccessfully ?? 'Announcement created successfully')));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _fetchSurveys(); // Fetch surveys on page load
//     _fetchSurveyResponses(); // Fetch survey responses on page load
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:null,
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: AppLocalizations.of(context)?.survey ?? 'Survey'),
//             Tab(text: AppLocalizations.of(context)?.anunce ?? 'Announcement'),
//             Tab(text: AppLocalizations.of(context)?.review ?? 'Review'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Survey Tab
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(AppLocalizations.of(context)?.createsurvey ?? 'Create Survey', style: Theme.of(context).textTheme.titleLarge),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _surveyTitleController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.surveytitle ?? 'Survey Title',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _surveyQuestionController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.entersurveyquestion ?? 'Enter Survey Question',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: _surveyOptionController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.entersurveyoption ?? 'Enter Survey Option',
//                           border: OutlineInputBorder(),
//                         ),
//                         onSubmitted: (value) {
//                           if (_surveyOptionController.text.isNotEmpty) {
//                             setState(() {
//                               _surveyOptions.add(_surveyOptionController.text);
//                               _surveyOptionController.clear();
//                             });
//                           }
//                         },
//                       ),
//                       SizedBox(height: 8),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_surveyOptionController.text.isNotEmpty) {
//                             setState(() {
//                               _surveyOptions.add(_surveyOptionController.text);
//                               _surveyOptionController.clear();
//                             });
//                           }
//                         },
//                         child: Text(AppLocalizations.of(context)?.addoption ?? 'Add Option'),
//                       ),
//                       SizedBox(height: 16),
//                       if (_surveyOptions.isNotEmpty)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: _surveyOptions.map((option) => Text(option)).toList(),
//                         ),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_surveyQuestionController.text.isNotEmpty && _surveyOptions.isNotEmpty) {
//                             setState(() {
//                               _questions.add({
//                                 'question': _surveyQuestionController.text,
//                                 'options': List.from(_surveyOptions),
//                               });
//                               _surveyQuestionController.clear();
//                               _surveyOptions.clear();
//                             });
//                           }
//                         },
//                         child: Text(AppLocalizations.of(context)?.addquestion ?? 'Add Question'),
//                       ),
//                       SizedBox(height: 16),
//                       // Submit Survey button
//                       ElevatedButton(
//                         onPressed: _submitSurvey,
//                         child: Text(AppLocalizations.of(context)?.sub ?? 'Submit'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Announcement Tab
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(AppLocalizations.of(context)?.createpublicannouncement ?? 'Create Public Announcement', style: Theme.of(context).textTheme.titleLarge),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _announcementTitleController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.title ?? 'Title',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: _announcementDescriptionController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.description ?? 'Description',
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 3,
//                       ),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: _announcementSchemeController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.scheme ?? 'Scheme',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: _announcementRegistrationLinkController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.registrationlink ?? 'Registration Link',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: _announcementInstructionsController,
//                         decoration: InputDecoration(
//                           labelText: AppLocalizations.of(context)?.instruction ?? 'Instruction',
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 3,
//                       ),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _submitAnnouncement,
//                         child: Text(AppLocalizations.of(context)?.submitannouncement ?? 'Submit Announcement'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Review Survey Tab
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(AppLocalizations.of(context)?.reviewsurvey ?? 'Review Survey', style: Theme.of(context).textTheme.titleLarge),
//                   SizedBox(height: 16),
//                   if (_surveyResponsesList.isNotEmpty)
//                     ..._surveyResponsesList.map((response) {
//                       return Card(
//                         elevation: 4,
//                         margin: EdgeInsets.only(bottom: 16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Survey ID: ${response['surveyId']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                               Text('User: ${response['userName']} (${response['userEmail']})', style: TextStyle(fontSize: 14)),
//                               Text('Timestamp: ${response['timestamp'].toDate()}', style: TextStyle(fontSize: 14)),
//                               SizedBox(height: 8),
//                               Text('Responses:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                               ...response['responses'].entries.map<Widget>((entry) {
//                                 return Text('${entry.key}: ${entry.value}', style: TextStyle(fontSize: 14));
//                               }).toList(),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList()
//                   else
//                     Center(child: Text(AppLocalizations.of(context)?.no ?? 'No responses')),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';

class PoliceEngagementScreen extends StatefulWidget {
  @override
  _PoliceEngagementScreenState createState() => _PoliceEngagementScreenState();
}

class _PoliceEngagementScreenState extends State<PoliceEngagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Survey creation controllers
  TextEditingController _surveyTitleController = TextEditingController();
  TextEditingController _surveyQuestionController = TextEditingController();
  TextEditingController _surveyOptionController = TextEditingController();
  List<Map<String, dynamic>> _questions = [];
  List<String> _surveyOptions = [];

  // Announcement creation controllers
  TextEditingController _announcementTitleController = TextEditingController();
  TextEditingController _announcementDescriptionController =
  TextEditingController();
  TextEditingController _announcementSchemeController =
  TextEditingController();
  TextEditingController _announcementRegistrationLinkController =
  TextEditingController();
  TextEditingController _announcementInstructionsController =
  TextEditingController();

  List<Map<String, dynamic>> _surveyResponsesList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchSurveyResponses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _surveyTitleController.dispose();
    _surveyQuestionController.dispose();
    _surveyOptionController.dispose();
    _announcementTitleController.dispose();
    _announcementDescriptionController.dispose();
    _announcementSchemeController.dispose();
    _announcementRegistrationLinkController.dispose();
    _announcementInstructionsController.dispose();
    super.dispose();
  }

  void _fetchSurveyResponses() async {
    final responsesSnapshot =
    await FirebaseFirestore.instance.collection('survey_responses').get();
    setState(() {
      _surveyResponsesList = responsesSnapshot.docs.map((doc) {
        return {
          'surveyId': doc['surveyId'],
          'userEmail': doc['userEmail'] ?? 'N/A',
          'userName': doc['userName'] ?? 'Anonymous',
          'timestamp': doc['timestamp'] ?? FieldValue.serverTimestamp(),
          'responses': doc['responses'] ?? {},
        };
      }).toList();
    });
  }

  void _submitSurvey() {
    if (_surveyTitleController.text.isEmpty || _questions.isEmpty) {
      _showSnackBar(
        AppLocalizations.of(context)?.pleaseentertitle ??
            'Please enter a title and add questions',
        isError: true,
      );
      return;
    }

    FirebaseFirestore.instance.collection('surveys').add({
      'title': _surveyTitleController.text,
      'questions': _questions.map((question) {
        return {
          'question': question['question'],
          'options': question['options'],
        };
      }).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _surveyTitleController.clear();
      _questions.clear();
      _surveyOptions.clear();
    });

    _showSnackBar(
      AppLocalizations.of(context)?.surveycreatedsuccessfully ??
          'Survey created successfully',
      isError: false,
    );
  }

  void _submitAnnouncement() {
    if (_announcementTitleController.text.isEmpty ||
        _announcementDescriptionController.text.isEmpty) {
      _showSnackBar(
        AppLocalizations.of(context)?.plscmpltannouncement ??
            'Please complete the announcement',
        isError: true,
      );
      return;
    }

    FirebaseFirestore.instance.collection('announcements').add({
      'title': _announcementTitleController.text,
      'description': _announcementDescriptionController.text,
      'scheme': _announcementSchemeController.text,
      'registrationLink': _announcementRegistrationLinkController.text,
      'instructions': _announcementInstructionsController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _announcementTitleController.clear();
      _announcementDescriptionController.clear();
      _announcementSchemeController.clear();
      _announcementRegistrationLinkController.clear();
      _announcementInstructionsController.clear();
    });

    _showSnackBar(
      AppLocalizations.of(context)?.announcementcreatedsuccessfully ??
          'Announcement created successfully',
      isError: false,
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.roboto(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Color(0xFFEF4444) : Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSurveyTab(),
                _buildAnnouncementTab(),
                _buildReviewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Engagement',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Create surveys & announcements',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
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
            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF59E0B).withOpacity(0.3),
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
          fontSize: 13,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.poll_outlined, size: 18),
            text: AppLocalizations.of(context)?.survey ?? 'Survey',
          ),
          Tab(
            icon: Icon(Icons.campaign_outlined, size: 18),
            text: AppLocalizations.of(context)?.anunce ?? 'Announcement',
          ),
          Tab(
            icon: Icon(Icons.analytics_outlined, size: 18),
            text: AppLocalizations.of(context)?.review ?? 'Review',
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.poll_rounded,
            title: AppLocalizations.of(context)?.createsurvey ?? 'Create Survey',
            subtitle: 'Build engaging surveys for the community',
            color: Color(0xFF6366F1),
          ),
          SizedBox(height: 20),
          _buildModernTextField(
            controller: _surveyTitleController,
            label: AppLocalizations.of(context)?.surveytitle ?? 'Survey Title',
            icon: Icons.title,
            hint: 'Enter a descriptive title',
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: _surveyQuestionController,
            label: AppLocalizations.of(context)?.entersurveyquestion ??
                'Survey Question',
            icon: Icons.help_outline,
            hint: 'What would you like to ask?',
            maxLines: 2,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: _surveyOptionController,
                  label: AppLocalizations.of(context)?.entersurveyoption ??
                      'Survey Option',
                  icon: Icons.radio_button_unchecked,
                  hint: 'Add an option',
                  onSubmitted: (value) {
                    if (_surveyOptionController.text.isNotEmpty) {
                      setState(() {
                        _surveyOptions.add(_surveyOptionController.text);
                        _surveyOptionController.clear();
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 12),
              _buildIconButton(
                icon: Icons.add_circle,
                color: Color(0xFF6366F1),
                onPressed: () {
                  if (_surveyOptionController.text.isNotEmpty) {
                    setState(() {
                      _surveyOptions.add(_surveyOptionController.text);
                      _surveyOptionController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          if (_surveyOptions.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildOptionsList(),
          ],
          SizedBox(height: 20),
          _buildGradientButton(
            label: AppLocalizations.of(context)?.addquestion ?? 'Add Question',
            icon: Icons.add_box,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            onPressed: () {
              if (_surveyQuestionController.text.isNotEmpty &&
                  _surveyOptions.isNotEmpty) {
                setState(() {
                  _questions.add({
                    'question': _surveyQuestionController.text,
                    'options': List.from(_surveyOptions),
                  });
                  _surveyQuestionController.clear();
                  _surveyOptions.clear();
                });
              }
            },
          ),
          if (_questions.isNotEmpty) ...[
            SizedBox(height: 20),
            _buildQuestionsList(),
          ],
          SizedBox(height: 24),
          _buildGradientButton(
            label: AppLocalizations.of(context)?.sub ?? 'Submit Survey',
            icon: Icons.send_rounded,
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
            ),
            onPressed: _submitSurvey,
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.campaign_rounded,
            title: AppLocalizations.of(context)?.createpublicannouncement ??
                'Create Announcement',
            subtitle: 'Share important updates with the public',
            color: Color(0xFFF59E0B),
          ),
          SizedBox(height: 20),
          _buildModernTextField(
            controller: _announcementTitleController,
            label: AppLocalizations.of(context)?.title ?? 'Title',
            icon: Icons.title,
            hint: 'Announcement title',
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: _announcementDescriptionController,
            label: AppLocalizations.of(context)?.description ?? 'Description',
            icon: Icons.description,
            hint: 'Detailed description',
            maxLines: 4,
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: _announcementSchemeController,
            label: AppLocalizations.of(context)?.scheme ?? 'Scheme',
            icon: Icons.category,
            hint: 'Related scheme or program',
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: _announcementRegistrationLinkController,
            label: AppLocalizations.of(context)?.registrationlink ??
                'Registration Link',
            icon: Icons.link,
            hint: 'https://example.com',
          ),
          SizedBox(height: 16),
          _buildModernTextField(
            controller: _announcementInstructionsController,
            label: AppLocalizations.of(context)?.instruction ?? 'Instructions',
            icon: Icons.list_alt,
            hint: 'Step-by-step instructions',
            maxLines: 4,
          ),
          SizedBox(height: 24),
          _buildGradientButton(
            label: AppLocalizations.of(context)?.submitannouncement ??
                'Submit Announcement',
            icon: Icons.send_rounded,
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
            ),
            onPressed: _submitAnnouncement,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchSurveyResponses();
      },
      color: Color(0xFFF59E0B),
      child: _surveyResponsesList.isEmpty
          ? _buildEmptyReviewState()
          : ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _surveyResponsesList.length,
        itemBuilder: (context, index) {
          final response = _surveyResponsesList[index];
          return _buildResponseCard(response, index);
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    void Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onSubmitted: onSubmitted,
        style: GoogleFonts.roboto(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFF6366F1)),
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
          ),
          hintStyle: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list, size: 18, color: Color(0xFF6366F1)),
              SizedBox(width: 8),
              Text(
                'Options',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ..._surveyOptions.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: Colors.red[400]),
                    onPressed: () {
                      setState(() {
                        _surveyOptions.removeAt(entry.key);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.quiz, size: 20, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text(
              'Added Questions (${_questions.length})',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ..._questions.asMap().entries.map((entry) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF6366F1).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Q${entry.key + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value['question'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                      onPressed: () {
                        setState(() {
                          _questions.removeAt(entry.key);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ...entry.value['options'].asMap().entries.map<Widget>((opt) {
                  return Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.radio_button_unchecked,
                            size: 16, color: Colors.grey[400]),
                        SizedBox(width: 8),
                        Text(
                          opt.value,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResponseCard(Map<String, dynamic> response, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
                      colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        response['userName'] ?? 'Anonymous',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        response['userEmail'] ?? 'N/A',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 12),
            _buildInfoChip(
              icon: Icons.assignment,
              label: 'Survey ID',
              value: response['surveyId'] ?? 'N/A',
            ),
            SizedBox(height: 8),
            _buildInfoChip(
              icon: Icons.access_time,
              label: 'Submitted',
              value: response['timestamp'] != null
                  ? _formatTimestamp(response['timestamp'])
                  : 'N/A',
            ),
            if (response['responses'] != null &&
                (response['responses'] as Map).isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Responses:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              ...((response['responses'] as Map).entries.map((entry) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF59E0B).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xFFF59E0B).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.question_answer,
                        size: 16,
                        color: Color(0xFFF59E0B),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              entry.value.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.roboto(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
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
      return 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildEmptyReviewState() {
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
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF59E0B).withOpacity(0.1),
                    Color(0xFFFBBF24).withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 80,
                color: Color(0xFFF59E0B).withOpacity(0.6),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)?.no ?? 'No Responses Yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Survey responses will appear here',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Pull down to refresh',
            style: GoogleFonts.roboto(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}