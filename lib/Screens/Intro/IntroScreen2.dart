

import 'package:caller_app/Screens/Intro/page_model.dart';
import 'package:concentric_transition/page_view.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Constent/Colors.dart';
import '../../Widget/widgets.dart';
import '../BottomTabBar.dart';

class Intro2 extends StatefulWidget {
  @override
  State<Intro2> createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {

  final _shoppingBox = Hive.box('GetContacts');

  List<Map<String, dynamic>> _items = [];

  List<Contact>? _contacts;

  bool isload = false;

  bool? istrue;

  Country? _selectedCountry;

  final pages = [
    const PageData(
      title: "Make some\nnoise",
      image: "assets/images/first.json",
      bdColor: AppColors.backgroundLightBlack,
      txtColor: AppColors.textColor,
    ),
    const PageData(
      title: "Let's hunt\nghosts",
      image: "assets/images/second.json",
      bdColor: AppColors.backgroundPista,
      txtColor: Colors.black,
    ),
    const PageData(
      title: "Join the\nGhost Gang.",
      image: "assets/images/gang.json",
      bdColor: Colors.white,
      txtColor: Colors.black,
    ),
  ];

  void _onPressed() async {
    final country =
    await Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PickerPage();
    }));
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        print('--------country code------> ${_selectedCountry?.callingCode}  --- ${ _selectedCountry?.name}');
        storage.write('CountryCode', _selectedCountry?.callingCode);
          istrue == true
              ? Wid_Con.NavigationOffAll(BottomTabbar())
              : Container();
      });
    }
  }

  requestStoragePermission() async {
    _onPressed();
    var status = await Permission.phone.request();
    var Status1 = await Permission.contacts.request();
    print('step 1 ');
    if (Status1.isGranted && status.isGranted) {
      print('--------country code2------> ${_selectedCountry?.callingCode}  --- ${ _selectedCountry?.name}');
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

      storage.write('gotContact', true);
      print('step 8 ');
      print('------------------conta-----------------> $_items');

      print('step 9 ');

      print('step 10 ');

      _items.isNotEmpty ? istrue = true : const CircularProgressIndicator();


      if(_selectedCountry!.callingCode.isNotEmpty){
        istrue == true
            ? Wid_Con.NavigationOffAll(BottomTabbar())
            : Container();
      }

    }else{}



    // AndroidIntent intent = const AndroidIntent(
    //   action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
    // );
    // await intent.launch();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initCountry();
  }

  // void initCountry() async {
  //   final country = await getDefaultCountry(context);
  //   setState(() {
  //     _selectedCountry = country;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
      onFinish: (){
        requestStoragePermission();
      },
        // onChange: (page) {
        //   print(page);
        //   setState((){
        //     if(page==2){
        //
        //     }
        //   });
        // },
        itemBuilder: (index){
          final page = pages[index % pages.length];
          return SafeArea(child: _Page(page: page));
        },
        itemCount: pages.length,
        colors: pages.map((e) => e.bdColor).toList(),
        radius: screenWidth*0.1,
        duration: Duration(milliseconds: 1000),
        nextButtonBuilder: (context)=>Padding(
          padding: const EdgeInsets.all(8.0),
          child:isload == false?Icon(
            Icons.navigate_next,
            size: screenWidth*0.08,
          ):CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _Page  extends StatelessWidget{
  final PageData page;
  const _Page({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    space(double p)=>SizedBox(height: screenWidth*p/100);
    return Column(
      children: [
        space(45),
        Container(
          decoration: BoxDecoration(
            color: page.bdColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: -5,
                blurRadius: 50,
                offset: const Offset(0, 30),
              ),
            ],
          ),
          height: screenWidth*0.6,
          width: screenWidth*0.8,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(page.image.toString(),),
                ],
              )),),
        space(10),
        _Text(
            page:page,
            style:TextStyle(
                fontSize:45,
                fontFamily: 'demo',
                color: page.txtColor,
                fontWeight: FontWeight.w600,
                height: 1
            )
        ),
        space(50),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    Key? key,
    required this.page,
    this.style,
  }):super(key : key);

  final PageData page;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${page.title}',style: style,textAlign: TextAlign.center,),
      ],
    );
  }
}


class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        backgroundColor: themeColor,
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Text('Select Country'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: CountryPickerWidget(
            onSelected: (country) => Navigator.pop(context, country),
          ),
        ),
      ),
    );
  }
}