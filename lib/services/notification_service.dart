// /*
// import 'dart:math';
// */
//
// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
//
// class LocalNotificationService {
//   BuildContext? context;
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   static void initialize() async {
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: AndroidInitializationSettings(
//             "@mipmap/ic_launcher"),
//         iOS: DarwinInitializationSettings());
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     NotificationSettings settings =
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.instance.getInitialMessage().then(
//           (message) {
//         print("FirebaseMessaging.instance.getInitialMessage");
//         if (message != null) {
//           print("New Notification");
//           print('${message.notification!.body}_________body1____');
//           print("message.data12 ${message.data}");
//           // if (message.data['_id'] != null) {
//           //   Navigator.of(context).push(
//           //     MaterialPageRoute(
//           //       builder: (context) => DemoScreen(
//           //         id: message.data['_id'],
//           //       ),
//           //     ),
//           //   );
//           // }
//         }
//       },
//     );
//
//     FirebaseMessaging.onMessage.listen(
//           (message) {
//         print("FirebaseMessaging.onMessage______________");
//         if (message.notification != null) {
//           print('${message.notification}_________________');
//           print('${message.notification!.body}_________body____');
//           print("message.data11 ${message.data}");
//
//          display(message);
//          // Get.to(const FeedbackScreen());
//           //handleNotification(message.data);
//
//         }
//       },
//     );
//
//     FirebaseMessaging.onMessageOpenedApp.listen(
//           (message) {
//         print("FirebaseMessaging.onMessageOpenedApp___________");
//         if (message.notification != null) {
//           print('_____________${message.notification}_______________');
//           print('_____________${message.notification?.title}_______________');
//           print(message.notification!.body);
//           print("message.data22 ${message.data}");
//
//           // Get.to(FeedbackScreen());
//           //handleNotification(message.data);
//
//          // HomeScreenState().setSegmentValue(2) ;
//
//
//
//
//         }
//       },
//     );
//
//
//   }
//   static  Future<void> handleNotification(Map<String, dynamic> message) async {
//     final NotificationAppLaunchDetails? notificationAppLaunchDetails =
//     await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//     if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
//       // App was opened from a notification
//       // TODO: handle the notification
//
//     } else {
//       // App was opened normally
//     }
//   }
//
//
//   static void display(RemoteMessage message) async {
//     try {
//       print("In Notification method");
//       // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
//       Random random = Random();
//       int id = random.nextInt(1000);
//       const NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             "JdxApp",
//             "JdxApp",
//             importance: Importance.max,
//             priority: Priority.high,
//           ));
//       //print("my id is ${id.toString()}");
//       await _flutterLocalNotificationsPlugin.show(
//           id,
//           message.notification!.title,
//           message.notification!.body,
//           notificationDetails,
//           payload: message.data['_id']);
//     } on Exception catch (e) {
//       print('Error>>>$e');
//     }
//   }
//
//
//
// }

/*
import 'dart:math';
*/


import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdx/Controller/BottomNevBar.dart';
import 'package:jdx/Controller/home_controller.dart';
import 'package:jdx/Views/HomeScreen.dart';

class LocalNotificationService {
  static final ctrl= Get.put(HomeController());

  BuildContext? context;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() async {
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings(
          "@mipmap/ic_launcher"),
      //iOS: DarwinInitializationSettings()
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");

        }
      },
    );

    FirebaseMessaging.onMessage.listen(
          (message) {
        if (message.notification != null) {
          print("message.data11 ${message.data}");
          if(message.data['type']=='order'){
            // ctrl.getOrders(status: message.data['status']);
          }
          display(message);
          // Get.to(BottomNav());
          //handleNotification(message.data);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        if (message.notification != null) {

          print(message.notification!.body);
          print("message.data22 ${message.data}");



        }
      },
    );


  }
  static  Future<void> handleNotification(Map<String, dynamic> message) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      // App was opened from a notification
      // TODO: handle the notification

    } else {
      // App was opened normally
    }
  }


  static void display(RemoteMessage message) async {
    try {
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "default_notification_channel",
            "Pickport",
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('test')
          ));
      await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: message.data['_id']);

    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }



}