import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:judica/common_pages/slpash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "N/A";
  String email = "N/A";
  String mobileNumber = "N/A";
  String dateOfBirth = "N/A";
  String address = "N/A";
  String? imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _requestPermissions();
  }

  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc.data()?['username'] ?? "N/A";
          email = userDoc.data()?['email'] ?? "N/A";
          mobileNumber = userDoc.data()?['Mobile Number'] ?? "N/A";
          dateOfBirth = userDoc.data()?['Date of Birth'] ?? "N/A";
          address = userDoc.data()?['Address'] ?? "N/A";
          imageUrl = userDoc.data()?['imageUrl'];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> saveUserData(String field, String value) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .update({field: value});

      setState(() {
        if (field == 'username') userName = value;
        if (field == 'email') email = value;
        if (field == 'Mobile Number') mobileNumber = value;
        if (field == 'Date of Birth') dateOfBirth = value;
        if (field == 'Address') address = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error saving user data: $e");
      }
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  void _showEditDialog(String title, String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                saveUserData(field, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 249, 246, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 85,
                    backgroundImage: imageUrl != null ? FileImage(File(imageUrl!)) : null,
                    child: imageUrl == null
                        ? Center(
                      child: Text(
                        AppLocalizations.of(context)?.clicktoupload ?? "Upload Image",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                buildEditableField("Name", userName, "username"),
                const SizedBox(height: 15),
                buildEditableField("Email", email, "email"),
                const SizedBox(height: 15),
                buildEditableField("Mobile Number", mobileNumber, "Mobile Number"),
                const SizedBox(height: 15),
                buildEditableField("Date of Birth", dateOfBirth, "Date of Birth"),
                const SizedBox(height: 15),
                buildEditableField("Address", address, "Address"),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 125, 41, 1),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(AppLocalizations.of(context)?.logout ?? "Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableField(String title, String value, String field) {
    return GestureDetector(
      onTap: () => _showEditDialog(title, field, value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromRGBO(255, 125, 41, 1), width: 2),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Flexible(
              child: Text(value, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
