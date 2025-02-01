import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Police Community Engagement',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      home: PoliceEngagementScreen(),
    );
  }
}

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
  List<Map<String, dynamic>> _surveysList = [];

  // To hold the survey responses list from Firestore
  List<Map<String, dynamic>> _surveyResponsesList = [];

  // Fetch created surveys from Firestore
  void _fetchSurveys() async {
    final surveysSnapshot = await FirebaseFirestore.instance.collection('surveys').get();
    setState(() {
      _surveysList = surveysSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'questions': List<Map<String, dynamic>>.from(doc['questions']),
        };
      }).toList();
    });
  }

  // Fetch survey responses from Firestore
  void _fetchSurveyResponses() async {
    final responsesSnapshot = await FirebaseFirestore.instance.collection('survey_responses').get();

    setState(() {
      _surveyResponsesList = responsesSnapshot.docs.map((doc) {
        return {
          'surveyId': doc['surveyId'],
          'userEmail': doc['userEmail'],
          'userName': doc['userName'],
          'timestamp': doc['timestamp'],
          'responses': doc['responses'], // Keep responses as a Map<String, dynamic>
        };
      }).toList();
    });
  }

  // Submit Survey with Multiple Questions and Options
  void _submitSurvey() {
    if (_surveyTitleController.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter title and questions')));
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Survey created successfully')));
  }

  // Submit Public Announcement
  void _submitAnnouncement() {
    if (_announcementTitleController.text.isEmpty ||
        _announcementDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete the announcement details')));
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Announcement created successfully')));
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
        title: Text('Police Community Engagement'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Survey'),
            Tab(text: 'Announcement'),
            Tab(text: 'Review Surveys'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Survey Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Survey', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16),
                    TextField(
                      controller: _surveyTitleController,
                      decoration: InputDecoration(
                        labelText: 'Survey Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _surveyQuestionController,
                      decoration: InputDecoration(
                        labelText: 'Enter Survey Question',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _surveyOptionController,
                      decoration: InputDecoration(
                        labelText: 'Enter Survey Option',
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
                      child: Text('Add Option'),
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
                      child: Text('Add Question'),
                    ),
                    SizedBox(height: 16),
                    // Submit Survey button
                    ElevatedButton(
                      onPressed: _submitSurvey,
                      child: Text('Submit Survey'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Announcement Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Public Announcement', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16),
                    TextField(
                      controller: _announcementTitleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _announcementDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _announcementSchemeController,
                      decoration: InputDecoration(
                        labelText: 'Scheme (if applicable)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _announcementRegistrationLinkController,
                      decoration: InputDecoration(
                        labelText: 'Registration Link (if any)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _announcementInstructionsController,
                      decoration: InputDecoration(
                        labelText: 'Instructions',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitAnnouncement,
                      child: Text('Submit Announcement'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Review Survey Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Review Survey Responses', style: Theme.of(context).textTheme.titleLarge),
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
                  Center(child: Text('No survey responses available.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
