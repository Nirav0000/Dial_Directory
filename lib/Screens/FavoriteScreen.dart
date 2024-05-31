import 'dart:ui';

import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constent/Colors.dart';
import '../Controller/GetController.dart';
import '../Widget/widgets.dart';
import 'MoreInfo.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, this.controller, this.fevData});
  final ScrollController? controller;
  final  fevData;


  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var favoriteController = Get.put(MyController());
  List<Map<String, dynamic>> _items = [];
  DirectDialer? dialer;
  var size, height, width;
  int _selectedIndex = -1;
  List FevoritsItme = [];
  Future<void> setupDialer() async => dialer = await DirectDialer.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupDialer();
    setState(() {
      _items = storage.read('FavriteContacts')??[];
    });
  }
  Future<void> saveSelectedItems() async {
    // final prefs = await SharedPreferences.getInstance();
    // const key = 'selected_items';
    // ignore: prefer_null_aware_operators
    final value = _items.map((item) =>item['phone']!=null? item['phone'].toString():null).join(',');
    storage.write("FevContacts", value);
    // await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: themeColor,
      body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wid_Con.textfield(
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {});
                        }
                        return null;
                      },
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
                      )),

                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: _items.isEmpty
                              ? Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: AssetImage('assets/images/contactEmpty.png'),height: 100,),
                                  SizedBox(
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: GridView.builder(
                              controller: widget.controller,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                  /*provider.isDark ? 150 :*/ 200,
                                  crossAxisSpacing: 15,
                                  mainAxisExtent: 250,
                                  mainAxisSpacing: 15),
                              itemCount: _items.length,
                              itemBuilder: (BuildContext context, int i) {
                                _items.removeWhere((item) =>
                                item['name'] == null && item['phone']);
                                _items.sort((a, b) {
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
                                final currentItem = _items[i];

                                return GestureDetector(
                                  onTap: () async {

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: white),
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
                                                    Container(
                                                      margin: EdgeInsets.only(left: 8,right:8,top: 8,bottom: 25),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey.shade100,
                                                          borderRadius: BorderRadius.circular(10),
                                                          image:  currentItem['image']!= null?DecorationImage(
                                                              image:MemoryImage(
                                                                  currentItem['image']),fit: BoxFit.cover):DecorationImage(

                                                              image:AssetImage('assets/images/EmptyImage.png'),fit: BoxFit.cover)),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: BackdropFilter(
                                                        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                                        child: Container(
                                                          height: 70,
                                                          width: 70,
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
                                                                    if (_items.contains(
                                                                        currentItem)) {
                                                                      _items.remove(
                                                                          currentItem);
                                                                    } else {
                                                                      _items.add(
                                                                          currentItem);
                                                                    }
                                                                    saveSelectedItems();
                                                                  });
                                                                },
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      _items.contains(currentItem)?
                                                                  'assets/images/fevorit_nonfill.png':
                                                                  'assets/images/Fevorit.png'),
                                                                  height: 22,)),
                                                            InkWell(
                                                                splashColor: transparent,
                                                                hoverColor: transparent,
                                                                onTap: () async {
                                                                  await dialer?.dial(currentItem['phone']);
                                                                },
                                                                child: Image(image: AssetImage('assets/images/call_icon.png'),height: 22,)),
                                                            InkWell(
                                                                splashColor: transparent,
                                                                hoverColor: transparent,
                                                                onTap: () {
                                                                  if(currentItem['phone']!=''){
                                                                    launchUrl(Uri.parse("sms:${currentItem['phone']}"));
                                                                  }

                                                                },
                                                                child: Image(image: AssetImage('assets/images/message.png'),height: 23,)),
                                                            InkWell(
                                                                splashColor: transparent,
                                                                hoverColor: transparent,
                                                                onTap: () {
                                                                  setState(() {
                                                                    // _deleteItem(currentItem['key']);
                                                                    Wid_Con.NavigationTo( MoreInfo());
                                                                  });

                                                                },
                                                                child: Image(image: AssetImage('assets/images/more.png'),height: 18,)),
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
    );
  }
}
