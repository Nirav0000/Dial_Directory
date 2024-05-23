import 'package:caller_app/Constent/Colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../Bottom_bar/BottomBar.dart';
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
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 5,
                color: grey,
                offset: Offset(0, 5),
              )
            ]
          ),
          fit: StackFit.expand,
          icon: (width, height) => Center(
            child: Text('${storage.read('totalContacts')} Contacts'),
          ),
          borderRadius: BorderRadius.circular(500),
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: Colors.white,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 100,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: true,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
              controller: tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const BouncingScrollPhysics(),
              children: [
                Grid_Screen(controller: controller,),
                Grid_Screen(controller: controller,),
                Grid_Screen(),
                Grid_Screen(),
              ]

          ),
          child: TabBar(
            dividerHeight: 0,
            padding: EdgeInsets.symmetric(vertical: 5),
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,splashFactory: NoSplash.splashFactory,
            splashBorderRadius: BorderRadius.circular(50),
            indicator: UnderlineTabIndicator(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: currentPage == 0
                        ? blue
                        : currentPage == 1
                        ? blue
                        : currentPage == 2
                        ? blue
                        : currentPage == 3
                        ? blue
                        :unselectedColor,
                    width: 4),
                insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                      Icons.home,
                      color: currentPage == 0 ? blue : grey,
                    )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                      Icons.search,
                      color: currentPage == 1 ? blue : grey,
                    )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                      Icons.add,
                      color: currentPage == 2 ? blue : grey,
                    )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: currentPage == 3 ? blue : grey,
                    )),
              ),

            ],
          ),),),);
  }
}