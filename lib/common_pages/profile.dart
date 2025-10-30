// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:judica/common_pages/slpash_screen.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:intl/intl.dart'; // <--- CORRECT LOCATION for the fix
// //
// // import '../l10n/app_localizations.dart';
// //
// // // Define the primary color based on the user's existing style for consistency
// // const Color _primaryColor = Color.fromRGBO(255, 125, 41, 1);
// // const Color _backgroundColor = Color.fromRGBO(250, 249, 246, 1);
// //
// // class ProfilePage extends StatefulWidget {
// //   const ProfilePage({super.key});
// //
// //   @override
// //   State<ProfilePage> createState() => _ProfilePageState();
// // }
// //
// // class _ProfilePageState extends State<ProfilePage> {
// //   String userName = "N/A";
// //   String email = "N/A";
// //   String mobileNumber = "N/A";
// //   String dateOfBirth = "N/A";
// //   String address = "N/A";
// //   String? localImagePath;
// //
// //   final ImagePicker _picker = ImagePicker();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchUserData();
// //     _requestPermissions();
// //   }
// //
// //   // --- Data Management ---
// //
// //   Future<void> fetchUserData() async {
// //     try {
// //       final currentUser = FirebaseAuth.instance.currentUser;
// //       final docId = currentUser?.email;
// //       if (docId == null) return;
// //
// //       final userDoc = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(docId)
// //           .get();
// //
// //       if (userDoc.exists) {
// //         if (mounted) {
// //           setState(() {
// //             userName = userDoc.data()?['username'] ?? "N/A";
// //             email = userDoc.data()?['email'] ?? "N/A";
// //             mobileNumber = userDoc.data()?['Mobile Number'] ?? "N/A";
// //             dateOfBirth = userDoc.data()?['Date of Birth'] ?? "N/A";
// //             address = userDoc.data()?['Address'] ?? "N/A";
// //             localImagePath = userDoc.data()?['imageUrl'];
// //           });
// //         }
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print("Error fetching user data: $e");
// //       }
// //     }
// //   }
// //
// //   Future<void> saveUserData(String field, String value) async {
// //     try {
// //       final currentUser = FirebaseAuth.instance.currentUser;
// //       final docId = currentUser?.email;
// //       if (docId == null) return;
// //
// //       await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(docId)
// //           .update({field: value});
// //
// //       if (mounted) {
// //         setState(() {
// //           switch (field) {
// //             case 'username':
// //               userName = value;
// //               break;
// //             case 'email':
// //               email = value;
// //               break;
// //             case 'Mobile Number':
// //               mobileNumber = value;
// //               break;
// //             case 'Date of Birth':
// //               dateOfBirth = value;
// //               break;
// //             case 'Address':
// //               address = value;
// //               break;
// //           }
// //         });
// //
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Changes saved successfully!'),
// //             duration: Duration(seconds: 2),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print("Error saving user data: $e");
// //       }
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Failed to save changes.'),
// //             duration: Duration(seconds: 2),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     }
// //   }
// //
// //   // --- Permissions and Image Handling ---
// //
// //   Future<void> _requestPermissions() async {
// //     await [Permission.camera, Permission.photos].request();
// //   }
// //
// //   Future<void> _pickImage() async {
// //     final pickedFile = await _picker.pickImage(
// //       source: ImageSource.gallery,
// //       maxWidth: 500,
// //       maxHeight: 500,
// //     );
// //
// //     if (pickedFile != null) {
// //       final localPath = pickedFile.path;
// //       final currentUser = FirebaseAuth.instance.currentUser;
// //       final docId = currentUser?.email;
// //
// //       if (docId != null) {
// //         // Here you should upload the file to storage (e.g., Firebase Storage)
// //         // and save the permanent URL to Firestore. Since we are using the local
// //         // path as per the original structure, we save the path.
// //         await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(docId)
// //             .update({'imageUrl': localPath});
// //       }
// //
// //       if (mounted) {
// //         setState(() {
// //           localImagePath = localPath;
// //         });
// //       }
// //     }
// //   }
// //
// //   // --- Authentication ---
// //
// //   void _logout() async {
// //     await FirebaseAuth.instance.signOut();
// //     if (mounted) {
// //       Navigator.pushReplacement(
// //           context, MaterialPageRoute(builder: (context) => const SplashScreen()));
// //     }
// //   }
// //
// //   // --- UI and Dialogs ---
// //
// //   Future<void> _showDatePickerDialog() async {
// //     DateTime initialDate;
// //     try {
// //       // Try to parse existing date, default to 20 years ago
// //       initialDate = DateFormat('dd/MM/yyyy').parse(dateOfBirth);
// //     } catch (_) {
// //       initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
// //     }
// //
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: initialDate,
// //       firstDate: DateTime(1900),
// //       lastDate: DateTime.now(),
// //       builder: (BuildContext context, Widget? child) {
// //         return Theme(
// //           data: ThemeData.light().copyWith(
// //             colorScheme: const ColorScheme.light(
// //               primary: _primaryColor, // Header background color
// //               onPrimary: Colors.white, // Header text color
// //               onSurface: Colors.black, // Body text color
// //             ),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //
// //     if (picked != null) {
// //       final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
// //       saveUserData('Date of Birth', formattedDate);
// //     }
// //   }
// //
// //   void _showEditDialog(String title, String field, String currentValue) {
// //     // If Date of Birth, use the dedicated picker
// //     if (field == 'Date of Birth') {
// //       _showDatePickerDialog();
// //       return;
// //     }
// //
// //     TextEditingController controller = TextEditingController(text: currentValue);
// //     TextInputType keyboardType = TextInputType.text;
// //     if (field == 'Mobile Number') {
// //       keyboardType = TextInputType.phone;
// //     } else if (field == 'email') {
// //       keyboardType = TextInputType.emailAddress;
// //     }
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('Edit $title', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
// //           content: TextField(
// //             controller: controller,
// //             keyboardType: keyboardType,
// //             decoration: InputDecoration(
// //               hintText: 'Enter new $title',
// //               border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
// //               focusedBorder: OutlineInputBorder(
// //                 borderSide: const BorderSide(color: _primaryColor, width: 2),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 saveUserData(field, controller.text);
// //                 Navigator.pop(context);
// //               },
// //               child: const Text('Save', style: TextStyle(color: _primaryColor)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   // --- Widget Builders ---
// //
// //   Widget _buildProfileHeader() {
// //     ImageProvider? imageProvider;
// //     bool hasValidLocalFile = false;
// //
// //     // Safely try to load the local file image
// //     if (localImagePath != null) {
// //       try {
// //         imageProvider = FileImage(File(localImagePath!));
// //         hasValidLocalFile = true;
// //       } catch (e) {
// //         // If the file cannot be loaded (e.g., deleted or invalid path), fall back.
// //         if (kDebugMode) print("Error loading local profile image: $e");
// //         imageProvider = null;
// //       }
// //     }
// //
// //     return Column(
// //       children: [
// //         GestureDetector(
// //           onTap: _pickImage,
// //           child: CircleAvatar(
// //             radius: 80,
// //             backgroundColor: _primaryColor.withOpacity(0.1),
// //             backgroundImage: imageProvider, // Use the determined ImageProvider
// //             child: hasValidLocalFile
// //                 ? null // If we have a valid image, no child widget is needed
// //                 : Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Icon(
// //                   Icons.camera_alt,
// //                   color: _primaryColor,
// //                   size: 40,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   AppLocalizations.of(context)?.clicktoupload ?? "Upload Image",
// //                   textAlign: TextAlign.center,
// //                   style: GoogleFonts.roboto(color: Colors.black87, fontSize: 14),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 15),
// //         Text(
// //           userName,
// //           style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
// //         ),
// //         Text(
// //           email,
// //           style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
// //         ),
// //         const SizedBox(height: 30),
// //       ],
// //     );
// //   }
// //
// //   Widget buildEditableField(String title, String value, String field) {
// //     // Determine if the field is the special Date of Birth field
// //     final bool isDateField = field == 'Date of Birth';
// //
// //     return GestureDetector(
// //       onTap: () => _showEditDialog(title, field, value),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
// //         margin: const EdgeInsets.only(bottom: 12),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: _primaryColor.withOpacity(0.4), width: 1),
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.1),
// //               spreadRadius: 1,
// //               blurRadius: 3,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: GoogleFonts.poppins(
// //                       fontWeight: FontWeight.bold, fontSize: 14, color: _primaryColor),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Row(
// //                   children: [
// //                     Flexible(
// //                       child: Text(
// //                         value,
// //                         style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             Icon(
// //               isDateField ? Icons.calendar_month : Icons.edit,
// //               color: Colors.grey,
// //               size: 20,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: _backgroundColor,
// //       body: SingleChildScrollView(
// //         child: Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: ConstrainedBox(
// //               constraints: const BoxConstraints(maxWidth: 600),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   const SizedBox(height: 20),
// //                   _buildProfileHeader(),
// //
// //                   Card(
// //                     elevation: 5,
// //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //                     color: Colors.white,
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(16.0),
// //                       child: Column(
// //                         children: [
// //                           buildEditableField("Name", userName, "username"),
// //                           buildEditableField("Email", email, "email"),
// //                           buildEditableField("Mobile Number", mobileNumber, "Mobile Number"),
// //                           buildEditableField("Date of Birth", dateOfBirth, "Date of Birth"),
// //                           buildEditableField("Address", address, "Address"),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //
// //                   const SizedBox(height: 40),
// //                   ElevatedButton.icon(
// //                     onPressed: _logout,
// //                     icon: const Icon(Icons.logout, color: Colors.white),
// //                     label: Text(
// //                       AppLocalizations.of(context)?.logout ?? "Logout",
// //                       style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
// //                     ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: _primaryColor,
// //                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                       elevation: 5,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:judica/common_pages/slpash_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
//
// import '../l10n/app_localizations.dart';
//
// const Color _primaryColor = Color.fromRGBO(255, 125, 41, 1);
// const Color _backgroundColor = Color.fromRGBO(250, 249, 246, 1);
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String userName = "N/A";
//   String email = "N/A";
//   String mobileNumber = "N/A";
//   String dateOfBirth = "N/A";
//   String address = "N/A";
//   String? localImagePath;
//
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     _requestPermissions();
//   }
//
//   // --- Data Management ---
//
//   Future<void> fetchUserData() async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       final docId = currentUser?.email;
//       if (docId == null) return;
//
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(docId)
//           .get();
//
//       if (userDoc.exists) {
//         if (mounted) {
//           setState(() {
//             userName = userDoc.data()?['username'] ?? "N/A";
//             email = userDoc.data()?['email'] ?? "N/A";
//             mobileNumber = userDoc.data()?['Mobile Number'] ?? "N/A";
//             dateOfBirth = userDoc.data()?['Date of Birth'] ?? "N/A";
//             address = userDoc.data()?['Address'] ?? "N/A";
//             localImagePath = userDoc.data()?['imageUrl'];
//           });
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error fetching user data: $e");
//       }
//     }
//   }
//
//   Future<void> saveUserData(String field, String value) async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       final docId = currentUser?.email;
//       if (docId == null) return;
//
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(docId)
//           .update({field: value});
//
//       if (mounted) {
//         setState(() {
//           switch (field) {
//             case 'username':
//               userName = value;
//               break;
//             case 'email':
//               email = value;
//               break;
//             case 'Mobile Number':
//               mobileNumber = value;
//               break;
//             case 'Date of Birth':
//               dateOfBirth = value;
//               break;
//             case 'Address':
//               address = value;
//               break;
//           }
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Changes saved successfully!'),
//             duration: Duration(seconds: 2),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error saving user data: $e");
//       }
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to save changes.'),
//             duration: Duration(seconds: 2),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   // --- Permissions and Image Handling ---
//
//   Future<void> _requestPermissions() async {
//     await [Permission.camera, Permission.photos].request();
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 500,
//       maxHeight: 500,
//     );
//
//     if (pickedFile != null) {
//       final localPath = pickedFile.path;
//       final currentUser = FirebaseAuth.instance.currentUser;
//       final docId = currentUser?.email;
//
//       if (docId != null) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(docId)
//             .update({'imageUrl': localPath});
//       }
//
//       if (mounted) {
//         setState(() {
//           localImagePath = localPath;
//         });
//       }
//     }
//   }
//
//   // --- Authentication ---
//
//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     if (mounted) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => const SplashScreen()));
//     }
//   }
//
//   // --- UI and Dialogs ---
//
//   Future<void> _showDatePickerDialog() async {
//     DateTime initialDate;
//     try {
//       initialDate = DateFormat('dd/MM/yyyy').parse(dateOfBirth);
//     } catch (_) {
//       initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
//     }
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: _primaryColor,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
//       saveUserData('Date of Birth', formattedDate);
//     }
//   }
//
//   void _showEditDialog(String title, String field, String currentValue) {
//     if (field == 'Date of Birth') {
//       _showDatePickerDialog();
//       return;
//     }
//
//     TextEditingController controller = TextEditingController(text: currentValue);
//     TextInputType keyboardType = TextInputType.text;
//     if (field == 'Mobile Number') {
//       keyboardType = TextInputType.phone;
//     } else if (field == 'email') {
//       keyboardType = TextInputType.emailAddress;
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit $title', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//           content: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             decoration: InputDecoration(
//               hintText: 'Enter new $title',
//               border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: _primaryColor, width: 2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//             ),
//             TextButton(
//               onPressed: () {
//                 saveUserData(field, controller.text);
//                 Navigator.pop(context);
//               },
//               child: const Text('Save', style: TextStyle(color: _primaryColor)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // --- Widget Builders ---
//
//   Widget _buildProfileHeader() {
//     ImageProvider? imageProvider;
//     bool hasValidLocalFile = false;
//
//     if (localImagePath != null) {
//       try {
//         imageProvider = FileImage(File(localImagePath!));
//         hasValidLocalFile = true;
//       } catch (e) {
//         if (kDebugMode) print("Error loading local profile image: $e");
//         imageProvider = null;
//       }
//     }
//
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _pickImage,
//           child: CircleAvatar(
//             radius: 80,
//             backgroundColor: _primaryColor.withOpacity(0.1),
//             backgroundImage: imageProvider,
//             child: hasValidLocalFile
//                 ? null
//                 : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.camera_alt,
//                   color: _primaryColor,
//                   size: 40,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   AppLocalizations.of(context)?.clicktoupload ?? "Upload Image",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.roboto(color: Colors.black87, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 15),
//         Text(
//           userName,
//           style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
//         ),
//         Text(
//           email,
//           style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
//         ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }
//
//   Widget buildEditableField(String title, String value, String field) {
//     final bool isDateField = field == 'Date of Birth';
//
//     return GestureDetector(
//       onTap: () => _showEditDialog(title, field, value),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _primaryColor.withOpacity(0.4), width: 1),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold, fontSize: 14, color: _primaryColor),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Icon(
//               isDateField ? Icons.calendar_month : Icons.edit,
//               color: Colors.grey,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 600),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 20),
//                   _buildProfileHeader(),
//
//                   Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           buildEditableField("Name", userName, "username"),
//                           buildEditableField("Email", email, "email"),
//                           buildEditableField("Mobile Number", mobileNumber, "Mobile Number"),
//                           buildEditableField("Date of Birth", dateOfBirth, "Date of Birth"),
//                           buildEditableField("Address", address, "Address"),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//                   ElevatedButton.icon(
//                     onPressed: _logout,
//                     icon: const Icon(Icons.logout, color: Colors.white),
//                     label: Text(
//                       AppLocalizations.of(context)?.logout ?? "Logout",
//                       style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _primaryColor,
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       elevation: 5,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:judica/common_pages/slpash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

const Color _primaryColor = Color.fromRGBO(255, 125, 41, 1);

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
  String? localImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _requestPermissions();
  }

  // --- Data Management ---

  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final docId = currentUser?.email;
      if (docId == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .get();

      if (userDoc.exists) {
        if (mounted) {
          setState(() {
            userName = userDoc.data()?['username'] ?? "N/A";
            email = userDoc.data()?['email'] ?? "N/A";
            mobileNumber = userDoc.data()?['Mobile Number'] ?? "N/A";
            dateOfBirth = userDoc.data()?['Date of Birth'] ?? "N/A";
            address = userDoc.data()?['Address'] ?? "N/A";
            localImagePath = userDoc.data()?['imageUrl'];
          });
        }
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
      final docId = currentUser?.email;
      if (docId == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .update({field: value});

      if (mounted) {
        setState(() {
          switch (field) {
            case 'username':
              userName = value;
              break;
            case 'email':
              email = value;
              break;
            case 'Mobile Number':
              mobileNumber = value;
              break;
            case 'Date of Birth':
              dateOfBirth = value;
              break;
            case 'Address':
              address = value;
              break;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving user data: $e");
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save changes.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Permissions and Image Handling ---

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.photos].request();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile != null) {
      final localPath = pickedFile.path;
      final currentUser = FirebaseAuth.instance.currentUser;
      final docId = currentUser?.email;

      if (docId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update({'imageUrl': localPath});
      }

      if (mounted) {
        setState(() {
          localImagePath = localPath;
        });
      }
    }
  }

  // --- Authentication ---

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SplashScreen()));
    }
  }

  // --- UI and Dialogs ---

  Future<void> _showDatePickerDialog() async {
    DateTime initialDate;
    try {
      initialDate = DateFormat('dd/MM/yyyy').parse(dateOfBirth);
    } catch (_) {
      initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      saveUserData('Date of Birth', formattedDate);
    }
  }

  void _showEditDialog(String title, String field, String currentValue) {
    if (field == 'Date of Birth') {
      _showDatePickerDialog();
      return;
    }

    TextEditingController controller = TextEditingController(text: currentValue);
    TextInputType keyboardType = TextInputType.text;
    if (field == 'Mobile Number') {
      keyboardType = TextInputType.phone;
    } else if (field == 'email') {
      keyboardType = TextInputType.emailAddress;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: 'Enter new $title',
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: _primaryColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                saveUserData(field, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: _primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // --- Widget Builders ---

  Widget _buildProfileHeader() {
    ImageProvider? imageProvider;
    bool hasValidLocalFile = false;

    if (localImagePath != null) {
      try {
        imageProvider = FileImage(File(localImagePath!));
        hasValidLocalFile = true;
      } catch (e) {
        if (kDebugMode) print("Error loading local profile image: $e");
        imageProvider = null;
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 80,
            backgroundColor: _primaryColor.withOpacity(0.1),
            backgroundImage: imageProvider,
            child: hasValidLocalFile
                ? null
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt,
                  color: _primaryColor,
                  size: 40,
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)?.clicktoupload ?? "Upload Image",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          userName,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Text(
          email,
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildEditableField(String title, String value, String field) {
    final bool isDateField = field == 'Date of Birth';

    return GestureDetector(
      onTap: () => _showEditDialog(title, field, value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _primaryColor.withOpacity(0.4), width: 1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 14, color: _primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isDateField ? Icons.calendar_month : Icons.edit,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
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
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileHeader(),

                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildEditableField("Name", userName, "username"),
                              buildEditableField("Email", email, "email"),
                              buildEditableField("Mobile Number", mobileNumber, "Mobile Number"),
                              buildEditableField("Date of Birth", dateOfBirth, "Date of Birth"),
                              buildEditableField("Address", address, "Address"),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: Text(
                          AppLocalizations.of(context)?.logout ?? "Logout",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}