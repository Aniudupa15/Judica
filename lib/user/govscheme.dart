  // import 'package:flutter/material.dart';
  // import 'package:cloud_firestore/cloud_firestore.dart';
  // import 'package:url_launcher/url_launcher.dart';
  // import 'package:firebase_auth/firebase_auth.dart'; // For getting the current user email
  //
  // class GovernmentInfo extends StatelessWidget {
  //   @override
  //   Widget build(BuildContext context) {
  //     return DefaultTabController(
  //       length: 2, // Two tabs: one for surveys, one for announcements
  //       child: Scaffold(
  //         appBar: AppBar(
  //           title: Text("Notifications"),
  //           backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
  //           bottom: TabBar(
  //             tabs: [
  //               Tab(text: "Surveys"),
  //               Tab(text: "Announcements"),
  //             ],
  //           ),
  //         ),
  //         body: TabBarView(
  //           children: [
  //             // Surveys Tab
  //             SurveyTab(),
  //
  //             // Announcements Tab
  //             AnnouncementsTab(),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }
  //
  // class SurveyTab extends StatefulWidget {
  //   @override
  //   _SurveyTabState createState() => _SurveyTabState();
  // }
  //
  // class _SurveyTabState extends State<SurveyTab> {
  //   List<String> answeredSurveyIds = []; // To store answered survey IDs
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     _loadAnsweredSurveys();
  //   }
  //
  //   // Load the list of answered surveys from Firestore
  //   Future<void> _loadAnsweredSurveys() async {
  //     final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
  //     if (userEmail == null) return; // If user is not logged in, return
  //
  //     final surveyResponsesSnapshot = await FirebaseFirestore.instance
  //         .collection('survey_responses')
  //         .where('userEmail', isEqualTo: userEmail)
  //         .get();
  //
  //     setState(() {
  //       answeredSurveyIds = surveyResponsesSnapshot.docs.map((doc) => doc['surveyId'] as String).toList();
  //     });
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //
  //           children: [
  //             Container(
  //               decoration: const BoxDecoration(
  //                 image: DecorationImage(
  //                   image: AssetImage("assets/ChatBotBackground.jpg"),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             // Surveys List
  //             Expanded(
  //               child: StreamBuilder<QuerySnapshot>(
  //                 stream: FirebaseFirestore.instance.collection('surveys').snapshots(),
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Center(child: CircularProgressIndicator());
  //                   }
  //                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //                     return Center(child: Text("No surveys available."));
  //                   }
  //
  //                   final surveys = snapshot.data!.docs.where((survey) {
  //                     // Exclude surveys that the user has already answered
  //                     return !answeredSurveyIds.contains(survey.id);
  //                   }).toList();
  //
  //                   return ListView.builder(
  //                     itemCount: surveys.length,
  //                     itemBuilder: (context, index) {
  //                       final survey = surveys[index];
  //                       return Card(
  //                         elevation: 3,
  //                         child: ListTile(
  //                           title: Text(
  //                             survey['title'] ?? "Untitled Survey",
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                           trailing: Icon(Icons.check_circle_outline),
  //                           onTap: () {
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => SurveyPage(survey: survey),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }
  //
  // class SurveyPage extends StatefulWidget {
  //   final QueryDocumentSnapshot survey;
  //
  //   SurveyPage({required this.survey});
  //
  //   @override
  //   _SurveyPageState createState() => _SurveyPageState();
  // }
  //
  // class _SurveyPageState extends State<SurveyPage> {
  //   final _responses = <String, String>{}; // Store responses
  //   bool _hasAnswered = false;
  //   String? _userName; // Store the user's name
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     _checkIfAnswered();
  //     _loadUserName();
  //   }
  //
  //   // Load the user's name from Firestore based on their email
  //   Future<void> _loadUserName() async {
  //     final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
  //     if (userEmail == null) return; // If user is not logged in, return
  //
  //     final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);
  //     final userSnapshot = await userDoc.get();
  //
  //     if (userSnapshot.exists) {
  //       setState(() {
  //         _userName = userSnapshot['username']; // Assuming the username field exists
  //       });
  //     }
  //   }
  //
  //   // Check if user has already answered the survey
  //   Future<void> _checkIfAnswered() async {
  //     final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
  //     if (userEmail == null) return; // If user is not logged in, return
  //
  //     final surveyResponses = await FirebaseFirestore.instance
  //         .collection('survey_responses')
  //         .where('userEmail', isEqualTo: userEmail)
  //         .where('surveyId', isEqualTo: widget.survey.id)
  //         .get();
  //
  //     if (surveyResponses.docs.isNotEmpty) {
  //       setState(() {
  //         _hasAnswered = true;
  //       });
  //     }
  //   }
  //
  //   // Submit survey responses
  //   Future<void> _submitSurvey() async {
  //     if (_hasAnswered) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have already answered this survey.")));
  //       return;
  //     }
  //
  //     // Ensure userName is not null
  //     if (_userName == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User name not available.")));
  //       return;
  //     }
  //
  //     final userEmail = FirebaseAuth.instance.currentUser?.email; // Get current user email
  //     if (userEmail == null) return; // If user is not logged in, return
  //
  //     // Save responses under the survey title with a subcollection 'responses'
  //     final surveyTitle = widget.survey['title'] ?? 'Untitled Survey';
  //     final surveyDoc = FirebaseFirestore.instance.collection('surveys').doc(widget.survey.id);
  //
  //     // Create or access the subcollection 'responses' under each survey document
  //     final responsesCollection = surveyDoc.collection('responses');
  //
  //     // Use userEmail or UID to ensure unique document IDs for each user's response
  //     final userResponseDoc = responsesCollection.doc(userEmail);
  //
  //     await userResponseDoc.set({
  //       'userEmail': userEmail,
  //       'userName': _userName,
  //       'responses': _responses,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //
  //     // Set hasAnswered to true so they can't submit again
  //     setState(() {
  //       _hasAnswered = true;
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Survey submitted successfully")));
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text(widget.survey['title'] ?? "Survey Details"),
  //         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
  //       ),
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               widget.survey['title'] ?? "Untitled Survey",
  //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 16),
  //             if (_hasAnswered)
  //               Text("You have already answered this survey.", style: TextStyle(color: Colors.red)),
  //             if (!_hasAnswered)
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: List.generate(
  //                   widget.survey['questions'].length,
  //                       (index) {
  //                     final question = widget.survey['questions'][index];
  //                     return Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(question['question'], style: TextStyle(fontSize: 18)),
  //                         ...List.generate(
  //                           question['options'].length,
  //                               (optionIndex) {
  //                             final option = question['options'][optionIndex];
  //                             return RadioListTile<String>(
  //                               value: option,
  //                               groupValue: _responses[question['question']],
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   _responses[question['question']] = value!;
  //                                 });
  //                               },
  //                               title: Text(option),
  //                             );
  //                           },
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ),
  //             SizedBox(height: 16),
  //             if (!_hasAnswered)
  //               ElevatedButton(
  //                 onPressed: _submitSurvey,
  //                 child: Text("Submit Survey"),
  //               ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }
  //
  // class AnnouncementsTab extends StatelessWidget {
  //   @override
  //   Widget build(BuildContext context) {
  //     return Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: StreamBuilder<QuerySnapshot>(
  //               stream: FirebaseFirestore.instance.collection('announcements').snapshots(),
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return Center(child: CircularProgressIndicator());
  //                 }
  //                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //                   return Center(child: Text("No announcements available."));
  //                 }
  //
  //                 final announcements = snapshot.data!.docs;
  //
  //                 return ListView.builder(
  //                   itemCount: announcements.length,
  //                   itemBuilder: (context, index) {
  //                     final announcement = announcements[index];
  //                     return Card(
  //                       elevation: 3,
  //                       child: ListTile(
  //                         title: Text(
  //                           announcement['title'] ?? "Untitled Announcement",
  //                           style: TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                         subtitle: Text(announcement['description'] ?? ""),
  //                         trailing: Icon(Icons.arrow_forward_ios),
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => AnnouncementDetailsPage(announcement: announcement),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     );
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
  //
  // class AnnouncementDetailsPage extends StatelessWidget {
  //   final QueryDocumentSnapshot announcement;
  //
  //   AnnouncementDetailsPage({required this.announcement});
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text(announcement['title'] ?? "Announcement Details"),
  //         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
  //       ),
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               announcement['title'] ?? "Untitled Scheme",
  //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 16),
  //             Text(
  //               announcement['description'] ?? "Description not available.",
  //               style: TextStyle(fontSize: 16),
  //               textAlign: TextAlign.justify,
  //             ),
  //             SizedBox(height: 16),
  //             Text(
  //               "Instructions:",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 8),
  //             Text(
  //               announcement['instructions'] ?? "No instructions available.",
  //               style: TextStyle(fontSize: 16),
  //               textAlign: TextAlign.justify,
  //             ),
  //             SizedBox(height: 16),
  //             if (announcement['registrationLink'] != null && announcement['registrationLink'].isNotEmpty)
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   final url = announcement['registrationLink'];
  //                   if (await canLaunch(url)) {
  //                     await launch(url);
  //                   } else {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text("Unable to open registration link.")),
  //                     );
  //                   }
  //                 },
  //                 child: Text("Register for Scheme"),
  //               ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }
  
  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
  
  // Define a common primary color for consistency
  const Color _primaryColor = Color.fromRGBO(255, 165, 89, 1);
  const Color _accentColor = Color.fromARGB(255, 10, 106, 172); // A complementary blue
  
  class GovernmentInfo extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 2, // Two tabs: one for surveys, one for announcements
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Notifications",
            ),
            backgroundColor: _primaryColor,
            elevation: 4,
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.roboto(),
              tabs: const [
                Tab(text: "Surveys"),
                Tab(text: "Announcements"),
              ],
            ),
          ),
          body: const TabBarView(
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
  
  // -----------------------------------------------------
  // --- SURVEY TAB IMPLEMENTATION ---
  // -----------------------------------------------------
  
  class SurveyTab extends StatefulWidget {
    const SurveyTab({super.key});
  
    @override
    _SurveyTabState createState() => _SurveyTabState();
  }
  
  class _SurveyTabState extends State<SurveyTab> {
    List<String> answeredSurveyIds = [];
  
    @override
    void initState() {
      super.initState();
      _loadAnsweredSurveys();
    }
  
    // Load the list of answered surveys from Firestore
    Future<void> _loadAnsweredSurveys() async {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) return;
  
      final surveyResponsesSnapshot = await FirebaseFirestore.instance
          .collection('survey_responses')
          .where('userEmail', isEqualTo: userEmail)
          .get();
  
      if (mounted) {
        setState(() {
          answeredSurveyIds = surveyResponsesSnapshot.docs.map((doc) => doc['surveyId'] as String).toList();
        });
      }
    }
  
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('surveys').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No surveys available.",
                style: GoogleFonts.roboto(color: Colors.grey.shade600),
              ),
            );
          }
  
          final allSurveys = snapshot.data!.docs;
          final pendingSurveys = allSurveys.where((survey) {
            // Exclude surveys that the user has already answered
            return !answeredSurveyIds.contains(survey.id);
          }).toList();
  
          final answeredSurveys = allSurveys.where((survey) {
            return answeredSurveyIds.contains(survey.id);
          }).toList();
  
          // Combine lists to show pending first, then answered
          final surveysToShow = [...pendingSurveys, ...answeredSurveys];
  
          if (surveysToShow.isEmpty) {
            return Center(
              child: Text(
                "All available surveys have been answered. 🎉",
                style: GoogleFonts.roboto(color: Colors.green.shade700),
              ),
            );
          }
  
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: surveysToShow.length,
            itemBuilder: (context, index) {
              final survey = surveysToShow[index];
              final isAnswered = answeredSurveyIds.contains(survey.id);
  
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  tileColor: isAnswered ? Colors.green.shade50 : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    survey['title'] ?? "Untitled Survey",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: isAnswered ? Colors.green.shade800 : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    isAnswered ? "Completed" : "Tap to participate",
                    style: GoogleFonts.roboto(
                      color: isAnswered ? Colors.green : Colors.grey.shade600,
                      fontStyle: isAnswered ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  trailing: isAnswered
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                      : const Icon(Icons.arrow_forward_ios, color: _primaryColor, size: 20),
                  onTap: () {
                    if (!isAnswered) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveyPage(survey: survey),
                        ),
                      ).then((value) {
                        // Reload state when returning to this page
                        _loadAnsweredSurveys();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You have already completed this survey.")),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      );
    }
  }
  
  // -----------------------------------------------------
  // --- SURVEY PAGE IMPLEMENTATION ---
  // -----------------------------------------------------
  
  class SurveyPage extends StatefulWidget {
    final QueryDocumentSnapshot survey;
  
    const SurveyPage({super.key, required this.survey});
  
    @override
    _SurveyPageState createState() => _SurveyPageState();
  }
  
  class _SurveyPageState extends State<SurveyPage> {
    final _responses = <String, String>{}; // Store responses: {question: selected_option}
    bool _hasAnswered = false;
    String? _userName;
  
    @override
    void initState() {
      super.initState();
      _checkIfAnswered();
      _loadUserData();
    }
  
    // Load the user's name and check if they've answered
    Future<void> _loadUserData() async {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) return;
  
      // Load user name
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
      if (userSnapshot.exists && userSnapshot.data()!.containsKey('username')) {
        setState(() {
          _userName = userSnapshot['username'];
        });
      } else {
        // Fallback to email prefix if username is not found
        _userName = userEmail.split('@').first;
      }
  
      // Check if answered (redundant with the check in SurveyTab, but good practice here)
      final surveyResponses = await FirebaseFirestore.instance
          .collection('survey_responses') // Assuming a top-level collection for tracking
          .where('userEmail', isEqualTo: userEmail)
          .where('surveyId', isEqualTo: widget.survey.id)
          .get();
  
      if (mounted && surveyResponses.docs.isNotEmpty) {
        setState(() {
          _hasAnswered = true;
        });
      }
    }
  
    // Re-run the check as a simplified method
    Future<void> _checkIfAnswered() async {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) return;
  
      // Look for response in the top-level collection used for filtering
      final surveyResponses = await FirebaseFirestore.instance
          .collection('survey_responses')
          .where('userEmail', isEqualTo: userEmail)
          .where('surveyId', isEqualTo: widget.survey.id)
          .get();
  
      if (mounted && surveyResponses.docs.isNotEmpty) {
        setState(() {
          _hasAnswered = true;
        });
      }
    }
  
  
    // Submit survey responses
    Future<void> _submitSurvey() async {
      if (_hasAnswered) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have already answered this survey.")));
        return;
      }
  
      final questions = widget.survey['questions'] as List<dynamic>;
  
      // Validation: Check if all questions have been answered
      if (_responses.length != questions.length) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please answer all questions before submitting."), backgroundColor: Colors.red));
        return;
      }
  
      // Ensure user data is available
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null || _userName == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User details are missing. Please log in again."), backgroundColor: Colors.red));
        return;
      }
  
      try {
        // 1. Save response to the survey's subcollection
        final surveyDoc = FirebaseFirestore.instance.collection('surveys').doc(widget.survey.id);
        await surveyDoc.collection('responses').doc(userEmail).set({
          'userEmail': userEmail,
          'userName': _userName,
          'responses': _responses,
          'timestamp': FieldValue.serverTimestamp(),
        });
  
        // 2. Save a record to the top-level survey_responses collection for tracking/filtering
        await FirebaseFirestore.instance.collection('survey_responses').add({
          'surveyId': widget.survey.id,
          'userEmail': userEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });
  
  
        // Update UI state and notify user
        if (mounted) {
          setState(() {
            _hasAnswered = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Survey submitted successfully! Thank you."), backgroundColor: Colors.green),
          );
        }
        // Navigate back after successful submission
        Navigator.pop(context);
  
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error submitting survey: ${e.toString()}"), backgroundColor: Colors.red),
          );
        }
      }
    }
  
    @override
    Widget build(BuildContext context) {
      final questions = widget.survey['questions'] as List<dynamic>? ?? [];
  
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.survey['title'] ?? "Survey Details",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: _primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Opinion Matters",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                widget.survey['title'] ?? "Untitled Survey",
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 30),
  
              if (_hasAnswered)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: [
                        const Icon(Icons.sentiment_satisfied_alt, color: Colors.green, size: 60),
                        const SizedBox(height: 10),
                        Text(
                          "Thank you! You have already answered this survey.",
                          style: GoogleFonts.roboto(fontSize: 18, color: Colors.green.shade700, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
  
              if (!_hasAnswered)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    questions.length,
                        (index) {
                      final question = questions[index];
                      final questionText = question['question'] as String;
                      final options = question['options'] as List<dynamic>? ?? [];
  
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. $questionText",
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: _accentColor),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              options.length,
                                  (optionIndex) {
                                final option = options[optionIndex] as String;
                                return RadioListTile<String>(
                                  value: option,
                                  groupValue: _responses[questionText],
                                  onChanged: (value) {
                                    setState(() {
                                      _responses[questionText] = value!;
                                    });
                                  },
                                  title: Text(option, style: GoogleFonts.roboto(fontSize: 16)),
                                  activeColor: _primaryColor,
                                );
                              },
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
  
              const SizedBox(height: 30),
              if (!_hasAnswered)
                Center(
                  child: ElevatedButton(
                    onPressed: _submitSurvey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Submit Survey",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    }
  }
  
  // -----------------------------------------------------
  // --- ANNOUNCEMENTS TAB IMPLEMENTATION ---
  // -----------------------------------------------------
  
  class AnnouncementsTab extends StatelessWidget {
    const AnnouncementsTab({super.key});
  
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('announcements').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No new announcements.",
                style: GoogleFonts.roboto(color: Colors.grey.shade600),
              ),
            );
          }
  
          final announcements = snapshot.data!.docs;
  
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              final timestamp = (announcement['timestamp'] as Timestamp?)?.toDate();
  
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.campaign, color: _accentColor, size: 30),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    announcement['title'] ?? "Untitled Announcement",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement['description'] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(color: Colors.grey.shade700),
                      ),
                      if (timestamp != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Posted: ${timestamp.day}/${timestamp.month}/${timestamp.year}",
                            style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: _primaryColor, size: 20),
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
      );
    }
  }
  
  // -----------------------------------------------------
  // --- ANNOUNCEMENT DETAILS PAGE IMPLEMENTATION ---
  // -----------------------------------------------------
  
  class AnnouncementDetailsPage extends StatelessWidget {
    final QueryDocumentSnapshot announcement;
  
    const AnnouncementDetailsPage({super.key, required this.announcement});
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            announcement['title'] ?? "Announcement Details",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: _primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement['title'] ?? "Untitled Scheme",
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 30),
  
              // Description
              Text(
                "Overview:",
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: _accentColor),
              ),
              const SizedBox(height: 8),
              Text(
                announcement['description'] ?? "Description not available.",
                style: GoogleFonts.roboto(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
  
              // Instructions
              Text(
                "Instructions:",
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: _accentColor),
              ),
              const SizedBox(height: 8),
              Text(
                announcement['instructions'] ?? "No instructions available.",
                style: GoogleFonts.roboto(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
  
              // Registration Button
              if (announcement['registrationLink'] != null && announcement['registrationLink'].isNotEmpty)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = announcement['registrationLink'];
                      if (url is String && await canLaunch(url)) {
                        await launch(url);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Unable to open registration link.")),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: Text(
                      "View/Register",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }