import 'dart:async';

import 'package:caller_app/Constent/Colors.dart';
import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Bottom_bar/BottomBar.dart';
import 'FavoriteScreen.dart';
import 'HomeScreen.dart';
import 'KeypadSheet.dart';
import 'SettingScreen.dart';

class BottomTabbar extends StatefulWidget {
  BottomTabbar({
    Key? key, this.page,
  }) : super(key: key);
  final page;

  @override
  _BottomTabbarState createState() => _BottomTabbarState();
}

class _BottomTabbarState extends State<BottomTabbar>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink
  ];
  DirectDialer? dialer;
  Future<void> setupDialer() async => dialer = await DirectDialer.instance;
  InterstitialAd? interstitialAd;


  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 3, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    Timer(Duration(seconds: 15,), () {
      InterstitialAD();
    });
    super.initState();
  }

  Future<void> InterstitialAD() async {
   await InterstitialAd.load(
        adUnitId: 'ca-app-pub-5175616370870793/7351236434',
        request: AdRequest(),
        adLoadCallback:
        InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          interstitialAd?.show();
        }, onAdFailedToLoad: (LoadAdError loadError) {
          print("InterstitialAd failed to load : $loadError");
        }));
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.5
        ? Colors.black
        : Colors.white;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:tabController.index!=2?
      Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          child: Image(
            image: AssetImage('assets/images/keyPadFilled.png'),
            height: 25,
          ),
          backgroundColor: bottomBG,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                constraints: BoxConstraints.loose(Size(
                    MediaQuery.of(context).size.width,
                  680)),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return  KeyPadSheet(dialer: dialer,);
               }
            );
          },
        ),
      ):
      Container(),
      body: BottomBar(
        barDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 5,
                color: grey.withOpacity(0.5),
                // offset: Offset(0, 5),
              )
            ]),
        fit: StackFit.passthrough,
        icon: (width, height) => Center(
          child: Text('${storage.read('totalContacts')} Contacts'),
        ),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        duration: Duration(milliseconds: 200),
        curve: Curves.decelerate,
        showIcon: true,
        width: double.infinity,
        // width: MediaQuery.of(context).size.width * 1,
        barColor: bottomBG,
        start: 2,
        end: 0,
        offset: 0,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 100,
        reverse: false,
        hideOnScroll:storage.read('totalContacts')==null?false: int.parse(storage.read('totalContacts').toString())<20?false:true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Grid_Screen(
                controller: controller,
              ),
              FavoriteScreen(
                controller: controller,
              ),
              SettingScreen(),
            ]),
        child: TabBar(
          dividerHeight: 0,
          automaticIndicatorColorAdjustment: true,
          padding: EdgeInsets.symmetric(vertical: 5),
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          controller: tabController,
          splashFactory: NoSplash.splashFactory,
          splashBorderRadius: BorderRadius.circular(10),
          indicator: UnderlineTabIndicator(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: currentPage == 0
                      ? white
                      : currentPage == 1
                          ? white
                          : currentPage == 2
                              ? white
                              : currentPage == 3
                                  ? white
                                  : unselectedColor,
                  width: 4),
              insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
          tabs: [
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                  child: Image(
                image: AssetImage(currentPage == 0
                    ? 'assets/images/HomeManuFill.png'
                    : 'assets/images/HomeManu.png'),
                height: 25,
              )),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                  child: Image(
                image: AssetImage(currentPage == 1
                    ? 'assets/images/FavoritFillManu.png'
                    : 'assets/images/FavoritManu.png'),
                height: 30,
              )),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                  child: Image(
                image: AssetImage(
                    currentPage == 3
                    ? 'assets/images/SettingFillManu.png'
                    : 'assets/images/SettingManu.png'),
                height: 30,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Test'),
      ),
    );
  }
}
