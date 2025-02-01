import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judica/common_pages/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  String selectedRole = 'Citizen'; // Default role
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
    if (passwordController.text != confirmPasswordController.text) {
      displayMessageToUser(AppLocalizations.of(context)!.passworddont);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await createUserDocument(userCredential);

      if (context.mounted) {
        Navigator.pop(context);
        displayMessageToUser(AppLocalizations.of(context)!.regsuccess);
      }
    } on FirebaseAuthException catch (e) {
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
    } catch (e) {
      displayMessageToUser(AppLocalizations.of(context)!.error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createUserDocument(UserCredential userCredential) async {
    if (userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'role': selectedRole,
      });
    }
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
                          style:const  TextStyle(color: Colors.blue),
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
        items: [AppLocalizations.of(context)!.citizen, AppLocalizations.of(context)!.police, AppLocalizations.of(context)!.advocate]
            .map((role) => DropdownMenuItem(value: role, child: Text(role)))
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
