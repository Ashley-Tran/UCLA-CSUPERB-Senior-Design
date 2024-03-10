import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:telematics_sdk_example/screens/physicianUI/patient_display_screen.dart';

import 'package:telematics_sdk_example/screens/physicianUI/physician_settings_screen.dart';
import 'package:telematics_sdk_example/screens/patientUI/tutorial_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _sizedBoxSpace = SizedBox(height: 24);

class PhysicianHomeScreen extends StatefulWidget {
  PhysicianHomeScreen({Key? key}) : super(key: key);

  @override
  _PhysicianHomeScreenState createState() => _PhysicianHomeScreenState();
}

class _PhysicianHomeScreenState extends State<PhysicianHomeScreen> {
  String docName = "";
  User? currentUser = FirebaseAuth.instance.currentUser;
  final UnifiedAuthService _auth = UnifiedAuthService();

  Map<String, String> patientList = {};
  List<String> summaryScores = [];
//  Map<String, String> summaryScores = {};
  @override
  void initState() {
    super.initState();
    loadPatients();
    // _listItems();
  }

  String patients = "";
  String summaryScore = "";

  void loadPatients() async {
    try {
      var items = await _auth.getPatients();
      setState(() {
        patientList = items;

        if (items.isNotEmpty) {
          patientList.forEach((key, value) async {
            print(key);
            print(value);
            summaryScore = await _auth.fetchSummarySafetyScore(
                "2024-01-01", "2024-10-10", value);
            // if(summaryScore.isNotEmpty){
            //      summaryScores.add(summaryScore);
            // }
            // summaryScores[key] = summaryScore;
            // summaryScores.addEntries(key, (value) => summaryScore);
            // print(summaryScore);
            summaryScores.add(summaryScore);
          });
        }
      });
    } catch (e) {
      print("Error loading patients: $e");
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
      }
    });
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color.fromARGB(255, 103, 139, 183),
      onTap: _onItemTapped,
    );
  }

  List<ListTile> patientsAndScores = [];

  List<ListTile> _listItems() {
    List<ListTile> list = [];
    ListTile tile;
    int index = 0;
    patientList.forEach((key, value) {
      double s = double.parse(summaryScores[index]);
      print(s);
      if (s >= 80 && s < 101) {
        tile = new ListTile(
            tileColor: Color.fromARGB(255, 68, 125, 171),
            title: Text(key),
            subtitle: Text("Summary Score: " + summaryScores[index]),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PatientDisplayScreen(value)));
            },
            shape: Border(
              bottom: BorderSide(color: Colors.black),
            ));
        list.add(tile);
      } else if (s >= 60 && s < 80) {
        tile = new ListTile(
            tileColor: Color.fromARGB(255, 106, 121, 134),
            title: Text(key),
            subtitle: Text("Summary Score: " + summaryScores[index]),
            shape: Border(
              bottom: BorderSide(color: Colors.black),
            ));
        list.add(tile);
      } else {
        ListTile tile = new ListTile(
            tileColor: Color.fromARGB(255, 249, 0, 0),
            title: Text(key),
            subtitle: Text("Summary Score: " + summaryScores[index]),
            shape: Border(bottom: BorderSide(color: Colors.black)));
        list.add(tile);
      }
      index++;
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(top: 200, right: 150)),
              Text('Home', style: TextStyle(color: Colors.black, fontSize: 20)),
              Padding(padding: EdgeInsets.only(right: 100)),
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(TutorialHome());
                },
              ),
            ],
          ),
          Column(children: _listItems()),
          _sizedBoxSpace,
          _sizedBoxSpace,
        ],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
