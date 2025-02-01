import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  String _incidentDescription = '';
  String _priority = "Low"; // Default priority
  String _status = "Pending"; // Default status
  Position? _currentPosition;
  File? _selectedFile;
  final _imagePicker = ImagePicker();
  final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dgdxa7qqg/image/upload";
  final String cloudinaryPreset = "Judica";

  // Get current user details
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  Future<void> _pickFile() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadFileToCloudinary(File file) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = cloudinaryPreset;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url'];
      } else {
        throw Exception("Failed to upload file to Cloudinary.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
      return null;
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? fileUrl;
      if (_selectedFile != null) {
        fileUrl = await _uploadFileToCloudinary(_selectedFile!);
        if (fileUrl == null) return;
      }

      try {
        // Generate a unique complaint ID using UUID
        String complaintId = Uuid().v4();

        // Add the complaint to Firestore
        await FirebaseFirestore.instance.collection('complaints').doc(complaintId).set({
          'description': _incidentDescription,
          'priority': _priority,
          'status': _status,
          'userName': _currentUser?.displayName ?? "Unknown User",
          'userPhone': _currentUser?.phoneNumber ?? "Unknown",
          'timestamp': FieldValue.serverTimestamp(),
          'location': _currentPosition != null
              ? {
            'latitude': _currentPosition!.latitude,
            'longitude': _currentPosition!.longitude,
          }
              : null,
          'fileUrl': fileUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Complaint submitted successfully!")),
        );

        setState(() {
          _formKey.currentState!.reset();
          _currentPosition = null;
          _selectedFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting complaint: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/ChatBotBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ), Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Incident Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide a description of the incident.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _incidentDescription = value!;
                  },
                ),
                SizedBox(height: 40),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(),
                  ),
                  items: ["Low", "Medium", "High"]
                      .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                  onSaved: (value) {
                    _priority = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: Icon(Icons.location_on),
                  label: Text("Use Current Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (_currentPosition != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Location: Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),SizedBox(height: 20,),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(Icons.attach_file),
                  label: Text("Attach Media/Document"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (_selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("File selected: ${_selectedFile!.path.split('/').last}"),
                  ),
                Spacer(),
                ElevatedButton(
                  onPressed: _submitComplaint,
                  child: Text("Submit Complaint"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),]
      ),
    );
  }
}
