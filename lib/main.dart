
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jdx/Utils/Color.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:jdx/services/demo_localization.dart';
import 'package:jdx/services/notification_service.dart';
import 'package:jdx/services/session.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Views/splash.dart';


@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint(message.data.toString());
  //debugPrint(message.notification!.title);
}

LocalNotificationService notificationClass = LocalNotificationService();
Future<void> handleNotificationPermission() async {
  const permission = Permission.notification;
  final status = await permission.status;
  if (status.isGranted) {
    print('User granted this permission before');
  } else {
    final before = await permission.shouldShowRequestRationale;
    final rs = await permission.request();
    final after = await permission.shouldShowRequestRationale;

    if (rs.isGranted) {
      print('User granted notication permission');
    } else if (!before && after) {
      print('Show permission request pop-up and user denied first time');
    } else if (before && !after) {
      print('Show permission request pop-up and user denied a second time');
    } else if (!before && !after) {
      print('No more permission pop-ups displayed');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await handleNotificationPermission();
  await Permission.location.request();
  // FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: CustomColors.primaryColor, // status bar color
  ));
  //notificationClass.initNotification();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);


  // LocalNotificationService.initialize();

  try {
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint("-----------token:-----${token}");
  } on FirebaseException {
    debugPrint('__________FirebaseException_____________');
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
    debugPrint('__________${state}_________');
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted)
      setState(() {
        _locale = locale;
      });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (mounted)
        setState(() {
          this._locale = locale;
        });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PickPort Driver',
      locale: _locale,
      supportedLocales: [
        Locale("kn", "IN"),
        Locale("hi", "IN"),
        Locale("en", "US"),
        Locale("ta", "IN"),
        Locale("te", "IN"),
        Locale("mr", "IN"),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        // fontFamily: GoogleFonts.poppins().fontFamily,
        primarySwatch: colors.primary_app,
      ),
      home: SplashScreen(),
    );
  }
}
