import 'package:flutter/material.dart';
import 'package:telematics_sdk_example/screens/physicianUI/patient_trips_screen.dart';
import 'package:telematics_sdk_example/services/UnifiedAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientDisplayScreen extends StatefulWidget {
  final String email;
  final String token;
  PatientDisplayScreen(this.email, this.token);

  @override
  State<StatefulWidget> createState() {
    return _PatientDisplayScreenState(this.email,this.token);
  }
}

class _PatientDisplayScreenState extends State<PatientDisplayScreen> {
  String email;
  String token;
  _PatientDisplayScreenState(this.email, this.token);

  User? currentUser = FirebaseAuth.instance.currentUser;
  final UnifiedAuthService _auth = UnifiedAuthService();
  List<String> stats = [];
  List<Card> firstCards = [];
  List<Card> scoreCards = [];
  int tripCount = 0;
  @override
  void initState() {
    super.initState();
    loadStats();
    loadScores();
  }

  // get the patient's accumulated totals
  void loadStats() async {
    try {
      var items = await _auth.fetchStatistics(this.token);
      if (items.isNotEmpty) {
        setState(() {
          stats = items;
          Card totalTrips = new Card(child: Text("Trip Count: " + stats[0]));
          tripCount = int.parse(stats[0]);
          Card totalMiles =
              new Card(child: Text("Total Miles Driven: " + stats[1]));
          Card totalTime =
              new Card(child: Text("Total Minutes Driven: " + stats[2]));
          firstCards.add(totalTrips);
          firstCards.add(totalMiles);
          firstCards.add(totalTime);
        });
      }
    } catch (e) {
      print("Error loading stats: $e");
    }
  }

  // get the patient's accumulated scores
  void loadScores() async {
    try {
      var items = await _auth.fetchScores(this.token);
      if (items.isNotEmpty) {
        setState(() {
          Card aScore =
              new Card(child: Text("Acceleration Score - " + items[0]));
          Card bScore = new Card(child: Text("Braking Score - " + items[1]));
          Card sScore = new Card(child: Text("Speeding Score - " + items[2]));
          Card cScore = new Card(child: Text("Cornering Score - " + items[3]));
          Card pScore = new Card(child: Text("Phone Usage Score - " + items[4]));
          scoreCards.add(aScore);
          scoreCards.add(bScore);
          scoreCards.add(sScore);
          scoreCards.add(cScore);
          scoreCards.add(pScore);
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
        children: [Column(children: firstCards), Column(children: scoreCards), 
        TextButton(onPressed:  () {
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PatientTripsScreen(email, token, tripCount)));
                }, child: Text("Test"))],
      ),
    );
  }
}
