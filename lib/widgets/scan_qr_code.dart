import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:thundercard/widgets/my_qr_code.dart';

import '../constants.dart';
import '../main.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanned = false;

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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: seedColorDark,
                  // color: white,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 60,
                        ),
                        const MyQrCode(name: 'cardseditor'),
                        Container(
                          width: 60,
                          margin: EdgeInsets.only(bottom: 32),
                          decoration: BoxDecoration(color: gray),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.share_rounded,
                                    color: white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.open_in_full_rounded,
                                    color: white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(flex: 6, child: _buildQrView(context)),
            Expanded(
              flex: 2,
              child: Container(
                color: seedColorDark,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // if (result != null)
                    //   Text(
                    //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                    // else
                    //   const Text('Scan a code'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null &&
                                      snapshot.data == true) {
                                    return const Icon(
                                        Icons.flashlight_on_rounded);
                                  } else {
                                    return const Icon(
                                        Icons.flashlight_off_rounded);
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: IconButton(
                    //         onPressed: () async {
                    //           await controller?.pauseCamera();
                    //         },
                    //         icon: const Icon(Icons.pause_circle_rounded),
                    //       ),
                    //     ),
                    //     // Switch(value: value, onChanged: onChanged)
                    //     Container(
                    //       margin: const EdgeInsets.all(8),
                    //       child: IconButton(
                    //         onPressed: () async {
                    //           await controller?.resumeCamera();
                    //         },
                    //         icon: const Icon(Icons.play_circle_rounded),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height)
            ? MediaQuery.of(context).size.width * 0.4
            : MediaQuery.of(context).size.height * 0.4;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Color(0xFFFFFFFF),
              borderRadius: 12,
              borderLength: 0,
              borderWidth: 0,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: (MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height)
                ? MediaQuery.of(context).size.width * 0.4
                : MediaQuery.of(context).size.height * 0.4,
            height: (MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height)
                ? MediaQuery.of(context).size.width * 0.4
                : MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Color(0x22FFFFFF),
              border: Border.all(color: Color(0x88FFFFFF), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            CupertinoIcons.qrcode,
            color: Color(0x32FFFFFF),
            size: (MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height)
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.height * 0.2,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data == true) {
                        return const Icon(Icons.flashlight_on_rounded);
                      } else {
                        return const Icon(Icons.flashlight_off_rounded);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      log(scanData.code.toString());
      HapticFeedback.vibrate();
      setState(() {
        result = scanData;
      });
      if (scanData.code == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This QR code is invalid.")));
      } else {
        _transitionToNextPage(
            describeEnum(scanData.format), scanData.code.toString());
      }
    });
    this.controller!.pauseCamera();
    this.controller!.resumeCamera();
  }

  Future<void> _transitionToNextPage(String type, String data) async {
    if (!_isScanned) {
      this.controller?.pauseCamera();
      _isScanned = true;
    }

    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyHomePage(
        title: 'John',
        type: type,
        data: data,
      ),
    ))
        .then((value) {
      this.controller?.resumeCamera();
      _isScanned = false;
    });
  }

  // 変更前
  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.resumeCamera();
  //   controller.scannedDataStream.listen((scanData) {
  //     log(scanData.code.toString());
  //     HapticFeedback.vibrate();
  //     setState(() {
  //       result = scanData;
  //     });
  //   });
  //   this.controller!.pauseCamera();
  //   this.controller!.resumeCamera();
  // }

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
