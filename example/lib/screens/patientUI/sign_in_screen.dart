import 'dart:async';
import 'package:flutter/material.dart';
import 'package:telematics_sdk_example/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telematics_sdk_example/screens/patientUI/patient_home_screen.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

const String virtualDeviceToken = '';

class PatientSignInScreen extends StatefulWidget {
  const PatientSignInScreen({Key? key}) : super(key: key);

  @override
  State<PatientSignInScreen> createState() => _PatientSignInScreenState();
}

class _PatientSignInScreenState extends State<PatientSignInScreen> {
  String? errorMessage = ' ';
  bool isLogin = true;
  bool isConfirmed = false;
  bool isLoading = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final UnifiedAuthService _auth = UnifiedAuthService();

  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String clientId = '';

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
          right: 90,
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
                      height: 200,
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
        padding: const EdgeInsets.only(top: 320, left: 20, right: 20),
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
        height: 70,
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

  Widget _email(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'EMAIL ADDRESS',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          }
          // Check for a valid email format using a regular expression
          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
              .hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          // controller = value;
          return null; // Return null for valid input
        },
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
      padding: const EdgeInsets.only(top: 50, left: 25, right: 20),
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
      AppUser? user = await _auth.registerUser(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        clientId: clientId,
      );
      if (user != null) {
        String? deviceToken = await _auth.getDeviceTokenForUser(user.uid, true);

        if (!mounted) return;

        if (deviceToken != null) {
          await _auth.login(deviceToken);

          if (!mounted) return;

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PatientHomeScreen()));

          // Stop loading
          setState(() => isLoading = false);
        } else {
          throw Exception('Device token could not be retrieved.');
        }
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
        String? deviceToken =
            await _auth.getDeviceTokenForUser(user.uid, false);

        if (!mounted) return;

        if (deviceToken != null) {
          await _auth.login(deviceToken);

          if (!mounted) return;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PatientHomeScreen()));

          // Stop loading
          setState(() => isLoading = false);
        } else {
          throw Exception('Device token could not be retrieved.');
        }
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

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
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

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Future<void> _checkPass (Text pass, Text secondPass) async {
  //   if(pass != secondPass){
  //     _showSnackBar('Passwords do not match');
  //   }
  // }
  Widget _passwordCheck() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextFormField(
        controller: _controllerConfirmPassword,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'CONFIRM PASSWORD',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please re-enter password';
          }
          if (_controllerPassword.text != _controllerConfirmPassword.text) {
            return "Password does not match";
          }
          return null;
        },
      ),
    );
  }

  Widget _password(
    String title,
    TextEditingController controller,
    TextEditingController controller2,
    // String password,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: SizedBox(
        height: 70,
        width: 300,
        child: TextField(
          controller: controller,
          onChanged: (val) {
            if (val == controller2.text) {
              // _showSnackBar("Passwords don't match.");
              setState(() {
                isConfirmed = !isConfirmed;
              });
            } else {
              _showSnackBar("Passwords don't match.");
            }
          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BackButton(),
          _decoration(),
          _loginHeader(),
          Column(
            // space
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(bottom: 250)),
              if (isLogin) ...[
                // Padding(padding:)
                _entryField('EMAIL', _controllerEmail),
                // _email(_controllerEmail),
                _entryField('PASSWORD', _controllerPassword),
                // _errorMessage(),
                _forgotPasswordLink(),
                _submitButton(),
                _loginOrRegisterButton(),
              ] else ...[
                _entryField('EMAIL', _controllerEmail),

                _entryField('PASSWORD', _controllerPassword),
                FlutterPwValidator(
                    width: 300,
                    height: 100,
                    minLength: 9,
                    uppercaseCharCount: 1,
                    specialCharCount: 1,
                    numericCharCount: 2,
                    onSuccess: () {},
                    controller: _controllerPassword),
                const SizedBox(
                  height: 20,
                ),
                _passwordCheck(),
//SWORD', _controllerConfirmPassword),
                // if(isConfirmed)...[
                _submitButton(),
                // ],
                // _submitButton(),

                _loginOrRegisterButton(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
