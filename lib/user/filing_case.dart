import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  String _incidentDescription = '';
  String _priority = "Low";
  String _status = "Pending";
  Position? _currentPosition;
  File? _selectedFile;
  final _imagePicker = ImagePicker();
  final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dgdxa7qqg/image/upload";
  final String cloudinaryPreset = "Judica";
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable them in settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // First check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location services are disabled. Please enable them in your device settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Request permission explicitly
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission denied. Please enable it in your app settings.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission permanently denied. Please enable it in your app settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Show loading indicator
      setState(() {
        _isLoadingLocation = true;
      });

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).whenComplete(() {
        setState(() {
          _isLoadingLocation = false;
        });
      });

      setState(() {
        _currentPosition = position;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location fetched successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
        throw Exception("Failed to upload file");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
      }
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
        String complaintId = const Uuid().v4();

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
            'longitude': _currentPosition!.longitude
          }
              : null,
          'fileUrl': fileUrl,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Complaint submitted successfully!")),
          );
        }

        setState(() {
          _formKey.currentState!.reset();
          _currentPosition = null;
          _selectedFile = null;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error submitting complaint: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ChatBotBackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Incident Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) =>
                      value == null || value.isEmpty ? "Please provide a description." : null,
                      onSaved: (value) => _incidentDescription = value!,
                    ),
                    const SizedBox(height: 40),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: const InputDecoration(
                        labelText: "Priority",
                        border: OutlineInputBorder(),
                      ),
                      items: ["Low", "Medium", "High"]
                          .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => _priority = value!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                      icon: _isLoadingLocation
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.location_on),
                      label: Text(_isLoadingLocation ? "Getting Location..." : "Use Current Location"),
                    ),
                    if (_currentPosition != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}",
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: const Text("Attach Media"),
                    ),
                    if (_selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("File selected: ${_selectedFile!.path.split('/').last}"),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitComplaint,
                      child: const Text("Submit Complaint"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}