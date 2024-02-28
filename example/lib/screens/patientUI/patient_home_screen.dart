import 'dart:async';
import 'dart:io' show Platform;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:telematics_sdk/telematics_sdk.dart';
import 'package:telematics_sdk_example/screens/patientUI/settings_screen.dart';
import 'package:telematics_sdk_example/screens/patientUI/tutorial_screen.dart';

const _sizedBoxSpace = SizedBox(height: 24);

class PatientHomeScreen extends StatefulWidget {
  PatientHomeScreen({Key? key}) : super(key: key);

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final _trackingApi = TrackingApi();
  late StreamSubscription<PermissionWizardResult?>
      _onPermissionWizardStateChanged;
  late StreamSubscription<bool> _onLowerPower;
  late StreamSubscription<TrackLocation> _onLocationChanged;

  var _deviceId = '';
  var _isSdkEnabled = false;
  var _isAllRequiredPermissionsGranted = false;
  var _isTracking = true;
  var _isAggressiveHeartbeats = false;
  TrackLocation? _location;

  final _tokenEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _onPermissionWizardStateChanged =
        _trackingApi.onPermissionWizardClose.listen(_onPermissionWizardResult);
    _onLowerPower = _trackingApi.lowerPowerMode.listen(_onLowPowerResult);
    _onLocationChanged =
        _trackingApi.locationChanged.listen(_onLocationChangedResult);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // get Device ID
    final virtualDeviceToken = await _trackingApi.getDeviceId();

    // set decive_id and text field - if empty; disable SDK
    if (virtualDeviceToken != null && virtualDeviceToken.isNotEmpty) {
      _deviceId = virtualDeviceToken;
      _tokenEditingController.text = _deviceId;
    } else {
      await _trackingApi.setEnableSdk(enable: false);
    }
    // bool if SDK is enabled
    _isSdkEnabled = await _trackingApi.isSdkEnabled() ?? false;

    // bool if perms are granted
    _isAllRequiredPermissionsGranted =
        await _trackingApi.isAllRequiredPermissionsAndSensorsGranted() ?? false;

    // disable tracking & aggressive heartbeats
    if (Platform.isIOS) {
      final disableTracking = await _trackingApi.isDisableTracking() ?? false;
      _isTracking = !disableTracking;
      _isAggressiveHeartbeats =
          await _trackingApi.isAggressiveHeartbeat() ?? false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

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
              Text('HOME', style: TextStyle(color: Colors.black, fontSize: 20)),
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
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          _logo(),
          Text('SDK status: ${_isSdkEnabled ? 'Enabled' : 'Disabled'}'),
          Text(
            'Permissions: ${_isAllRequiredPermissionsGranted ? 'Granted' : 'Not granted'}',
          ),
          Text("Virtual Device Token:\n ${_tokenEditingController.text}"),
          (Platform.isIOS)
              ? Text(
                  'Tracking: ${_isSdkEnabled && _isTracking ? 'Enabled' : 'Disabled'}')
              : SizedBox.shrink(),
          Text(_getCurrentLocation()),
          _sizedBoxSpace,
          // ElevatedButton(
          //   onPressed: () async {
          //     await _onPermissionsSDK();
          //   },
          //   child: const Text('Start Permission Wizard'),
          // ),
          _sizedBoxSpace,
          // (_isAllRequiredPermissionsGranted !=isAllRequiredPermissionsAndSensorsGranted())
          // if(!_isAllRequiredPermissionsGranted){

          // },
          // (Platform.isIOS)
          //     ? Row(
          //         children: [
          //           Expanded(
          //             child: const Text('Aggressive Heartbeats'),
          //           ),
          //           Switch.adaptive(
          //               value: _isAggressiveHeartbeats,
          //               onChanged:
          //                   _isSdkEnabled ? _onAggressiveHeartbeats : null)
          //         ],
          //       )
          //     : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  @override
  void dispose() {
    _onPermissionWizardStateChanged.cancel();
    _onLowerPower.cancel();
    _onLocationChanged.cancel();
    super.dispose();
  }

  Future<void> _onAggressiveHeartbeats(bool value) async {
    await _trackingApi.setAggressiveHeartbeats(value: value);
    _isAggressiveHeartbeats =
        await _trackingApi.isAggressiveHeartbeat() ?? false;
    setState(() {});
  }

  Future<void> _onPermissionsSDK() async {
    if (!_isAllRequiredPermissionsGranted) {
      _trackingApi.showPermissionWizard(
        enableAggressivePermissionsWizard: false,
        enableAggressivePermissionsWizardPage: true,
      );
    } else {
      _showSnackBar('All permissions are already granted');
    }
  }

  void _onPermissionWizardResult(PermissionWizardResult result) {
    const _wizardResultMapping = {
      PermissionWizardResult.allGranted: 'All permissions was granted',
      PermissionWizardResult.notAllGranted: 'All permissions was not granted',
      PermissionWizardResult.canceled: 'Wizard cancelled',
    };

    if (result == PermissionWizardResult.allGranted ||
        result == PermissionWizardResult.notAllGranted) {
      setState(() {
        _isAllRequiredPermissionsGranted =
            result == PermissionWizardResult.allGranted;
      });
    }

    _showSnackBar(_wizardResultMapping[result] ?? '');
  }

  void _onLowPowerResult(bool isLowPower) {
    if (isLowPower) {
      _showSnackBar(
        "Low Power Mode.\nYour trips may be not recorded. Please, follow to Settings=>Battery=>Low Power",
      );
    }
  }

  void _onLocationChangedResult(TrackLocation location) {
    print(
        'location latitude: ${location.latitude}, longitude: ${location.longitude}');
    setState(() {
      _location = location;
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _getCurrentLocation() {
    if (_location != null) {
      return 'Location: ${_location!.latitude}, ${_location!.longitude}';
    } else {
      return 'Location: null';
    }
  }
}
