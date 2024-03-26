import 'package:flutter/material.dart';
import 'package:telematics_sdk_example/screens/physicianUI/patient_display_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:telematics_sdk_example/screens/physicianUI/physician_settings_screen.dart';
import 'package:telematics_sdk_example/screens/physicianUI/physician_tutorial_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "dart:collection";
const _sizedBoxSpace = SizedBox(height: 24);

class PhysicianHomeScreen extends StatefulWidget {
  PhysicianHomeScreen({Key? key}) : super(key: key);

  @override
  _PhysicianHomeScreenState createState() => _PhysicianHomeScreenState();
}

class _PhysicianHomeScreenState extends State<PhysicianHomeScreen> {
  String docName = "";
  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, String> patientList = {};
  List<String> summaryScores = [];

  @override
  void initState() {
    // super.initState();
    loadPatients();
    super.initState();
    // _listItems();
  }

  Future<Map<String, String>> getPatients() async {
    List<String> emails = [];
    List<String> accessTokens = [];
    Map<String, String> patientList = <String, String>{};

    DatabaseReference ref = FirebaseDatabase.instance.ref('patients');
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid;
      try {
        DatabaseEvent event = await ref.once();
        Map<dynamic, dynamic> patients =
            event.snapshot.value as Map<dynamic, dynamic>;

        patients.forEach((key, value) async {
          String patientAT = '${value['accessToken']}';
          String patientEmail = '${value['email']}';

          if ('${value['physicianID']}' == uid) {
            accessTokens.add(patientAT);
            emails.add(patientEmail);
          }
        });

        patientList = Map.fromIterables(emails, accessTokens);
      SplayTreeMap<String, String> sortedList = 
      SplayTreeMap<String,String>.from(patientList);
      patientList = sortedList;
      
      } catch (e) {
        print(e.toString());
        // Handle errors or return an empty list
      }
    }
    setState(() {});
    return patientList;
  }

  Future<String> fetchSummarySafetyScore(
      String startDate, String endDate, String authToken) async {
    var client = http.Client();
    String statistics = '';
    try {
      var url =
          Uri.parse('https://api.telematicssdk.com/indicators/v2/Scores/safety')
              .replace(queryParameters: {
        'StartDate': startDate,
        'EndDate': endDate,
      });

      final response = await client.get(
        url,
        headers: {
          'accept': 'application/json',
          'authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["Result"] != null) {
          statistics = data["Result"]["SafetyScore"].toString();
        } else {
          statistics = "0";
        }
      } else {
        print(
            'Failed to fetch daily statistics, status code: ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching daily statistics: $e');
    } finally {
      client.close();
    }
    setState(() {});
    return statistics;
  }

  String patients = "";
  String summaryScore = "";
  List<ListTile> patientsAndScores = [];
  void loadPatients() async {
    ListTile tile;
    try {
      var items = await getPatients();
      patientList = items;
      if (items.isNotEmpty) {
        patientList.forEach((key, value) async {
          summaryScore =
              await fetchSummarySafetyScore("2024-01-01", "2024-10-10", value);
          if (summaryScore.isNotEmpty) {
            summaryScores.add(summaryScore);
            double s = double.parse(summaryScore);
            if (s >= 80 && s < 101) {
              tile = new ListTile(
                  tileColor: Color.fromARGB(255, 68, 125, 171),
                  title: Text(key),
                  subtitle: Text("Summary Score: " + summaryScore),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PatientDisplayScreen(key, value)));
                  },
                  shape: Border(
                    bottom: BorderSide(color: Colors.black),
                  ));
              patientsAndScores.add(tile);
            } else if (s >= 60 && s < 80) {
              tile = new ListTile(
                  tileColor: Color.fromARGB(255, 106, 121, 134),
                  title: Text(key),
                  subtitle: Text("Summary Score: " + summaryScore),
                  shape: Border(
                    bottom: BorderSide(color: Colors.black),
                  ));
              patientsAndScores.add(tile);
            } else if (s == 0) {
              tile = new ListTile(
                  tileColor: Color.fromARGB(255, 189, 189, 198),
                  title: Text(key),
                  subtitle: Text("Summary Score: -"),
                  shape: Border(
                    bottom: BorderSide(color: Colors.black),
                  ));
              patientsAndScores.add(tile);
            } else {
              ListTile tile = new ListTile(
                  tileColor: Color.fromARGB(255, 249, 0, 0),
                  title: Text(key),
                  subtitle: Text("Summary Score: " + summaryScore),
                  shape: Border(bottom: BorderSide(color: Colors.black)));
              patientsAndScores.add(tile);
            }
          }
        });
      }
    } catch (e) {
      print("Error loading patients: $e");
    }
    // if(patientsAndScores.isNotEmpty){
    //   patientsAndScores.sort((a, b) => a.title?.compareTo(b.title?));
    // }
    // patientsAndScores.sort((a, b) => a.title?.toString.compareTo(b.title?.toString));
    setState(() {});
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
                  showDialog(
                      context: context, builder: (context) => Tutorial());
                },
              ),
            ],
          ),
          // Column(children: _listItems()),
          Column(children: patientsAndScores),
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
