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
      ),
      home: PoliceEngagementScreen(),
    );
  }
}

class PoliceEngagementScreen extends StatefulWidget {
  @override
  _PoliceEngagementScreenState createState() => _PoliceEngagementScreenState();
}

class _PoliceEngagementScreenState extends State<PoliceEngagementScreen> {
  int _selectedIndex = 0;

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

  // Fetch survey responses
  Future<List<Map<String, dynamic>>> _fetchSurveyResponses(String surveyId) async {
    try {
      final responsesSnapshot = await FirebaseFirestore.instance
          .collection('surveys')
          .doc(surveyId)
          .collection('survey-responses')
          .get();
      return responsesSnapshot.docs.map((doc) {
        return {
          'userId': doc['userId'],
          'responses': List<Map<String, dynamic>>.from(doc['responses']),
        };
      }).toList();
    } catch (e) {
      print('Error fetching responses: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSurveys(); // Fetch surveys on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Police Community Engagement'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Survey Tab
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedIndex == 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Create Survey Section
                      Text('Create Survey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      TextField(
                        controller: _surveyTitleController,
                        decoration: InputDecoration(labelText: 'Survey Title'),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _surveyQuestionController,
                        decoration: InputDecoration(labelText: 'Enter Survey Question'),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _surveyOptionController,
                        decoration: InputDecoration(labelText: 'Enter Survey Option'),
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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1; // Switch to the review screen
                          });
                        },
                        child: Text('Review Survey'),
                      ),
                    ],
                  ),
                ),
              if (_selectedIndex == 1)
              // Review Survey Section (Displays all questions and options)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Review Your Survey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      if (_questions.isNotEmpty)
                        ..._questions.map((question) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(question['question'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              ...question['options'].map<Widget>((option) {
                                return Text(option);
                              }).toList(),
                              SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitSurvey,
                        child: Text('Submit Survey'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0; // Switch back to create survey screen
                          });
                        },
                        child: Text('Edit Survey'),
                      ),
                      // Show Responses Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewSurveyResponsesScreen(surveyId: _surveysList[0]['id']),
                            ),
                          );
                        },
                        child: Text('Show Responses'),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Announcement Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Public Announcement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: _announcementTitleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _announcementDescriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _announcementSchemeController,
                  decoration: InputDecoration(labelText: 'Scheme (if applicable)'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _announcementRegistrationLinkController,
                  decoration: InputDecoration(labelText: 'Registration Link (if any)'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _announcementInstructionsController,
                  decoration: InputDecoration(labelText: 'Instructions'),
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Survey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcement',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// New Screen to Display Survey Responses
class ViewSurveyResponsesScreen extends StatelessWidget {
  final String surveyId;

  ViewSurveyResponsesScreen({required this.surveyId});

  Future<List<Map<String, dynamic>>> _fetchSurveyResponses() async {
    try {
      final responsesSnapshot = await FirebaseFirestore.instance
          .collection('surveys')
          .doc(surveyId)
          .collection('survey-responses')
          .get();
      return responsesSnapshot.docs.map((doc) {
        return {
          'userId': doc['userId'],
          'responses': List<Map<String, dynamic>>.from(doc['responses']),
        };
      }).toList();
    } catch (e) {
      print('Error fetching responses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Survey Responses')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSurveyResponses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No responses yet.'));
          }

          final responses = snapshot.data!;
          return ListView.builder(
            itemCount: responses.length,
            itemBuilder: (context, index) {
              final response = responses[index];
              return Card(
                child: ListTile(
                  title: Text('User: ${response['userId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (response['responses'] as List).map((res) {
                      return Text('${res['questionId']}: ${res['answer']}');
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
