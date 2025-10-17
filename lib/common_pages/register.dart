// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:judica/common_pages/login.dart';
//
// import '../l10n/app_localizations.dart';
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;
//   String selectedRole = 'Citizen'; // Changed to lowercase constant
//   bool isLoading = false;
//
//   @override
//   void dispose() {
//     usernameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void register() async {
//     print('=== REGISTRATION STARTED ===');
//
//     // Validate fields
//     if (usernameController.text.trim().isEmpty) {
//       displayMessageToUser('Username cannot be empty');
//       return;
//     }
//
//     if (emailController.text.trim().isEmpty) {
//       displayMessageToUser('Email cannot be empty');
//       return;
//     }
//
//     if (passwordController.text != confirmPasswordController.text) {
//       displayMessageToUser(AppLocalizations.of(context)!.passworddont);
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       print('Creating Firebase Auth user...');
//       UserCredential userCredential =
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text,
//       );
//       print('Firebase Auth user created: ${userCredential.user?.uid}');
//       print('User email: ${userCredential.user?.email}');
//
//       print('Calling createUserDocument...');
//       await createUserDocument(userCredential);
//       print('createUserDocument completed');
//
//       if (context.mounted) {
//         Navigator.pop(context);
//         displayMessageToUser(AppLocalizations.of(context)!.regsuccess);
//       }
//     } on FirebaseAuthException catch (e) {
//       print('FirebaseAuthException: ${e.code} - ${e.message}');
//       String message;
//       switch (e.code) {
//         case 'weak-password':
//           message = AppLocalizations.of(context)!.passwordtooweak;
//           break;
//         case 'email-already-in-use':
//           message = AppLocalizations.of(context)!.alreadyexist;
//           break;
//         case 'invalid-email':
//           message = AppLocalizations.of(context)!.notvalid;
//           break;
//         default:
//           message = AppLocalizations.of(context)!.error;
//       }
//       displayMessageToUser(message);
//     } catch (e, stackTrace) {
//       print('Registration error: $e');
//       print('Stack trace: $stackTrace');
//       displayMessageToUser('${AppLocalizations.of(context)!.error}: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//       print('=== REGISTRATION ENDED ===');
//     }
//   }
//
//   Future<void> createUserDocument(UserCredential userCredential) async {
//     print('=== CREATE USER DOCUMENT STARTED ===');
//
//     if (userCredential.user == null) {
//       print('ERROR: userCredential.user is null!');
//       throw Exception('User credential is null');
//     }
//     final user = userCredential.user!;
//     final email = user.email;
//     final username = usernameController.text.trim();
//     final role = selectedRole;
//
//     print('User ID: ${user.uid}');
//     print('Email: $email');
//     print('Username: $username');
//     print('Role: $role');
//
//     if (email == null || email.isEmpty) {
//       print('ERROR: Email is null or empty!');
//       throw Exception('User email is null or empty');
//     }
//
//     try {
//       print('Attempting to write to Firestore...');
//       print('Collection: users');
//       print('Document ID: $email');
//
//       final docRef = FirebaseFirestore.instance
//           .collection("users")
//           .doc(email);
//
//       print('Document reference created: ${docRef.path}');
//
//       final data = {
//         'email': email,
//         'username': username,
//         'role': role,
//         'createdAt': FieldValue.serverTimestamp(),
//         'uid': user.uid,
//       };
//
//       print('Data to be written: $data');
//
//       await docRef.set(data);
//
//       print('✓ Firestore write successful!');
//
//       // Verify the document was written
//       final docSnapshot = await docRef.get();
//       if (docSnapshot.exists) {
//         print('✓ Document verified in Firestore: ${docSnapshot.data()}');
//       } else {
//         print('WARNING: Document not found after write!');
//       }
//
//     } catch (e, stackTrace) {
//       print('ERROR writing to Firestore: $e');
//       print('Stack trace: $stackTrace');
//
//       if (e.toString().contains('PERMISSION_DENIED')) {
//         print('PERMISSION ERROR: Check your Firestore security rules!');
//       }
//
//       rethrow;
//     }
//
//     print('=== CREATE USER DOCUMENT COMPLETED ===');
//   }
//
//   void displayMessageToUser(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.judica),
//         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
//       ),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: AbsorbPointer(
//         absorbing: isLoading,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/Background.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 150,
//                     height: 150,
//                     decoration: const BoxDecoration(
//                       color: Color.fromRGBO(255, 238, 169, 1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       size: 100,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildTextField(usernameController, AppLocalizations.of(context)!.username, Icons.person_2_outlined),
//                   const SizedBox(height: 20),
//                   _buildTextField(
//                     emailController,
//                     AppLocalizations.of(context)!.email,
//                     Icons.email_outlined,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 20),
//                   _buildTextField(
//                     passwordController,
//                     AppLocalizations.of(context)!.password,
//                     Icons.lock_outline,
//                     obscureText: !isPasswordVisible,
//                     toggleVisibility: () {
//                       setState(() {
//                         isPasswordVisible = !isPasswordVisible;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _buildTextField(
//                     confirmPasswordController,
//                     AppLocalizations.of(context)!.confirmpassword,
//                     Icons.lock_outline,
//                     obscureText: !isConfirmPasswordVisible,
//                     toggleVisibility: () {
//                       setState(() {
//                         isConfirmPasswordVisible = !isConfirmPasswordVisible;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _buildRoleDropdown(),
//                   const SizedBox(height: 20),
//                   _buildRegisterButton(),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.haveanaccount,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => LoginPage()),
//                           );
//                         },
//                         child: Text(
//                           AppLocalizations.of(context)!.login,
//                           style: const TextStyle(color: Colors.blue),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String hintText,
//       IconData icon, {
//         bool obscureText = false,
//         VoidCallback? toggleVisibility,
//         TextInputType keyboardType = TextInputType.text,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           suffixIcon: toggleVisibility != null
//               ? IconButton(
//             icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//             onPressed: toggleVisibility,
//           )
//               : null,
//           labelText: hintText,
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//           ),
//           prefixIcon: Icon(icon),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRoleDropdown() {
//     // Map of internal constant values to localized display labels
//     final roles = {
//       'Citizen': AppLocalizations.of(context)!.citizen,
//       'Judge': AppLocalizations.of(context)!.police,
//       'Police': AppLocalizations.of(context)!.advocate,
//     };
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: selectedRole,
//         hint: Text(AppLocalizations.of(context)!.selectrole),
//         onChanged: (String? value) {
//           setState(() {
//             selectedRole = value!;
//           });
//         },
//         decoration: const InputDecoration(
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//           ),
//         ),
//         items: roles.entries
//             .map((entry) => DropdownMenuItem(
//           value: entry.key, // Store constant value in database
//           child: Text(entry.value), // Display localized text
//         ))
//             .toList(),
//       ),
//     );
//   }
//
//   Widget _buildRegisterButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : register,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color.fromRGBO(255, 125, 41, 1),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: isLoading
//             ? const CircularProgressIndicator(color: Colors.white)
//             : Text(AppLocalizations.of(context)!.register),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judica/common_pages/login.dart';

import '../l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String selectedRole = 'Citizen';
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() async {
    print('=== REGISTRATION STARTED ===');

    // Validate fields
    if (usernameController.text.trim().isEmpty) {
      displayMessageToUser('Username cannot be empty');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      displayMessageToUser('Email cannot be empty');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      displayMessageToUser(AppLocalizations.of(context)!.passworddont);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('Creating Firebase Auth user...');
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      print('Firebase Auth user created: ${userCredential.user?.uid}');
      print('User email: ${userCredential.user?.email}');

      print('Calling createUserDocument...');
      await createUserDocument(userCredential);
      print('createUserDocument completed');

      if (context.mounted) {
        Navigator.pop(context);
        // Show different message based on role
        if (selectedRole == 'Judge' || selectedRole == 'Police') {
          displayMessageToUser('Registration successful! Your account is pending approval.');
        } else {
          displayMessageToUser(AppLocalizations.of(context)!.regsuccess);
        }
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'weak-password':
          message = AppLocalizations.of(context)!.passwordtooweak;
          break;
        case 'email-already-in-use':
          message = AppLocalizations.of(context)!.alreadyexist;
          break;
        case 'invalid-email':
          message = AppLocalizations.of(context)!.notvalid;
          break;
        default:
          message = AppLocalizations.of(context)!.error;
      }
      displayMessageToUser(message);
    } catch (e, stackTrace) {
      print('Registration error: $e');
      print('Stack trace: $stackTrace');
      displayMessageToUser('${AppLocalizations.of(context)!.error}: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
      print('=== REGISTRATION ENDED ===');
    }
  }

  Future<void> createUserDocument(UserCredential userCredential) async {
    print('=== CREATE USER DOCUMENT STARTED ===');

    if (userCredential.user == null) {
      print('ERROR: userCredential.user is null!');
      throw Exception('User credential is null');
    }
    final user = userCredential.user!;
    final email = user.email;
    final username = usernameController.text.trim();
    final role = selectedRole;

    print('User ID: ${user.uid}');
    print('Email: $email');
    print('Username: $username');
    print('Role: $role');

    if (email == null || email.isEmpty) {
      print('ERROR: Email is null or empty!');
      throw Exception('User email is null or empty');
    }

    try {
      print('Attempting to write to Firestore...');
      print('Collection: users');
      print('Document ID: $email');

      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(email);

      print('Document reference created: ${docRef.path}');

      // Determine if approval is needed
      bool requiresApproval = (role == 'Judge' || role == 'Police');
      String approvalStatus = requiresApproval ? 'pending' : 'approved';

      final data = {
        'email': email,
        'username': username,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
        'isApproved': !requiresApproval, // Boolean: true for Citizen, false for Judge/Police
        'approvalStatus': approvalStatus, // String: 'approved', 'pending', or 'rejected'
      };

      print('Data to be written: $data');

      await docRef.set(data);

      print('✓ Firestore write successful!');

      // Verify the document was written
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        print('✓ Document verified in Firestore: ${docSnapshot.data()}');
      } else {
        print('WARNING: Document not found after write!');
      }

    } catch (e, stackTrace) {
      print('ERROR writing to Firestore: $e');
      print('Stack trace: $stackTrace');

      if (e.toString().contains('PERMISSION_DENIED')) {
        print('PERMISSION ERROR: Check your Firestore security rules!');
      }

      rethrow;
    }

    print('=== CREATE USER DOCUMENT COMPLETED ===');
  }

  void displayMessageToUser(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.judica),
        backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/Background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 238, 169, 1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(usernameController, AppLocalizations.of(context)!.username, Icons.person_2_outlined),
                  const SizedBox(height: 20),
                  _buildTextField(
                    emailController,
                    AppLocalizations.of(context)!.email,
                    Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    passwordController,
                    AppLocalizations.of(context)!.password,
                    Icons.lock_outline,
                    obscureText: !isPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    confirmPasswordController,
                    AppLocalizations.of(context)!.confirmpassword,
                    Icons.lock_outline,
                    obscureText: !isConfirmPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildRoleDropdown(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.haveanaccount,
                        style: const TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hintText,
      IconData icon, {
        bool obscureText = false,
        VoidCallback? toggleVisibility,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: toggleVisibility != null
              ? IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          )
              : null,
          labelText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    // Map of internal constant values to localized display labels
    final roles = {
      'Citizen': AppLocalizations.of(context)!.citizen,
      'Judge': AppLocalizations.of(context)!.police,
      'Police': AppLocalizations.of(context)!.advocate,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        hint: Text(AppLocalizations.of(context)!.selectrole),
        onChanged: (String? value) {
          setState(() {
            selectedRole = value!;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),
        items: roles.entries
            .map((entry) => DropdownMenuItem(
          value: entry.key, // Store constant value in database
          child: Text(entry.value), // Display localized text
        ))
            .toList(),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(255, 125, 41, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(AppLocalizations.of(context)!.register),
      ),
    );
  }
}