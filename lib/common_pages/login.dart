// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:judica/Judge/judge_home.dart';
// import 'package:judica/auth/admin_page.dart';
// import 'package:judica/police/police_home.dart';
// import 'package:judica/common_pages/register.dart';
// import 'package:judica/user/user_home.dart';
// import 'package:judica/common_pages/forgot_password.dart';
// import '../auth/auth_services.dart';
// import '../l10n/app_localizations.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;
//
//   // Login function
//   Future<void> login() async {
//     if (!_validateFields()) return;
//
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userCredential.user?.email)
//           .get();
//
//       if (userDoc.exists && userDoc.data() != null) {
//         Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//         String role = userData['role'] ?? '';
//
//         // Check approval status for Judge and Police roles
//         if (role == 'Judge' || role == 'Police') {
//           bool isApproved = userData['isApproved'] ?? false;
//           String approvalStatus = userData['approvalStatus'] ?? 'pending';
//
//           if (!isApproved || approvalStatus != 'approved') {
//             // Sign out the user
//             await FirebaseAuth.instance.signOut();
//
//             // Show appropriate message based on status
//             if (approvalStatus == 'rejected') {
//               _displayMessageToUser('Your account has been rejected. Please contact support.');
//             } else {
//               _displayMessageToUser('Your account is pending approval. Please wait for admin verification.');
//             }
//             return;
//           }
//         }
//
//         // If approved or Citizen/Admin, navigate to home
//         _navigateToHome(role);
//       } else {
//         _displayMessageToUser(AppLocalizations.of(context)!.usernotfound);
//       }
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'user-not-found':
//           message = 'No user found with this email.';
//           break;
//         case 'wrong-password':
//           message = 'Incorrect password.';
//           break;
//         case 'invalid-email':
//           message = 'Invalid email address.';
//           break;
//         case 'user-disabled':
//           message = 'This account has been disabled.';
//           break;
//         default:
//           message = 'Error: ${e.message}';
//       }
//       _displayMessageToUser(message);
//     } catch (e) {
//       _displayMessageToUser('Error: ${e.toString()}');
//     }
//   }
//
//   bool _validateFields() {
//     if (emailController.text.trim().isEmpty) {
//       _displayMessageToUser(AppLocalizations.of(context)!.cannotemail);
//       return false;
//     }
//     if (passwordController.text.trim().isEmpty) {
//       _displayMessageToUser(AppLocalizations.of(context)!.cannotpasswort);
//       return false;
//     }
//     return true;
//   }
//
//   void _navigateToHome(String role) {
//     Widget? homePage;
//     switch (role) {
//       case 'Citizen':
//         homePage = const UserHome();
//         break;
//       case 'Police':
//         homePage = const PoliceHome();
//         break;
//       case 'Judge':
//         homePage = const AdvocateHome();
//         break;
//       case 'Admin':
//         homePage = const AdminPage();
//         break;
//       default:
//         _displayMessageToUser(AppLocalizations.of(context)!.usernotfound);
//         return;
//     }
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => homePage!),
//     );
//   }
//
//   void _displayMessageToUser(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }
//
//
//   OutlineInputBorder _buildBorder() {
//     return const OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.black),
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(12),
//         bottomRight: Radius.circular(12),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Judica"),
//         backgroundColor: const Color.fromRGBO(255, 165, 89, 1),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/Background.jpg', fit: BoxFit.cover),
//           SingleChildScrollView(
//             padding: const EdgeInsets.only(top: 150.0, left: 10, right: 10),
//             child: Column(
//               children: [
//                 _buildAvatar(),
//                 const SizedBox(height: 20),
//                 _buildTextField(emailController, 'Email', Icons.person_outline),
//                 const SizedBox(height: 20),
//                 _buildTextField(passwordController, 'Password', Icons.lock_outline, true),
//                 _buildForgotPassword(),
//                 const SizedBox(height: 20),
//                 _buildLoginButton(),
//                 const SizedBox(height: 20),
//                 _buildSocialLogin(),
//                 const SizedBox(height: 20),
//                 _buildRegisterLink(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAvatar() {
//     return Container(
//       width: 150,
//       height: 150,
//       decoration: const BoxDecoration(
//         color: Color.fromRGBO(255, 238, 169, 1),
//         shape: BoxShape.circle,
//       ),
//       child: const Icon(Icons.person, size: 100),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hintText,
//       IconData icon, [bool obscureText = false]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText && !_isPasswordVisible,
//         decoration: InputDecoration(
//           suffixIcon: obscureText
//               ? IconButton(
//             icon: Icon(
//               _isPasswordVisible
//                   ? Icons.visibility
//                   : Icons.visibility_off,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isPasswordVisible = !_isPasswordVisible;
//               });
//             },
//           )
//               : Icon(icon),
//           hintText: hintText,
//           enabledBorder: _buildBorder(),
//           focusedBorder: _buildBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForgotPassword() {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
//         );
//       },
//       child: const Align(
//         alignment: Alignment.centerRight,
//         child: Text("Forgot Password?", style: TextStyle(color: Colors.black)),
//       ),
//     );
//   }
//
//   Widget _buildLoginButton() {
//     return SizedBox(
//       width: 200,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: login,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color.fromRGBO(251, 146, 60, 1),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: const Text('Log In →', style: TextStyle(fontSize: 18)),
//       ),
//     );
//   }
//
//   Widget _buildSocialLogin() {
//     return Column(
//       children: [
//         Text(
//           "Continue",
//           style: TextStyle(color: Colors.black),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 setState(() {
//                   _isLoading = true;
//                 });
//                 try {
//                   await AuthServices().signInWithGoogle(context);
//                 } catch (e) {
//                   _displayMessageToUser('Error: ${e.toString()}');
//                   print("hello ${e.toString()}");
//                 } finally {
//                   if (mounted) {
//                     setState(() {
//                       _isLoading = false;
//                     });
//                   }
//                 }
//               },
//               child: _isLoading
//                   ? const SpinKitCircle(
//                 color: Color.fromRGBO(251, 146, 60, 1),
//                 size: 50.0,
//               )
//                   : Image.asset('assets/google.png', width: 50),
//             ),
//             const SizedBox(width: 25),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRegisterLink() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(AppLocalizations.of(context)!.account),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const RegisterPage()),
//             );
//           },
//           child: Text(
//             AppLocalizations.of(context)!.sign,
//             style: TextStyle(color: Colors.blue),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:judica/Judge/judge_home.dart';
import 'package:judica/auth/admin_page.dart';
import 'package:judica/police/police_home.dart';
import 'package:judica/common_pages/register.dart';
import 'package:judica/user/user_home.dart';
import 'package:judica/common_pages/forgot_password.dart';
import '../auth/auth_services.dart';
import '../l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user?.email)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String role = userData['role'] ?? '';

        // Check approval status for Judge and Police roles
        if (role == 'Judge' || role == 'Police') {
          bool isApproved = userData['isApproved'] ?? false;
          String approvalStatus = userData['approvalStatus'] ?? 'pending';

          if (!isApproved || approvalStatus != 'approved') {
            await FirebaseAuth.instance.signOut();

            if (approvalStatus == 'rejected') {
              _displayMessageToUser('Your account has been rejected. Please contact support.');
            } else {
              _displayMessageToUser('Your account is pending approval. Please wait for admin verification.');
            }
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }

        _navigateToHome(role);
      } else {
        _displayMessageToUser(AppLocalizations.of(context)!.usernotfound);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        default:
          message = 'Error: ${e.message}';
      }
      _displayMessageToUser(message);
    } catch (e) {
      _displayMessageToUser('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToHome(String role) {
    Widget? homePage;
    switch (role) {
      case 'Citizen':
        homePage = const UserHome();
        break;
      case 'Police':
        homePage = const PoliceHome();
        break;
      case 'Judge':
        homePage = const AdvocateHome();
        break;
      case 'Admin':
        homePage = const AdminPage();
        break;
      default:
        _displayMessageToUser(AppLocalizations.of(context)!.usernotfound);
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage!),
    );
  }

  void _displayMessageToUser(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          _buildHeader(),
                          const SizedBox(height: 48),
                          _buildEmailField(),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 12),
                          _buildForgotPassword(),
                          const SizedBox(height: 32),
                          _buildLoginButton(),
                          const SizedBox(height: 24),
                          _buildDivider(),
                          const SizedBox(height: 24),
                          _buildSocialLogin(),
                          const Spacer(),
                          _buildRegisterLink(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF4A5FE8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.gavel,
                color: Color(0xFF4A5FE8),
                size: 36,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Judica',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5FE8),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue to Judica',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4A5FE8), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4A5FE8), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Color(0xFF4A5FE8),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A5FE8),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isGoogleLoading
                ? null
                : () async {
              setState(() {
                _isGoogleLoading = true;
              });
              try {
                await AuthServices().signInWithGoogle(context);
              } catch (e) {
                _displayMessageToUser('Error: ${e.toString()}');
              } finally {
                if (mounted) {
                  setState(() {
                    _isGoogleLoading = false;
                  });
                }
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: _isGoogleLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFF4A5FE8),
                  strokeWidth: 2.5,
                ),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/google.png', width: 26, height: 26),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.account,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.sign,
              style: const TextStyle(
                color: Color(0xFF4A5FE8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}