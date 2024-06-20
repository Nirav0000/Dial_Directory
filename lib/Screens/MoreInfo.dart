import 'dart:io';
import 'dart:math';

import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constent/Colors.dart';
import '../Widget/widgets.dart';
import 'BottomTabBar.dart';
import 'EditScreen.dart';
import 'QR_detail/Ganerate_QR.dart';
import 'QR_detail/Scanner_qr.dart';

class MoreInfo extends StatefulWidget {
  MoreInfo({super.key, this.image, this.name, this.phone, this.index, this.CurrentIndex, this.email});
  var image;
  final name;
  final phone;
  final email;
  final index;
  final CurrentIndex;

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  final _imagePicker = ImagePicker();
  var newImage;
  DirectDialer? dialer;
  final _shoppingBox = Hive.box('GetContacts');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupDialer();
  }

  Future<void> setupDialer() async => dialer = await DirectDialer.instance;

  Future<void> _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems(); // update the UI
  }

  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "phone": value['phone'],
        "image": value['image'],
        "email": value['email']
      };
    }).toList();
  }


  shareContacts() async {
    Share.share('Name: ${widget.name} \nNumber: ${widget.phone}');
  }

  Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName.txt'; // 3

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        Wid_Con.NavigationOff(BottomTabbar());
        return true;
      },
      child: Scaffold(
        backgroundColor: themeColor,
        appBar: AppBar(
          backgroundColor: transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Wid_Con.NavigationOff(BottomTabbar());
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Transform.translate(
                  offset: Offset(-40, 30),
                    child: Image(image: AssetImage('assets/images/bg_mail.png'),height: 200,opacity: const AlwaysStoppedAnimation(.6),)),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Transform.translate(
                    offset: Offset(20, -100),
                    child: Image(image: AssetImage('assets/images/bg_call.png'),height: 150,opacity: const AlwaysStoppedAnimation(.6),)),
              ),
              Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 100, left: 10, right: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.name}',
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: themeDarkColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${widget.phone}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: themeDarkColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    splashColor: transparent,
                                    hoverColor: transparent,
                                    onTap: () async {
                                      await dialer?.dial(widget.phone.toString());
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                            child: const Image(
                                          image: AssetImage(
                                              'assets/images/call_icon.png'),
                                          height: 22,
                                        )))),
                                InkWell(
                                    splashColor: transparent,
                                    hoverColor: transparent,
                                    onTap: () {
                                      if (widget.phone != null) {
                                        launchUrl(Uri.parse(
                                            "sms:${widget.phone.toString()}"));
                                      }
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                            child: const Image(
                                          image:
                                              AssetImage('assets/images/message.png'),
                                          height: 23,
                                        )))),
                                InkWell(
                                    splashColor: transparent,
                                    hoverColor: transparent,
                                    onTap: () async {
                                      String email = Uri.encodeComponent(
                                          "${widget.email!=null? widget.email:""}");
                                      String subject =
                                          Uri.encodeComponent("Hello...,");
                                      String body = Uri.encodeComponent("Hi! ");
                                      print(subject); //output: Hello%20Flutter
                                      Uri mail = Uri.parse(
                                          "mailto:$email?subject=$subject&body=$body");
                                      if (await launchUrl(mail)) {
                                        //email app opened
                                      } else {
                                        //email app is not opened
                                      }
                                    },
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Center(
                                            child: const Image(
                                          image: AssetImage('assets/images/mail.png'),
                                          height: 25,
                                        )))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: widget.image == null
                            ? Container(
                          decoration: BoxDecoration(
                           shape: BoxShape.circle,
                            border: Border.all(color: themeColor,width: 5)
                          ),
                              child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage('assets/images/EmptyImage.png'),
                                ),
                            )
                            : widget.image.toString().contains('assets/images')?CircleAvatar(
                          backgroundColor: white,
                          backgroundImage:AssetImage(widget.image),
                          radius: 70,
                        ):CircleAvatar(
                          backgroundColor: white,
                          backgroundImage:MemoryImage(widget.image),
                          radius: 70,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            splashColor: transparent,
                            hoverColor: transparent,
                            onTap: () async {
                              if (widget.phone != null) {
                                launchUrl(Uri.parse(widget.phone
                                        .toString()
                                        .contains('+')
                                    ? "https://wa.me/${widget.phone}"
                                    : "https://wa.me/${storage.read('CountryCode')}${widget.phone}"));
                              }
                            },
                            child: Container(
                              color: transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Image(
                                    image: AssetImage('assets/images/whatsapp.png'),
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      'WhatsApp ( ${widget.phone} )',
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: themeDarkColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: grey,
                            thickness: 0.3,
                          ),
                        ),
                        InkWell(
                            splashColor: transparent,
                            hoverColor: transparent,
                            onTap: () {
                              if (widget.phone != null) {
                                launchUrl(Uri.parse(widget.phone
                                        .toString()
                                        .contains('+')
                                    ? "https://t.me/${widget.phone}"
                                    : "https://t.me/${storage.read('CountryCode')}${widget.phone}"));
                              }
                            },
                            child: Container(
                              color: transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Image(
                                    image: AssetImage('assets/images/telegram.png'),
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Telegram ( ${widget.phone} )',
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: themeDarkColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )),

                      ],
                    ),
                  ),
                )
              ],
            )],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: white.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Wid_Con.NavigationTo(EditScreen(
                            imageEdit: widget.image,
                            nameEdit: widget.name,
                            numberEdit: widget.phone,
                            emailEdit: widget.email,
                            CurrentIndex: widget.CurrentIndex,
                          ));
                        },
                        icon: Image(
                          image: AssetImage('assets/images/edit.png'),
                          height: 22,
                        )),
                    Text(
                      'Edit',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          color: themeDarkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: shareContacts,
                        icon: Image(
                          image: AssetImage('assets/images/share.png'),
                          height: 20,
                        )),
                    Text(
                      'Share',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          color: themeDarkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),

                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PullDownButton(
                      itemBuilder: (context) => [
                        PullDownMenuItem(
                          onTap: () {
                            Wid_Con.NavigationTo(Ganerate_QR(
                              name: widget.name,
                              mobile_number: widget.phone,
                            ));
                          },
                          title: 'QR code',
                          icon: CupertinoIcons.qrcode,
                        ),
                        PullDownMenuItem(
                          onTap: () {
                            setState(() {
                              _deleteItem(widget.index);
                              Wid_Con.NavigationOffAll(BottomTabbar());
                            });
                          },
                          title: 'Delete',
                          isDestructive: true,
                          icon: CupertinoIcons.delete,
                        ),
                      ],
                      routeTheme: PullDownMenuRouteTheme(
                        backgroundColor: white.withOpacity(0.5),
                      ),
                      buttonBuilder: (context, showMenu) => CupertinoButton(
                        onPressed: showMenu,
                        padding: EdgeInsets.zero,
                        child: Image(
                          image: AssetImage('assets/images/more.png'),
                          height: 25,
                        ),
                      ),
                    ),
                    Text(
                      'More',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          color: themeDarkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
