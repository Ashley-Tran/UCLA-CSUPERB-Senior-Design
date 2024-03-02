import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:telematics_sdk_example/services/user.dart';
import 'package:telematics_sdk_example/services/telematics_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:telematics_sdk/telematics_sdk.dart';

class UnifiedAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TelematicsService _telematicsService = TelematicsService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final TrackingApi _trackingApi = TrackingApi();

  final String instanceId = "ee050880-86db-4502-9e82-366da9e3d4de";
  final String instanceKey = "b0fafb2a-bd86-408e-87f5-cce93619be2c";

  // Converts Firebase User to custom AppUser
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // Register with email, password, and user details for telematics
  Future<AppUser?> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String clientId,
  }) async {
    try {
      // Firebase Authentication to create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      // Register user in telematics system
      TokenResponse tokenResponse = await _telematicsService.registerUser(
        // firstName: firstName,
        // lastName: lastName,
        // phone: phone,
        email: email,
        // clientId: clientId,
      );

      // Store telematics tokens and username in Firebase database linked to the user's UID
      if (firebaseUser != null) {
        await _database.ref('userTokens/${firebaseUser.uid}').set({
          'deviceToken': tokenResponse.deviceToken,
          'accessToken': tokenResponse.accessToken,
          'refreshToken': tokenResponse.refreshToken,
        });
      }

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email, password, and user details for telematics
  Future<AppUser?> registerPatient(
      {required String email,
      required String password,
      // required String firstName,
      // required String lastName,
      required String gender,
      required String birthday,
      required String physician}) async {
    try {
      // Firebase Authentication to create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      // Register user in telematics system
      TokenResponse tokenResponse = await _telematicsService.registerUser(
        // firstName: firstName,
        // lastName: lastName,
        email: email,
        // phone: phone
      );

      // Store telematics tokens and username in Firebase database linked to the user's UID
      if (firebaseUser != null) {
        await _database.ref('patients/${firebaseUser.uid}').set({
          'deviceToken': tokenResponse.deviceToken,
          'accessToken': tokenResponse.accessToken,
          'refreshToken': tokenResponse.refreshToken,
          'gender': gender,
          'birthday': birthday,
          'email': email,
          'physician': physician
        });
      }

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AppUser?> registerPhysician({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String NPI,
    required String OrgName,
  }) async {
    try {
      // Firebase Authentication to create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      // Store telematics tokens and username in Firebase database linked to the user's UID
      if (firebaseUser != null) {
        await _database.ref('physicians/${firebaseUser.uid}').set({
          'First Name': firstName,
          'Last Name': lastName,
          'phone': phone,
          'NPI': NPI,
          'OrgName': OrgName
        });
      }

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// getToke()
  // Get Device token (Firebase side)
  Future<String?> getDeviceTokenForUser(String? uid, bool isNewUser) async {
    if (uid == null) {
      print("UID is null. Cannot retrieve device token.");
      return null;
    }

    DatabaseReference dbRef = FirebaseDatabase.instance.ref('patients/$uid');

    try {
      DataSnapshot snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null && data.containsKey('deviceToken')) {
          final String? deviceToken = data['deviceToken'];
          print("Device token for UID $uid is: $deviceToken");
          login(deviceToken);
          if (isNewUser) {
            _trackingApi.showPermissionWizard(
                enableAggressivePermissionsWizard: false,
                enableAggressivePermissionsWizardPage: true);
          } else {}
          initializeAndStartTracking(deviceToken!);
          return deviceToken;
        } else {
          print("Device token not found for UID $uid.");
        }
      } else {
        print("Snapshot does not exist for UID $uid.");
      }
    } catch (e) {
      print(
          "An error occurred while trying to fetch device token for UID $uid: $e");
    }

    return null;
  }



 Future<String?> getPhysician(String? uid) async {
    if (uid == null) {
      print("UID is null. Cannot retrieve Physician.");
      return null;
    }

    DatabaseReference dbRef = FirebaseDatabase.instance.ref('patients/$uid');

    try {
      DataSnapshot snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null && data.containsKey('physician')) {
          final String? physician = data['physician'];
          print("Physician for UID $uid is: $physician");
          return physician;
        } else {
          print("Physician not found for UID $uid.");
        }
      } else {
        print("Snapshot does not exist for UID $uid.");
      }
    } catch (e) {
      print(
          "An error occurred while trying to fetch physician for UID $uid: $e");
    }

    return null;
  }

  // Method to login to Damoov
  Future<void> login(String? userId) async {
    var url = Uri.parse('https://user.telematicssdk.com/v1/Auth/Login');

    var headers = {
      'accept': 'application/json',
      'InstanceId': 'ee050880-86db-4502-9e82-366da9e3d4de',
      'content-type': 'application/json',
    };

    var body = jsonEncode({
      'LoginFields': {"Devicetoken": userId},
      'Password': 'b0fafb2a-bd86-408e-87f5-cce93619be2c'
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('Response data: ${response.body}');
    } else {
      // If the server did not return a 200 OK response,
      print(
          'Failed to login, status code: ${response.statusCode}, body: ${response.body}');
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }

    print("Login here");
  }

  // Method to reset passsword (Firebase side)
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
    } catch (e) {
      print("Failed to send password reset email: $e");
      // Handle the error appropriately
    }
  }

  // Method to change the current user's email
  Future<void> changeEmail(String newEmail) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        print("Email updated successfully to $newEmail");
      } catch (e) {
        print("Failed to update email: $e");
        // Handle the error appropriately
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  AppUser? getCurrentAppUser() {
    return _userFromFirebaseUser(_auth.currentUser);
  }

  Future<void> addPhysician(String physician) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _database
          .ref('patients/${user.uid}')
          .update({'physician': physician});
    }
  }

  Future<void> addBirthday(String birthday) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _database
          .ref('patients/${user.uid}')
          .update({'birthday': birthday});
    }
  }

  // Future<String> getBirthday() async {
  //    User? user = _auth.currentUser;
  //   // String birthday; 
  //    if (user != null) {
  //     await 
  //      _database
  //         .ref('patients/${user.uid}/birthday').get();
  //         // .get({'birthday'});
  //   }
  //   return null;
  // }

  // Method to change the current user's password
  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        print("Password updated successfully.");
      } catch (e) {
        print("Failed to update password: $e");
        // Handle the error appropriately
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  // Method to initialize and start tracking with the given device token
  Future<void> initializeAndStartTracking(String deviceToken) async {
    try {
      // Set the device token
      await _trackingApi.setDeviceID(deviceId: deviceToken);
      // Enable sdk
      await _trackingApi.setEnableSdk(enable: true);
      // enable high frequency
      await _trackingApi.enableHF(value: true);
      // turn off disable tracking
      await _trackingApi.setDisableTracking(value: false);
    } catch (e) {
      print("Error initializing and starting tracking: $e");
    }
  }
}
