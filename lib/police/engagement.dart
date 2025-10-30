import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class PoliceEngagementScreen extends StatefulWidget {
  @override
  _PoliceEngagementScreenState createState() => _PoliceEngagementScreenState();
}

class _PoliceEngagementScreenState extends State<PoliceEngagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Survey creation controllers
  TextEditingController _surveyTitleController = TextEditingController();
  TextEditingController _surveyQuestionController = TextEditingController();
  TextEditingController _surveyOptionController = TextEditingController();
  List<Map<String, dynamic>> _questions = [];
  List<String> _surveyOptions = [];

  // Announcement creation controllers
  TextEditingController _announcementTitleController = TextEditingController();
  TextEditingController _announcementDescriptionController = TextEditingController();
  TextEditingController _announcementSchemeController = TextEditingController();
  TextEditingController _announcementRegistrationLinkController = TextEditingController();
  TextEditingController _announcementInstructionsController = TextEditingController();

  // To hold the created surveys list from Firestore

  // To hold the survey responses list from Firestore
  List<Map<String, dynamic>> _surveyResponsesList = [];

  // Fetch created surveys from Firestore
  void _fetchSurveys() async {
    await FirebaseFirestore.instance.collection('surveys').get();
    setState(() {
    });
  }

  // Fetch survey responses from Firestore
  void _fetchSurveyResponses() async {
    final responsesSnapshot = await FirebaseFirestore.instance.collection('survey_responses').get();
    setState(() {
      _surveyResponsesList = responsesSnapshot.docs.map((doc) {
        return {
          'surveyId': doc['surveyId'],
          'userEmail': doc['userEmail'] ?? 'N/A', // Handling null value for email
          'userName': doc['userName'] ?? 'Anonymous', // Handling null value for name
          'timestamp': doc['timestamp'] ?? FieldValue.serverTimestamp(), // Handling null timestamp
          'responses': doc['responses'] ?? {}, // Null safe responses
        };
      }).toList();
    });
  }

  // Submit Survey with Multiple Questions and Options
  void _submitSurvey() {
    if (_surveyTitleController.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.pleaseentertitle ?? 'Please enter a title')));
      return;
    }

    // Save survey to Firebase
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.surveycreatedsuccessfully ?? 'Survey created successfully')));
  }

  // Submit Public Announcement
  void _submitAnnouncement() {
    if (_announcementTitleController.text.isEmpty ||
        _announcementDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.plscmpltannouncement ?? 'Please complete the announcement')));
      return;
    }

    // Save announcement to Firebase
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.announcementcreatedsuccessfully ?? 'Announcement created successfully')));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchSurveys(); // Fetch surveys on page load
    _fetchSurveyResponses(); // Fetch survey responses on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:null,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)?.survey ?? 'Survey'),
            Tab(text: AppLocalizations.of(context)?.anunce ?? 'Announcement'),
            Tab(text: AppLocalizations.of(context)?.review ?? 'Review'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Survey Tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)?.createsurvey ?? 'Create Survey', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 16),
                      TextField(
                        controller: _surveyTitleController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.surveytitle ?? 'Survey Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _surveyQuestionController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.entersurveyquestion ?? 'Enter Survey Question',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _surveyOptionController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.entersurveyoption ?? 'Enter Survey Option',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (_surveyOptionController.text.isNotEmpty) {
                            setState(() {
                              _surveyOptions.add(_surveyOptionController.text);
                              _surveyOptionController.clear();
                            });
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_surveyOptionController.text.isNotEmpty) {
                            setState(() {
                              _surveyOptions.add(_surveyOptionController.text);
                              _surveyOptionController.clear();
                            });
                          }
                        },
                        child: Text(AppLocalizations.of(context)?.addoption ?? 'Add Option'),
                      ),
                      SizedBox(height: 16),
                      if (_surveyOptions.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _surveyOptions.map((option) => Text(option)).toList(),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_surveyQuestionController.text.isNotEmpty && _surveyOptions.isNotEmpty) {
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
                        child: Text(AppLocalizations.of(context)?.addquestion ?? 'Add Question'),
                      ),
                      SizedBox(height: 16),
                      // Submit Survey button
                      ElevatedButton(
                        onPressed: _submitSurvey,
                        child: Text(AppLocalizations.of(context)?.sub ?? 'Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Announcement Tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)?.createpublicannouncement ?? 'Create Public Announcement', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 16),
                      TextField(
                        controller: _announcementTitleController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.title ?? 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _announcementDescriptionController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.description ?? 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _announcementSchemeController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.scheme ?? 'Scheme',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _announcementRegistrationLinkController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.registrationlink ?? 'Registration Link',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _announcementInstructionsController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.instruction ?? 'Instruction',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitAnnouncement,
                        child: Text(AppLocalizations.of(context)?.submitannouncement ?? 'Submit Announcement'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Review Survey Tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)?.reviewsurvey ?? 'Review Survey', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 16),
                  if (_surveyResponsesList.isNotEmpty)
                    ..._surveyResponsesList.map((response) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Survey ID: ${response['surveyId']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('User: ${response['userName']} (${response['userEmail']})', style: TextStyle(fontSize: 14)),
                              Text('Timestamp: ${response['timestamp'].toDate()}', style: TextStyle(fontSize: 14)),
                              SizedBox(height: 8),
                              Text('Responses:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ...response['responses'].entries.map<Widget>((entry) {
                                return Text('${entry.key}: ${entry.value}', style: TextStyle(fontSize: 14));
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                  else
                    Center(child: Text(AppLocalizations.of(context)?.no ?? 'No responses')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
