import 'package:caller_app/Screens/Intro/IntroScreen2.dart';
import 'package:caller_app/testScreen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Screens/SplashScreen.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await GetStorage.init();
  await Hive.initFlutter();
  await Hive.openBox('GetContacts');
  runApp(
      // DevicePreview(
      //   enabled: true,
      //   builder: (context) =>
            GetMaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // No scaling
          );
        },
        // builder: FToastBuilder(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
        ),
        home: SplashScreen(),
        // home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    // )
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}