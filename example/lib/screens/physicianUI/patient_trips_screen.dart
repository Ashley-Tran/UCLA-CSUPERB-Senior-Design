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

  List<List<String>> trips = [];

  List<Container> containers = [];
    List<String> startDates = [];
      List<String> endDates = [];
            List<String> locations = [];
  List<String> mileages = [];
  List<String> durations = [];
  List<String> accelerations = [];
  List<String> brakings = [];
  List<String> cornerings = [];
  List<String> phoneUsages = [];
  List<String> nightHours = [];
  List<String> avgSpeeds = [];
    List<String> aScores = [];
        List<String> bScores = [];
            List<String> cScores = [];
                List<String> sScores = [];
                    List<String> pScores = [];
                              List<String> spScores = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
    // loadMileages();
  }

  // get the patient's accumulated totals
  void loadTrips() async {
    try {
      var items = await _auth.fetchTrips(this.token, this.tripCount);
      if (items.isNotEmpty) {
        setState(() {
          trips = items;
          startDates = trips[0];
            endDates = trips[1];
                locations = trips[2];
          mileages = trips[3];
          durations = trips[4];
          avgSpeeds = trips[10];
          accelerations = trips[5];
          brakings = trips[6];
          cornerings = trips[7];
          phoneUsages = trips[8];
          nightHours = trips[9];
          sScores = trips[11];
                  aScores = trips[12];
                          bScores = trips[13];
                                  cScores = trips[14];
                                          spScores = trips[15];
                                                  pScores = trips[16];

          for (int i = 0; i < tripCount; i++) {
            List<Text> details = [];
            trips.forEach((element) {
              details.add(Text(element[i]));
            });
            containers.add(Container(
              color: Color.fromARGB(255, 238, 235, 235),
              margin: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
               
                    Row(children:<Widget>[
                      Flexible(child:
                      Text(
                            // overflow: TextOverflow.ellipsis,
                           startDates[i].toString() + "\n" + endDates[i].toString() +"\n",
                            // textAlign: TextAlign.right,
                          ))]),
                     Row(children:<Widget>[
                     Expanded(child:
                        
                          Text(
                            locations[i].toString() +"\n",
                          
                          ),
                     )
                        ]
                        ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Drive Duration",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            durations[i].toString(),
                            textAlign: TextAlign.right,
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mileage",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            mileages[i].toString(),
                            textAlign: TextAlign.right,
                          )
                        ]),
                        Divider(color: Colors.black,),
                       
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Average Speed",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            avgSpeeds[i].toString(),
                            textAlign: TextAlign.right,
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Acceleration Count",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(accelerations[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Braking Count",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(brakings[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cornering Count",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(cornerings[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone Usage",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(phoneUsages[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Night Driving",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(nightHours[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                         Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Safety Score",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(sScores[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Acceleration Score",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(aScores[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Braking Score",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(bScores[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cornering Score",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(cScores[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Speeding Score",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(spScores[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone Usage Score",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(pScores[i].toString(),
                              textAlign: TextAlign.right)
                        ]),
                  ]),
            ));
          }
        });
      }
    } catch (e) {
      print("Error loading stats: $e");
    }

  }

  void loadMileages() {
    if (trips.isNotEmpty) {
      print("works");
    }
    //   setState((){
    //    for (int i = 0; i < tripCount; i++) {
    //           List<Text> details = [];
    //           trips.forEach((element) {
    //             details.add(Text(element[i]));
    //             // print(element[i]);
    //           });
    //           containers.add(Container(
    //               color: Color.fromARGB(255, 244, 244, 244),
    //               margin: EdgeInsets.all(10),
    //               child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: details)));
    //         }
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 51, 110, 159)
                ]),
          ),
        ),
      ),
      body: ListView(
        children: containers,
      ),
    );
  }
}
