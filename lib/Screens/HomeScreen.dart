import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';


import '../Constent/Colors.dart';
import '../Controller/GetController.dart';
import '../Widget/widgets.dart';
import 'MoreInfo.dart';

class Grid_Screen extends StatefulWidget {
  Grid_Screen({
    Key? key,
    this.controller,
  }) : super(key: key);
  final ScrollController? controller;

  @override
  State<Grid_Screen> createState() => _Grid_ScreenState();
}

class _Grid_ScreenState extends State<Grid_Screen> {
  var homeController = Get.put(MyController());
  List<Map<String, dynamic>> _items = [];
  List? _contacts;
  bool DBdata = false;
  var DATA;
  var size, height, width;
  final _shoppingBox = Hive.box('GetContacts');
  List FevoritsItme = [];
  int clickCount = 0;
  List? uniquePersons;
  bool isFevorit = false;
  int _selectedIndex = -1;
  DirectDialer? dialer;
  List _filteredContacts = [];
  int isexpan = -1;
  bool isChangeView = storage.read('selectView')??false;
  GlobalKey<AnimatedListState> _key = GlobalKey();
  ScrollController _scrollController = ScrollController();
  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    setupDialer();
    getphoneDate();
    _refreshItems();
    loadSelectedItems();
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


  Future<void> setupDialer() async => dialer = await DirectDialer.instance;

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems(); // update the UI
  }

  void getphoneDate() async {
    if (await FlutterContacts.requestPermission()) {
      _contacts = await FlutterContacts.getContacts(
          withThumbnail: true,
          withProperties: true,
          withPhoto: true,
          withAccounts: true);
    }
  }

  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "phone": value['phone'],
        "image": value['image'],
        "email": value['email'],
      };
    }).toList();

    setState(() {
      _items = data.toList();
      _filteredContacts = _items;
      _items.forEach((e) {
setState(() {
  if(e['name']==''||e['phone']==''){
    _deleteItem(e['key']);
  }
});
        // print('------name-----> ${e['name']}');
        // print('------phone--------> ${e['phone']}');
      });
      storage.write('totalContacts', _items.length);
    });
  }

  Future<void> saveSelectedItems() async {
    // final prefs = await SharedPreferences.getInstance();
    // const key = 'selected_items';
    // ignore: prefer_null_aware_operators
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final value = FevoritsItme.map((item) =>item['phone']!=null? item['phone'].toString():null).join(',');
        storage.write("FevContacts", value);
        loadSelectedItems();
      });
    });

    // await prefs.setString(key, value);
  }

  Future<void> loadSelectedItems() async {
    // final prefs = await SharedPreferences.getInstance();
    // const key = 'selected_items';
    // final value = prefs.getString(key) ?? '';


    if(storage.read('FevContacts')!=null){
      final value = storage.read('FevContacts');
print('-------dzsfdgvzs------> ${storage.read('FevContacts')}');
      final list = value.split(',').toList();
      final selectedList =
      _filteredContacts.where((item) => list.contains(item['phone'])).toList();
      log('------------------>$selectedList');
      setState(() {
        FevoritsItme = selectedList ?? [];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            storage.write('FavriteContacts', FevoritsItme);
          });
        });
      });
    }
  }
  Future<void> _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems(); // update the UI
  }
  bool isNumeric(String str) {
    return num.tryParse(str) != null;
  }

  void _filterContacts(String text) {
    if (text.isEmpty) {
      setState(() {
        _filteredContacts = _items;
      });
    } else {
      if(isNumeric(text)==true){
        setState(() {
          _filteredContacts = _items
              .where((contact) =>
          contact['phone'] != '' &&contact['phone'].toString().replaceAll(' ', '').contains(text))
              .toList();
        });
      }else{
        setState(() {
          _filteredContacts = _items
              .where((contact) =>
          contact['name'] != null &&contact['name'].toLowerCase().contains(text))
              .toList();
        });
      }

    }
  }

  List selectItems = [];
  bool isMultiSelectionEnabled = false;
  void doMultiSelection(var path) {
    if (isMultiSelectionEnabled) {
      setState(() {
        if (selectItems.contains(path)) {
          selectItems.remove(path);
        } else {
          selectItems.add(path);
        }
        if(selectItems.isEmpty){
          isMultiSelectionEnabled = false;
        }
      });
    } else {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    //uniquePersons = removeDuplicates(_filteredContacts);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    // final provider = FavoriteProvider.of(context);
    // words_ = provider.words;
    // print("--------------------> fev list -------------> $FevoritsItme");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: themeColor,
        body: Stack(
            children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 12, bottom: 8),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            color: white.withOpacity(0.5),
                            border: Border.all(color: white),
                            borderRadius: BorderRadius.circular(10)),
                        child:  Center(
                            child: IconButton(
                                onPressed: () {
                                  InterstitialAD();
                                  setState(() {
                                    isChangeView =! isChangeView;
                                    storage.write('selectView', isChangeView);
                                  });
                                },
                                icon: Image(
                                  image: AssetImage(
                                      isChangeView == false
                                          ? 'assets/images/grid.png'
                                          : 'assets/images/list.png'),
                                  height: 20,
                                )),
                          ),
                      ),
                    ),
                    Expanded(
                      child:Padding(padding: EdgeInsets.only(bottom: 5,top: 30),
                        child: Wid_Con.textfield(
                            borderwidth: 1,
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                _filterContacts(value.toLowerCase());
                              });
                            }
                            return null;
                          },
                          contentvertical: 5,
                          filled: true,
                          filledColor: white.withOpacity(0.5),
                          hintText: "Search",
                          borderSide: BorderSide(color: white),

                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(
                              'assets/images/Search.png',
                              width: 3,
                              height: 3,
                            ),
                          ),),
                      ),
                    ),
                    isMultiSelectionEnabled==true?
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 12, bottom: 8),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            color: white.withOpacity(0.5),
                            border: Border.all(color: white),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: IconButton(
                                onPressed: () {
                                  selectItems.forEach((e) {
                                    _deleteItem(e['key']);
                                  });

                                  setState(() {
                                    isMultiSelectionEnabled=false;
                                  });
                                },
                                icon: Image(
                                  image: AssetImage(
                                     'assets/images/clear_Image.png'),
                                  height: 20,
                                )),
                          ),

                      ),
                    ):Container(),
                  ],
                ),
            isChangeView == false?
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 15),
                        child: _filteredContacts.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Image(image: AssetImage('assets/images/contactEmpty.png'),height: 100,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'No Contact Found',
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: grey),
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            :
                        // CupertinoScrollbar(
                        //   thickness: 5,
                        //       thumbVisibility: false,
                        //       child:
                        CupertinoScrollbar(

                          controller: widget.controller,
                          thickness: 8.0,
                          thicknessWhileDragging: 10,
                          // showTrackOnHover: true,
                          radius: Radius.circular(20),scrollbarOrientation: ScrollbarOrientation.right,
                          // thumbVisibility: true,
                          // interactive: true,
                          // trackVisibility: true,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: GridView.builder(
                                controller: widget.controller,
                              physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            /*provider.isDark ? 150 :*/ 200,
                                        crossAxisSpacing: 15,
                                        mainAxisExtent: 250,
                                        mainAxisSpacing: 15),
                                itemCount: _filteredContacts.length,
                                itemBuilder: (BuildContext context, int i) {
                                  _filteredContacts.removeWhere((item) =>
                                      item['name'] == null && item['phone']);
                                  _filteredContacts.sort((a, b) {
                                    String nameA = a['name'] ?? '';
                                    String nameB = b['name'] ?? '';

                                    // If either contact has no name, move it to the end
                                    if (nameA.isEmpty && nameB.isNotEmpty) {
                                      return 1;
                                    } else if (nameA.isNotEmpty &&
                                        nameB.isEmpty) {
                                      return -1;
                                    }

                                    // Otherwise, sort based on the names
                                    return nameA.compareTo(nameB);
                                  });
                                  final currentItem = _filteredContacts[i];

                                  return GestureDetector(
                                    onTap: () async {
                                      doMultiSelection(currentItem);
                                      print('---------------Select----------> $selectItems');
                                    },
                                    onLongPress: (){
                                      setState(() {
                                        isMultiSelectionEnabled = true;
                                      });
                                      doMultiSelection(currentItem);
                                      print('---------------Select----------> $selectItems');
                                    },
                                    child: Container(
                                     decoration: BoxDecoration(
                                       color: white.withOpacity(0.5),
                                       borderRadius: BorderRadius.circular(10),
                                       border: Border.all(color: selectItems.contains(currentItem)?themeDarkColor:white),
                                       boxShadow: [
                            // BoxShadow(
                            //   color: Colors.grey.shade300,
                            //   offset: Offset(1, 1),
                            //   spreadRadius: 1,
                            //   blurRadius: 10
                            // )
                                       ]
                                     ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: Stack(
                                                     alignment: Alignment.bottomCenter,
                                                    children: [
                                                      InkWell(
                                                        onTap: isMultiSelectionEnabled==false?() {
                                                          Wid_Con.NavigationTo( MoreInfo(
                                                            image: currentItem['image'],
                                                            name: currentItem['name'],
                                                            phone: currentItem['phone'],
                                                            index: currentItem['key'],
                                                            email: currentItem['email'],
                                                            CurrentIndex: currentItem,
                                                          ));
                                                        }:null,
                                                        child: Container(
                                                        margin: const EdgeInsets.only(left: 8,right:8,top: 8,bottom: 25),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade100,
                                                            borderRadius: BorderRadius.circular(10),
                                                            image:  currentItem['image']!= null?currentItem['image'].toString().contains('assets/images')?DecorationImage(
                                                                image:AssetImage(
                                                                    currentItem['image']),fit: BoxFit.contain):DecorationImage(
                                                                image:MemoryImage(
                                                                    currentItem['image']),fit: BoxFit.cover):const DecorationImage(

                                                                                              image:AssetImage('assets/images/EmptyImage.png'),fit: BoxFit.cover)),
                                                                                                              ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(100),
                                                        child: BackdropFilter(
                                                          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                                          child: Container(
                                                            height: 55,
                                                            width: 55,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: black.withOpacity(0.1)),
                                                                color: Colors.white.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(100)
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                currentItem['name'][0] ??
                                                                    '',
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                    "Montserrat",
                                                                    fontSize: 25,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(

                                                  width: width / 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        currentItem['name'] ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        currentItem['phone'] ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            color: grey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                                        child: Container(
                                                          // color: grey,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                            InkWell(
                                                              splashColor: transparent,
                                                                hoverColor: transparent,
                                                                 onTap: () {
                                                                   setState(() {
                                                                     // provider.toggleFavorite(currentItem);
                                                                     if (FevoritsItme.contains(
                                                                         currentItem)) {
                                                                       FevoritsItme.remove(
                                                                           currentItem);
                                                                     } else {
                                                                       FevoritsItme.add(
                                                                           currentItem);
                                                                     }
                                                                     saveSelectedItems();
                                                                   });
                                                                 },
                                                                child: Image(
                                                                  image: AssetImage(FevoritsItme.contains(currentItem)?
                                                                  'assets/images/fevorit_nonfill.png':
                                                                  'assets/images/Fevorit.png'),
                                                                  height: 22,)),
                                                            InkWell(
                                                                splashColor: transparent,
                                                                hoverColor: transparent,
                                                              onTap: () async {
                                                                await dialer?.dial(currentItem['phone']);
                                                              },
                                                                child: const Image(image: AssetImage('assets/images/call_icon.png'),height: 23,)),
                                                            InkWell(
                                                              splashColor: transparent,
                                                              hoverColor: transparent,
                                                              onTap: () {
                                                                if(currentItem['phone']!=''){
                                                                  launchUrl(Uri.parse("sms:${currentItem['phone']}"));
                                                                }

                                                              },
                                                                child: const Image(image: AssetImage('assets/images/message.png'),height: 24,)),
                                                            InkWell(
                                                                splashColor: transparent,
                                                                hoverColor: transparent,
                                                                onTap: () {
                                                                  setState(() {
                                                                    // _deleteItem(currentItem['key']);
                                                                    Wid_Con.NavigationTo( MoreInfo(
                                                                      image: currentItem['image'],
                                                                      name: currentItem['name'],
                                                                      phone: currentItem['phone'],
                                                                      index: currentItem['key'],
                                                                      email: currentItem['email'],
                                                                      CurrentIndex: currentItem,
                                                                    ));
                                                                  });

                                                                },
                                                                child: Container(
                                                                  height: 25,
                                                                    width: 25,
                                                                    // color: grey,
                                                                    child: const Image(image: AssetImage('assets/images/more.png'),))),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ),
                        ),
                            // ),
                      ),
                    ),
                  ):Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: _filteredContacts.isEmpty
                            ? Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(image: AssetImage('assets/images/contactEmpty.png'),height: 100,),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'No Contact Found',
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: grey),
                                ),
                              ],
                            ),
                          ),
                        )
                            :
                        // CupertinoScrollbar(
                        //   thickness: 5,
                        //       thumbVisibility: false,
                        //       child:
                        ListView.builder(
key: _key,
                          itemCount: _filteredContacts.length,
                          controller: widget.controller,
                          // itemCount: _filteredContacts.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int i) {
                            _filteredContacts.removeWhere((item) =>
                            item['name'] == null && item['phone']);
                            _filteredContacts.sort((a, b) {
                              String nameA = a['name'] ?? '';
                              String nameB = b['name'] ?? '';

                              // If either contact has no name, move it to the end
                              if (nameA.isEmpty && nameB.isNotEmpty) {
                                return 1;
                              } else if (nameA.isNotEmpty &&
                                  nameB.isEmpty) {
                                return -1;
                              }

                              // Otherwise, sort based on the names
                              return nameA.compareTo(nameB);
                            });
                            final currentItem = _filteredContacts[i];

                            return GestureDetector(
                              onLongPress: (){
                                setState(() {
                                  isMultiSelectionEnabled = true;
                                });
                                doMultiSelection(currentItem);
                                print('---------------Select----------> $selectItems');
                              },
                              onTap:isMultiSelectionEnabled == false? () async {
                                setState(() {

                                  _selectedIndex = i;

                                  Timer(Duration(milliseconds: 300), () {
                                    setState(() {
                                      isexpan = i;
                                    });
                                  });
                                });
                                // await dialer?.dial(currentItem['phone']);
                              }:(){
                                doMultiSelection(currentItem);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: selectItems.contains(currentItem)?themeDarkColor:white),

                                ),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn,
                                      height: _selectedIndex == i ?100:70,
                                      // color: grey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                currentItem['image']!= null?
                                                currentItem['image'].toString().contains('assets/images')?
                                                InkWell(
                                                  onTap:isMultiSelectionEnabled==false? () {
                                                    Wid_Con.NavigationTo( MoreInfo(
                                                      image: currentItem['image'],
                                                      name: currentItem['name'],
                                                      phone: currentItem['phone'],
                                                      index: currentItem['key'],
                                                      email: currentItem['email'],
                                                      CurrentIndex: currentItem,
                                                    ));
                                                  }:null,
                                                  child: CircleAvatar(
                                                    backgroundColor: white,
                                                    radius: 25,
                                                    backgroundImage: AssetImage(currentItem['image']),
                                                  ),
                                                ):
                                                InkWell(
                                                  onTap:isMultiSelectionEnabled==false? () {
                                                    Wid_Con.NavigationTo( MoreInfo(
                                                      image: currentItem['image'],
                                                      name: currentItem['name'],
                                                      phone: currentItem['phone'],
                                                      index: currentItem['key'],
                                                      email: currentItem['email'],
                                                      CurrentIndex: currentItem,
                                                    ));
                                                  }:null,
                                                  child: CircleAvatar(
                                                    backgroundColor: white,
                                                    radius: 25,
                                                    backgroundImage: MemoryImage(currentItem['image']),
                                                  ),
                                                ): InkWell(
                                                  onTap: isMultiSelectionEnabled==false?() {
                                                    Wid_Con.NavigationTo( MoreInfo(
                                                      image: currentItem['image'],
                                                      name: currentItem['name'],
                                                      phone: currentItem['phone'],
                                                      index: currentItem['key'],
                                                      email: currentItem['email'],
                                                      CurrentIndex: currentItem,
                                                    ));
                                                  }:null,
                                                  child: CircleAvatar(
                                                    backgroundColor: white,
                                                  radius: 25,
                                                                            backgroundImage: AssetImage('assets/images/EmptyImage.png'),
                                                                            ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10,top: 5),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          currentItem['name'] ??
                                                              '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                              "Montserrat",
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                        ),
                                                        Text(
                                                          currentItem['phone'] ??
                                                              '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "Montserrat",
                                                              color: grey,
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                        ),

                                                        _selectedIndex == i?
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10,top: 10 ),
                                                          child: Container(
                                                            // color: grey,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                AnimatedContainer(
                                                                  height: isexpan == i?20:0,
                                                                  duration: Duration(milliseconds: 300),
                                                                  child: InkWell(
                                                                      splashColor: transparent,
                                                                      hoverColor: transparent,
                                                                      onTap: () {
                                                                        setState(() {
                                                                          // provider.toggleFavorite(currentItem);
                                                                          if (FevoritsItme.contains(
                                                                              currentItem)) {
                                                                            FevoritsItme.remove(
                                                                                currentItem);
                                                                          } else {
                                                                            FevoritsItme.add(
                                                                                currentItem);
                                                                          }
                                                                          saveSelectedItems();
                                                                        });
                                                                      },
                                                                      child: Image(
                                                                        image: AssetImage(FevoritsItme.contains(currentItem)?
                                                                        'assets/images/fevorit_nonfill.png':
                                                                        'assets/images/Fevorit.png'),
                                                                        height: 22,)),
                                                                ),
                                                                AnimatedContainer(
                                                                  height: isexpan == i?22:0,
                                                                  duration: Duration(milliseconds: 300),
                                                                  child: InkWell(
                                                                      splashColor: transparent,
                                                                      hoverColor: transparent,
                                                                      onTap: () async {
                                                                        await dialer?.dial(currentItem['phone']);
                                                                      },
                                                                      child: const Image(image: AssetImage('assets/images/call_icon.png'),height: 25,)),
                                                                ),
                                                                AnimatedContainer(
                                                                  height: isexpan == i?23:0,
                                                                  duration: Duration(milliseconds: 300),
                                                                  child: InkWell(
                                                                      splashColor: transparent,
                                                                      hoverColor: transparent,
                                                                      onTap: () {
                                                                        if(currentItem['phone']!=''){
                                                                          launchUrl(Uri.parse("sms:${currentItem['phone']}"));
                                                                        }

                                                                      },
                                                                      child: const Image(image: AssetImage('assets/images/message.png'),height: 25,)),
                                                                ),
                                                                AnimatedContainer(
                                                                  height: isexpan == i?23:0,
                                                                  duration: Duration(milliseconds: 300),
                                                                  child: InkWell(
                                                                      splashColor: transparent,
                                                                      hoverColor: transparent,
                                                                      onTap: () {
                                                                        setState(() {
                                                                          // _deleteItem(currentItem['key']);
                                                                          Wid_Con.NavigationTo( MoreInfo(
                                                                            image: currentItem['image'],
                                                                            name: currentItem['name'],
                                                                            phone: currentItem['phone'],
                                                                            index: currentItem['key'],
                                                                            CurrentIndex: currentItem,
                                                                          ));
                                                                        });

                                                                      },
                                                                      child: Container(
                                                                          height: 25,
                                                                          width: 25,
                                                                          child: const Image(image: AssetImage('assets/images/more.png'),))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ):Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // ),
                      ),
                    ),
                  ),
                // widget.combinedList != null ?
                // Text(widget.combinedList.toString() ?? '') : Container()
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
