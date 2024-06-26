import 'package:caller_app/Constent/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';



class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key, this.isrequire}) : super(key: key);
  final isrequire;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Center(
            child: Container(
            height: 400,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("App  Update is required!",
                  textAlign: TextAlign.center, style: TextStyle(
                    fontFamily: "Montserrat",
                    color: bottomBG,
                    fontSize: 20, fontWeight: FontWeight.w700
                ),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30,top: 20),
                  child: Text("We have added new features and fix some bugs to make your experience seamless ",
                    textAlign: TextAlign.center, style: TextStyle(
                      fontFamily: "Montserrat",
                      color: bottomBG,
                      fontSize: 18, fontWeight: FontWeight.w500
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(moreinfobg),
                        minimumSize: MaterialStateProperty.all<Size?>(Size(200, 50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),

                      ),
                      onPressed: launchMap,
                      child:  Text(
                        "UPDATE",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      )),
                )
              ],
            ),
                    ),
          ),
          Transform.translate(
              offset: Offset(0, -200),
              child: Center(child: Image(image: AssetImage('assets/images/update_bg.png'),height: 300,)))
        ],
      ),
    );
  }
}
void launchMap() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appPackageName = packageInfo.packageName;
  String googleUrl = "https://play.google.com/store/apps/details?id=" + appPackageName;

  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  }


}
