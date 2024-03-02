import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telematics_sdk_example/services/auth.dart';

import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientProfileScreen extends StatefulWidget {
  PatientProfileScreen({Key? key}) : super(key: key);

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final User? user = Auth().currentUser;

  final TextEditingController _newPasswordController = TextEditingController();
  final UnifiedAuthService _auth = UnifiedAuthService();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _birthdayController = TextEditingController();
String physician = "";
  // String? physician = "";

//Change password
  Future<void> updateUserPassword() async {
    if (_newPasswordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        await _auth
            .getCurrentUser()
            ?.updatePassword(_newPasswordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully")),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update password: $error")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
    }
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdayController.text.isNotEmpty
          ? DateTime.tryParse(_birthdayController.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
    try {
      await _auth.addBirthday(_birthdayController.text);
    } catch (e) {
      print("Birthday not added");
    }
  }


  Future<void> _displayPhysician() async{
    final physician = await _auth.getPhysician(user?.uid);
    // return physician;
    // if(physician!= null){
    //   return Text(physician);
    // }
    // else{
    // return Text("None found");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.0),
          child: AppBar(
            title:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ]),
            backgroundColor: Color.fromARGB(255, 103, 139, 183),
          ),
        ),
        body: Stack(
          children: [
            ListView(
                padding: const EdgeInsets.only(left: 10, top: 10),
                children: [
                  Text("Basic Information",
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 4, 27, 63),
                      ))
                ]),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 40, top: 50),
              children: [
                Text('Email: ${user?.email ?? 'User email'}',
                    style: TextStyle(fontSize: 15)),
                   
                Text("Physician(s):${physician ?? 'User physician'}",
                    style: TextStyle(fontSize: 15)),
                TextFormField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectBirthday(context),
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm New Password'),
                  obscureText: true,
                ),
                TextButton(
                  child: Text("Change Password"),
                  onPressed: updateUserPassword,
                )
              ],
            )
          ],
        ));
  }
}
