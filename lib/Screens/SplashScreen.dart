import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:caller_app/Widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../Constent/Colors.dart';
import 'BottomTabBar.dart';
import 'Intro/IntroScreen2.dart';
import 'UpdateScreen.dart';

// class MyCustomWidget extends StatefulWidget {
//   @override
//   MyCustomWidgetState createState() => MyCustomWidgetState();
// }
//
// class MyCustomWidgetState extends State<MyCustomWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'Suppose this is an app in your Phone\'s Screen page.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             OpenContainer(
//               closedBuilder: (_, openContainer) {
//                 return Container(
//                   height: 80,
//                   width: 80,
//                   child: Center(
//                     child: Text(
//                       'App Logo',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               openColor: Colors.white,
//               closedElevation: 20,
//               closedShape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               transitionDuration: Duration(milliseconds: 700),
//               openBuilder: (_, closeContainer) {
//                 return SecondPage();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _a = true;
      });
    });
    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _b = true;
      });
    });
    Timer(Duration(milliseconds: 1300), () {
      setState(() {
        _c = true;
      });
    });
    Timer(Duration(milliseconds: 1700), () {
      setState(() {
        _e = true;
      });
    });
    Timer(Duration(milliseconds: 3400), () {
      setState(() {
        _d = true;
      });
    });
    Timer(Duration(milliseconds: 3000), () {
      setState(() {
        getappversion();

      });
    });


  }

  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;
  int? app_version_api;

  @override
  void dispose() {
    super.dispose();
  }



  Future<void> getappversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // Map<String, dynamic> map1 = {
    //   'fn': 'getAppVersion'
    // };
    var response = await http
        .get(Uri.parse("https://www.dninfotechin.com/api/app-version"));
    final appversionAPI = json.decode(response.body);

    String build_version = packageInfo.version;
    int build_number = int.parse(packageInfo.buildNumber);
    print('Response...................................................: ${appversionAPI['dialDirectory']['version']}');
    print(
        'build_number...................................................: ${build_number}');

    // appversion = Appversion.fromJson(res);

    // setState(() {
    app_version_api = int.parse(appversionAPI['dialDirectory']['version'].toString());

    // splashscreen.preferences!.setString("app_version", app_version);
    print(
        'app_version............................................ ${app_version_api}');
    // });

    if (build_number < 2/*app_version_api!*/) {
      // ignore: use_build_context_synchronously
      // Wid_Con.NavigationOff(const UpdateScreen());
      Navigator.of(context).pushReplacement(
        ThisIsFadeRoute(
          route: UpdateScreen(isrequire: appversionAPI['dialDirectory']['isRequiredUpdate'],),
        ),
      );
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => UpdateScreen(),
      //   ),
      // );
    } else {
      Navigator.of(context).pushReplacement(
        ThisIsFadeRoute(
          route: storage.read('gotContact')==true? BottomTabbar():Intro2(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: _d ? 900 : 2500),
              curve: _d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
              height: _d
                  ? 0
                  : _a
                  ? _h / 2
                  : 20,
              width: 20,
              // color: Colors.deepPurpleAccent,
            ),
            AnimatedContainer(
              duration: Duration(
                  seconds: _d
                      ? 1
                      : _c
                      ? 1
                      : 0),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d
                  ? _h
                  : _c
                  ? 220
                  : 20,
              width: _d
                  ? _w
                  : _c
                  ? 220
                  : 20,
              decoration: BoxDecoration(
                  color: _b ? themeColor : Colors.transparent,
                  // shape: _c? BoxShape.rectangle : BoxShape.circle,
                  borderRadius:
                  _d ? BorderRadius.only() : BorderRadius.circular(30)),
              child: Center(
                child: _e
                    ? Container(
                  color: transparent,
                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _e?
                          Container(
                            height: 100,
                            width: 100,

                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: transparent,
                              image: DecorationImage(image: AssetImage('assets/images/logo.png'))
                            ),
                          ):Container(),
                          AnimatedTextKit(
                                            totalRepeatCount: 1,
                                            animatedTexts: [
                          FadeAnimatedText(
                            'Dial Directory',
                            duration: Duration(milliseconds: 1700),
                            textStyle: TextStyle(
                              color: black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                                            ],
                                          ),
                        ],
                      ),
                    )
                    : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget? page;
  final Widget? route;

  ThisIsFadeRoute({this.page, this.route})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page!,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: route,
        ),
  );
}

