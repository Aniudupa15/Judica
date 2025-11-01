// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';
//
// class Bailpage extends StatefulWidget {
//   const Bailpage({super.key});
//
//   @override
//   State<Bailpage> createState() => _BailpageState();
// }
//
// class _BailpageState extends State<Bailpage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   // --- NEW Form fields ---
//   int? ipcSectionCount;
//   bool? hasSpecialLaw; // Changed to nullable bool for the form
//   String? bailType;
//   bool? bailCancellationCase; // Changed to nullable bool for the form
//   int? priorCasesCount;
//   String? crimeType;
//   // --- END NEW Form fields ---
//
//   // Dropdown options
//   final List<String> bailTypes = [
//     'Anticipatory',
//     'Interim',
//     'Not applicable',
//     'Others',
//     'Regular',
//     'Unknown'
//   ];
//   final List<String> crimeTypes = [
//     'Attempt to Murder',
//     'Cyber Crime',
//     'Domestic Violence',
//     'Dowry Harassment',
//     'Extortion',
//     'Fraud or Cheating',
//     'Kidnapping',
//     'Murder',
//     'Narcotics',
//     'Others',
//     'Sexual Offense',
//     'Theft or Robbery'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bail Eligibility Predictor'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Stack(
//         children: [
//           // Background Image (Assuming you have this asset)
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/ChatBotBackground.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Stack(
//                 children: [
//                   SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const SizedBox(height: 20),
//                         // New Fields
//                         _buildNumericInput(
//                           'IPC Section Count',
//                               (value) => ipcSectionCount = int.tryParse(value),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildBooleanDropdown(
//                           'Has Special Law',
//                               (value) => setState(() => hasSpecialLaw = value == 1 ? true : (value == 0 ? false : null)),
//                           hasSpecialLaw,
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDropdown('Bail Type', bailTypes, bailType, (value) {
//                           setState(() => bailType = value);
//                         }),
//                         const SizedBox(height: 16),
//                         _buildBooleanDropdown(
//                           'Bail Cancellation Case',
//                               (value) => setState(() => bailCancellationCase = value == 1 ? true : (value == 0 ? false : null)),
//                           bailCancellationCase,
//                         ),
//                         const SizedBox(height: 16),
//                         _buildNumericInput(
//                           'Prior Cases Count',
//                               (value) => priorCasesCount = int.tryParse(value),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDropdown('Crime Type', crimeTypes, crimeType, (value) {
//                           setState(() => crimeType = value);
//                         }),
//                         // Removed old fields
//                         const SizedBox(height: 32),
//                         ElevatedButton(
//                           onPressed: _isLoading ? null : _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                             textStyle: const TextStyle(fontSize: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Text(
//                             'Submit',
//                             style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                   if (_isLoading)
//                     Positioned.fill(
//                       child: Container(
//                         // ignore: deprecated_member_use
//                         color: Colors.black.withOpacity(0.5),
//                         child: const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Helper for string dropdowns (reused)
//   Widget _buildDropdown(String label, List<String> items, String? currentValue, ValueChanged<String?> onChanged) {
//     return DropdownButtonFormField<String>(
//       value: currentValue,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
//       onChanged: onChanged,
//       validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
//     );
//   }
//
//   // Helper for numeric inputs (reused, slightly modified to use onSaved for simplicity)
//   Widget _buildNumericInput(String label, ValueChanged<String> onSaved) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       keyboardType: TextInputType.number,
//       validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
//       onSaved: (value) => onSaved(value!),
//     );
//   }
//
//   // New helper for boolean inputs (Yes/No representing true/false)
//   Widget _buildBooleanDropdown(String label, ValueChanged<int?> onChanged, bool? currentValue) {
//     return DropdownButtonFormField<int>(
//       value: currentValue == null ? null : (currentValue ? 1 : 0),
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       items: const [
//         DropdownMenuItem(value: 1, child: Text('Yes')),
//         DropdownMenuItem(value: 0, child: Text('No')),
//       ],
//       onChanged: onChanged,
//       validator: (value) => value == null ? 'Please select $label' : null,
//     );
//   }
//
//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       _formKey.currentState!.save();
//
//       // --- UPDATED Payload for the new fields ---
//       final payload = {
//         'ipc_section_count': ipcSectionCount,
//         // Convert bool to int (1 for true, 0 for false) as is common in API payloads
//         'has_special_law': hasSpecialLaw == true ? 1 : 0,
//         'bail_type': bailType,
//         'bail_cancellation_case': bailCancellationCase == true ? 1 : 0,
//         'prior_cases_count': priorCasesCount,
//         'crime_type': crimeType,
//       };
//       // --- END UPDATED Payload ---
//
//       // NOTE: I've kept the original apiUrl. Update this if the endpoint has changed.
//       const apiUrl = 'https://aniudupa-fir-gen.hf.space/bail-reckoner/predict-bail';
//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode(payload),
//         );
//
//         if (response.statusCode == 200) {
//           final responseData = json.decode(response.body);
//           _showResponseDialog(responseData);
//         } else {
//           // Attempt to show error from response body if available, otherwise generic
//           final errorBody = json.decode(response.body)['detail'] ?? 'Failed with status: ${response.statusCode}';
//           _showResponseDialog({'Error': errorBody});
//         }
//       } catch (e) {
//         _showResponseDialog({'Error': 'Network or processing error: ${e.toString()}'});
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   void _showResponseDialog(Map<String, dynamic> response) {
//     // Check for 'Eligible for Bail' or a similar key in the new response
//     // Assuming the API still returns 'Eligible for Bail' as 1 or 0
//     final isBailGranted = response['Eligible for Bail'] == 1;
//     final lottieAsset = isBailGranted ? 'assets/bail.json' : 'assets/no_bail.json';
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(isBailGranted ? 'Bail Granted! 🎉' : 'Bail Denied 😔'),
//           content: SingleChildScrollView( // Added SingleChildScrollView
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Check if Lottie asset exists or replace with a fallback
//                 // NOTE: Lottie.asset might fail if the asset files are not in the pubspec.yaml
//                 // I'll keep it as is, assuming the assets are configured.
//                 Lottie.asset(lottieAsset, height: 150, repeat: false),
//                 const SizedBox(height: 20),
//                 ...response.entries.map((entry) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: Text(
//                       '${entry.key}: ${entry.value}',
//                       textAlign: TextAlign.start,
//                       style: const TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Bailpage extends StatefulWidget {
  const Bailpage({super.key});

  @override
  State<Bailpage> createState() => _BailpageState();
}

class _BailpageState extends State<Bailpage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _animController;

  // Form fields
  int? ipcSectionCount;
  bool? hasSpecialLaw;
  String? bailType;
  bool? bailCancellationCase;
  int? priorCasesCount;
  String? crimeType;

  // Dropdown options
  final List<String> bailTypes = [
    'Anticipatory',
    'Interim',
    'Not applicable',
    'Others',
    'Regular',
    'Unknown'
  ];
  final List<String> crimeTypes = [
    'Attempt to Murder',
    'Cyber Crime',
    'Domestic Violence',
    'Dowry Harassment',
    'Extortion',
    'Fraud or Cheating',
    'Kidnapping',
    'Murder',
    'Narcotics',
    'Others',
    'Sexual Offense',
    'Theft or Robbery'
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 600),
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
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
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
                              child: const Icon(
                                Icons.gavel,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bail Assessment',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Complete the form below',
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
                    ),
                    const SizedBox(height: 24),

                    // Form Fields with staggered animation
                    _buildAnimatedField(
                      delay: 100,
                      child: _buildNumericInput(
                        'IPC Section Count',
                        Icons.numbers,
                        const Color(0xFF8B5CF6),
                            (value) => ipcSectionCount = int.tryParse(value),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildAnimatedField(
                      delay: 150,
                      child: _buildBooleanDropdown(
                        'Has Special Law',
                        Icons.policy,
                        const Color(0xFFEF4444),
                            (value) => setState(() => hasSpecialLaw = value == 1 ? true : (value == 0 ? false : null)),
                        hasSpecialLaw,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildAnimatedField(
                      delay: 200,
                      child: _buildDropdown(
                        'Bail Type',
                        Icons.description,
                        const Color(0xFF3B82F6),
                        bailTypes,
                        bailType,
                            (value) => setState(() => bailType = value),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildAnimatedField(
                      delay: 250,
                      child: _buildBooleanDropdown(
                        'Bail Cancellation Case',
                        Icons.cancel,
                        const Color(0xFFF59E0B),
                            (value) => setState(() => bailCancellationCase = value == 1 ? true : (value == 0 ? false : null)),
                        bailCancellationCase,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildAnimatedField(
                      delay: 300,
                      child: _buildNumericInput(
                        'Prior Cases Count',
                        Icons.history,
                        const Color(0xFF10B981),
                            (value) => priorCasesCount = int.tryParse(value),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildAnimatedField(
                      delay: 350,
                      child: _buildDropdown(
                        'Crime Type',
                        Icons.warning,
                        const Color(0xFFEF4444),
                        crimeTypes,
                        crimeType,
                            (value) => setState(() => crimeType = value),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    _buildAnimatedField(
                      delay: 400,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _submitForm,
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: _isLoading
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
                                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Check Eligibility',
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
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedField({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildNumericInput(
      String label,
      IconData icon,
      Color color,
      ValueChanged<String> onSaved,
      ) {
    return Container(
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
        style: GoogleFonts.roboto(fontSize: 15),
        keyboardType: TextInputType.number,
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
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      IconData icon,
      Color color,
      List<String> items,
      String? currentValue,
      ValueChanged<String?> onChanged,
      ) {
    return Container(
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
      child: DropdownButtonFormField<String>(
        value: currentValue,
        style: GoogleFonts.roboto(fontSize: 15, color: Colors.black87),
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
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildBooleanDropdown(
      String label,
      IconData icon,
      Color color,
      ValueChanged<int?> onChanged,
      bool? currentValue,
      ) {
    return Container(
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
      child: DropdownButtonFormField<int>(
        value: currentValue == null ? null : (currentValue ? 1 : 0),
        style: GoogleFonts.roboto(fontSize: 15, color: Colors.black87),
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
        items: const [
          DropdownMenuItem(value: 1, child: Text('Yes')),
          DropdownMenuItem(value: 0, child: Text('No')),
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();

      final payload = {
        'ipc_section_count': ipcSectionCount,
        'has_special_law': hasSpecialLaw == true ? 1 : 0,
        'bail_type': bailType,
        'bail_cancellation_case': bailCancellationCase == true ? 1 : 0,
        'prior_cases_count': priorCasesCount,
        'crime_type': crimeType,
      };

      const apiUrl = 'https://aniudupa-fir-gen.hf.space/bail-reckoner/predict-bail';
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          _showResponseDialog(responseData);
        } else {
          final errorBody = json.decode(response.body)['detail'] ?? 'Failed with status: ${response.statusCode}';
          _showResponseDialog({'Error': errorBody});
        }
      } catch (e) {
        _showResponseDialog({'Error': 'Network or processing error: ${e.toString()}'});
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showResponseDialog(Map<String, dynamic> response) {
    final isBailGranted = response['Eligible for Bail'] == 1;
    final lottieAsset = isBailGranted ? 'assets/bail.json' : 'assets/no_bail.json';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isBailGranted
                          ? [const Color(0xFF10B981), const Color(0xFF34D399)]
                          : [const Color(0xFFEF4444), const Color(0xFFF87171)],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isBailGranted ? Icons.check_circle : Icons.cancel,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isBailGranted ? 'Bail Granted! 🎉' : 'Bail Denied 😔',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        lottieAsset,
                        height: 150,
                        repeat: false,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            isBailGranted ? Icons.check_circle : Icons.cancel,
                            size: 100,
                            color: isBailGranted ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ...response.entries.map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${entry.value}',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                // Footer Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isBailGranted
                            ? [const Color(0xFF10B981), const Color(0xFF34D399)]
                            : [const Color(0xFFEF4444), const Color(0xFFF87171)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Text(
                            'OK',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}