import 'dart:async';
import 'package:flutter/material.dart';
import 'package:telematics_sdk_example/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telematics_sdk_example/screens/physicianUI/physician_home_screen.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';

class PhysicianSignInScreen extends StatefulWidget {
  const PhysicianSignInScreen({Key? key}) : super(key: key);

  @override
  State<PhysicianSignInScreen> createState() => _PhysicianSignInScreenState();
}

class _PhysicianSignInScreenState extends State<PhysicianSignInScreen> {
  String? errorMessage = ' ';
  bool isLogin = true;
  bool isConfirmed = false;
  bool isLoading = false;

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerOrgName = TextEditingController();
  final TextEditingController _controllerNPI = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final UnifiedAuthService _auth = UnifiedAuthService();

  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  // String clientId = '';

  Widget _decoration() {
    return Stack(
      children: [
        Positioned(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 15, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: (const Color.fromARGB(255, 4, 27, 63))!,
                  width: 5,
                ),
              ),
            ),
          ),
        ),
        // This is that invisible rectangle at the top left.
        Positioned(
          top: 28,
          left: -100,
          child: Container(
            height: 175,
            width: 175,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: BoxShape.rectangle,
            ),
          ),
        ),
        // This is that invisible rectangle at the bottom right.
        Positioned(
          bottom: -45,
          right: -13,
          child: Container(
            height: 175,
            width: 175,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
        // This is for the blue ball-top left.
        Positioned(
          top: 30.0,
          left: -40.0,
          child: Container(
            height: 125,
            width: 125,
            decoration: BoxDecoration(
              color: (const Color.fromARGB(255, 4, 27, 63)),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: BackButton(color: Colors.white),
          ),
        ),
        // This is for the beige ball-top left.
        Positioned(
          top: 100.0,
          left: -40.0,
          child: Container(
            height: 95,
            width: 95,
            decoration: BoxDecoration(
              color: (const Color.fromARGB(255, 200, 195, 146)),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
          ),
        ),
        // This is for the blue ball-bottom right.
        Positioned(
          bottom: -80.0,
          right: -80.0,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: (const Color.fromARGB(255, 4, 27, 63)),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
          ),
        ),
        // This is for the beige ball-bottom right.
        Positioned(
          bottom: -50.0,
          right: 50.0,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: (const Color.fromARGB(255, 200, 195, 146)),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
          ),
        ),
        // This belongs to the car logo.
        Positioned(
          top: 100.0,
          right: 120,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 103, 139, 183),
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/road.png',
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginHeader() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 275, left: 20, right: 20),
        child: Column(
          children: [
            Text(
              isLogin ? 'Sign In' : 'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: SizedBox(
        height: 45,
        width: 300,
        child: TextField(
          controller: controller,
          // autofocus: false,
          decoration: InputDecoration(
            hintText: title,
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 4, 27, 63)),
            ),
          ),
        ),
      ),
    );
  }

// Displays link and calls UnifiedAuthService method to send reset email
  Widget _forgotPasswordLink() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 190,
      ),
      child: GestureDetector(
        onTap: _resetPassword,
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: const Color.fromARGB(255, 23, 111, 182),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (_controllerEmail.text.isNotEmpty) {
      email = _controllerEmail.text;
      try {
        await _auth.resetPassword(email);
        // Display a success message or navigate to a confirmation screen
        print('Password reset email sent to $email');
      } catch (e) {
        print('Failed to reset password: $e');
        // Handle the error appropriately, such as displaying an error message
      }
    } else {
      setState(() {
        errorMessage = 'Please enter your email to reset the password.';
      });
    }
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 25, right: 20),
      child: SizedBox(
        height: 50,
        width: 350,
        child: FilledButton(
          onPressed: isLogin ? _signIn : createUserWithEmailAndPassword,
          style: FilledButton.styleFrom(
            backgroundColor: (Color.fromARGB(255, 103, 139, 183)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
          child: Text(
            isLogin ? 'Sign In' : 'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: (Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      setState(() => isLoading = true);
      AppUser? user = await _auth.registerPhysician(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        firstName: _controllerFirstName.text,
        lastName: _controllerLastName.text,
        npi: _controllerNPI.text,
        organizationName: _controllerOrgName.text,
        phone: _controllerPhone.text,
      );
      if (user != null) {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PhysicianHomeScreen()));

        // Stop loading
        setState(() => isLoading = false);
      } else {
        throw Exception(
            'Failed to sign in. Please check your email and password.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> _signIn() async {
    try {
      setState(() => isLoading = true);
      AppUser? user = await _auth.signInWithEmailAndPassword(
          _controllerEmail.text, _controllerPassword.text);

      if (!mounted) return;

      if (user != null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PhysicianHomeScreen()));

        //   // Stop loading
        setState(() => isLoading = false);
      } else {
        throw Exception(
            'Failed to sign in. Please check your email and password.');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _loginOrRegisterButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 100),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin
              ? 'Don\'t have an account? Sign up.'
              : 'Already have an account? Sign in.',
          style: TextStyle(
            color: const Color.fromARGB(255, 23, 111, 182),
            // decoration: TextDecoration.underline,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _decoration(),
          _loginHeader(),
          Column(
            // space
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Padding(padding: const EdgeInsets.only(bottom: 200)),
              if (isLogin) ...[
                Padding(padding: const EdgeInsets.only(bottom: 200)),
                _entryField('EMAIL', _controllerEmail),
                 Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25, right: 20),
                ),
                _entryField('PASSWORD', _controllerPassword),
                _forgotPasswordLink(),
                 Padding(
                  padding: const EdgeInsets.only(top: 50, left: 25, right: 20),
                ),
                // Padding(padding: const EdgeInsets.only(bottom: 50)),
                _submitButton(),
                _loginOrRegisterButton(),
              ] else ...[
                Padding(padding: const EdgeInsets.only(bottom: 235)),
                _entryField('EMAIL', _controllerEmail),
                _entryField('PASSWORD', _controllerPassword),
                _entryField('CONFIRM PASSWORD', _controllerConfirmPassword),
                _entryField('FIRST NAME', _controllerFirstName),
                _entryField('LAST NAME', _controllerLastName),
                _entryField('PHONE', _controllerPhone),
                _entryField('NPI', _controllerNPI),
                _entryField('ORG. NAME', _controllerOrgName),
                _submitButton(),
                _loginOrRegisterButton(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
