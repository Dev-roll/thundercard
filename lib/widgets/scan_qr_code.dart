import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:thundercard/widgets/my_qr_code_.dart';

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: Column(
                            children: [],
                          ),
                        ),
                        const MyQrCode(name: 'cardseditor'),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.share_rounded)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.open_in_full_rounded)),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
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
                                  // return const Text('ON');
                                } else {
                                  return const Icon(
                                      Icons.flashlight_off_rounded);
                                  // return const Text('OFF');
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // var scanArea = min(
    //     MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    var scanArea =
        (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height)
            ? MediaQuery.of(context).size.width * 0.75
            : MediaQuery.of(context).size.height * 0.75;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 8,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
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
