import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constent/Colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,

centerTitle: true,
        title: Text(
          "Settings",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: "Montserrat",
              color: themeDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
                offset: Offset(80, -80),
                child: Image(image: AssetImage('assets/images/bg_settinf.png'),height: 200,opacity: const AlwaysStoppedAnimation(.6),)),
          ),
          Padding(
          padding: const EdgeInsets.only(left: 20,top: 40),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100),bottomLeft: Radius.circular(100)),
                hoverColor: transparent,
                splashColor: themeColor.withOpacity(0.1),
                highlightColor: white.withOpacity(0.3),
                onTap: () async {
                  await launchUrl(Uri.parse('https://www.termsfeed.com/live/f9805160-fc5b-425a-8c37-9889ec39dd1c'));
                },
                child: Container(
                  color: transparent,
                  child: Row(
                    children: [
                      Image(image: AssetImage('assets/images/policy.png'),height: 60,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            "Privacy Policy",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                color: themeDarkColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(100),bottomLeft: Radius.circular(100)),
                  hoverColor: transparent,
                  splashColor: themeColor.withOpacity(0.1),
                  highlightColor: white.withOpacity(0.3),
                  onTap: () async {
                    String email = Uri.encodeComponent("dninfotech16@gmail.com");
                    String subject =
                    Uri.encodeComponent("Hello Sir, - Caller App");
                    String body = Uri.encodeComponent("Hi! ");
                    print(subject); //output: Hello%20Flutter
                    Uri mail =
                    Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                    //email app opened
                    } else {
                    //email app is not opened
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/images/contact_us.png'),height: 60,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              "Contact Us",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: themeDarkColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(100),bottomLeft: Radius.circular(100)),
                  hoverColor: transparent,
                  splashColor: themeColor.withOpacity(0.1),
                  highlightColor: white.withOpacity(0.3),
                  onTap: () {
                    FlutterShare.share(
                        linkUrl:
                        "https://play.google.com/store/apps/details?id=com.dn.dialdirectory",
                        title: 'Caller App');
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/images/share_us.png'),height: 60,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              "Share Us",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: themeDarkColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(100),bottomLeft: Radius.circular(100)),
                  hoverColor: transparent,
                  splashColor: themeColor.withOpacity(0.1),
                  highlightColor: white.withOpacity(0.3),
                  onTap: () {
                    LaunchReview.launch(androidAppId: "com.dn.dialdirectory");
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/images/rate_us.png'),height: 60,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              "Rate Us",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: themeDarkColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Image(image: AssetImage('assets/images/version.png'),height: 60,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "App Version",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: themeDarkColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Version: 1.0.1",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: themeDarkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )],
      ),
    );
  }
}
