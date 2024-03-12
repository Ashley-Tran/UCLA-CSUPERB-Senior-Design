import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientTripsScreen extends StatefulWidget {
  final String email;
  final String token;
  final int tripCount;
  PatientTripsScreen(this.email, this.token, this.tripCount);

  @override
  State<StatefulWidget> createState() {
    return _PatientTripsScreenState(this.email, this.token, this.tripCount);
  }
}

class _PatientTripsScreenState extends State<PatientTripsScreen> {
  String email;
  String token;
  int tripCount;
  _PatientTripsScreenState(this.email, this.token, this.tripCount);
  User? currentUser = FirebaseAuth.instance.currentUser;
  final UnifiedAuthService _auth = UnifiedAuthService();

  // List<String> scores = [];
  List<List<String>> trips = [];
  // List<Card> scoreCards = [];

  // List<Row> tripRows = [];
  // List<Column> containers = [];
    List<Container> containers = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  // get the patient's accumulated totals
  void loadTrips() async {
    try {
      var items = await _auth.fetchTrips(this.token, this.tripCount);
      if (items.isNotEmpty) {
        setState(() {
          trips = items;
          for (int i = 0; i < tripCount; i++) {
            List<Text> details = [];
            trips.forEach((element) {
              details.add(Text(element[i]));
              // print(element[i]);
            });
            containers.add(Container(color: Color.fromARGB(255, 238, 235, 235),margin: EdgeInsets.all(10), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: details)));
           
            // containers.add(Column
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisSize: MainAxisSize.min,
            //     children: details));
          }
        });
      }
    } catch (e) {
      print("Error loading stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email),
      ),
      body: ListView(
        children: containers,
        
      ),
    );
  }
}
