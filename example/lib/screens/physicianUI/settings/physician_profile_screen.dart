import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telematics_sdk_example/services/auth.dart';
import 'package:group_button/group_button.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
// import 'package:firebase_database/firebase_database.dart';

class PhysicianProfileScreen extends StatefulWidget {
  PhysicianProfileScreen({Key? key}) : super(key: key);

  @override
  _PhysicianProfileScreenState createState() => _PhysicianProfileScreenState();
}

class _PhysicianProfileScreenState extends State<PhysicianProfileScreen> {
  final User? user = Auth().currentUser;

  final TextEditingController _newPasswordController = TextEditingController();
  final UnifiedAuthService _auth = UnifiedAuthService();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String physician = "";

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
              padding: const EdgeInsets.only(top: 50),
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                      right: 40,
                    ),
                    child: Text('Email: ${user?.email ?? 'User email'}',
                        style: TextStyle(fontSize: 15))),
                Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text('Verified NPI: ###########',
                        style: TextStyle(fontSize: 15))),
                Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      controller: _newPasswordController,
                      decoration:
                          const InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                      ),
                      obscureText: true,
                    )),
                TextButton(
                  child: Text("Change Password"),
                  onPressed: updateUserPassword,
                ),
                Text("Preferred Unit of Measurement",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.only(left:25), child:
                Row(children: [
                GroupButton(
                  isRadio:true,
                  buttons: ['km/hr', 'mi/hr']),
                GroupButton(isRadio:true, buttons: ['12hr', '24hr'],)
                ]),
                ),
              ],
           
            )
          ],
        ));
  }
}
