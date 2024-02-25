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

  final String instanceId = "ccfcceb5-c86d-4eea-8a76-e5aab2e89d21";
  final String instanceKey = "ceee91a5-87f2-4ef5-836a-5a7922718d6e";

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
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        clientId: clientId,
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



Future<AppUser?> registerPhysician({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String NIP,
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
          'Last Name' : lastName, 
          'phone': phone,
          'NIP' : NIP,
          'OrgName' : OrgName
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

  // Get Device token (Firebase side)
  Future<String?> getDeviceTokenForUser(String? uid, bool isNewUser) async {
    if (uid == null) {
      print("UID is null. Cannot retrieve device token.");
      return null;
    }

    DatabaseReference dbRef = FirebaseDatabase.instance.ref('userTokens/$uid');

    try {
      DataSnapshot snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null && data.containsKey('deviceToken')) {
          final String? deviceToken = data['deviceToken'];
          print("Device token for UID $uid is: $deviceToken");
          login(deviceToken);
          if(isNewUser){
             _trackingApi.showPermissionWizard(
        enableAggressivePermissionsWizard: false,
        enableAggressivePermissionsWizardPage: true);
          }
          else{
            
          }
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

  // Method to login to Damoov
  Future<void> login(String? userId) async {
    var url = Uri.parse('https://user.telematicssdk.com/v1/Auth/Login');

    var headers = {
      'accept': 'application/json',
      'InstanceId': 'ccfcceb5-c86d-4eea-8a76-e5aab2e89d21',
      'content-type': 'application/json',
    };

    var body = jsonEncode({
      'LoginFields': {"Devicetoken": userId},
      'Password': 'ceee91a5-87f2-4ef5-836a-5a7922718d6e'
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

//  setState(() {});
      // // Show the permission wizard and request necessary permissions
      // _trackingApi.showPermissionWizard(
      //   enableAggressivePermissionsWizard: true,
      //   enableAggressivePermissionsWizardPage: true,
      // );

      // // Listener for permission wizard result
      // final permissionWizardResult =
      //     await _trackingApi.onPermissionWizardClose.first;
      // if (permissionWizardResult == PermissionWizardResult.allGranted) {
      //   // Check if SDK is enabled and enable it if not
      //   final isSdkEnabled = await _trackingApi.isSdkEnabled() ?? false;
      //   if (!isSdkEnabled) {
      //     await _trackingApi.setEnableSdk(enable: true);
      //   }

      //   // Start tracking
      //   final isTracking = await _trackingApi.isTracking() ?? false;
      //   if (!isTracking) {
      //     await _trackingApi.startTracking();
      //   }

      //   print("SDK Enabled and Tracking Started");
      // } else {
      //   print(
      //       "Permissions not fully granted. SDK not enabled and tracking not started.");
      // }
    } catch (e) {
      print("Error initializing and starting tracking: $e");
    }
  }
}
