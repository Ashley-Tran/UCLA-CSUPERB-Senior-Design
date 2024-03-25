import 'package:flutter/material.dart';

const double aspectRatio = 1 / 1.1;
const edgeInsets = 12.0;

enum Bodies {
  setup,
  homePage,
  userStats,
  acceleration,
  braking,
  speeding,
  cornering,
  phoneUsage,
  tripDetails,
  settingsPage,
  credentials,
  tutorial,
  aboutApp,
  privacyStatement,
}

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<StatefulWidget> createState() => TutorialState();
}

class TutorialState extends State<Tutorial> {
  int index = 0;
  var page = Bodies.values.first;
  late Widget body;
  @override
  Widget build(BuildContext context) {
    switch (page) {
      case Bodies.setup:
        body = tutorialStart(
            "Tutorial - Setup",
            "This app will track and record your driving events "
                "automatically in the background.\n\n"
                "Please ensure that all permissions are granted "
                "and that your mobile device does not optimize "
                "this application.");
        break;
      case Bodies.homePage:
        body = tutorialBody(
          "Tutorial - Home Page",
          "This page shows a list of patients in alphabetical order, including their Patient ID, Glaucoma Risk Factor, and Overall Safety Score.\n\n"
              "Click on a patient for more details.",
          Icons.home_outlined,
        );
        break;
      case Bodies.userStats:
        body = tutorialBody(
          "Tutorial - Home Page",
          "Patient Summary\n\n"
          "Upon selecting a patient, you will view their driving statistics, " 
          "including scores for acceleration, braking, cornering, phone usage, " 
          "and speeding, as well as their total miles, hours driven, and number of trips.",
              
          null,
        );
        break;
      case Bodies.acceleration:
        body = tutorialBody(
          "Tutorial - Patient Statistics",
          "Acceleration\n\n"
              "Aggregated score over 2 weeks where patient's accelerations were faster than 9ft/s^2.",
          Icons.track_changes_outlined,
        );
        break;
      case Bodies.braking:
        body = tutorialBody(
          "Tutorial - Patient Statistics",
          "Braking\n\n"
              "Aggregated score over 2 weeks where patient's decelerations were faster than 9ft/s^2.",
          Icons.traffic,
        );
        break;
      case Bodies.speeding:
        body = tutorialBody(
          "Tutorial - Patient Statistics",
          "Speeding\n\n"
              "Aggregated score over 2 weeks where patient's speed is greater than that of the speed limit.",
          Icons.speed,
        );
        break;
      case Bodies.cornering:
        body = tutorialBody(
          "Tutorial - Patient Statistics",
          "Cornering\n\n"
              "Aggregated score over 2 weeks where patient's cornering were faster than 13ft/s^2.",
          Icons.turn_slight_right,
        );
        break;
      case Bodies.phoneUsage:
        body = tutorialBody(
          "Tutorial - Patient Statistics",
          "Phone Usage\n\n"
              "Aggregate the total score from trip parameters to generate scores for the ML model.",
          Icons.system_security_update,
        );
        break;

      case Bodies.tripDetails:
        body = tutorialBody(
          "Tutorial - Trip Details",
          "This page displays detailed data for each of the patient's trips,"
              "including location and scores for acceleration, braking, speeding,"
              "cornering, phone usage, and collision.",
          null,
        );
        break;
      case Bodies.settingsPage:
        body = tutorialBody(
          "Tutorial - Settings Page",
          "Tap this icon at the bottom right corner "
              "to navigate to the Settings Page "
              "where you can edit your profile, access the tutorial, "
              "get informed about the app, "
              "and view the apps privacy statement.",
          Icons.settings_outlined,
        );
        break;
      case Bodies.credentials:
        body = tutorialBody(
          "Tutorial - Settings Page",
          "Tap this icon in the settings page "
              "to navigate to your profile page "
              "where you can view and manage your credentials.",
          Icons.person_2_outlined,
        );
        break;
      case Bodies.tutorial:
        body = tutorialBody(
          "Tutorial - Settings Page",
          "Tap this icon in the settings page "
              "to navigate to the tutorial "
              "where you can view and get a brief explanation how the UI works.",
          Icons.menu_book,
        );
        break;
      case Bodies.aboutApp:
        body = tutorialBody(
          "Tutorial - Settings Page",
          "Tap this icon in the settings page "
              "to navigate to the about app page "
              "where you can get to know the apps objective/goals.",
          Icons.info_outline,
        );
        break;
      case Bodies.privacyStatement:
        body = tutorialBody(
          "Tutorial - Settings Page",
          "Tap this icon in the settings page "
              "to navigate to the privacy statement document.",
          Icons.security,
        );
        break;
      default:
        break;
    }
    return body;
  }

  Widget tutorialStart(String title, String body) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(edgeInsets),
      children: [
        AppBar(
          leading: CloseButton(
            color: Color(0xff627CB2),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            textAlign: TextAlign.center,
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(body),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Row(
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                              color: Color(0xff627CB2),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xff627CB2),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          page = Bodies.values.indexed.elementAt(++index).$2;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget tutorialBody(String title, String body, IconData? icon) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(edgeInsets),
      title: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      children: [
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(body),
                if (icon != null)
                  Icon(
                    icon,
                    size: 60,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Color(0xff627CB2),
                          ),
                          Text(
                            "Previous",
                            style: TextStyle(
                              color: Color(0xff627CB2),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          try {
                            page = Bodies.values.indexed.elementAt(--index).$2;
                          } catch (e) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                    TextButton(
                      child: const Row(
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                              color: Color(0xff627CB2),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xff627CB2),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          try {
                            page = Bodies.values.indexed.elementAt(++index).$2;
                          } catch (e) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}