import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:telematics_sdk_example/screens/physicianUI/physician_settings_screen.dart';
import 'package:telematics_sdk_example/screens/patientUI/tutorial_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';

const _sizedBoxSpace = SizedBox(height: 24);

class PhysicianHomeScreen extends StatefulWidget {
  PhysicianHomeScreen({Key? key}) : super(key: key);

  @override
  _PhysicianHomeScreenState createState() => _PhysicianHomeScreenState();
}

class _PhysicianHomeScreenState extends State<PhysicianHomeScreen> {
  String docName = "";
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  String patients = "";
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
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

  Widget _logo() {
    // return Positioned(
    // top: 100.0,
    // right: 90,
    // child:
    return Center(
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
      // ),
    );
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

  List<String> _testKeys = [];
  List<String> _realKeys = [];
  Future<List<String>> _getPatientList() async {
    List<String> _listKeys = [];
    FirebaseDatabase.instance.ref('patients').get().then((snapshot) {
      if (snapshot.exists) {
        // Grabs all patients user ids
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          _listKeys.add(key);
        });
      } else {
        print("None found");
      }
      setState(() {
        _testKeys = _listKeys;
      });
    });

    for (var key in _testKeys) {
      final ref = FirebaseDatabase.instance.ref();
      DatabaseEvent event = await ref.child('patients/${key}/physician').once();
      // final snapshot = await ref.child('patients/${key}/physician').get();
      if (event.snapshot.exists) {
        // Iterate through all user ids & find those that match physician
        if (event.snapshot.value.toString() == "Test Doc") {
          String newKey = key;
          _realKeys.add(newKey);
          setState(() {});
        }
      }
    }
    return _listKeys;
  }

  String _summarySafetyScore = 'Loading...';
  List<String> summaryScores = [];
  final UnifiedAuthService _auth = UnifiedAuthService();
  Future<void> _fetchSummarySafetyScore(String userID) async {
    try {
      DatabaseEvent event = await FirebaseDatabase.instance
          .ref("patients/${userID}/accessToken")
          .once();

      // final snapshot = await FirebaseDatabase.instance
      //     .ref("patients/${userID}/accessToken")
      //     .get();

      String? accessToken = event.snapshot.value.toString();
      // String? accessToken = snapshot.value.toString();

      String startDate = "2024-01-01";
      String endDate = "2024-03-24";

      String statistics =
          await _auth.fetchSummarySafetyScore(startDate, endDate, accessToken);
      setState(() {
        summaryScores.add(statistics);
      });
    } catch (e) {
      setState(() {
        _summarySafetyScore = 'Error fetching statistics: $e';
      });
    }
  }

  Widget _patientList() {
    if (_realKeys.isEmpty) {
      _getPatientList();
    }

    // Get all distinct items for patients of the physician
    _realKeys = _realKeys.toSet().toList();

    // //TEST
    if (summaryScores.length < _realKeys.length) {
      for (var k in _realKeys) {
        if (summaryScores.length != _realKeys.length) {
          _fetchSummarySafetyScore(k);
        }
        // _fetchSummarySafetyScore(k);
      }
    }

    summaryScores = summaryScores.toSet().toList();
    print(summaryScores);
    print(_realKeys);
    while (_realKeys.length > summaryScores.length) {
      summaryScores.add("0");
    }
    print(summaryScores);
    print(_realKeys);
    final list = Map.fromIterables(_realKeys, summaryScores);
    // summaryScores[0] = "0";
    return Column(
      children: <Widget>[
        // Padding(padding: EdgeInsets.only(bottom: 10, top: 10),),
        // for (var k in _realKeys)
        for (int i = 0; i < _realKeys.length; i++)
          ListTile(
            // contentPadding: ,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            tileColor: Color.fromARGB(255, 10, 65, 111),
            textColor: Colors.white,

            title: Text(_realKeys.elementAt(i), style: TextStyle(color: Colors.blue)),
            subtitle: Text("    Accumulated Safety Score: " + summaryScores.elementAt(i)),
          )
        // else if (int.parse(summaryScores[i]) <= 70)
        //   ListTile(
        //     tileColor: Color.fromARGB(255, 26, 123, 202),
        //     title: Text(_realKeys.elementAt(i)),
        //     subtitle: Text("Safety Score: " + summaryScores.elementAt(i)),
        //   )
        ,
        Padding(
          padding: EdgeInsets.only(bottom: 10, top: 10),
        ),
      ],
    );
    // return Text(_realKeys.elementAt(0) + " " + _realKeys.elementAt(1));
  }

  // Widget _testlist(){
  // print(summaryScores);
  // print(_realKeys);
  //  final children = <Widget>[];
  //   for(var i = 0; i < _realKeys.length; i++){
  //         children.add(ListTile(
  //           title: Text(_realKeys.elementAt(i)),
  //           subtitle: Text(summaryScores.elementAt(i))
  //         ));
  //       }
  //       return new ListView(children:children);
  // }

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
              // _patientList(),
              // Text()
            ],
          ),
          // Padding(padding: EdgeInsets.only(top: 30)),
          // _logo(),
          _patientList(),
          // _testlist(),

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
