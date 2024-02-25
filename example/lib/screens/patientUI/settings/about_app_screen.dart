import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  AboutAppScreen({Key? key}) : super(key: key);

  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  // final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.0),
          child: AppBar(
            title:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "About the Application",
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
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 40, top: 50, right: 40),
              children: [
                Text(
                    "[***FORMAT, EDIT & ADD TO***]\n\n This application was developed by California State University, Los Angeles' Computer Science 2023-2024 CAPSTONE team in collaboration with UCLA, CSUPERB, and in accordance with the National Institute of Health's guidelines. Its intended use is to serve as a tool for medical physicians with patients who have early-mild glaucoma by analyzing recorded driving events against reported driving patterns & behaviors from those with mild-severe glaucoma.",
                    style: TextStyle(fontSize: 15)),
              ],
            )
          ],
        ));
  }
}
