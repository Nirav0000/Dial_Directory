import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Constent/Colors.dart';

class Scanner_qr extends StatefulWidget {
  const Scanner_qr({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Scanner_qrState();
}

class _Scanner_qrState extends State<Scanner_qr> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String name = '';
  String phoneNumber = '';

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(onPressed: () async {
            await controller?.flipCamera();
            setState(() {});
          }, icon: Image(image: AssetImage('assets/images/turn_camera.png',),height: 25,)),
          IconButton(onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          }, icon: Image(image: AssetImage('assets/images/Torch.png',),height: 30,)),

        ],
        centerTitle: true,
        title: Text(
          "Scan Contact",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: "Montserrat",
              color: themeDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: themeColor,
          borderRadius: 30,
          borderLength: 50,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print('-------qr-----> ${result!.code}');

          // Regular expressions to extract the name and phone number
          RegExp nameRegExp = RegExp(r'N:(.*?);');
          RegExp phoneRegExp = RegExp(r'TEL;TYPE=CELL:(.*)');

          setState(() {
            // Extracting the name
             name = nameRegExp.firstMatch(result!.code.toString())!.group(1).toString();
            // Extracting the phone number
             phoneNumber = phoneRegExp.firstMatch(result!.code.toString())!.group(1).toString();

            print('Name: $name');
            print('Phone Number: $phoneNumber');
          });
          // Printing the results



      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}