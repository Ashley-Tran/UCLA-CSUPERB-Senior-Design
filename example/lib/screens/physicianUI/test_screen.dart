import 'package:flutter/material.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
import 'package:telematics_sdk_example/services/user.dart';
import 'package:firebase_database/firebase_database.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final UnifiedAuthService _authService = UnifiedAuthService();
  String _dailyStatistics = 'Loading...';
  List<String> _testKeys = [];
  List<String> _patientKeys = [];
  @override
  void initState() {
    super.initState();
    _getPatientList();
    // _getPTest();
    // print(_testKeys);
    // _fetchSummarySafetyScore("6GA5GGEzy6fNl9M78LPaEhpGhD42");
  }

  Future<void> _fetchSummarySafetyScore(String userID) async {
    try {
      final snapshot = await FirebaseDatabase.instance
          .ref("patients/${userID}/accessToken")
          .get();
      String? accessToken = snapshot.value.toString();
      print(accessToken);
      String startDate = "2024-01-01";
      String endDate = "2024-04-24";

      String statistics = await _authService.fetchSummarySafetyScore(
          startDate, endDate, accessToken);
      setState(() {
        _dailyStatistics = statistics;
      });
    } catch (e) {
      setState(() {
        _dailyStatistics = 'Error fetching statistics: $e';
      });
    }
  }


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
      final snapshot = await ref.child('patients/${key}/physician').get();
      if (snapshot.exists) {
        // Iterate through all user ids & find those that match physician
        if (snapshot.value.toString() == "Test Doc") {
          String newKey = key;
          // setState(() {
          _realKeys.add(newKey);
          // });
          setState(() {});
          // print(snapshot.value.toString());
        }
        // print(snapshot.value.toString());
      } else {
        // print('No data available.');
      }
    }

    return _realKeys;
  }



// List<String> _realKeys = [];
  // Future<List<String>> _getPTest(List<String> _listKeys) async {
  //   List<String> _realKeys = [];
  //   for (var key in _testKeys) {
  //     // print(key);
  //     final ref = FirebaseDatabase.instance.ref();
  //     final snapshot = await ref.child('patients/${key}/physician').get();
  //     if (snapshot.exists) {
  //       if (snapshot.value.toString() != "Test Doc") {
  //         String newKey = key;
  //         _testKeys.remove(newKey);
  //         // _realKeys.add(newKey);
  //         print(newKey);
  //         setState(() {});
  //         }
  //       }
  //     }
  //   }
  //   return _realKeys;
  //   // setState(() {
  //   //   _testKeys = _realKeys;
  //   //   // print(_testKeys);
  //   // });
  //   // print(_testKeys);
  //   // print
  //   // return _testKeys;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        // child: Text(_dailyStatistics),
        child: Text(_realKeys.length.toString()),
      ),
    );
  }
}



// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() {
//   Map<String, String> headers = {
//     'accept': 'application/json',
//     'authorization':
//         'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJzdWIiOiIxYmIzZWY5Mi04NmMxLTQ0MmItYTNkZC0wZjU0OWZmYWJiZGQiLCJqdGkiOiJiOGViZTdlYS02YmRhLTRiNjQtOWI3Zi1lMjk0YzczM2E2YmMiLCJpYXQiOjE3MDkzNTAyMDksIlNka0VuYWJsZUxvZ2dpbmciOiJGYWxzZSIsIlNka0VuYWJsZVRyYWNraW5nIjoiVHJ1ZSIsIlNka0NsaWVudElkIjoiIiwiU2RrRW5hYmxlZCI6IlRydWUiLCJTZGtTZXR0aW5nc1VyaSI6Imh0dHBzOi8vYXBpLnRlbGVtYXRpY3NzZGsuY29tL3NldHRpbmdzL2Jhc2UiLCJJbnN0YW5jZUlkIjoiZWUwNTA4ODA4NmRiNDUwMjllODIzNjZkYTllM2Q0ZGUiLCJEZXZpY2VUb2tlbiI6IjFiYjNlZjkyODZjMTQ0MmJhM2RkMGY1NDlmZmFiYmRkIiwiQ29tcGFueUlkIjoiZGQ1YTMzYzA0NzdhNDVkYWE5ODFhZTQyYzQxNmRhNmYiLCJBcHBJZCI6ImVmYjc2ZjU4ZGU1MzRiZmJiODY5NmY5NWExN2EwYWNhIiwiSXNBZG1pbiI6IkZhbHNlIiwiU2RrIjoiVHJ1ZSIsIm5iZiI6MTcwOTM1MDIwOCwiZXhwIjoxNzE4OTUwMjA4LCJpc3MiOiJ3ZWJBcGkiLCJhdWQiOiJodHRwczovL3VzZXIudGVsZW1hdGljc3Nkay5jb20ifQ.t2uiqbF9SCdEk7BCkAyJaU0UtDCQZHzwYXIXtpXxE5MSfYr5pM7g1Zn93BMFAtaSgRDIcjx5Iz4pAC4DH3UoBRsdKi5fD3M9oCrGhBbJgt19LVV1UynuA9OhvtTlnn1huYwljSRpwrowRPHtH0swYRndzkCA0wKR_CqydbP1SQ5tqXlo1o3A1ky-gQS18kPXG3qyOxNuZtR0GO7gLivY27OEXIHOYKrXKmuwOqbouNVhw8mtn56-goT89yU-5Wj7ZBC-2hD7TZjfzJgY_1LP-eXa5j7Syj7C-sCbCx_at6hWoW2IuHumatYWTCq5RBvYqFjJEf3yd2kOdXY5kaUWEw'
//   };

//   http.get(
//       Uri.parse(
//           'https://api.telematicssdk.com/indicators/v2/Scores/safety?startDate=2024-01-31&endDate=2024-12-31'),
//       headers: headers)
//       .then((response) {
//     if (response.statusCode == 200) {
//       var jsonResponse = jsonDecode(response.body);
//       print(jsonResponse);
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }

