// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:open_filex/open_filex.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:dio/dio.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'dart:io';
// //
// // class FirComponent extends StatefulWidget {
// //   const FirComponent({super.key});
// //
// //   @override
// //   _FirComponentState createState() => _FirComponentState();
// // }
// //
// // class _FirComponentState extends State<FirComponent> with SingleTickerProviderStateMixin {
// //   final _formKey = GlobalKey<FormState>();
// //   late TabController _tabController;
// //   bool isLoading = false;
// //
// //   // FIR details form fields
// //   final TextEditingController _bookNoController = TextEditingController();
// //   final TextEditingController _formNoController = TextEditingController();
// //   final TextEditingController _policeStationController = TextEditingController();
// //   final TextEditingController _districtController = TextEditingController();
// //   final TextEditingController _dateHourOccurrenceController = TextEditingController();
// //   final TextEditingController _dateHourReportedController = TextEditingController();
// //   final TextEditingController _informerNameController = TextEditingController();
// //   final TextEditingController _descriptionOffenseController = TextEditingController();
// //   final TextEditingController _placeOccurrenceController = TextEditingController();
// //   final TextEditingController _criminalNameController = TextEditingController();
// //   final TextEditingController _investigationStepsController = TextEditingController();
// //   final TextEditingController _dispatchTimeController = TextEditingController();
// //
// //   // List to hold FIR documents from Firebase
// //   List<DocumentSnapshot> firList = [];
// //
// //   // Function to handle FIR generation request
// //   Future<void> generateFIR() async {
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     final firDetails = {
// //       "book_no": _bookNoController.text,
// //       "form_no": _formNoController.text,
// //       "police_station": _policeStationController.text,
// //       "district": _districtController.text,
// //       "date_hour_occurrence": _dateHourOccurrenceController.text,
// //       "date_hour_reported": _dateHourReportedController.text,
// //       "informer_name": _informerNameController.text,
// //       "description_offense": _descriptionOffenseController.text,
// //       "place_occurrence": _placeOccurrenceController.text,
// //       "criminal_name": _criminalNameController.text,
// //       "investigation_steps": _investigationStepsController.text,
// //       "dispatch_time": _dispatchTimeController.text,
// //     };
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse('https://aniudupa-fir-gen.hf.space/generate-fir/'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: json.encode(firDetails),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         final downloadUrl = responseData['view_url'];
// //
// //         if (downloadUrl != null && Uri.parse(downloadUrl).isAbsolute) {
// //           // Save FIR metadata to Firestore
// //           await _saveFIRToFirestore(downloadUrl);
// //         } else {
// //           _showErrorDialog('Invalid download URL received. Please contact support.');
// //         }
// //       } else {
// //         throw Exception('Failed to generate FIR: ${response.reasonPhrase}');
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Error occurred: ${e.toString()}');
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   // Function to save the FIR data to Firestore
// //   Future<void> _saveFIRToFirestore(String downloadUrl) async {
// //     try {
// //       final firCollection = FirebaseFirestore.instance.collection('fir');
// //       final newFIR = {
// //         "url": downloadUrl,
// //         "generated_at": Timestamp.now(),
// //       };
// //
// //       await firCollection.add(newFIR);
// //
// //       // Refresh the FIR list
// //       _fetchFIRList();
// //     } catch (e) {
// //       _showErrorDialog('Failed to save FIR: ${e.toString()}');
// //     }
// //   }
// //
// //   // Function to fetch FIRs from Firestore
// //   Future<void> _fetchFIRList() async {
// //     try {
// //       final firCollection = FirebaseFirestore.instance.collection('fir');
// //       final querySnapshot = await firCollection.orderBy('generated_at', descending: true).get();
// //
// //       setState(() {
// //         firList = querySnapshot.docs;
// //       });
// //     } catch (e) {
// //       _showErrorDialog('Error fetching FIR list: ${e.toString()}');
// //     }
// //   }
// //
// //   // Error Dialog Helper Function
// //   void _showErrorDialog(String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("Error"),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: const Text('Close'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Function to delete FIR
// //   Future<void> _deleteFIR(String firId) async {
// //     try {
// //       await FirebaseFirestore.instance.collection('fir').doc(firId).delete();
// //       _fetchFIRList();
// //     } catch (e) {
// //       _showErrorDialog('Failed to delete FIR: ${e.toString()}');
// //     }
// //   }
// //
// //   Future<bool> requestStoragePermission() async {
// //     if (Platform.isAndroid) {
// //       // For Android 13 (API level 33) and above
// //       if (await Permission.storage.isGranted) return true;
// //
// //       // Request multiple permissions for Android
// //       final Map<Permission, PermissionStatus> statuses = await [
// //         Permission.storage,
// //         Permission.manageExternalStorage,
// //       ].request();
// //
// //       // Check if any required permissions are granted
// //       return statuses[Permission.storage] == PermissionStatus.granted ||
// //           statuses[Permission.manageExternalStorage] == PermissionStatus.granted;
// //     }
// //
// //     // For iOS, storage permissions are handled differently
// //     if (Platform.isIOS) {
// //       return await Permission.photos.request().isGranted;
// //     }
// //
// //     return false;
// //   }
// //
// //   // Updated download function
// //   Future<String?> _downloadPDFToExternal(String url) async {
// //     try {
// //       // Request storage permission
// //       bool permissionGranted = await requestStoragePermission();
// //
// //       if (!permissionGranted) {
// //         _showErrorDialog('Storage permission is required to download files.');
// //         return null;
// //       }
// //
// //       // Determine appropriate download directory
// //       Directory? downloadDir;
// //       if (Platform.isAndroid) {
// //         downloadDir = await getExternalStorageDirectory();
// //       } else if (Platform.isIOS) {
// //         downloadDir = await getApplicationDocumentsDirectory();
// //       }
// //
// //       if (downloadDir == null) {
// //         _showErrorDialog('Could not access download directory');
// //         return null;
// //       }
// //
// //       // Generate unique filename
// //       final String fileName = 'FIR_${DateTime.now().millisecondsSinceEpoch}.pdf';
// //       final String filePath = '${downloadDir.path}/$fileName';
// //
// //       // Download file
// //       Dio dio = Dio();
// //       await dio.download(url, filePath);
// //
// //       // Show success message with open option
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('FIR downloaded to: $filePath'),
// //           action: SnackBarAction(
// //             label: 'Open',
// //             onPressed: () async {
// //               // Open the downloaded file
// //               final result = await OpenFilex.open(filePath);
// //
// //               // Check the result of opening the file
// //               switch (result.type) {
// //                 case ResultType.done:
// //                   print('File opened successfully');
// //                   break;
// //                 case ResultType.error:
// //                   _showErrorDialog('Failed to open file: ${result.message}');
// //                   break;
// //                 default:
// //                   print('File open result: ${result.type}');
// //               }
// //             },
// //           ),
// //         ),
// //       );
// //
// //       // Return the file path for sharing
// //       return filePath;
// //     } catch (e) {
// //       _showErrorDialog('Download failed: ${e.toString()}');
// //       return null;
// //     }
// //   }
// //
// //   // Function to share the FIR PDF
// //   Future<void> _sharePDF(String url) async {
// //     try {
// //       // Download the file first
// //       final filePath = await _downloadPDFToExternal(url);
// //
// //       if (filePath != null) {
// //         // Share the downloaded file
// //         await Share.shareXFiles([XFile(filePath)], text: 'FIR Document');
// //       }
// //     } catch (e) {
// //       _showErrorDialog('Share failed: ${e.toString()}');
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //     _fetchFIRList(); // Load FIRs on initialization
// //   }
// //
// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     _bookNoController.dispose();
// //     _formNoController.dispose();
// //     _policeStationController.dispose();
// //     _districtController.dispose();
// //     _dateHourOccurrenceController.dispose();
// //     _dateHourReportedController.dispose();
// //     _informerNameController.dispose();
// //     _descriptionOffenseController.dispose();
// //     _placeOccurrenceController.dispose();
// //     _criminalNameController.dispose();
// //     _investigationStepsController.dispose();
// //     _dispatchTimeController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           // Background Image
// //           Container(
// //             decoration: const BoxDecoration(
// //               image: DecorationImage(
// //                 image: AssetImage("assets/ChatBotBackground.jpg"), // Add your image path here
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //           ),
// //           // Content with TabBar
// //           Column(
// //             children: [
// //               TabBar(
// //                 controller: _tabController,
// //                 tabs: const [
// //                   Tab(text: 'Generate FIR'),
// //                   Tab(text: 'View FIRs'),
// //                 ],
// //                 labelColor: Colors.orange, // Active tab label color
// //                 unselectedLabelColor: Colors.black, // Inactive tab label color
// //                 indicatorColor: Colors.blue, // Indicator color
// //               ),
// //               Expanded(
// //                 child: TabBarView(
// //                   controller: _tabController,
// //                   children: [
// //                     _buildGenerateFIRForm(),
// //                     _buildFIRListView(),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Widget to display the FIR form
// //   Widget _buildGenerateFIRForm() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Form(
// //         key: _formKey,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildTextField(_bookNoController, 'Book Number'),
// //             _buildTextField(_formNoController, 'Form Number'),
// //             _buildTextField(_policeStationController, 'Police Station'),
// //             _buildTextField(_districtController, 'District'),
// //             _buildTextField(_dateHourOccurrenceController, 'Date/Hour of Occurrence'),
// //             _buildTextField(_dateHourReportedController, 'Date/Hour Reported'),
// //             _buildTextField(_informerNameController, 'Informer Name'),
// //             _buildTextField(_descriptionOffenseController, 'Description of Offense'),
// //             _buildTextField(_placeOccurrenceController, 'Place of Occurrence'),
// //             _buildTextField(_criminalNameController, 'Criminal Name'),
// //             _buildTextField(_investigationStepsController, 'Investigation Steps'),
// //             _buildTextField(_dispatchTimeController, 'Dispatch Time'),
// //             const SizedBox(height: 16.0),
// //             Center(
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.blueAccent,
// //                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
// //                   textStyle: const TextStyle(fontSize: 16),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //                 onPressed: generateFIR,
// //                 child: isLoading
// //                     ? const CircularProgressIndicator(color: Colors.white)
// //                     : const Text('Generate FIR', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Helper function to create text fields with transparency
// //   Widget _buildTextField(TextEditingController controller, String labelText) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16.0),
// //       child: TextFormField(
// //         controller: controller,
// //         decoration: InputDecoration(
// //           labelText: labelText,
// //           filled: true,
// //           fillColor: Colors.white.withOpacity(0.7),
// //           border: const OutlineInputBorder(),
// //         ),
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'This field is required';
// //           }
// //           return null;
// //         },
// //       ),
// //     );
// //   }
// //
// //   // Widget to display FIRs
// //   Widget _buildFIRListView() {
// //     if (firList.isEmpty) {
// //       return const Center(child: Text('No FIRs available'));
// //     }
// //     return ListView.builder(
// //       itemCount: firList.length,
// //       itemBuilder: (context, index) {
// //         final firData = firList[index].data() as Map<String, dynamic>;
// //         final firId = firList[index].id;
// //         final downloadUrl = firData['url'];
// //
// //         return ListTile(
// //           title: Text('FIR #$firId'),
// //           subtitle: Text('Generated at: ${firData['generated_at']}'),
// //           trailing: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               IconButton(
// //                 icon: const Icon(Icons.download),
// //                 onPressed: () => _downloadPDFToExternal(downloadUrl),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.share),
// //                 onPressed: () => _sharePDF(downloadUrl),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.delete),
// //                 onPressed: () => _deleteFIR(firId),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// // // KeepAliveWidget to maintain state across tabs
// // class KeepAliveWidget extends StatefulWidget {
// //   final Widget child;
// //
// //   const KeepAliveWidget({super.key, required this.child});
// //
// //   @override
// //   _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
// // }
// //
// // class _KeepAliveWidgetState extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin {
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return widget.child;
// //   }
// // }
// //
// // class PDFViewPage extends StatelessWidget {
// //   final String filePath;
// //
// //   const PDFViewPage({super.key, required this.filePath});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('View FIR PDF')),
// //       body: PDFView(
// //         filePath: filePath,
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:io';
//
// class FirComponent extends StatefulWidget {
//   const FirComponent({super.key});
//
//   @override
//   _FirComponentState createState() => _FirComponentState();
// }
//
// class _FirComponentState extends State<FirComponent> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TabController _tabController;
//   bool isLoading = false;
//
//   // FIR details form fields
//   final TextEditingController _bookNoController = TextEditingController();
//   final TextEditingController _formNoController = TextEditingController();
//   final TextEditingController _policeStationController = TextEditingController();
//   final TextEditingController _districtController = TextEditingController();
//   final TextEditingController _dateHourOccurrenceController = TextEditingController();
//   final TextEditingController _dateHourReportedController = TextEditingController();
//   final TextEditingController _informerNameController = TextEditingController();
//   final TextEditingController _descriptionOffenseController = TextEditingController();
//   final TextEditingController _placeOccurrenceController = TextEditingController();
//   final TextEditingController _criminalNameController = TextEditingController();
//   final TextEditingController _investigationStepsController = TextEditingController();
//   final TextEditingController _dispatchTimeController = TextEditingController();
//
//   // List to hold FIR documents from Firebase
//   List<DocumentSnapshot> firList = [];
//
//   // Function to handle FIR generation request
//   Future<void> generateFIR() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final firDetails = {
//       "book_no": _bookNoController.text,
//       "form_no": _formNoController.text,
//       "police_station": _policeStationController.text,
//       "district": _districtController.text,
//       "date_hour_occurrence": _dateHourOccurrenceController.text,
//       "date_hour_reported": _dateHourReportedController.text,
//       "informer_name": _informerNameController.text,
//       "description_offense": _descriptionOffenseController.text,
//       "place_occurrence": _placeOccurrenceController.text,
//       "criminal_name": _criminalNameController.text,
//       "investigation_steps": _investigationStepsController.text,
//       "dispatch_time": _dispatchTimeController.text,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://aniudupa-fir-gen.hf.space/generate-fir/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(firDetails),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         final downloadUrl = responseData['view_url'];
//
//         if (downloadUrl != null && Uri.parse(downloadUrl).isAbsolute) {
//           // Save FIR metadata to Firestore
//           await _saveFIRToFirestore(downloadUrl);
//
//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('FIR generated successfully!')),
//           );
//
//           // Switch to View FIRs tab
//           _tabController.animateTo(1);
//         } else {
//           _showErrorDialog('Invalid download URL received. Please contact support.');
//         }
//       } else {
//         throw Exception('Failed to generate FIR: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       _showErrorDialog('Error occurred: ${e.toString()}');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   // Function to save the FIR data to Firestore
//   Future<void> _saveFIRToFirestore(String downloadUrl) async {
//     try {
//       final firCollection = FirebaseFirestore.instance.collection('fir');
//       final newFIR = {
//         "url": downloadUrl,
//         "generated_at": Timestamp.now(),
//       };
//
//       await firCollection.add(newFIR);
//
//       // Refresh the FIR list
//       _fetchFIRList();
//     } catch (e) {
//       _showErrorDialog('Failed to save FIR: ${e.toString()}');
//     }
//   }
//
//   // Function to fetch FIRs from Firestore
//   Future<void> _fetchFIRList() async {
//     try {
//       final firCollection = FirebaseFirestore.instance.collection('fir');
//       final querySnapshot = await firCollection.orderBy('generated_at', descending: true).get();
//
//       setState(() {
//         firList = querySnapshot.docs;
//       });
//     } catch (e) {
//       _showErrorDialog('Error fetching FIR list: ${e.toString()}');
//     }
//   }
//
//   // Error Dialog Helper Function
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Error"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to delete FIR
//   Future<void> _deleteFIR(String firId) async {
//     try {
//       await FirebaseFirestore.instance.collection('fir').doc(firId).delete();
//       _fetchFIRList();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('FIR deleted successfully')),
//       );
//     } catch (e) {
//       _showErrorDialog('Failed to delete FIR: ${e.toString()}');
//     }
//   }
//
//   // Updated permission request function
//   Future<bool> requestStoragePermission() async {
//     if (Platform.isAndroid) {
//       try {
//         // Get Android version
//         final androidInfo = await DeviceInfoPlugin().androidInfo;
//         final sdkInt = androidInfo.version.sdkInt;
//
//         // Android 13 (API 33) and above - no storage permission needed for Downloads folder
//         if (sdkInt >= 33) {
//           return true; // No permission needed
//         }
//
//         // Android 10-12 (API 29-32)
//         if (sdkInt >= 29) {
//           return true; // Scoped storage, no permission needed
//         }
//
//         // Android 9 and below (API 28 and below)
//         final status = await Permission.storage.request();
//         return status.isGranted;
//       } catch (e) {
//         print('Error checking Android version: $e');
//         // Fallback: try to request permission anyway
//         final status = await Permission.storage.request();
//         return status.isGranted;
//       }
//     }
//
//     // For iOS
//     if (Platform.isIOS) {
//       final status = await Permission.photos.request();
//       return status.isGranted;
//     }
//
//     return false;
//   }
//
//   // Updated download function
//   Future<String?> _downloadPDFToExternal(String url) async {
//     try {
//       // Request storage permission
//       bool permissionGranted = await requestStoragePermission();
//
//       if (!permissionGranted) {
//         _showErrorDialog('Storage permission is required to download files.');
//         return null;
//       }
//
//       // Determine appropriate download directory
//       Directory? downloadDir;
//       String fileName = 'FIR_${DateTime.now().millisecondsSinceEpoch}.pdf';
//       String filePath;
//
//       if (Platform.isAndroid) {
//         // Use Downloads directory for Android
//         // This works without special permissions on Android 10+
//         downloadDir = Directory('/storage/emulated/0/Download');
//
//         // Fallback to app-specific directory if Downloads not accessible
//         if (!await downloadDir.exists()) {
//           downloadDir = await getExternalStorageDirectory();
//         }
//
//         if (downloadDir == null) {
//           _showErrorDialog('Could not access download directory');
//           return null;
//         }
//
//         filePath = '${downloadDir.path}/$fileName';
//       } else if (Platform.isIOS) {
//         // For iOS, use app documents directory
//         downloadDir = await getApplicationDocumentsDirectory();
//         filePath = '${downloadDir.path}/$fileName';
//       } else {
//         _showErrorDialog('Unsupported platform');
//         return null;
//       }
//
//       // Show loading indicator
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Downloading FIR...'),
//           duration: Duration(seconds: 30),
//         ),
//       );
//
//       // Download file
//       Dio dio = Dio();
//       await dio.download(
//         url,
//         filePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
//           }
//         },
//       );
//
//       // Dismiss loading snackbar
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//
//       // Show success message with open option
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('FIR downloaded successfully!'),
//           duration: const Duration(seconds: 5),
//           action: SnackBarAction(
//             label: 'Open',
//             onPressed: () async {
//               final result = await OpenFilex.open(filePath);
//
//               if (result.type == ResultType.error) {
//                 _showErrorDialog('Failed to open file: ${result.message}');
//               }
//             },
//           ),
//         ),
//       );
//
//       return filePath;
//     } catch (e) {
//       print('Download error: $e');
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       _showErrorDialog('Download failed: ${e.toString()}');
//       return null;
//     }
//   }
//
//   // Function to share the FIR PDF
//   Future<void> _sharePDF(String url) async {
//     try {
//       // Download the file first
//       final filePath = await _downloadPDFToExternal(url);
//
//       if (filePath != null) {
//         // Share the downloaded file
//         await Share.shareXFiles([XFile(filePath)], text: 'FIR Document');
//       }
//     } catch (e) {
//       _showErrorDialog('Share failed: ${e.toString()}');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _fetchFIRList(); // Load FIRs on initialization
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _bookNoController.dispose();
//     _formNoController.dispose();
//     _policeStationController.dispose();
//     _districtController.dispose();
//     _dateHourOccurrenceController.dispose();
//     _dateHourReportedController.dispose();
//     _informerNameController.dispose();
//     _descriptionOffenseController.dispose();
//     _placeOccurrenceController.dispose();
//     _criminalNameController.dispose();
//     _investigationStepsController.dispose();
//     _dispatchTimeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/ChatBotBackground.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Content with TabBar
//           Column(
//             children: [
//               TabBar(
//                 controller: _tabController,
//                 tabs: const [
//                   Tab(text: 'Generate FIR'),
//                   Tab(text: 'View FIRs'),
//                 ],
//                 labelColor: Colors.orange,
//                 unselectedLabelColor: Colors.black,
//                 indicatorColor: Colors.blue,
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildGenerateFIRForm(),
//                     _buildFIRListView(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget to display the FIR form
//   Widget _buildGenerateFIRForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(_bookNoController, 'Book Number'),
//             _buildTextField(_formNoController, 'Form Number'),
//             _buildTextField(_policeStationController, 'Police Station'),
//             _buildTextField(_districtController, 'District'),
//             _buildTextField(_dateHourOccurrenceController, 'Date/Hour of Occurrence'),
//             _buildTextField(_dateHourReportedController, 'Date/Hour Reported'),
//             _buildTextField(_informerNameController, 'Informer Name'),
//             _buildTextField(_descriptionOffenseController, 'Description of Offense'),
//             _buildTextField(_placeOccurrenceController, 'Place of Occurrence'),
//             _buildTextField(_criminalNameController, 'Criminal Name'),
//             _buildTextField(_investigationStepsController, 'Investigation Steps'),
//             _buildTextField(_dispatchTimeController, 'Dispatch Time'),
//             const SizedBox(height: 16.0),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                   textStyle: const TextStyle(fontSize: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: isLoading ? null : generateFIR,
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   'Generate FIR',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper function to create text fields with transparency
//   Widget _buildTextField(TextEditingController controller, String labelText) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: labelText,
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.7),
//           border: const OutlineInputBorder(),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'This field is required';
//           }
//           return null;
//         },
//       ),
//     );
//   }
//
//   // Widget to display FIRs
//   Widget _buildFIRListView() {
//     if (firList.isEmpty) {
//       return const Center(
//         child: Text(
//           'No FIRs available',
//           style: TextStyle(fontSize: 16),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(8.0),
//       itemCount: firList.length,
//       itemBuilder: (context, index) {
//         final firData = firList[index].data() as Map<String, dynamic>;
//         final firId = firList[index].id;
//         final downloadUrl = firData['url'];
//         final generatedAt = firData['generated_at'] as Timestamp;
//         final dateTime = generatedAt.toDate();
//         final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 8.0),
//           child: ListTile(
//             title: Text(
//               'FIR #${index + 1}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text('Generated at: $formattedDate'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.download, color: Colors.blue),
//                   onPressed: () => _downloadPDFToExternal(downloadUrl),
//                   tooltip: 'Download',
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.share, color: Colors.green),
//                   onPressed: () => _sharePDF(downloadUrl),
//                   tooltip: 'Share',
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     // Show confirmation dialog before deleting
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Delete FIR'),
//                         content: const Text('Are you sure you want to delete this FIR?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               _deleteFIR(firId);
//                             },
//                             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   tooltip: 'Delete',
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // KeepAliveWidget to maintain state across tabs
// class KeepAliveWidget extends StatefulWidget {
//   final Widget child;
//
//   const KeepAliveWidget({super.key, required this.child});
//
//   @override
//   _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
// }
//
// class _KeepAliveWidgetState extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return widget.child;
//   }
// }
//
// // PDF View Page
// class PDFViewPage extends StatelessWidget {
//   final String filePath;
//
//   const PDFViewPage({super.key, required this.filePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('View FIR PDF')),
//       body: PDFView(
//         filePath: filePath,
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class FirComponent extends StatefulWidget {
  const FirComponent({super.key});

  @override
  _FirComponentState createState() => _FirComponentState();
}

class _FirComponentState extends State<FirComponent> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool isLoading = false;

  // FIR details form fields
  final TextEditingController _bookNoController = TextEditingController();
  final TextEditingController _formNoController = TextEditingController();
  final TextEditingController _policeStationController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _dateHourOccurrenceController = TextEditingController();
  final TextEditingController _dateHourReportedController = TextEditingController();
  final TextEditingController _informerNameController = TextEditingController();
  final TextEditingController _descriptionOffenseController = TextEditingController();
  final TextEditingController _placeOccurrenceController = TextEditingController();
  final TextEditingController _criminalNameController = TextEditingController();
  final TextEditingController _investigationStepsController = TextEditingController();
  final TextEditingController _dispatchTimeController = TextEditingController();

  List<DocumentSnapshot> firList = [];

  Future<void> generateFIR() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final firDetails = {
      "book_no": _bookNoController.text,
      "form_no": _formNoController.text,
      "police_station": _policeStationController.text,
      "district": _districtController.text,
      "date_hour_occurrence": _dateHourOccurrenceController.text,
      "date_hour_reported": _dateHourReportedController.text,
      "informer_name": _informerNameController.text,
      "description_offense": _descriptionOffenseController.text,
      "place_occurrence": _placeOccurrenceController.text,
      "criminal_name": _criminalNameController.text,
      "investigation_steps": _investigationStepsController.text,
      "dispatch_time": _dispatchTimeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://aniudupa-fir-gen.hf.space/generate-fir/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(firDetails),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final downloadUrl = responseData['view_url'];

        if (downloadUrl != null && Uri.parse(downloadUrl).isAbsolute) {
          await _saveFIRToFirestore(downloadUrl);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text('FIR generated successfully!', style: GoogleFonts.poppins()),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          _tabController.animateTo(1);
          _clearForm();
        } else {
          _showErrorDialog('Invalid download URL received. Please contact support.');
        }
      } else {
        throw Exception('Failed to generate FIR: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showErrorDialog('Error occurred: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearForm() {
    _bookNoController.clear();
    _formNoController.clear();
    _policeStationController.clear();
    _districtController.clear();
    _dateHourOccurrenceController.clear();
    _dateHourReportedController.clear();
    _informerNameController.clear();
    _descriptionOffenseController.clear();
    _placeOccurrenceController.clear();
    _criminalNameController.clear();
    _investigationStepsController.clear();
    _dispatchTimeController.clear();
  }

  Future<void> _saveFIRToFirestore(String downloadUrl) async {
    try {
      final firCollection = FirebaseFirestore.instance.collection('fir');
      final newFIR = {
        "url": downloadUrl,
        "generated_at": Timestamp.now(),
      };
      await firCollection.add(newFIR);
      _fetchFIRList();
    } catch (e) {
      _showErrorDialog('Failed to save FIR: ${e.toString()}');
    }
  }

  Future<void> _fetchFIRList() async {
    try {
      final firCollection = FirebaseFirestore.instance.collection('fir');
      final querySnapshot = await firCollection.orderBy('generated_at', descending: true).get();
      setState(() {
        firList = querySnapshot.docs;
      });
    } catch (e) {
      _showErrorDialog('Error fetching FIR list: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.error_outline, color: Colors.red),
            ),
            const SizedBox(width: 12),
            Text('Error', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: GoogleFonts.roboto()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: GoogleFonts.poppins(color: const Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFIR(String firId) async {
    try {
      await FirebaseFirestore.instance.collection('fir').doc(firId).delete();
      _fetchFIRList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('FIR deleted successfully', style: GoogleFonts.poppins()),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      _showErrorDialog('Failed to delete FIR: ${e.toString()}');
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;
        if (sdkInt >= 33) return true;
        if (sdkInt >= 29) return true;
        final status = await Permission.storage.request();
        return status.isGranted;
      } catch (e) {
        print('Error checking Android version: $e');
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  Future<String?> _downloadPDFToExternal(String url) async {
    try {
      bool permissionGranted = await requestStoragePermission();
      if (!permissionGranted) {
        _showErrorDialog('Storage permission is required to download files.');
        return null;
      }

      Directory? downloadDir;
      String fileName = 'FIR_${DateTime.now().millisecondsSinceEpoch}.pdf';
      String filePath;

      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
        if (!await downloadDir.exists()) {
          downloadDir = await getExternalStorageDirectory();
        }
        if (downloadDir == null) {
          _showErrorDialog('Could not access download directory');
          return null;
        }
        filePath = '${downloadDir.path}/$fileName';
      } else if (Platform.isIOS) {
        downloadDir = await getApplicationDocumentsDirectory();
        filePath = '${downloadDir.path}/$fileName';
      } else {
        _showErrorDialog('Unsupported platform');
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text('Downloading FIR...', style: GoogleFonts.poppins()),
            ],
          ),
          backgroundColor: const Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 30),
        ),
      );

      Dio dio = Dio();
      await dio.download(url, filePath);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('FIR downloaded successfully!', style: GoogleFonts.poppins()),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.white,
            onPressed: () async {
              final result = await OpenFilex.open(filePath);
              if (result.type == ResultType.error) {
                _showErrorDialog('Failed to open file: ${result.message}');
              }
            },
          ),
        ),
      );

      return filePath;
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showErrorDialog('Download failed: ${e.toString()}');
      return null;
    }
  }

  Future<void> _sharePDF(String url) async {
    try {
      final filePath = await _downloadPDFToExternal(url);
      if (filePath != null) {
        await Share.shareXFiles([XFile(filePath)], text: 'FIR Document');
      }
    } catch (e) {
      _showErrorDialog('Share failed: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFIRList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bookNoController.dispose();
    _formNoController.dispose();
    _policeStationController.dispose();
    _districtController.dispose();
    _dateHourOccurrenceController.dispose();
    _dateHourReportedController.dispose();
    _informerNameController.dispose();
    _descriptionOffenseController.dispose();
    _placeOccurrenceController.dispose();
    _criminalNameController.dispose();
    _investigationStepsController.dispose();
    _dispatchTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Modern Tab Bar Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFEF4444),
              indicatorWeight: 3,
              labelColor: const Color(0xFFEF4444),
              unselectedLabelColor: Colors.grey[600],
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  icon: const Icon(Icons.add_box, size: 20),
                  text: 'Generate FIR',
                ),
                Tab(
                  icon: const Icon(Icons.library_books, size: 20),
                  text: 'View FIRs',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGenerateFIRForm(),
                _buildFIRListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateFIRForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New FIR',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fill in the details below',
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Fields
            _buildModernTextField(
              controller: _bookNoController,
              label: 'Book Number',
              icon: Icons.book,
              color: const Color(0xFFEF4444),
            ),
            _buildModernTextField(
              controller: _formNoController,
              label: 'Form Number',
              icon: Icons.format_list_numbered,
              color: const Color(0xFFEF4444),
            ),
            _buildModernTextField(
              controller: _policeStationController,
              label: 'Police Station',
              icon: Icons.local_police,
              color: const Color(0xFF3B82F6),
            ),
            _buildModernTextField(
              controller: _districtController,
              label: 'District',
              icon: Icons.location_city,
              color: const Color(0xFF3B82F6),
            ),
            _buildModernTextField(
              controller: _dateHourOccurrenceController,
              label: 'Date/Hour of Occurrence',
              icon: Icons.calendar_today,
              color: const Color(0xFF8B5CF6),
            ),
            _buildModernTextField(
              controller: _dateHourReportedController,
              label: 'Date/Hour Reported',
              icon: Icons.access_time,
              color: const Color(0xFF8B5CF6),
            ),
            _buildModernTextField(
              controller: _informerNameController,
              label: 'Informer Name',
              icon: Icons.person,
              color: const Color(0xFFF59E0B),
            ),
            _buildModernTextField(
              controller: _descriptionOffenseController,
              label: 'Description of Offense',
              icon: Icons.description_outlined,
              color: const Color(0xFFEF4444),
              maxLines: 3,
            ),
            _buildModernTextField(
              controller: _placeOccurrenceController,
              label: 'Place of Occurrence',
              icon: Icons.place,
              color: const Color(0xFF10B981),
            ),
            _buildModernTextField(
              controller: _criminalNameController,
              label: 'Criminal Name',
              icon: Icons.person_outline,
              color: const Color(0xFFEF4444),
            ),
            _buildModernTextField(
              controller: _investigationStepsController,
              label: 'Investigation Steps',
              icon: Icons.fact_check,
              color: const Color(0xFF3B82F6),
              maxLines: 3,
            ),
            _buildModernTextField(
              controller: _dispatchTimeController,
              label: 'Dispatch Time',
              icon: Icons.schedule,
              color: const Color(0xFF8B5CF6),
            ),

            const SizedBox(height: 24),

            // Generate Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : generateFIR,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Generate FIR',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.roboto(fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.roboto(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildFIRListView() {
    if (firList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No FIRs Available',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate your first FIR to see it here',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: firList.length,
      itemBuilder: (context, index) {
        final firData = firList[index].data() as Map<String, dynamic>;
        final firId = firList[index].id;
        final downloadUrl = firData['url'];
        final generatedAt = firData['generated_at'] as Timestamp;
        final dateTime = generatedAt.toDate();
        final formattedDate =
            '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    const Color(0xFFEF4444).withOpacity(0.02),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FIR #${index + 1}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  formattedDate,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey[200]),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.download,
                          label: 'Download',
                          color: const Color(0xFF3B82F6),
                          onTap: () => _downloadPDFToExternal(downloadUrl),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          color: const Color(0xFF10B981),
                          onTap: () => _sharePDF(downloadUrl),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.delete,
                          label: 'Delete',
                          color: const Color(0xFFEF4444),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Delete FIR',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Are you sure you want to delete this FIR? This action cannot be undone.',
                                  style: GoogleFonts.roboto(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteFIR(firId);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFEF4444),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// KeepAliveWidget to maintain state across tabs
class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({super.key, required this.child});

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// PDF View Page
class PDFViewPage extends StatelessWidget {
  final String filePath;

  const PDFViewPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View FIR PDF',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFEF4444),
        elevation: 0,
      ),
      body: PDFView(filePath: filePath),
    );
  }
}