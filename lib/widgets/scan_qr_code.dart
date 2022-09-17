import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/Thundercard.dart';
import 'package:thundercard/widgets/my_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Notifications.dart';
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
  final GlobalKey _globalKey = GlobalKey();
  // ByteData? _image;
  // Image? _image;
  // _doCapture();

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
    String username = 'cardseditor';
    String thunderCardUrl = 'https://github.com/$username';
    final picker = ImagePicker();
    // var _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
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
                            RepaintBoundary(
                              key: _globalKey,
                              child: MyQrCode(name: username),
                            ),
                            Container(
                              width: 60,
                              margin: EdgeInsets.only(bottom: 32),
                              // decoration: BoxDecoration(color: gray),
                              child: Column(
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     // ScaffoldMessenger.of(context)
                                  //     //     .showSnackBar(const SnackBar(
                                  //     //         content: Text(
                                  //     //             "This QR code is invalid.")));
                                  //     showModalBottomSheet(
                                  //       context: context,
                                  //       builder: (BuildContext context) {
                                  //         return Container(
                                  //           child: ShareQRView(),
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  //   child: Icon(
                                  //     Icons.share_rounded,
                                  //     color: white,
                                  //   ),
                                  //   style: ElevatedButton.styleFrom(
                                  //     primary: seedColorDark,
                                  //     padding: EdgeInsets.all(18),
                                  //   ),
                                  // ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //         content: Text(
                                      //             "This QR code is invalid.")));
                                      // showModalBottomSheet(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return Container(
                                      //       child:
                                      //           MyQrCode(name: 'cardseditor'),
                                      //     );
                                      //   },
                                      // );
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => FittedBox(
                                          child: MyQrCode(
                                            name: username,
                                          ),
                                        ),
                                      ));
                                    },
                                    child: Icon(
                                      Icons.open_in_full_rounded,
                                      color: white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: seedColorDark,
                                      padding: EdgeInsets.all(18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 0, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 32,
                            color: white,
                          ),
                          style: ElevatedButton.styleFrom(
                              // primary: Colors.transparent,
                              padding: EdgeInsets.all(16)),
                        ),
                      ),
                    ),
                  ],
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
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // await exportToImage(_globalKey);
                                    // await Share.share(thunderCardUrl,
                                    //     subject:
                                    //         '$usernameさんのThundercardアカウントの共有');
                                    final bytes =
                                        await exportToImage(_globalKey);
                                    //byte data→Uint8List
                                    final widgetImageBytes = bytes?.buffer
                                        .asUint8List(bytes.offsetInBytes,
                                            bytes.lengthInBytes);
                                    //App directoryファイルに保存
                                    final applicationDocumentsFile =
                                        await getApplicationDocumentsFile(
                                            username, widgetImageBytes!);

                                    final path = applicationDocumentsFile.path;
                                    await Share.shareFiles(
                                      [
                                        path,
                                      ],
                                      text: thunderCardUrl,
                                      subject:
                                          '$usernameさんのThundercardアカウントの共有',
                                    );
                                    applicationDocumentsFile.delete();
                                  },
                                  child: Icon(
                                    Icons.share_rounded,
                                    // size: 32,
                                    color: white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      // primary: Color(0x00000000),
                                      padding: EdgeInsets.all(20)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: thunderCardUrl));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Color(0xff333333),
                                        behavior: SnackBarBehavior.floating,
                                        clipBehavior: Clip.antiAlias,
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 16, 0),
                                              child: Icon(Icons
                                                  .library_add_check_rounded),
                                            ),
                                            Expanded(
                                              child: const Text(
                                                'クリップボードにコピーしました',
                                                style: TextStyle(
                                                    color: white,
                                                    overflow:
                                                        TextOverflow.fade),
                                              ),
                                            ),
                                          ],
                                        ),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy_rounded,
                                    // size: 32,
                                    color: white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      // primary: Color(0x00000000),
                                      padding: EdgeInsets.all(20)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final bytes =
                                        await exportToImage(_globalKey);
                                    //byte data→Uint8List
                                    final widgetImageBytes = bytes?.buffer
                                        .asUint8List(bytes.offsetInBytes,
                                            bytes.lengthInBytes);
                                    final result =
                                        await ImageGallerySaver.saveImage(
                                      widgetImageBytes!,
                                      name: username,
                                    );
                                    //App directoryファイルに保存
                                    // final applicationDocumentsFile =
                                    //     await getApplicationDocumentsFile(
                                    //         username, widgetImageBytes!);
                                    // final path = applicationDocumentsFile.path;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Color(0xff333333),
                                        behavior: SnackBarBehavior.floating,
                                        clipBehavior: Clip.antiAlias,
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 16, 0),
                                              child: Icon(Icons
                                                  .file_download_done_rounded),
                                            ),
                                            Expanded(
                                              child: const Text(
                                                'QRコードをダウンロードしました',
                                                style: TextStyle(
                                                    color: white,
                                                    overflow:
                                                        TextOverflow.fade),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // duration: const Duration(seconds: 12),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          // label: '開く',
                                          label: 'OK',
                                          onPressed: () {
                                            // pickImage();
                                            // _launchURL(
                                            // '',
                                            // 'mailto:example@gmail.com?subject=hoge&body=test',
                                            // thunderCardUrl,
                                            // 'twitter://user?screen_name=cardseditor',
                                            // secondUrl:
                                            //     'https://github.com/cardseditor',
                                            // );
                                          },
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.save_alt_rounded,
                                    // size: 32,
                                    color: white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      // primary: Color(0x00000000),
                                      padding: EdgeInsets.all(20)),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              //   child: Center(
                              //     child: _image ??
                              //         const Icon(Icons.no_photography_rounded),
                              //   ),
                              // ),
                            ],
                          ),
                          // child: ElevatedButton(
                          //   onPressed: () async {
                          //     await controller?.toggleFlash();
                          //     setState(() {});
                          //   },
                          //   child: FutureBuilder(
                          //     future: controller?.getFlashStatus(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.data != null &&
                          //           snapshot.data == true) {
                          //         return const Icon(
                          //             Icons.flashlight_on_rounded);
                          //       } else {
                          //         return const Icon(
                          //             Icons.flashlight_off_rounded);
                          //       }
                          //     },
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //     padding: EdgeInsets.all(16),
                          //   ),
                          // ),
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
            ),
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
                child: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null && snapshot.data == true) {
                      return ElevatedButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: Icon(Icons.flashlight_on_rounded),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          primary: white,
                        ),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: Icon(Icons.flashlight_off_rounded),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          primary: seedColorDark,
                        ),
                      );
                    }
                  },
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

  Future<ByteData?> exportToImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData;
  }

  Future<File> getApplicationDocumentsFile(
      String text, List<int> imageData) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  // Future<Uint8List> convertWidgetToImage(GlobalKey widgetGlobalKey) async {
  //   // RenderObjectを取得
  //   RenderRepaintBoundary boundary =
  //       widgetGlobalKey.currentContext.findRenderObject();
  //   // RenderObject を dart:ui の Image に変換する
  //   ui.Image image = await boundary.toImage();
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData.buffer.asUint8List();
  // }

  // Future<void> _doCapture() async {
  //   final image = await _convertWidgetToImage();
  //   setState(() {
  //     _image = image;
  //   });
  //   // return image;
  // }
  // Future<Image?> _convertWidgetToImage() async {
  //   try {
  //     final boundary = _globalKey.currentContext!.findRenderObject()
  //         as RenderRepaintBoundary;
  //     final image = await boundary.toImage(pixelRatio: 3.0);
  //     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     var pngBytes = byteData!.buffer.asUint8List();
  //     return Image.memory(pngBytes);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  // Future _launchURL(String url, {String? secondUrl}) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(
  //       Uri.parse(url),
  //       // mode: LaunchMode.platformDefault,
  //     );
  //   } else if (secondUrl != null && await canLaunchUrl(Uri.parse(secondUrl))) {
  //     await launchUrl(
  //       Uri.parse(secondUrl),
  //       // mode: LaunchMode.externalNonBrowserApplication,
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Color(0xff333333),
  //       behavior: SnackBarBehavior.floating,
  //       clipBehavior: Clip.antiAlias,
  //       content: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
  //             child: Icon(
  //               Icons.error_outline_rounded,
  //               color: error,
  //             ),
  //           ),
  //           Expanded(
  //             child: const Text(
  //               'アプリを開けません',
  //               style: TextStyle(color: white),
  //             ),
  //           ),
  //         ],
  //       ),
  //       duration: const Duration(seconds: 2),
  //       action: SnackBarAction(
  //         label: 'OK',
  //         onPressed: () {},
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(28),
  //       ),
  //     ));
  //   }
  // }

  // Future pickImage() async {
  //   try {
  //     final picedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (picedFile == null) return;
  //     // final imageTemp = File(picedFile.path);
  //     // if (await canLaunchUrl(Uri.parse(picedFile.path))) {
  //     //   await launchUrl(Uri.parse(picedFile.path));
  //     // }
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
}
