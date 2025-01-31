import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For getting the current user email

class GovernmentInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: one for surveys, one for announcements
      child: Scaffold(
        appBar: AppBar(
          title: Text("Government Schemes & Legal Rights"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Surveys"),
              Tab(text: "Announcements"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Surveys Tab
            SurveyTab(),

            // Announcements Tab
            AnnouncementsTab(),
          ],
        ),
      ),
    );
  }
}

class SurveyTab extends StatefulWidget {
  @override
  _SurveyTabState createState() => _SurveyTabState();
}

class _SurveyTabState extends State<SurveyTab> {
  List<String> answeredSurveyIds = []; // To store answered survey IDs

  @override
  void initState() {
    super.initState();
    _loadAnsweredSurveys();
  }

  // Load the list of answered surveys from Firestore
  Future<void> _loadAnsweredSurveys() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
    if (userEmail == null) return; // If user is not logged in, return

    final surveyResponsesSnapshot = await FirebaseFirestore.instance
        .collection('survey_responses')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    setState(() {
      answeredSurveyIds = surveyResponsesSnapshot.docs.map((doc) => doc['surveyId'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Surveys List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('surveys').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No surveys available."));
                }

                final surveys = snapshot.data!.docs.where((survey) {
                  // Exclude surveys that the user has already answered
                  return !answeredSurveyIds.contains(survey.id);
                }).toList();

                return ListView.builder(
                  itemCount: surveys.length,
                  itemBuilder: (context, index) {
                    final survey = surveys[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          survey['title'] ?? "Untitled Survey",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.check_circle_outline),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurveyPage(survey: survey),
                            ),
                          );
                        },
                      ),
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
}

class SurveyPage extends StatefulWidget {
  final QueryDocumentSnapshot survey;

  SurveyPage({required this.survey});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _responses = <String, String>{}; // Store responses
  bool _hasAnswered = false;
  String? _userName; // Store the user's name

  @override
  void initState() {
    super.initState();
    _checkIfAnswered();
    _loadUserName();
  }

  // Load the user's name from Firestore based on their email
  Future<void> _loadUserName() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
    if (userEmail == null) return; // If user is not logged in, return

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      setState(() {
        _userName = userSnapshot['username']; // Assuming the username field exists
      });
    }
  }

  // Check if user has already answered the survey
  Future<void> _checkIfAnswered() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
    if (userEmail == null) return; // If user is not logged in, return

    final surveyResponses = await FirebaseFirestore.instance
        .collection('survey_responses')
        .where('userEmail', isEqualTo: userEmail)
        .where('surveyId', isEqualTo: widget.survey.id)
        .get();

    if (surveyResponses.docs.isNotEmpty) {
      setState(() {
        _hasAnswered = true;
      });
    }
  }

  // Submit survey responses
  Future<void> _submitSurvey() async {
    if (_hasAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have already answered this survey.")));
      return;
    }

    // Ensure userName is not null
    if (_userName == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User name not available.")));
      return;
    }

    final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
    if (userEmail == null) return; // If user is not logged in, return

    // Save responses under the survey title with a subcollection 'responses'
    final surveyTitle = widget.survey['title'] ?? 'Untitled Survey';
    final surveyDoc = FirebaseFirestore.instance.collection('surveys').doc(widget.survey.id);

    // Create or access the subcollection 'responses' under each survey document
    final responsesCollection = surveyDoc.collection('responses');

    // Use userEmail or UID to ensure unique document IDs for each user's response
    final userResponseDoc = responsesCollection.doc(userEmail);

    await userResponseDoc.set({
      'userEmail': userEmail,
      'userName': _userName,
      'responses': _responses,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Set hasAnswered to true so they can't submit again
    setState(() {
      _hasAnswered = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Survey submitted successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey['title'] ?? "Survey Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.survey['title'] ?? "Untitled Survey",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (_hasAnswered)
              Text("You have already answered this survey.", style: TextStyle(color: Colors.red)),
            if (!_hasAnswered)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.survey['questions'].length,
                      (index) {
                    final question = widget.survey['questions'][index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question['question'], style: TextStyle(fontSize: 18)),
                        ...List.generate(
                          question['options'].length,
                              (optionIndex) {
                            final option = question['options'][optionIndex];
                            return RadioListTile<String>(
                              value: option,
                              groupValue: _responses[question['question']],
                              onChanged: (value) {
                                setState(() {
                                  _responses[question['question']] = value!;
                                });
                              },
                              title: Text(option),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            if (!_hasAnswered)
              ElevatedButton(
                onPressed: _submitSurvey,
                child: Text("Submit Survey"),
              ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('announcements').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No announcements available."));
                }

                final announcements = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          announcement['title'] ?? "Untitled Announcement",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(announcement['description'] ?? ""),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnnouncementDetailsPage(announcement: announcement),
                            ),
                          );
                        },
                      ),
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
}

class AnnouncementDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot announcement;

  AnnouncementDetailsPage({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(announcement['title'] ?? "Announcement Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement['title'] ?? "Untitled Scheme",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              announcement['description'] ?? "Description not available.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              "Instructions:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              announcement['instructions'] ?? "No instructions available.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            if (announcement['registrationLink'] != null && announcement['registrationLink'].isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  final url = announcement['registrationLink'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Unable to open registration link.")),
                    );
                  }
                },
                child: Text("Register for Scheme"),
              ),
          ],
        ),
      ),
    );
  }
}
