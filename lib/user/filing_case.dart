// // // import 'package:flutter/material.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'dart:io';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:uuid/uuid.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // //
// // // class ComplaintForm extends StatefulWidget {
// // //   @override
// // //   _ComplaintFormState createState() => _ComplaintFormState();
// // // }
// // //
// // // class _ComplaintFormState extends State<ComplaintForm> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   String _incidentDescription = '';
// // //   String _priority = "Low";
// // //   String _status = "Pending";
// // //   Position? _currentPosition;
// // //   File? _selectedFile;
// // //   final _imagePicker = ImagePicker();
// // //   final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dgdxa7qqg/image/upload";
// // //   final String cloudinaryPreset = "Judica";
// // //   final User? _currentUser = FirebaseAuth.instance.currentUser;
// // //   bool _isLoadingLocation = false;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _checkLocationPermission();
// // //   }
// // //
// // //   Future<void> _checkLocationPermission() async {
// // //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // //     if (!serviceEnabled) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text('Location services are disabled. Please enable them in settings.'),
// // //             duration: Duration(seconds: 3),
// // //           ),
// // //         );
// // //       }
// // //       return;
// // //     }
// // //
// // //     LocationPermission permission = await Geolocator.checkPermission();
// // //     if (permission == LocationPermission.denied) {
// // //       permission = await Geolocator.requestPermission();
// // //       if (permission == LocationPermission.denied) {
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text('Location permissions are denied.'),
// // //               duration: Duration(seconds: 3),
// // //             ),
// // //           );
// // //         }
// // //         return;
// // //       }
// // //     }
// // //
// // //     if (permission == LocationPermission.deniedForever) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text('Location permissions are permanently denied.'),
// // //             duration: Duration(seconds: 3),
// // //           ),
// // //         );
// // //       }
// // //       return;
// // //     }
// // //   }
// // //
// // //   Future<void> _getCurrentLocation() async {
// // //     try {
// // //       // First check if location service is enabled
// // //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // //       if (!serviceEnabled) {
// // //         if (context.mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text('Location services are disabled. Please enable them in your device settings.'),
// // //               duration: Duration(seconds: 3),
// // //             ),
// // //           );
// // //         }
// // //         return;
// // //       }
// // //
// // //       // Request permission explicitly
// // //       LocationPermission permission = await Geolocator.checkPermission();
// // //
// // //       if (permission == LocationPermission.denied) {
// // //         permission = await Geolocator.requestPermission();
// // //
// // //         if (permission == LocationPermission.denied) {
// // //           if (context.mounted) {
// // //             ScaffoldMessenger.of(context).showSnackBar(
// // //               const SnackBar(
// // //                 content: Text('Location permission denied. Please enable it in your app settings.'),
// // //                 duration: Duration(seconds: 3),
// // //               ),
// // //             );
// // //           }
// // //           return;
// // //         }
// // //       }
// // //
// // //       if (permission == LocationPermission.deniedForever) {
// // //         if (context.mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content: Text('Location permission permanently denied. Please enable it in your app settings.'),
// // //               duration: Duration(seconds: 3),
// // //             ),
// // //           );
// // //         }
// // //         return;
// // //       }
// // //
// // //       // Show loading indicator
// // //       setState(() {
// // //         _isLoadingLocation = true;
// // //       });
// // //
// // //       // Get current position with timeout
// // //       Position position = await Geolocator.getCurrentPosition(
// // //         desiredAccuracy: LocationAccuracy.high,
// // //         timeLimit: const Duration(seconds: 10),
// // //       ).whenComplete(() {
// // //         setState(() {
// // //           _isLoadingLocation = false;
// // //         });
// // //       });
// // //
// // //       setState(() {
// // //         _currentPosition = position;
// // //       });
// // //
// // //       if (context.mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text('Location fetched successfully!'),
// // //             duration: Duration(seconds: 2),
// // //           ),
// // //         );
// // //       }
// // //
// // //     } catch (e) {
// // //       setState(() {
// // //         _isLoadingLocation = false;
// // //       });
// // //
// // //       if (context.mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text('Error getting location: ${e.toString()}'),
// // //             duration: const Duration(seconds: 3),
// // //           ),
// // //         );
// // //       }
// // //     }
// // //   }
// // //
// // //   Future<void> _pickFile() async {
// // //     final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
// // //     if (pickedFile != null) {
// // //       setState(() {
// // //         _selectedFile = File(pickedFile.path);
// // //       });
// // //     }
// // //   }
// // //
// // //   Future<String?> _uploadFileToCloudinary(File file) async {
// // //     try {
// // //       final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
// // //       request.fields['upload_preset'] = cloudinaryPreset;
// // //       request.files.add(await http.MultipartFile.fromPath('file', file.path));
// // //
// // //       final response = await request.send();
// // //       if (response.statusCode == 200) {
// // //         final responseData = await response.stream.bytesToString();
// // //         final jsonResponse = json.decode(responseData);
// // //         return jsonResponse['secure_url'];
// // //       } else {
// // //         throw Exception("Failed to upload file");
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text("Error uploading file: $e")),
// // //         );
// // //       }
// // //       return null;
// // //     }
// // //   }
// // //
// // //   Future<void> _submitComplaint() async {
// // //     if (_formKey.currentState!.validate()) {
// // //       _formKey.currentState!.save();
// // //
// // //       String? fileUrl;
// // //       if (_selectedFile != null) {
// // //         fileUrl = await _uploadFileToCloudinary(_selectedFile!);
// // //         if (fileUrl == null) return;
// // //       }
// // //
// // //       try {
// // //         String complaintId = const Uuid().v4();
// // //
// // //         await FirebaseFirestore.instance.collection('complaints').doc(complaintId).set({
// // //           'description': _incidentDescription,
// // //           'priority': _priority,
// // //           'status': _status,
// // //           'userName': _currentUser?.displayName ?? "Unknown User",
// // //           'userPhone': _currentUser?.phoneNumber ?? "Unknown",
// // //           'timestamp': FieldValue.serverTimestamp(),
// // //           'location': _currentPosition != null
// // //               ? {
// // //             'latitude': _currentPosition!.latitude,
// // //             'longitude': _currentPosition!.longitude
// // //           }
// // //               : null,
// // //           'fileUrl': fileUrl,
// // //         });
// // //
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(content: Text("Complaint submitted successfully!")),
// // //           );
// // //         }
// // //
// // //         setState(() {
// // //           _formKey.currentState!.reset();
// // //           _currentPosition = null;
// // //           _selectedFile = null;
// // //         });
// // //       } catch (e) {
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(content: Text("Error submitting complaint: $e")),
// // //           );
// // //         }
// // //       }
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Stack(
// // //         children: [
// // //           Container(
// // //             decoration: const BoxDecoration(
// // //               image: DecorationImage(
// // //                 image: AssetImage("assets/ChatBotBackground.jpg"),
// // //                 fit: BoxFit.cover,
// // //               ),
// // //             ),
// // //           ),
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: SingleChildScrollView(
// // //               child: Form(
// // //                 key: _formKey,
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                   children: [
// // //                     const SizedBox(height: 80),
// // //                     TextFormField(
// // //                       decoration: const InputDecoration(
// // //                         labelText: "Incident Description",
// // //                         border: OutlineInputBorder(),
// // //                       ),
// // //                       maxLines: 4,
// // //                       validator: (value) =>
// // //                       value == null || value.isEmpty ? "Please provide a description." : null,
// // //                       onSaved: (value) => _incidentDescription = value!,
// // //                     ),
// // //                     const SizedBox(height: 40),
// // //                     DropdownButtonFormField<String>(
// // //                       value: _priority,
// // //                       decoration: const InputDecoration(
// // //                         labelText: "Priority",
// // //                         border: OutlineInputBorder(),
// // //                       ),
// // //                       items: ["Low", "Medium", "High"]
// // //                           .map((priority) => DropdownMenuItem(
// // //                         value: priority,
// // //                         child: Text(priority),
// // //                       ))
// // //                           .toList(),
// // //                       onChanged: (value) => setState(() => _priority = value!),
// // //                     ),
// // //                     const SizedBox(height: 20),
// // //                     ElevatedButton.icon(
// // //                       onPressed: _isLoadingLocation ? null : _getCurrentLocation,
// // //                       icon: _isLoadingLocation
// // //                           ? const SizedBox(
// // //                         width: 20,
// // //                         height: 20,
// // //                         child: CircularProgressIndicator(strokeWidth: 2),
// // //                       )
// // //                           : const Icon(Icons.location_on),
// // //                       label: Text(_isLoadingLocation ? "Getting Location..." : "Use Current Location"),
// // //                     ),
// // //                     if (_currentPosition != null)
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
// // //                         child: Text(
// // //                           "Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}",
// // //                         ),
// // //                       ),
// // //                     const SizedBox(height: 20),
// // //                     ElevatedButton.icon(
// // //                       onPressed: _pickFile,
// // //                       icon: const Icon(Icons.attach_file),
// // //                       label: const Text("Attach Media"),
// // //                     ),
// // //                     if (_selectedFile != null)
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
// // //                         child: Text("File selected: ${_selectedFile!.path.split('/').last}"),
// // //                       ),
// // //                     const SizedBox(height: 20),
// // //                     ElevatedButton(
// // //                       onPressed: _submitComplaint,
// // //                       child: const Text("Submit Complaint"),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:uuid/uuid.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:google_fonts/google_fonts.dart'; // Added for professional fonts
// //
// // class ComplaintForm extends StatefulWidget {
// //   @override
// //   _ComplaintFormState createState() => _ComplaintFormState();
// // }
// //
// // class _ComplaintFormState extends State<ComplaintForm> {
// //   final _formKey = GlobalKey<FormState>();
// //   String _incidentDescription = '';
// //   String _priority = "Low";
// //   String _status = "Pending";
// //   Position? _currentPosition;
// //   File? _selectedFile;
// //   final _imagePicker = ImagePicker();
// //   // NOTE: Replace 'dgdxa7qqg' and 'Judica' with your actual Cloudinary details
// //   final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dgdxa7qqg/image/upload";
// //   final String cloudinaryPreset = "Judica";
// //   final User? _currentUser = FirebaseAuth.instance.currentUser;
// //   bool _isLoadingLocation = false;
// //   bool _isSubmitting = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkLocationPermission();
// //   }
// //
// //   // --- Location and Permission Logic (Unchanged but essential) ---
// //
// //   Future<void> _checkLocationPermission() async {
// //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Location services are disabled. Please enable them in settings.'),
// //             duration: Duration(seconds: 3),
// //           ),
// //         );
// //       }
// //       return;
// //     }
// //
// //     LocationPermission permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text('Location permissions are denied.'),
// //               duration: Duration(seconds: 3),
// //             ),
// //           );
// //         }
// //         return;
// //       }
// //     }
// //
// //     if (permission == LocationPermission.deniedForever) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Location permissions are permanently denied.'),
// //             duration: Duration(seconds: 3),
// //           ),
// //         );
// //       }
// //       return;
// //     }
// //   }
// //
// //   Future<void> _getCurrentLocation() async {
// //     // Permission checks are now internal to this function for better flow control
// //     try {
// //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //       if (!serviceEnabled) {
// //         if (context.mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text('Location services are disabled. Please enable them in your device settings.'),
// //               duration: Duration(seconds: 3),
// //             ),
// //           );
// //         }
// //         return;
// //       }
// //
// //       LocationPermission permission = await Geolocator.checkPermission();
// //       if (permission == LocationPermission.denied) {
// //         permission = await Geolocator.requestPermission();
// //         if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
// //           if (context.mounted) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(
// //                 content: Text('Location permission denied. Cannot fetch location.'),
// //                 duration: Duration(seconds: 3),
// //               ),
// //             );
// //           }
// //           return;
// //         }
// //       }
// //
// //       setState(() {
// //         _isLoadingLocation = true;
// //       });
// //
// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //         timeLimit: const Duration(seconds: 10),
// //       ).whenComplete(() {
// //         setState(() {
// //           _isLoadingLocation = false;
// //         });
// //       });
// //
// //       setState(() {
// //         _currentPosition = position;
// //       });
// //
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Location fetched successfully!'),
// //             duration: Duration(seconds: 2),
// //           ),
// //         );
// //       }
// //
// //     } catch (e) {
// //       setState(() {
// //         _isLoadingLocation = false;
// //       });
// //
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error getting location: ${e.toString()}'),
// //             duration: const Duration(seconds: 3),
// //           ),
// //         );
// //       }
// //     }
// //   }
// //
// //   // --- File Upload Logic (Unchanged but essential) ---
// //
// //   Future<void> _pickFile() async {
// //     // Allow both camera and gallery options
// //     final source = await showDialog<ImageSource>(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return SimpleDialog(
// //           title: const Text('Select Media Source'),
// //           children: <Widget>[
// //             SimpleDialogOption(
// //               onPressed: () { Navigator.pop(context, ImageSource.camera); },
// //               child: const Text('Camera'),
// //             ),
// //             SimpleDialogOption(
// //               onPressed: () { Navigator.pop(context, ImageSource.gallery); },
// //               child: const Text('Gallery'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //
// //     if (source != null) {
// //       final pickedFile = await _imagePicker.pickImage(source: source);
// //       if (pickedFile != null) {
// //         setState(() {
// //           _selectedFile = File(pickedFile.path);
// //         });
// //       }
// //     }
// //   }
// //
// //   Future<String?> _uploadFileToCloudinary(File file) async {
// //     try {
// //       final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
// //       request.fields['upload_preset'] = cloudinaryPreset;
// //       request.files.add(await http.MultipartFile.fromPath('file', file.path));
// //
// //       final response = await request.send();
// //       if (response.statusCode == 200) {
// //         final responseData = await response.stream.bytesToString();
// //         final jsonResponse = json.decode(responseData);
// //         return jsonResponse['secure_url'];
// //       } else {
// //         final errorBody = await response.stream.bytesToString();
// //         throw Exception("Failed to upload file. Status: ${response.statusCode}. Details: $errorBody");
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Error uploading file: ${e.toString().split(':')[0]}")), // Keep it brief
// //         );
// //       }
// //       return null;
// //     }
// //   }
// //
// //   // --- Submission Logic ---
// //
// //   Future<void> _submitComplaint() async {
// //     if (_formKey.currentState!.validate()) {
// //       _formKey.currentState!.save();
// //
// //       setState(() {
// //         _isSubmitting = true;
// //       });
// //
// //       String? fileUrl;
// //       if (_selectedFile != null) {
// //         fileUrl = await _uploadFileToCloudinary(_selectedFile!);
// //         if (fileUrl == null) {
// //           setState(() { _isSubmitting = false; });
// //           return;
// //         }
// //       }
// //
// //       try {
// //         String complaintId = const Uuid().v4();
// //
// //         await FirebaseFirestore.instance.collection('complaints').doc(complaintId).set({
// //           'description': _incidentDescription,
// //           'priority': _priority,
// //           'status': _status,
// //           'userId': _currentUser?.uid, // Added user ID for better tracking
// //           'userName': _currentUser?.displayName ?? "Anonymous User",
// //           'userEmail': _currentUser?.email ?? "No Email",
// //           'timestamp': FieldValue.serverTimestamp(),
// //           'location': _currentPosition != null
// //               ? {
// //             'latitude': _currentPosition!.latitude,
// //             'longitude': _currentPosition!.longitude
// //           }
// //               : null,
// //           'fileUrl': fileUrl,
// //         });
// //
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text("Complaint submitted successfully!"), backgroundColor: Colors.green),
// //           );
// //         }
// //
// //         // Reset the form state
// //         _formKey.currentState!.reset();
// //         setState(() {
// //           _currentPosition = null;
// //           _selectedFile = null;
// //           _priority = "Low";
// //           _isSubmitting = false;
// //         });
// //       } catch (e) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("Error submitting complaint: ${e.toString()}"), backgroundColor: Colors.red),
// //           );
// //         }
// //         setState(() {
// //           _isSubmitting = false;
// //         });
// //       }
// //     }
// //   }
// //
// //   // ------------------------------------
// //   // --- UI Build Method (Enhanced) ---
// //   // ------------------------------------
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // Define a consistent border style for professional inputs
// //     const outlineInputBorder = OutlineInputBorder(
// //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //       borderSide: BorderSide.none, // Hide the outline for filled look
// //     );
// //
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           // Background Image (Kept for consistency with user's theme)
// //           Container(
// //             decoration: const BoxDecoration(
// //               image: DecorationImage(
// //                 image: AssetImage("assets/ChatBotBackground.jpg"),
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //           ),
// //           // Scrollable form content
// //           SingleChildScrollView(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Center(
// //               child: ConstrainedBox(
// //                 constraints: const BoxConstraints(maxWidth: 600), // Max width for tablet/desktop view
// //                 child: Card(
// //                   elevation: 10,
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //                   color: Colors.white.withOpacity(0.95), // Slightly transparent card
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(24.0),
// //                     child: Form(
// //                       key: _formKey,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.stretch,
// //                         children: [
// //                           Text(
// //                             "Incident Details",
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                               color: Theme.of(context).primaryColor,
// //                             ),
// //                           ),
// //                           const Divider(height: 25, thickness: 1.5),
// //
// //                           // 1. Description Field
// //                           TextFormField(
// //                             decoration: InputDecoration(
// //                               labelText: "Incident Description",
// //                               hintText: "Describe the incident in detail...",
// //                               filled: true,
// //                               fillColor: Colors.grey[100],
// //                               border: outlineInputBorder,
// //                               enabledBorder: outlineInputBorder,
// //                               focusedBorder: outlineInputBorder.copyWith(
// //                                 borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
// //                               ),
// //                             ),
// //                             style: GoogleFonts.roboto(),
// //                             maxLines: 5,
// //                             validator: (value) =>
// //                             value == null || value.isEmpty ? "Please provide a description." : null,
// //                             onSaved: (value) => _incidentDescription = value!,
// //                           ),
// //                           const SizedBox(height: 20),
// //
// //                           // 2. Priority Dropdown
// //                           DropdownButtonFormField<String>(
// //                             value: _priority,
// //                             decoration: InputDecoration(
// //                               labelText: "Priority Level",
// //                               filled: true,
// //                               fillColor: Colors.grey[100],
// //                               border: outlineInputBorder,
// //                               enabledBorder: outlineInputBorder,
// //                               focusedBorder: outlineInputBorder.copyWith(
// //                                 borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
// //                               ),
// //                             ),
// //                             style: GoogleFonts.roboto(color: Colors.black87),
// //                             items: ["Low", "Medium", "High"]
// //                                 .map((priority) => DropdownMenuItem(
// //                               value: priority,
// //                               child: Text(priority),
// //                             ))
// //                                 .toList(),
// //                             onChanged: (value) => setState(() => _priority = value!),
// //                           ),
// //                           const SizedBox(height: 30),
// //
// //                           // 3. Location Section
// //                           Text(
// //                             "Location & Media",
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                               color: Theme.of(context).primaryColor,
// //                             ),
// //                           ),
// //                           const Divider(height: 25, thickness: 1.5),
// //
// //                           // Location Button
// //                           ElevatedButton.icon(
// //                             onPressed: _isLoadingLocation || _isSubmitting ? null : _getCurrentLocation,
// //                             icon: _isLoadingLocation
// //                                 ? const SizedBox(
// //                               width: 20,
// //                               height: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                                 : const Icon(Icons.location_on),
// //                             label: Text(_isLoadingLocation ? "Getting Location..." : "Attach Current Location"),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.blueGrey, // A distinct color for location
// //                               foregroundColor: Colors.white,
// //                               padding: const EdgeInsets.symmetric(vertical: 15),
// //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //                             ),
// //                           ),
// //
// //                           // Location Display
// //                           if (_currentPosition != null)
// //                             Padding(
// //                               padding: const EdgeInsets.only(top: 10.0),
// //                               child: Container(
// //                                 padding: const EdgeInsets.all(10),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.lightGreen.shade50,
// //                                   borderRadius: BorderRadius.circular(8),
// //                                   border: Border.all(color: Colors.lightGreen.shade300),
// //                                 ),
// //                                 child: Text(
// //                                   "GPS Coordinates: Lat ${_currentPosition!.latitude.toStringAsFixed(6)}, Lon ${_currentPosition!.longitude.toStringAsFixed(6)}",
// //                                   style: GoogleFonts.roboto(color: Colors.green.shade800, fontWeight: FontWeight.w500),
// //                                 ),
// //                               ),
// //                             ),
// //                           const SizedBox(height: 20),
// //
// //                           // 4. Attach Media Button
// //                           ElevatedButton.icon(
// //                             onPressed: _isSubmitting ? null : _pickFile,
// //                             icon: const Icon(Icons.cloud_upload),
// //                             label: Text(_selectedFile != null ? "Change Media" : "Attach Photo/Video"),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Theme.of(context).colorScheme.secondary,
// //                               foregroundColor: Colors.white,
// //                               padding: const EdgeInsets.symmetric(vertical: 15),
// //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //                             ),
// //                           ),
// //
// //                           // File Display
// //                           if (_selectedFile != null)
// //                             Padding(
// //                               padding: const EdgeInsets.only(top: 10.0),
// //                               child: Text(
// //                                 "File attached: ${_selectedFile!.path.split('/').last}",
// //                                 style: GoogleFonts.roboto(color: Colors.orange.shade700, fontStyle: FontStyle.italic),
// //                                 textAlign: TextAlign.center,
// //                               ),
// //                             ),
// //                           const SizedBox(height: 40),
// //
// //                           // 5. Submit Button
// //                           ElevatedButton(
// //                             onPressed: _isSubmitting ? null : _submitComplaint,
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Theme.of(context).primaryColor,
// //                               foregroundColor: Colors.white,
// //                               padding: const EdgeInsets.symmetric(vertical: 18),
// //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //                               elevation: 5,
// //                             ),
// //                             child: _isSubmitting
// //                                 ? const SizedBox(
// //                               width: 24,
// //                               height: 24,
// //                               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
// //                             )
// //                                 : Text(
// //                               "SUBMIT COMPLAINT",
// //                               style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 10),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart'; // Add this to pubspec.yaml
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ComplaintForm extends StatefulWidget {
//   @override
//   _ComplaintFormState createState() => _ComplaintFormState();
// }
//
// class _ComplaintFormState extends State<ComplaintForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _incidentDescription = '';
//   String _priority = "Low";
//   String _status = "Pending";
//   Position? _currentPosition;
//   String? _currentAddress; // Store the formatted address
//   File? _selectedFile;
//   final _imagePicker = ImagePicker();
//   final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dgdxa7qqg/image/upload";
//   final String cloudinaryPreset = "Judica";
//   final User? _currentUser = FirebaseAuth.instance.currentUser;
//   bool _isLoadingLocation = false;
//   bool _isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }
//
//   // --- Location and Permission Logic ---
//
//   Future<void> _checkLocationPermission() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location services are disabled. Please enable them in settings.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Location permissions are denied.'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location permissions are permanently denied.'),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//       return;
//     }
//   }
//
//   Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//
//         // Build a readable address
//         List<String> addressParts = [];
//
//         if (place.street != null && place.street!.isNotEmpty) {
//           addressParts.add(place.street!);
//         }
//         if (place.subLocality != null && place.subLocality!.isNotEmpty) {
//           addressParts.add(place.subLocality!);
//         }
//         if (place.locality != null && place.locality!.isNotEmpty) {
//           addressParts.add(place.locality!);
//         }
//         if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
//           addressParts.add(place.administrativeArea!);
//         }
//         if (place.postalCode != null && place.postalCode!.isNotEmpty) {
//           addressParts.add(place.postalCode!);
//         }
//
//         return addressParts.join(', ');
//       }
//       return "Address not found";
//     } catch (e) {
//       print("Error getting address: $e");
//       return "Unable to fetch address";
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Location services are disabled. Please enable them in your device settings.'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Location permission denied. Cannot fetch location.'),
//                 duration: Duration(seconds: 3),
//               ),
//             );
//           }
//           return;
//         }
//       }
//
//       setState(() {
//         _isLoadingLocation = true;
//       });
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10),
//       );
//
//       // Get address from coordinates
//       String address = await _getAddressFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//
//       setState(() {
//         _currentPosition = position;
//         _currentAddress = address;
//         _isLoadingLocation = false;
//       });
//
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location fetched successfully!'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//
//     } catch (e) {
//       setState(() {
//         _isLoadingLocation = false;
//       });
//
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error getting location: ${e.toString()}'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }
//
//   // --- File Upload Logic ---
//
//   Future<void> _pickFile() async {
//     final source = await showDialog<ImageSource>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Select Media Source'),
//           children: <Widget>[
//             SimpleDialogOption(
//               onPressed: () { Navigator.pop(context, ImageSource.camera); },
//               child: const Text('Camera'),
//             ),
//             SimpleDialogOption(
//               onPressed: () { Navigator.pop(context, ImageSource.gallery); },
//               child: const Text('Gallery'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (source != null) {
//       final pickedFile = await _imagePicker.pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _selectedFile = File(pickedFile.path);
//         });
//       }
//     }
//   }
//
//   Future<String?> _uploadFileToCloudinary(File file) async {
//     try {
//       final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
//       request.fields['upload_preset'] = cloudinaryPreset;
//       request.files.add(await http.MultipartFile.fromPath('file', file.path));
//
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.bytesToString();
//         final jsonResponse = json.decode(responseData);
//         return jsonResponse['secure_url'];
//       } else {
//         final errorBody = await response.stream.bytesToString();
//         throw Exception("Failed to upload file. Status: ${response.statusCode}. Details: $errorBody");
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error uploading file: ${e.toString().split(':')[0]}")),
//         );
//       }
//       return null;
//     }
//   }
//
//   // --- Submission Logic ---
//
//   Future<void> _submitComplaint() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       String? fileUrl;
//       if (_selectedFile != null) {
//         fileUrl = await _uploadFileToCloudinary(_selectedFile!);
//         if (fileUrl == null) {
//           setState(() { _isSubmitting = false; });
//           return;
//         }
//       }
//
//       try {
//         String complaintId = const Uuid().v4();
//
//         // Store lat/long in Firebase, but display address to user
//         await FirebaseFirestore.instance.collection('complaints').doc(complaintId).set({
//           'description': _incidentDescription,
//           'priority': _priority,
//           'status': _status,
//           'userId': _currentUser?.uid,
//           'userName': _currentUser?.displayName ?? "Anonymous User",
//           'userEmail': _currentUser?.email ?? "No Email",
//           'timestamp': FieldValue.serverTimestamp(),
//           'location': _currentPosition != null
//               ? {
//             'latitude': _currentPosition!.latitude,
//             'longitude': _currentPosition!.longitude,
//             'address': _currentAddress ?? "Address not available"
//           }
//               : null,
//           'fileUrl': fileUrl,
//         });
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Complaint submitted successfully!"), backgroundColor: Colors.green),
//           );
//         }
//
//         // Reset the form state
//         _formKey.currentState!.reset();
//         setState(() {
//           _currentPosition = null;
//           _currentAddress = null;
//           _selectedFile = null;
//           _priority = "Low";
//           _isSubmitting = false;
//         });
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error submitting complaint: ${e.toString()}"), backgroundColor: Colors.red),
//           );
//         }
//         setState(() {
//           _isSubmitting = false;
//         });
//       }
//     }
//   }
//
//   // --- UI Build Method ---
//
//   @override
//   Widget build(BuildContext context) {
//     const outlineInputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       borderSide: BorderSide.none,
//     );
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/ChatBotBackground.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 600),
//                 child: Card(
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   color: Colors.white.withOpacity(0.95),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(
//                             "Incident Details",
//                             style: GoogleFonts.poppins(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           const Divider(height: 25, thickness: 1.5),
//
//                           // Description Field
//                           TextFormField(
//                             decoration: InputDecoration(
//                               labelText: "Incident Description",
//                               hintText: "Describe the incident in detail...",
//                               filled: true,
//                               fillColor: Colors.grey[100],
//                               border: outlineInputBorder,
//                               enabledBorder: outlineInputBorder,
//                               focusedBorder: outlineInputBorder.copyWith(
//                                 borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//                               ),
//                             ),
//                             style: GoogleFonts.roboto(),
//                             maxLines: 5,
//                             validator: (value) =>
//                             value == null || value.isEmpty ? "Please provide a description." : null,
//                             onSaved: (value) => _incidentDescription = value!,
//                           ),
//                           const SizedBox(height: 20),
//
//                           // Priority Dropdown
//                           DropdownButtonFormField<String>(
//                             value: _priority,
//                             decoration: InputDecoration(
//                               labelText: "Priority Level",
//                               filled: true,
//                               fillColor: Colors.grey[100],
//                               border: outlineInputBorder,
//                               enabledBorder: outlineInputBorder,
//                               focusedBorder: outlineInputBorder.copyWith(
//                                 borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//                               ),
//                             ),
//                             style: GoogleFonts.roboto(color: Colors.black87),
//                             items: ["Low", "Medium", "High"]
//                                 .map((priority) => DropdownMenuItem(
//                               value: priority,
//                               child: Text(priority),
//                             ))
//                                 .toList(),
//                             onChanged: (value) => setState(() => _priority = value!),
//                           ),
//                           const SizedBox(height: 30),
//
//                           // Location Section
//                           Text(
//                             "Location & Media",
//                             style: GoogleFonts.poppins(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           const Divider(height: 25, thickness: 1.5),
//
//                           // Location Button
//                           ElevatedButton.icon(
//                             onPressed: _isLoadingLocation || _isSubmitting ? null : _getCurrentLocation,
//                             icon: _isLoadingLocation
//                                 ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                                 : const Icon(Icons.location_on),
//                             label: Text(_isLoadingLocation ? "Getting Location..." : "Attach Current Location"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blueGrey,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             ),
//                           ),
//
//                           // Address Display (instead of coordinates)
//                           if (_currentAddress != null)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 10.0),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.lightGreen.shade50,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(color: Colors.lightGreen.shade300),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.place, color: Colors.green.shade700, size: 20),
//                                     const SizedBox(width: 8),
//                                     Expanded(
//                                       child: Text(
//                                         _currentAddress!,
//                                         style: GoogleFonts.roboto(
//                                           color: Colors.green.shade800,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           const SizedBox(height: 20),
//
//                           // Attach Media Button
//                           ElevatedButton.icon(
//                             onPressed: _isSubmitting ? null : _pickFile,
//                             icon: const Icon(Icons.cloud_upload),
//                             label: Text(_selectedFile != null ? "Change Media" : "Attach Photo/Video"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).colorScheme.secondary,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             ),
//                           ),
//
//                           // File Display
//                           if (_selectedFile != null)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 10.0),
//                               child: Text(
//                                 "File attached: ${_selectedFile!.path.split('/').last}",
//                                 style: GoogleFonts.roboto(color: Colors.orange.shade700, fontStyle: FontStyle.italic),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           const SizedBox(height: 40),
//
//                           // Submit Button
//                           ElevatedButton(
//                             onPressed: _isSubmitting ? null : _submitComplaint,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).primaryColor,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 18),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               elevation: 5,
//                             ),
//                             child: _isSubmitting
//                                 ? const SizedBox(
//                               width: 24,
//                               height: 24,
//                               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                             )
//                                 : Text(
//                               "SUBMIT COMPLAINT",
//                               style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _incidentDescription = '';
  String _priority = "Low";
  String _status = "Pending";
  Position? _currentPosition;
  String? _currentAddress;
  File? _selectedFile;
  final _imagePicker = ImagePicker();
  final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dgdxa7qqg/image/upload";
  final String cloudinaryPreset = "Judica";
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        _showCustomSnackBar('Location services disabled', Icons.location_off, Colors.orange);
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          _showCustomSnackBar('Location permission denied', Icons.location_off, Colors.red);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        _showCustomSnackBar('Location permission permanently denied', Icons.block, Colors.red);
      }
      return;
    }
  }

  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty) addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) addressParts.add(place.locality!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressParts.add(place.administrativeArea!);
        if (place.postalCode != null && place.postalCode!.isNotEmpty) addressParts.add(place.postalCode!);
        return addressParts.join(', ');
      }
      return "Address not found";
    } catch (e) {
      return "Unable to fetch address";
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          _showCustomSnackBar('Enable location services', Icons.settings, Colors.orange);
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          if (context.mounted) {
            _showCustomSnackBar('Location permission required', Icons.location_off, Colors.red);
          }
          return;
        }
      }

      setState(() => _isLoadingLocation = true);

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      String address = await _getAddressFromCoordinates(position.latitude, position.longitude);

      setState(() {
        _currentPosition = position;
        _currentAddress = address;
        _isLoadingLocation = false;
      });

      if (context.mounted) {
        _showCustomSnackBar('Location captured successfully', Icons.check_circle, Colors.green);
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (context.mounted) {
        _showCustomSnackBar('Error getting location', Icons.error, Colors.red);
      }
    }
  }

  Future<void> _pickFile() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Media Source',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMediaOption(Icons.camera_alt, 'Camera', Colors.purple, ImageSource.camera),
                  const SizedBox(height: 12),
                  _buildMediaOption(Icons.photo_library, 'Gallery', Colors.blue, ImageSource.gallery),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (source != null) {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => _selectedFile = File(pickedFile.path));
      }
    }
  }

  Widget _buildMediaOption(IconData icon, String label, Color color, ImageSource source) {
    return InkWell(
      onTap: () => Navigator.pop(context, source),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
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
        throw Exception("Upload failed");
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar('Error uploading file', Icons.error, Colors.red);
      }
      return null;
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isSubmitting = true);

      String? fileUrl;
      if (_selectedFile != null) {
        fileUrl = await _uploadFileToCloudinary(_selectedFile!);
        if (fileUrl == null) {
          setState(() => _isSubmitting = false);
          return;
        }
      }

      try {
        String complaintId = const Uuid().v4();
        await FirebaseFirestore.instance.collection('complaints').doc(complaintId).set({
          'description': _incidentDescription,
          'priority': _priority,
          'status': _status,
          'userId': _currentUser?.uid,
          'userName': _currentUser?.displayName ?? "Anonymous User",
          'userEmail': _currentUser?.email ?? "No Email",
          'timestamp': FieldValue.serverTimestamp(),
          'location': _currentPosition != null
              ? {
            'latitude': _currentPosition!.latitude,
            'longitude': _currentPosition!.longitude,
            'address': _currentAddress ?? "Address not available"
          }
              : null,
          'fileUrl': fileUrl,
        });

        if (mounted) {
          _showCustomSnackBar('Complaint submitted successfully!', Icons.check_circle, Colors.green);
        }

        _formKey.currentState!.reset();
        setState(() {
          _currentPosition = null;
          _currentAddress = null;
          _selectedFile = null;
          _priority = "Low";
          _isSubmitting = false;
        });
      } catch (e) {
        if (mounted) {
          _showCustomSnackBar('Error submitting complaint', Icons.error, Colors.red);
        }
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showCustomSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: GoogleFonts.poppins())),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (_priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.report_problem,
                                size: 40,
                                color: Color(0xFF667eea),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Report Incident',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Help us keep the community safe',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Description Field
                                _buildSectionHeader('Incident Description', Icons.description),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  hint: "Describe what happened...",
                                  maxLines: 5,
                                  validator: (value) =>
                                  value == null || value.isEmpty ? "Description required" : null,
                                  onSaved: (value) => _incidentDescription = value!,
                                ),
                                const SizedBox(height: 24),

                                // Priority Selector
                                _buildSectionHeader('Priority Level', Icons.priority_high),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildPriorityChip("Low", Colors.green),
                                    const SizedBox(width: 8),
                                    _buildPriorityChip("Medium", Colors.orange),
                                    const SizedBox(width: 8),
                                    _buildPriorityChip("High", Colors.red),
                                  ],
                                ),
                                const SizedBox(height: 28),

                                // Location Section
                                _buildSectionHeader('Location', Icons.location_on),
                                const SizedBox(height: 12),
                                _buildActionButton(
                                  icon: _isLoadingLocation ? null : Icons.my_location,
                                  label: _isLoadingLocation ? "Getting Location..." : "Capture Location",
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                  ),
                                  onPressed: _isLoadingLocation || _isSubmitting ? null : _getCurrentLocation,
                                  isLoading: _isLoadingLocation,
                                ),

                                if (_currentAddress != null) ...[
                                  const SizedBox(height: 12),
                                  _buildInfoCard(
                                    icon: Icons.place,
                                    text: _currentAddress!,
                                    color: Colors.green,
                                  ),
                                ],
                                const SizedBox(height: 24),

                                // Media Section
                                _buildSectionHeader('Evidence', Icons.photo_camera),
                                const SizedBox(height: 12),
                                _buildActionButton(
                                  icon: Icons.add_photo_alternate,
                                  label: _selectedFile != null ? "Change Media" : "Attach Photo/Video",
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                                  ),
                                  onPressed: _isSubmitting ? null : _pickFile,
                                ),

                                if (_selectedFile != null) ...[
                                  const SizedBox(height: 12),
                                  _buildInfoCard(
                                    icon: Icons.attach_file,
                                    text: _selectedFile!.path.split('/').last,
                                    color: Colors.orange,
                                  ),
                                ],
                                const SizedBox(height: 32),

                                // Submit Button
                                _buildSubmitButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF667eea).withOpacity(0.2), const Color(0xFF764ba2).withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF667eea), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hint,
    required int maxLines,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: GoogleFonts.poppins(),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildPriorityChip(String label, Color color) {
    final isSelected = _priority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [color, color.withOpacity(0.7)])
                : null,
            color: isSelected ? null : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    required String label,
    required Gradient gradient,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: onPressed != null ? gradient : null,
        color: onPressed == null ? Colors.grey[300] : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: onPressed != null
            ? [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, color: Colors.white, size: 22),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSubmitting ? null : _submitComplaint,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: _isSubmitting
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Submitting...',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  'SUBMIT COMPLAINT',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}