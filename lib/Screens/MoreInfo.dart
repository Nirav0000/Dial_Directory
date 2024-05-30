import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30)),
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
                            ),
                            child: Row(
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
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/gallery.png'),
                                    height: 45,
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
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/camera.png'),
                                    height: 45,
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
                            ),
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
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image:
                                          AssetImage('assets/images/gallery.png'),
                                          height: 35,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('Gallery',overflow: TextOverflow.ellipsis,style: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: themeDarkColor,
                                              fontSize: 18,fontWeight: FontWeight.w600
                                          ),),
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
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image:
                                          AssetImage('assets/images/camera.png'),
                                          height: 35,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('Camera',overflow: TextOverflow.ellipsis,style: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: themeDarkColor,
                                              fontSize: 18,fontWeight: FontWeight.w600
                                          ),),
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

                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image:
                                          AssetImage('assets/images/clear_Image.png'),
                                          height: 35,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('Clear Image',overflow: TextOverflow.ellipsis,style: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: themeDarkColor,
                                              fontSize: 16,fontWeight: FontWeight.w600
                                          ),),
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
          )
        ],
      ),
    );
  }
}
