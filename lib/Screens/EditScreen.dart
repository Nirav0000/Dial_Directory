import 'package:caller_app/Widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../Constent/Colors.dart';
import 'BottomTabBar.dart';
import 'MoreInfo.dart';

class EditScreen extends StatefulWidget {
  EditScreen({super.key, this.nameEdit, this.numberEdit, this.imageEdit, this.NewNumber, this.CurrentIndex, this.emailEdit});
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.NewNumber!=null){
      numberController.text = widget.NewNumber.toString();
    }else{
      nameController.text = widget.nameEdit.toString();
      numberController.text = widget.numberEdit.toString();
      emailController.text = widget.emailEdit!=null?widget.emailEdit.toString():'';
      newImage = widget.imageEdit;

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
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems(); // update the UI
    Wid_Con.NavigationOffAll(BottomTabbar());
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);
    _refreshItems(); // Update the UI
    Wid_Con.NavigationOff(MoreInfo(name: nameController.text,phone: numberController.text,email: emailController.text,image: newImage));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B4242),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C8374),
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
      body: SingleChildScrollView(
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
                  color: themeColor, borderRadius: BorderRadius.circular(30)),
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
                            child: Image(image: AssetImage('assets/images/user.png'),height: 10),
                          )
                        ),
                        Wid_Con.textfield(
                          controller: numberController,
                          labelText: 'Number*',
                          hintText: 'Number',
                          height: 90,
                            keyboardType: TextInputType.phone,
                          prefixIcon: Icon(CupertinoIcons.phone_fill,color: moreinfobg,)
                        ),
                        Wid_Con.textfield(
                          controller: emailController,
                          labelText: 'Email',
                          hintText: 'Email',
                          height: 90,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(CupertinoIcons.mail_solid,color: moreinfobg,)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              Expanded(child: Wid_Con.button(onPressed: (){
                                Get.back();
                              },ButtonName: 'Cancel'),),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Wid_Con.button(onPressed: (){
                                setState(() {
                                  if(widget.NewNumber!=null){
                                    print('-----------new create----');
                                    _createItem({
                                      "name": nameController.text,
                                      "phone": numberController.text,
                                      "image": newImage,
                                      "email":emailController.text
                                    });
                                  }else{
                                    print('-----------old update----');
                                    _updateItem(widget.CurrentIndex['key'], {
                                      "name": nameController.text,
                                      "phone": numberController.text,
                                      "image": newImage,
                                      "email":emailController.text
                                    });
                                  }
                                });
                              },ButtonName: 'Save'),),

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
                                        widget.imageEdit = bytes;
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/gallery.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                                        widget.imageEdit = bytes;
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/camera.png'),
                                          height: 28,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                                      widget.imageEdit = null;
                                      Get.back();
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/clear_Image.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                  child: Stack(alignment: Alignment.topCenter, children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500),
                            border:
                                Border.all(color: Color(0xFF5C8374), width: 5)),
                        child: CircleAvatar(
                          backgroundImage: MemoryImage(widget.imageEdit),
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
                                        widget.imageEdit = bytes;
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
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/gallery.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                                        widget.imageEdit = bytes;
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
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/camera.png'),
                                          height: 28,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                                      widget.imageEdit = null;
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/clear_Image.png'),
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
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
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              border:
                                  Border.all(color: Color(0xFF5C8374), width: 5),
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
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
