import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../Constent/Colors.dart';

class Ganerate_QR extends StatefulWidget {
  const Ganerate_QR({super.key, this.mobile_number, this.name});
  final mobile_number;
  final name;

  @override
  State<Ganerate_QR> createState() => _Ganerate_QRState();
}

class _Ganerate_QRState extends State<Ganerate_QR> {

  ScreenshotController screenshotController = ScreenshotController();

  shareimage()async{
    await screenshotController.capture(delay:  Duration(milliseconds: 10)).then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        Share.shareFiles([imagePath.path]);
      }
    });
  }


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
        actions: [
          IconButton(onPressed: (){
            shareimage();
          }, icon: Image(image: AssetImage('assets/images/Share_qr.png',),height: 30,))
        ],
        centerTitle: true,
        title: Text(
          "${widget.name}'s QR code",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: "Montserrat",
              color: themeDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            height: 420,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data:'VERSION:CallerApp\n'
                      'N:${widget.name};\n'
                      'TEL;TYPE=CELL:${widget.mobile_number.toString().contains('+')?'':storage.read('CountryCode')} ${widget.mobile_number}',
                  version: QrVersions.auto,
                  size: 300.0,
                  dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
                  // gapless: false,
                  eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(25.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    '${widget.name}',
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
        ),
      ),
    );
  }
}
