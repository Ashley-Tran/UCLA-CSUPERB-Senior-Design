import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telematics_sdk_example/services/auth.dart';

class PatientProfileScreen extends StatefulWidget {
  PatientProfileScreen({Key? key}) : super(key: key);

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final User? user = Auth().currentUser;

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
                Text("Physician(s):", style: TextStyle(fontSize: 15)),
              ],
            )
          ],
        ));
  }
}
