import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:telematics_sdk_example/services/auth.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final ScrollController _controller;
  bool _useController = true;

  // This method handles the notification from the ScrollController.
  void _handleControllerNotification() {
    // print('Notified through the scroll controller.');
    // Access the position directly through the controller for details on the
    // scroll position.
  }

  @override
  void initState() {
    _controller = ScrollController();
    if (_useController) {
      // When listening to scrolling via the ScrollController, call
      // `addListener` on the controller.
      _controller.addListener(_handleControllerNotification);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    // ListView.separated works very similarly to this example with
    // CustomScrollView & SliverList.
  
    Widget body= CustomScrollView(
      // Provide the scroll controller to the scroll view.
      controller: _controller,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(.5),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const Text("T"),
                const Text('E'),
                const Text('S'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text('T'),
                const Text(' '),
                const Text(' '),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey),
                  child: CheckboxListTile(
                    title: const Text(
                        'By clicking, you confirm that you have read, understand, and agree with our privacy statement.',
                        style: TextStyle(fontSize: 10)),
                    value: isChecked,
                    // tileColor:Colors.grey,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },

                    // secondary: const Icon(Icons.hourglass_empty),
                  ),
                ),
                const Text(' '),
                const Text(' '),
                const Text(' '),
              ],
            ),
          ),
        ),
      ],
      // slivers: <Widget>[
      //       // const Text("test"),
      //   SliverList.separated(
      //     itemCount: 30,
      //     itemBuilder: (_, int index) {
      //       return Padding(
      //         padding: const EdgeInsets.symmetric(
      //           vertical: 8.0,
      //           horizontal: 20.0,
      //         ),
      //         child: Text('Item $index'),
      //       );
      //     },

      //     separatorBuilder: (_, __) => const Divider(
      //       indent: 20,
      //       endIndent: 20,
      //       thickness: 2,
      //     ),
      //     // const Text("test"),
      //   ),
      // ],
    
    );
    if (!_useController) {
      // If we are not using a ScrollController to listen to scrolling,
      // let's use a NotificationListener. Similar, but with a different
      // handler that provides information on what scrolling is occurring.
      body = NotificationListener<ScrollNotification>(
        // onNotification: _handleScrollNotification,
        child: body,
        
      );
    }

    return MaterialApp(
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 92, 147, 174)),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Statement'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        ),
        body: body,
      
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerNotification);
    super.dispose();
  }
}
