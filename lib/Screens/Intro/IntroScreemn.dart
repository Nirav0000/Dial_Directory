import 'package:animated_introduction/animated_introduction.dart';
import 'package:caller_app/Constent/Colors.dart';
import 'package:caller_app/Screens/BottomTabBar.dart';
import 'package:caller_app/Widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class Intro extends StatefulWidget {
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  // const Intro({super.key});
  final List<SingleIntroScreen> pages = [
    const SingleIntroScreen(
      title: 'Welcome to the Event Management App !',
      description: 'You plans your Events, We\'ll do the rest and will be the best! Guaranteed!  ',
      imageAsset: 'assets/images/onboard_one.png',
    ),
    const SingleIntroScreen(
      title: 'Book tickets to cricket matches and events',
      description: 'Tickets to the latest movies, crickets matches, concerts, comedy shows, plus lots more !',
      imageAsset: 'assets/images/onboard_two.png',
    ),
    const SingleIntroScreen(

      title: 'Grabs all events now only in your hands',
      description: 'All events are now in your hands, just a click away ! ',
      imageAsset: 'assets/images/onboard_three.png',
    ),
  ];

  final _shoppingBox = Hive.box('GetContacts');

  List<Map<String, dynamic>> _items = [];

  List<Contact>? _contacts;

  bool isload = false;

  bool? istrue;

  requestStoragePermission() async {

    var status = await Permission.phone.request();
    var Status1 = await Permission.contacts.request();
    print('step 1 ');
    if (Status1.isGranted && status.isGranted) {

      setState(() {
        isload = true;
      });
      print('step 2 ');
      _contacts = await FlutterContacts.getContacts(
          withThumbnail: true,
          withProperties: true,
          withPhoto: true,
          withAccounts: true);
      print('step 3 ');
      Future<void> _createItem(Map<String, dynamic> newItem) async {
        await _shoppingBox.add(newItem);
      }

      print('step 4 ');

      print('step 5 ');
      _contacts?.forEach((e) {
        print("------------------>  ${e.displayName}");
        print("------->  ${e.phones.isEmpty ? '0' : e.phones.first.number}");
        _createItem({
          "name": e.displayName.isEmpty ? '' : e.displayName,
          "phone": e.phones.isEmpty ? '' : e.phones.first.number,
          "image": e.photo
        });
      }); // });
      // }

      print('step 6 ');
      final data = _shoppingBox.keys.map((key) {
        final value = _shoppingBox.get(key);
        return {
          "key": key,
          "name": value["name"],
          "phone": value['phone'],
          "image": value['image']
        };
      }).toList();
      print('step 7 ');

      _items = data.toList();

      storage.write('gotContect', true);
      print('step 8 ');
      print('------------------conta-----------------> $_items');

      print('step 9 ');

      print('step 10 ');
      _items.isNotEmpty ? istrue = true : const CircularProgressIndicator();

      istrue == true
          ? Wid_Con.NavigationOffAll(BottomTabbar())
          : Container();

    }else{}



    // AndroidIntent intent = const AndroidIntent(
    //   action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
    // );
    // await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
        doneWidget: isload == false?Text('Done',style: TextStyle(
          fontSize: 18,color: black,
          fontWeight: FontWeight.bold
        ),):CircularProgressIndicator(color: black,),
        footerBgColor: themeColor,
        containerBg: Color(0xFFF7D7DA),
        indicatorType: IndicatorType.line,
          textColor: black,
          slides: pages,

          onDone: (){
            requestStoragePermission();

          },
    );
  }
}
