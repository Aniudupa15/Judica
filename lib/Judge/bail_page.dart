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
//   // Form fields
//   String? statute;
//   String? offenseCategory;
//   String? penalty;
//   int? imprisonmentDurationServed;
//   int? riskOfEscape;
//   int? riskOfInfluence;
//   int? suretyBondRequired;
//   int? personalBondRequired;
//   int? finesApplicable;
//   int? servedHalfTerm;
//   int? bailEligibility;
//   double? riskScore;
//   double? penaltySeverity;
//
//   // Dropdown options
//   final List<String> statutes = ['NDPS', 'SCST Act', 'PMLA', 'CrPC', 'IPC'];
//   final List<String> offenseCategories = [
//     'Crimes Against Children',
//     'Offenses Against the State',
//     'Crimes Against Foreigners',
//     'Crimes Against SCs and STs',
//     'Cyber Crime',
//     'Economic Offense',
//     'Crimes Against Women'
//   ];
//   final List<String> penalties = ['Fine', 'Both', 'Imprisonment'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
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
//                         _buildDropdown('Statute', statutes, statute, (value) {
//                           setState(() => statute = value);
//                         }),
//                         const SizedBox(height: 16),
//                         _buildDropdown('Offense Category', offenseCategories, offenseCategory, (value) {
//                           setState(() => offenseCategory = value);
//                         }),
//                         const SizedBox(height: 16),
//                         _buildDropdown('Penalty', penalties, penalty, (value) {
//                           setState(() => penalty = value);
//                         }),
//                         const SizedBox(height: 16),
//                         _buildNumericInput(
//                           'Imprisonment Duration Served (in years)',
//                               (value) => imprisonmentDurationServed = int.tryParse(value),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildYesNoDropdown('Risk of Escape', (value) => riskOfEscape = value),
//                         const SizedBox(height: 16),
//                         _buildYesNoDropdown('Risk of Influence', (value) => riskOfInfluence = value),
//                         const SizedBox(height: 16),
//                         _buildYesNoDropdown('Surety Bond Required', (value) => suretyBondRequired = value),
//                         const SizedBox(height: 16),
//                         _buildYesNoDropdown('Personal Bond Required', (value) => personalBondRequired = value),
//                         const SizedBox(height: 16),
//                         _buildYesNoDropdown('Fines Applicable', (value) => finesApplicable = value),
//                         const SizedBox(height: 16),
//                         _buildYesNoDropdown('Served Half Term', (value) => servedHalfTerm = value),
//                         const SizedBox(height: 16),
//                         _buildNumericInput(
//                           'Risk Score',
//                               (value) => riskScore = double.tryParse(value),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildNumericInput(
//                           'Penalty Severity',
//                               (value) => penaltySeverity = double.tryParse(value),
//                         ),
//                         const SizedBox(height: 16),
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
//   Widget _buildDropdown(String label, List<String> items, String? currentValue, ValueChanged<String?> onChanged) {
//     return DropdownButtonFormField<String>(
//       initialValue: currentValue,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
//       onChanged: onChanged,
//       validator: (value) => value == null ? 'Please select $label' : null,
//     );
//   }
//
//   Widget _buildYesNoDropdown(String label, ValueChanged<int?> onChanged) {
//     return DropdownButtonFormField<int>(
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       items: [0, 1]
//           .map((value) => DropdownMenuItem(value: value, child: Text(value == 1 ? 'Yes' : 'No')))
//           .toList(),
//       onChanged: onChanged,
//       validator: (value) => value == null ? 'Please select $label' : null,
//     );
//   }
//
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
//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       _formKey.currentState!.save();
//
//       final payload = {
//         'statute': statute,
//         'offense_category': offenseCategory,
//         'penalty': penalty,
//         'imprisonment_duration_served': imprisonmentDurationServed,
//         'risk_of_escape': riskOfEscape,
//         'risk_of_influence': riskOfInfluence,
//         'surety_bond_required': suretyBondRequired,
//         'personal_bond_required': personalBondRequired,
//         'fines_applicable': finesApplicable,
//         'served_half_term': servedHalfTerm,
//         'risk_score': riskScore,
//         'penalty_severity': penaltySeverity,
//       };
//
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
//           _showResponseDialog({'Error': 'Failed to get response.'});
//         }
//       } catch (e) {
//         _showResponseDialog({'Error': e.toString()});
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   void _showResponseDialog(Map<String, dynamic> response) {
//     final isBailGranted = response['Eligible for Bail'] == 1;
//     final lottieAsset = isBailGranted ? 'assets/bail.json' : 'assets/no_bail.json';
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(isBailGranted ? 'Bail Granted' : 'Bail Denied'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Lottie.asset(lottieAsset, height: 150),
//               const SizedBox(height: 20),
//               ...response.entries.map((entry) {
//                 return Text('${entry.key}: ${entry.value}');
//               }),
//             ],
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

class Bailpage extends StatefulWidget {
  const Bailpage({super.key});

  @override
  State<Bailpage> createState() => _BailpageState();
}

class _BailpageState extends State<Bailpage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // --- NEW Form fields ---
  int? ipcSectionCount;
  bool? hasSpecialLaw; // Changed to nullable bool for the form
  String? bailType;
  bool? bailCancellationCase; // Changed to nullable bool for the form
  int? priorCasesCount;
  String? crimeType;
  // --- END NEW Form fields ---

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bail Eligibility Predictor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // Background Image (Assuming you have this asset)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/ChatBotBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        // New Fields
                        _buildNumericInput(
                          'IPC Section Count',
                              (value) => ipcSectionCount = int.tryParse(value),
                        ),
                        const SizedBox(height: 16),
                        _buildBooleanDropdown(
                          'Has Special Law',
                              (value) => setState(() => hasSpecialLaw = value == 1 ? true : (value == 0 ? false : null)),
                          hasSpecialLaw,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown('Bail Type', bailTypes, bailType, (value) {
                          setState(() => bailType = value);
                        }),
                        const SizedBox(height: 16),
                        _buildBooleanDropdown(
                          'Bail Cancellation Case',
                              (value) => setState(() => bailCancellationCase = value == 1 ? true : (value == 0 ? false : null)),
                          bailCancellationCase,
                        ),
                        const SizedBox(height: 16),
                        _buildNumericInput(
                          'Prior Cases Count',
                              (value) => priorCasesCount = int.tryParse(value),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown('Crime Type', crimeTypes, crimeType, (value) {
                          setState(() => crimeType = value);
                        }),
                        // Removed old fields
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for string dropdowns (reused)
  Widget _buildDropdown(String label, List<String> items, String? currentValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
    );
  }

  // Helper for numeric inputs (reused, slightly modified to use onSaved for simplicity)
  Widget _buildNumericInput(String label, ValueChanged<String> onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      onSaved: (value) => onSaved(value!),
    );
  }

  // New helper for boolean inputs (Yes/No representing true/false)
  Widget _buildBooleanDropdown(String label, ValueChanged<int?> onChanged, bool? currentValue) {
    return DropdownButtonFormField<int>(
      value: currentValue == null ? null : (currentValue ? 1 : 0),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: const [
        DropdownMenuItem(value: 1, child: Text('Yes')),
        DropdownMenuItem(value: 0, child: Text('No')),
      ],
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();

      // --- UPDATED Payload for the new fields ---
      final payload = {
        'ipc_section_count': ipcSectionCount,
        // Convert bool to int (1 for true, 0 for false) as is common in API payloads
        'has_special_law': hasSpecialLaw == true ? 1 : 0,
        'bail_type': bailType,
        'bail_cancellation_case': bailCancellationCase == true ? 1 : 0,
        'prior_cases_count': priorCasesCount,
        'crime_type': crimeType,
      };
      // --- END UPDATED Payload ---

      // NOTE: I've kept the original apiUrl. Update this if the endpoint has changed.
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
          // Attempt to show error from response body if available, otherwise generic
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
    // Check for 'Eligible for Bail' or a similar key in the new response
    // Assuming the API still returns 'Eligible for Bail' as 1 or 0
    final isBailGranted = response['Eligible for Bail'] == 1;
    final lottieAsset = isBailGranted ? 'assets/bail.json' : 'assets/no_bail.json';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isBailGranted ? 'Bail Granted! 🎉' : 'Bail Denied 😔'),
          content: SingleChildScrollView( // Added SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Check if Lottie asset exists or replace with a fallback
                // NOTE: Lottie.asset might fail if the asset files are not in the pubspec.yaml
                // I'll keep it as is, assuming the assets are configured.
                Lottie.asset(lottieAsset, height: 150, repeat: false),
                const SizedBox(height: 20),
                ...response.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}