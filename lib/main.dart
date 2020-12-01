// import 'dart:convert';
// import 'package:easy_laundry/Widgets/myToast.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MyAppState();
//   }
// }
//
// class _MyAppState extends State<MyApp> {
//   String _message = '';
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//
//   _register() {
//     _firebaseMessaging.getToken().then((token) => print(token));
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getMessage();
//   }
//
//   void getMessage() {
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//       // MyToast(msg: 'on message ${message['notification']['body']}');
//       print('on message = ${message['notification']['body']}');
//       setState(() => _message = message["notification"]["body"]);
//     }, onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text("Message: $_message"),
//                 OutlineButton(
//                   child: Text("Register My Device"),
//                   onPressed: () {
//                     _register();
//                   },
//                 ),
//                 // Text("Message: $message")
//               ]),
//         ),
//         floatingActionButton: FloatingActionButton(onPressed: () async {
//           Map<String, String> headers = {
//             'Content-Type': 'application/json',
//             // 'Accept': 'application/json',
//             // 'Charset': 'utf-8',
//             'Authorization':
//                 'key=AAAA4HC7PA0:APA91bHXmMAlslnIwKIu_haQOrFC30CHache2zlgoK6-65nDDpZCWTP2Dy7pDdt50iOuYj2_kMayTZErxQYROpu2qqDtv073nA6JWv2kFXH_ftUUE5-4aWUDnlFHfnX3hZyNRNBn9IXD'
//           };
//           var res = await http.post("https://fcm.googleapis.com/fcm/send",
//               headers: headers,
//               body: json.encode({
//                 "to":
//                     "eM2xW-5OvrXJOs_fqqhqSm:APA91bGXUBM1g5X7RMFUk6PyacDJVshAsdaQ3-sIDmoInvQ5lcAzZ4G6pHwDU2bfhb4h4AD059PdskiGUi9TVRPIOHQxYAbutKpIJI7WAKX3NsBpKK1Se9WCm-zM0ylqVye5n6O1nZbt",
//                 "collapse_key": "New Message",
//                 "priority": "high",
//                 "notification": {
//                   "title": "Easy Laundry Notification",
//                   "body": "Hbr Sending this Notification from Easy Laundry App",
//                 }
//                 // "message": {
//                 //   "token":
//                 //       "eM2xW-5OvrXJOs_fqqhqSm:APA91bGXUBM1g5X7RMFUk6PyacDJVshAsdaQ3-sIDmoInvQ5lcAzZ4G6pHwDU2bfhb4h4AD059PdskiGUi9TVRPIOHQxYAbutKpIJI7WAKX3NsBpKK1Se9WCm-zM0ylqVye5n6O1nZbt",
//                 //   "notification": {
//                 //     "body": "This is an FCM notification message!",
//                 //     "title": "FCM Message"
//                 //   }
//                 // }
//               }));
//           print("Response = ${json.decode(res.body)}");
//         }),
//       ),
//     );
//   }
// }

import 'package:easy_laundry/Screens/login_screen.dart';
import 'package:easy_laundry/providers/Location_Model.dart';
import 'package:flutter/material.dart';
import 'package:easy_laundry/providers/OTP_Model.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Flutter_Otp(),
        ),
        ChangeNotifierProvider.value(
          value: user_model(),
        ),
        ChangeNotifierProvider.value(
          value: Location_Model(),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Easy Laundry',
          theme: ThemeData(
            primaryColor: Color(0xFF3698CF),
          ),
          home: Login_Page(),
          // home: PushMessagingExample(),
        ),
      ),
    );
  }
}

// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key key, this.title}) : super(key: key);
// //   final String title;
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// // //      appBar: AppBar(
// // //        title: Text(widget.title),
// // //      ),
// //         body: root_screen());
// //   }
// // }
