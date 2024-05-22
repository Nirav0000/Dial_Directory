import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'Screens/BottomTabBar.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/Intro/IntroScreemn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('shopping_box');
  runApp(
    GetMaterialApp(

      home: Intro(),
      debugShowCheckedModeBanner: false,
    )
  );
}