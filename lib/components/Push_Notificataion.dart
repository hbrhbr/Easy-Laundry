
// import 'package:easy_laundry/Widgets/myToast.dart';
// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
// class Push_Notification{
//
//   var playerId;
//   _send_notification()async{
//     try{
//       await OneSignal.shared.postNotificationWithJson({
//       "include_player_ids" : [ playerId],
//       "contents" : {"en" : "test notification"}
//     });
//     }
//     catch(e){
//       print("Excetion Occured = $e");
//     }
//   }
//
//   // configOneSignle()async{
//   //   await OneSignal.shared.init("bf274db0-489d-47dd-9353-772bbab62d43");
//   //   var status = await OneSignal.shared.getPermissionSubscriptionState();
//   //   playerId = status.subscriptionStatus.userId;
//   //   print("response = $playerId");
//   //   OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
//   //   OneSignal.shared.setNotificationReceivedHandler((notification) {
//   //     //Notification Content
//   //     Map<String,dynamic> a = notification.payload.additionalData;
//   //     List<int>user_ids = a["user_ids"];
//   //     print("User Ids = ${user_ids}");
//   //     if(user_ids.contains(2))
//   //     {
//   //       MyToast(msg:user_ids.contains(2).toString());
//   //     }
//   //     setState(() {
//   //       notification_content = notification.jsonRepresentation().replaceAll("\\n", "\n");
//   //     });
//   //   });
//   // }
// }