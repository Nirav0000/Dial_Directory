import 'dart:convert';
import 'dart:typed_data';

import 'package:caller_app/Widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../Constent/Colors.dart';
import 'BottomTabBar.dart';
import 'MoreInfo.dart';

class EditScreen extends StatefulWidget {
  EditScreen(
      {super.key,
      this.nameEdit,
      this.numberEdit,
      this.imageEdit,
      this.NewNumber,
      this.CurrentIndex,
      this.emailEdit});
  final nameEdit;
  final numberEdit;
  final emailEdit;
  var imageEdit;
  final NewNumber;
  final CurrentIndex;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _imagePicker = ImagePicker();
  var newImage;
  final _shoppingBox = Hive.box('GetContacts');

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String selectedAvatar = '';


  final AvatarPath = [
    "assets/images/avatar/1.png",
    "assets/images/avatar/2.png",
    "assets/images/avatar/3.png",
    "assets/images/avatar/4.png",
    "assets/images/avatar/5.png",
    "assets/images/avatar/6.png",
    "assets/images/avatar/7.png",
    "assets/images/avatar/8.png",
    "assets/images/avatar/9.png",
    "assets/images/avatar/10.png",
    "assets/images/avatar/11.png",
    "assets/images/avatar/12.png",
    "assets/images/avatar/13.png",
    "assets/images/avatar/14.png",
    "assets/images/avatar/15.png",
    "assets/images/avatar/16.png",
    "assets/images/avatar/17.png",
    "assets/images/avatar/18.png",
    "assets/images/avatar/19.png",
    "assets/images/avatar/20.png",
    "assets/images/avatar/21.png",
    "assets/images/avatar/22.png",
    "assets/images/avatar/23.png",
    "assets/images/avatar/24.png",
    "assets/images/avatar/25.png",
    "assets/images/avatar/26.png",
    "assets/images/avatar/27.png",
    "assets/images/avatar/28.png",
    "assets/images/avatar/29.png",
    "assets/images/avatar/30.png",
  ];
  bool isNumeric(String str) {
    return num.tryParse(str) != null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('------------------------------------edit--------------------> ${isNumeric('123')}');
    if (widget.NewNumber != null) {
      numberController.text = widget.NewNumber.toString();
    } else {
      nameController.text = widget.nameEdit.toString();
      numberController.text = widget.numberEdit.toString();
      emailController.text =
          widget.emailEdit != null ? widget.emailEdit.toString() : '';
      newImage = widget.imageEdit;
      if(isNumeric(nameController.text)==true){
        nameController.clear();
      }
    }
    print('--------scan----> ${numberController.text}');
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
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems(); // update the UI
    Wid_Con.NavigationOffAll(BottomTabbar());
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);
    _refreshItems(); // Update the UI
    Wid_Con.NavigationTo(MoreInfo(
        name: nameController.text,
        phone: numberController.text,
        email: emailController.text,
        image: newImage));
  }

  avatarDialog() {

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: themeColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Choose Avatar',
              style: TextStyle(color: themeDarkColor, fontSize: 20),
            ),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Divider(),
              Expanded(
                child: GridView.builder(
                  itemCount: AvatarPath.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  // itemCount: 6,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: selectedAvatar == AvatarPath[i]?themeDarkColor:transparent,width: 2),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedAvatar = AvatarPath[i];
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Image(image: AssetImage(AvatarPath[i])),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Wid_Con.button(
              onPressed: () {
                setState(() {
                  selectedAvatar = '';
                });
                Get.back();
              },
              ButtonName: 'Cancel',
              width: 100,
              height: 40,
              ButtonColor: themeColor,
              elevation: 0,
              Bordercolor: themeDarkColor,
              borderWidth: 1,
              titelcolor: themeDarkColor),
          Wid_Con.button(
              onPressed: () {
                Get.back(result: selectedAvatar);
                Get.back();
                setState(() {
                  selectedAvatar = '';
                });
              }, ButtonName: 'Select', width: 100, height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: moreinfobg,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: white,
            )),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: "Montserrat",
              color: white,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
                offset: Offset(20, 30),
                child: Image(
                  image: AssetImage('assets/images/bg_call.png'),
                  height: 150,
                  opacity: const AlwaysStoppedAnimation(0.6),
                )),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
                offset: Offset(-50, -80),
                child: Image(
                  image: AssetImage('assets/images/bg_user.png'),
                  height: 150,
                  opacity: const AlwaysStoppedAnimation(0.6),
                )),
          ),
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                      color: Color(0xFF5C8374),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 150, left: 25, right: 25),
                  width: double.infinity,
                  height: 450,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.10),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 0))
                      ],
                      color: themeColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wid_Con.textfield(
                                controller: nameController,
                                labelText: 'Name*',
                                hintText: 'Name',
                                height: 90,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Image(
                                      image:
                                          AssetImage('assets/images/user.png'),
                                      height: 10),
                                )),
                            Wid_Con.textfield(
                                controller: numberController,
                                labelText: 'Number*',
                                hintText: 'Number',
                                height: 90,
                                keyboardType: TextInputType.phone,
                                prefixIcon: Icon(
                                  CupertinoIcons.phone_fill,
                                  color: moreinfobg,
                                )),
                            Wid_Con.textfield(
                                controller: emailController,
                                labelText: 'Email',
                                hintText: 'Email',
                                height: 90,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icon(
                                  CupertinoIcons.mail_solid,
                                  color: moreinfobg,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Wid_Con.button(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        ButtonName: 'Cancel'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Wid_Con.button(
                                        onPressed: () {
                                          setState(() {
                                            if (widget.NewNumber != null) {
                                              print(
                                                  '-----------new create----');
                                              _createItem({
                                                "name": nameController.text,
                                                "phone": numberController.text,
                                                "image": newImage,
                                                "email": emailController.text
                                              });
                                            } else {
                                              print(
                                                  '-----------old update---- ${widget.CurrentIndex}');
                                              _updateItem(
                                                  widget.CurrentIndex['key'], {
                                                "name": nameController.text,
                                                "phone": numberController.text,
                                                "image": newImage,
                                                "email": emailController.text
                                              });
                                            }
                                          });
                                        },
                                        ButtonName: 'Save'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.imageEdit != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
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
                                Size(MediaQuery.of(context).size.width, 280)),
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                height: 280,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    // color: themeDarkColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 5,
                                        width: 50,
                                        margin: EdgeInsets.only(top: 8),
                                        decoration: BoxDecoration(
                                            color: grey.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        'Choose Option',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: themeDarkColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    InkWell(
                                      onTap: () async {

                                        final isavtar = await showDialog<dynamic>(
                                          context: context,
                                          builder: (context) {
                                            return avatarDialog();
                                          },
                                        );
                                        setState(() {

                                          widget.imageEdit = isavtar;
                                          newImage = isavtar;
                                        });
                                        print('---------avatar-----> $isavtar');
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFB190B6),
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/avatar/1.png'),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Avatar',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final photo =
                                            await _imagePicker.pickImage(
                                                source: ImageSource.gallery);
                                        if (photo != null) {
                                          final bytes =
                                              await photo.readAsBytes();
                                          setState(() {
                                            widget.imageEdit = bytes;
                                            newImage = bytes;
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/gallery.png'),
                                                height: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Gallery',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final photo =
                                            await _imagePicker.pickImage(
                                                source: ImageSource.camera);
                                        if (photo != null) {
                                          final bytes =
                                              await photo.readAsBytes();
                                          setState(() {
                                            widget.imageEdit = bytes;
                                            newImage = bytes;
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/camera.png'),
                                                height: 28,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Camera',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          widget.imageEdit = null;
                                          newImage = null;
                                          Get.back();
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/clear_Image.png'),
                                                height: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Clear Image',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Stack(alignment: Alignment.topCenter, children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                                borderRadius: BorderRadius.circular(500),
                                border: Border.all(
                                    color: Color(0xFF5C8374), width: 5)),
                            child: widget.imageEdit.toString().contains('assets/images')?CircleAvatar(
                              backgroundColor: white,
                              backgroundImage:AssetImage(widget.imageEdit),
                              radius: 80,
                            ):CircleAvatar(
                              backgroundColor: white,
                        backgroundImage:MemoryImage(widget.imageEdit),
    radius: 80,
    ),
                          ),
                        ),
                        Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(left: 135, top: 175),
                            decoration: BoxDecoration(
                              color: Color(0xFF5C8374),
                              borderRadius: BorderRadius.circular(50),
                              // border: Border.all(color: themeColor, width: 2),
                            ),
                            child: const Center(
                                child: Image(
                              image: AssetImage('assets/images/Editcamera.png'),
                              height: 22,
                            ))),
                      ]),
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
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
                                Size(MediaQuery.of(context).size.width, 280)),
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                height: 280,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    // color: themeDarkColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 5,
                                        width: 50,
                                        margin: EdgeInsets.only(top: 8),
                                        decoration: BoxDecoration(
                                            color: grey.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        'Choose Option',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: themeDarkColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    InkWell(
                                      onTap: () async {

                                       final isavtar = await showDialog<dynamic>(
                                          context: context,
                                          builder: (context) {
                                            return avatarDialog();
                                          },
                                        );
                                       setState(() {

                                         widget.imageEdit = isavtar;
                                         newImage = isavtar;


                                       });
                                       print('---------avatar-----> ${isavtar}');
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFB190B6),
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/avatar/1.png'),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Avatar',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final photo =
                                            await _imagePicker.pickImage(
                                                source: ImageSource.gallery);
                                        if (photo != null) {
                                          final bytes =
                                              await photo.readAsBytes();
                                          setState(() {
                                            widget.imageEdit = bytes;
                                            Navigator.pop(context);
                                            newImage = bytes;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/gallery.png'),
                                                height: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Gallery',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final photo =
                                            await _imagePicker.pickImage(
                                                source: ImageSource.camera);
                                        if (photo != null) {
                                          final bytes =
                                              await photo.readAsBytes();
                                          setState(() {
                                            widget.imageEdit = bytes;
                                            Navigator.pop(context);
                                            newImage = bytes;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/camera.png'),
                                                height: 28,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Camera',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          widget.imageEdit = null;
                                          newImage = null;
                                          Fluttertoast.showToast(
                                              msg: "Image is Empty",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: themeDarkColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/clear_Image.png'),
                                                height: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(
                                                  'Clear Image',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: themeDarkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(500),
                                border: Border.all(
                                    color: Color(0xFF5C8374), width: 5),
                              ),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    AssetImage('assets/images/EmptyImage.png'),
                              ),
                            ),
                          ),
                          Container(
                              height: 40,
                              width: 40,
                              margin:
                                  const EdgeInsets.only(left: 135, top: 175),
                              decoration: BoxDecoration(
                                color: Color(0xFF5C8374),
                                borderRadius: BorderRadius.circular(50),
                                // border: Border.all(color: themeColor, width: 2),
                              ),
                              child: const Center(
                                  child: Image(
                                image:
                                    AssetImage('assets/images/Editcamera.png'),
                                height: 22,
                              ))),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
