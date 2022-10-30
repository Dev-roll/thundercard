import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:thundercard/home_page.dart';
import 'package:thundercard/thundercard.dart';
import 'package:thundercard/add_card.dart';
import 'package:thundercard/widgets/fullscreen_qr_code.dart';
import 'package:thundercard/widgets/my_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../api/export_to_image.dart';
import '../api/get_application_documents_file.dart';
import '../notifications.dart';
import '../api/firebase_auth.dart';
import '../constants.dart';
import '../main.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({Key? key, required this.myCardId}) : super(key: key);
  final myCardId;

  @override
  State<StatefulWidget> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanned = false;
  final GlobalKey _globalKey = GlobalKey();
  var myCardId = '';
  var openUrl = '';
  var _lastChangedDate = DateTime.now();
  final linkTime = 10;
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.onSecondary,
        // systemNavigationBarIconBrightness: ThemeData(),
        // statusBarColor: Theme.of(context).colorScheme.onSecondary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      // SystemUiOverlayStyle.dark,
    );

    // var _screenSize = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String? uid = getUid();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: users.doc(uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;
            myCardId = user['my_cards'][0];
            String thunderCardUrl = '$initStr$myCardId';
            // String thunderCardUrl = 'thundercard://user?card_id=$myCardId';
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.onSecondary,
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
                              Stack(
                                children: [
                                  Container(
                                    width: 180,
                                    height: 216,
                                  ),
                                  Container(
                                    width: 180,
                                    height: 216,
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: FittedBox(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: (() async {
                                          controller?.pauseCamera();
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Theme(
                                                data: ThemeData(
                                                  colorSchemeSeed:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  brightness: Brightness.dark,
                                                  useMaterial3: true,
                                                ),
                                                child: FullscreenQrCode(
                                                  name: myCardId,
                                                ),
                                              ),
                                            ),
                                          );
                                          controller?.resumeCamera();
                                        }),
                                        child: RepaintBoundary(
                                          key: _globalKey,
                                          child: MyQrCode(
                                            name: myCardId,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 60,
                                margin: EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        controller?.pauseCamera();
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Theme(
                                              data: ThemeData(
                                                colorSchemeSeed:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                brightness: Brightness.dark,
                                                useMaterial3: true,
                                              ),
                                              child: FullscreenQrCode(
                                                name: myCardId,
                                              ),
                                            ),
                                          ),
                                        );
                                        controller?.resumeCamera();
                                      },
                                      icon: Icon(Icons.open_in_full_rounded),
                                      padding: EdgeInsets.all(12),
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
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Hero(
                            tag: 'close_button',
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: 32,
                                color: white,
                              ),
                              padding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 6, child: _buildQrView(context)),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.onSecondary,
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
                                    child: IconButton(
                                      onPressed: () async {
                                        // await exportToImage(_globalKey);
                                        // await Share.share(thunderCardUrl,
                                        //     subject:
                                        //         '$myCardIdさんのThundercardアカウントの共有');
                                        final bytes =
                                            await exportToImage(_globalKey);
                                        //byte data→Uint8List
                                        final widgetImageBytes = bytes?.buffer
                                            .asUint8List(bytes.offsetInBytes,
                                                bytes.lengthInBytes);
                                        //App directoryファイルに保存
                                        final applicationDocumentsFile =
                                            await getApplicationDocumentsFile(
                                                myCardId, widgetImageBytes!);

                                        final path =
                                            applicationDocumentsFile.path;
                                        await Share.shareFiles(
                                          [
                                            path,
                                          ],
                                          text: thunderCardUrl,
                                          subject:
                                              '$myCardIdさんのThundercardアカウントの共有',
                                        );
                                        applicationDocumentsFile.delete();
                                      },
                                      icon: Icon(Icons.share_rounded),
                                      padding: EdgeInsets.all(20),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: IconButton(
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
                                          name: myCardId,
                                        );
                                        //App directoryファイルに保存
                                        // final applicationDocumentsFile =
                                        //     await getApplicationDocumentsFile(
                                        //         myCardId, widgetImageBytes!);
                                        // final path = applicationDocumentsFile.path;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            elevation: 20,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                            behavior: SnackBarBehavior.floating,
                                            clipBehavior: Clip.antiAlias,
                                            dismissDirection:
                                                DismissDirection.horizontal,
                                            margin: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  100,
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                            ),
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
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.save_alt_rounded),
                                      padding: EdgeInsets.all(20),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: IconButton(
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: thunderCardUrl),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            elevation: 20,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                            behavior: SnackBarBehavior.floating,
                                            clipBehavior: Clip.antiAlias,
                                            dismissDirection:
                                                DismissDirection.horizontal,
                                            margin: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  100,
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                            ),
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
                                            action: SnackBarAction(
                                              label: 'OK',
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.copy_rounded),
                                      padding: EdgeInsets.all(20),
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
            );
          },
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
                      return IconButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        icon: Icon(Icons.flashlight_on_rounded),
                        padding: EdgeInsets.all(20),
                        style: IconButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      );
                    } else {
                      return IconButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        icon: Icon(Icons.flashlight_off_rounded),
                        padding: EdgeInsets.all(20),
                        style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
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
    controller.scannedDataStream.listen(
      (scanData) {
        log(scanData.code.toString());
        HapticFeedback.vibrate();
        setState(() {
          result = scanData;
        });
        if (scanData.code == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 20,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              behavior: SnackBarBehavior.floating,
              clipBehavior: Clip.antiAlias,
              dismissDirection: DismissDirection.horizontal,
              margin: EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: MediaQuery.of(context).size.height - 180,
              ),
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              content: Text("QRコードを読み取れませんでした"),
            ),
          );
        } else if (describeEnum(scanData.format) == 'qrcode') {
          final str = scanData.code.toString();
          final nowDate = DateTime.now();
          if (str.startsWith(initStr)) {
            _transitionToNextPage(
              str.split(initStr).last,
            );
          } else if (openUrl != str ||
              nowDate.difference(_lastChangedDate).inSeconds >= linkTime) {
            openUrl = str;
            _lastChangedDate = nowDate;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 20,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                behavior: SnackBarBehavior.floating,
                clipBehavior: Clip.antiAlias,
                dismissDirection: DismissDirection.horizontal,
                margin: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 40,
                ),
                duration: Duration(seconds: linkTime),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: Icon(Icons.link_rounded),
                    ),
                    Expanded(
                      child: Text(
                        openUrl,
                        style: TextStyle(
                            color: white, overflow: TextOverflow.fade),
                      ),
                    ),
                  ],
                ),
                action: SnackBarAction(
                  label: '開く',
                  onPressed: () {
                    _launchURL(openUrl.trim());
                  },
                ),
              ),
            );
          }
        }
      },
    );
    this.controller!.pauseCamera();
    this.controller!.resumeCamera();
  }

  Future<void> _transitionToNextPage(String data) async {
    if (!_isScanned) {
      this.controller?.pauseCamera();
      _isScanned = true;
    }

    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => AddCard(myCardId: myCardId, cardId: data),
    ))
        .then((value) {
      this.controller?.resumeCamera();
      _isScanned = false;
    });
  }

  Future _launchURL(String url, {String? secondUrl}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else if (secondUrl != null && await canLaunchUrl(Uri.parse(secondUrl))) {
      await launchUrl(
        Uri.parse(secondUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).size.height - 180,
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            Expanded(
              child: Text(
                'アプリを開けません',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ));
    }
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
        SnackBar(
          elevation: 20,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          dismissDirection: DismissDirection.horizontal,
          margin: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).size.height - 180,
          ),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          content: Text('no Permission'),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
