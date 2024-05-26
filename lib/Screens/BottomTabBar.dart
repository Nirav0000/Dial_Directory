import 'package:caller_app/Constent/Colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../Bottom_bar/BottomBar.dart';
import 'FavoriteScreen.dart';
import 'HomeScreen.dart';

class BottomTabbar extends StatefulWidget {
  BottomTabbar({Key? key,}) : super(key: key);


  @override
  _BottomTabbarState createState() => _BottomTabbarState();
}

class _BottomTabbarState extends State<BottomTabbar> with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [Colors.yellow, Colors.red, Colors.green, Colors.blue, Colors.pink];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
          () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
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
    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.5 ? Colors.black : Colors.white;
    return SafeArea(
      child: Scaffold(
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
            ]
          ),
          fit: StackFit.passthrough,
          icon: (width, height) => Center(
            child: Text('${storage.read('totalContacts')} Contacts'),
          ),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          showIcon: true,
          width: double.infinity,
          // width: MediaQuery.of(context).size.width * 1,
          barColor: Color(0xFF878ECD),
          start: 2,
          end: 0,
          offset: 0,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 100,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
              controller: tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Grid_Screen(controller: controller,),
                FavoriteScreen(controller: controller,),
                Test(),
                Test(),
              ]

          ),
          child: TabBar(

            dividerHeight: 0,
           automaticIndicatorColorAdjustment: true,
            padding: EdgeInsets.symmetric(vertical: 5),
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,
            splashFactory: NoSplash.splashFactory,
            splashBorderRadius: BorderRadius.circular(10),
            indicator: UnderlineTabIndicator(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: currentPage == 0
                        ? themeDarkColor
                        : currentPage == 1
                        ? themeDarkColor
                        : currentPage == 2
                        ? themeDarkColor
                        : currentPage == 3
                        ? themeDarkColor
                        :unselectedColor,
                    width: 4),
                insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Image(image: AssetImage(currentPage == 0?'assets/images/HomeManuFill.png':'assets/images/HomeManu.png'),height: 25,)),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Image(image: AssetImage(currentPage == 1?'assets/images/FavoritFillManu.png':'assets/images/FavoritManu.png'),height: 30,)),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Image(image: AssetImage(currentPage == 2?'assets/images/keyPadFilled.png':'assets/images/keyPad.png'),height: 25,)),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Image(image: AssetImage(currentPage == 3?'assets/images/SettingFillManu.png':'assets/images/SettingManu.png'),height: 30,)),
              ),

            ],
          ),),),);
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
