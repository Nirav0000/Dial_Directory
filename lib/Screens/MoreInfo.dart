import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constent/Colors.dart';
import '../Widget/widgets.dart';

class MoreInfo extends StatefulWidget {
  MoreInfo({super.key, this.image, this.name, this.phone});
  var image;
  final name;
  final phone;

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  final _imagePicker = ImagePicker();
  var newImage;
  DirectDialer? dialer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupDialer();
  }
  Future<void> setupDialer() async => dialer = await DirectDialer.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
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
                      padding: const EdgeInsets.only(bottom: 20,top: 10),
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
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(child: const Image(image: AssetImage('assets/images/call_icon.png'),height: 22,)))),
                          InkWell(
                              splashColor: transparent,
                              hoverColor: transparent,
                              onTap: () {
                                if(widget.phone!=null){
                                  launchUrl(Uri.parse("sms:${widget.phone.toString()}"));
                                }

                              },
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(child: const Image(image: AssetImage('assets/images/message.png'),height: 23,)))),
                          InkWell(
                              splashColor: transparent,
                              hoverColor: transparent,
                              onTap: () async {
                                String email = Uri.encodeComponent(
                                    "niravlukhi71@gnail.com");
                                String subject =
                                Uri.encodeComponent("Hello Sir,");
                                String body =
                                Uri.encodeComponent("Hi! ");
                                print(
                                    subject); //output: Hello%20Flutter
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
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(child: const Image(image: AssetImage('assets/images/mail.png'),height: 25,)))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (widget.image != null)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        constraints: BoxConstraints.loose(
                            Size(MediaQuery.of(context).size.width, 180)),
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: themeDarkColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final photo = await _imagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    if (photo != null) {
                                      final bytes = await photo.readAsBytes();
                                      setState(() {
                                        widget.image = bytes;
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/gallery.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Gallery',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: themeDarkColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final photo = await _imagePicker.pickImage(
                                        source: ImageSource.camera);
                                    if (photo != null) {
                                      final bytes = await photo.readAsBytes();
                                      setState(() {
                                        widget.image = bytes;
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/camera.png'),
                                          height: 28,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Camera',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: themeDarkColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      widget.image = null;
                                      Get.back();
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/clear_Image.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Clear Image',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: themeDarkColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Stack(children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: CircleAvatar(
                          backgroundImage: MemoryImage(widget.image),
                          radius: 80,
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     setState(() {
                    //       widget.image = null;
                    //     });
                    //   },
                    //   child: Center(
                    //     child:   Container(height: 40,width: 40,
                    //         margin: const EdgeInsets.only(left: 140,top: 10),
                    //         decoration: BoxDecoration(
                    //             color: grey,borderRadius: BorderRadius.circular(50)
                    //         ),child: const Center(child: Icon(Icons.close_outlined),)),
                    //   ),
                    // ),
                  ]),
                )
              else
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        constraints: BoxConstraints.loose(
                            Size(MediaQuery.of(context).size.width, 180)),
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: themeDarkColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final photo = await _imagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    if (photo != null) {
                                      final bytes = await photo.readAsBytes();
                                      setState(() {
                                        widget.image = bytes;
                                        Navigator.pop(context);
                                        newImage = bytes;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/gallery.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Gallery',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: themeDarkColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final photo = await _imagePicker.pickImage(
                                        source: ImageSource.camera);
                                    if (photo != null) {
                                      final bytes = await photo.readAsBytes();
                                      setState(() {
                                        widget.image = bytes;
                                        Navigator.pop(context);
                                        newImage = bytes;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/camera.png'),
                                          height: 28,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Camera',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: themeDarkColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      widget.image = null;
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/clear_Image.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Clear Image',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: themeDarkColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            AssetImage('assets/images/EmptyImage.png'),
                      ),
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
                                if(widget.phone!=null){
                                  launchUrl(Uri.parse("https://wa.me/${storage.read('CountryCode')}${widget.phone}"));
                                }
                              },
                              child: Container(
                                color: transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Image(image: AssetImage('assets/images/whatsapp.png'),height: 25,),
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
                                if(widget.phone!=null){
                                  launchUrl(Uri.parse("https://t.me/+91${widget.phone}"));
                                }

                              },
                              child: Container(
                                color: transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Image(image: AssetImage('assets/images/telegram.png'),height: 25,),
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
      ),
      bottomNavigationBar: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: white.withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30)
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(onPressed: (){}, icon: Image(image: AssetImage('assets/images/edit.png'),height: 22,)),
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
            Column(
              children: [
                IconButton(onPressed: (){}, icon: Image(image: AssetImage('assets/images/share.png'),height: 20,)),
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

            Column(
              children: [
                IconButton(onPressed: (){}, icon: Image(image: AssetImage('assets/images/more.png'),height: 25,)),
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

          ],
        ),
      ),
    );
  }
}
