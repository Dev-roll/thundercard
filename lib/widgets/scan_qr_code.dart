import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/add_card.dart';
import 'package:thundercard/widgets/fullscreen_qr_code.dart';
import 'package:thundercard/widgets/my_qr_code.dart';
import 'package:thundercard/widgets/positioned_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/colors.dart';
import '../api/dynamic_links.dart';
import '../api/export_to_image.dart';
import '../api/get_application_documents_file.dart';
import '../api/firebase_auth.dart';
import '../constants.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({Key? key}) : super(key: key);

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
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String? uid = getUid();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FutureBuilder(
          future: users.doc(uid).collection('card').doc('current_card').get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            Map<String, dynamic> currentCard =
                snapshot.data!.data() as Map<String, dynamic>;
            myCardId = currentCard['current_card'];
            // String thunderCardUrl = '$initStr$myCardId';
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.onSecondary,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Stack(
                        children: [
                          const SizedBox(
                            width: 180,
                            height: 216,
                          ),
                          Container(
                            width: 180,
                            height: 216,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: FittedBox(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (() async {
                                  controller?.pauseCamera();
                                  await Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => Theme(
                                        data: ThemeData(
                                          colorSchemeSeed: Theme.of(context)
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
                                  )
                                      .then((value) {
                                    SystemChrome.setSystemUIOverlayStyle(
                                      SystemUiOverlayStyle(
                                        systemNavigationBarColor: alphaBlend(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.08),
                                            Theme.of(context)
                                                .colorScheme
                                                .surface),
                                        statusBarIconBrightness:
                                            Brightness.light,
                                        statusBarBrightness: Brightness.dark,
                                      ),
                                    );
                                  });
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
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              child: IconButton(
                                onPressed: () async {
                                  final bytes = await exportToImage(_globalKey);
                                  final widgetImageBytes = bytes?.buffer
                                      .asUint8List(bytes.offsetInBytes,
                                          bytes.lengthInBytes);
                                  final applicationDocumentsFile =
                                      await getApplicationDocumentsFile(
                                          myCardId, widgetImageBytes!);

                                  final path = applicationDocumentsFile.path;
                                  final thunderCardUrl =
                                      await dynamicLinks(myCardId);

                                  await Share.shareXFiles(
                                    [
                                      XFile(path),
                                    ],
                                    text: thunderCardUrl.shortUrl.toString(),
                                    subject: '$myCardIdさんのThundercardアカウントの共有',
                                  );
                                  applicationDocumentsFile.delete();
                                },
                                icon: const Icon(Icons.share_rounded),
                                padding: const EdgeInsets.all(20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              child: IconButton(
                                onPressed: () async {
                                  final bytes = await exportToImage(_globalKey);
                                  final widgetImageBytes = bytes?.buffer
                                      .asUint8List(bytes.offsetInBytes,
                                          bytes.lengthInBytes);
                                  await ImageGallerySaver.saveImage(
                                    widgetImageBytes!,
                                    name: myCardId,
                                  );
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    PositionedSnackBar(
                                      context,
                                      'QRコードをダウンロードしました',
                                      icon: Icons.file_download_done_rounded,
                                      bottom:
                                          MediaQuery.of(context).size.height -
                                              140,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.save_alt_rounded),
                                padding: const EdgeInsets.all(20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                              child: IconButton(
                                onPressed: () async {
                                  controller?.pauseCamera();
                                  await Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => Theme(
                                        data: ThemeData(
                                          colorSchemeSeed: Theme.of(context)
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
                                  )
                                      .then((value) {
                                    SystemChrome.setSystemUIOverlayStyle(
                                      SystemUiOverlayStyle(
                                        systemNavigationBarColor: alphaBlend(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.08),
                                            Theme.of(context)
                                                .colorScheme
                                                .surface),
                                        statusBarIconBrightness:
                                            Brightness.light,
                                        statusBarBrightness: Brightness.dark,
                                      ),
                                    );
                                  });
                                  controller?.resumeCamera();
                                },
                                icon: const Icon(Icons.fullscreen_rounded),
                                padding: const EdgeInsets.all(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 2, child: _buildQrView(context)),
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
              borderColor: const Color(0xFFFFFFFF),
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
              color: const Color(0x22FFFFFF),
              border: Border.all(color: const Color(0x88FFFFFF), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            CupertinoIcons.qrcode,
            color: const Color(0x32FFFFFF),
            size: (MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height)
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.height * 0.2,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                        icon: const Icon(Icons.flashlight_on_rounded),
                        padding: const EdgeInsets.all(20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    } else {
                      return IconButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        icon: const Icon(Icons.flashlight_off_rounded),
                        padding: const EdgeInsets.all(20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
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
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.collections_rounded),
                    padding: const EdgeInsets.all(20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen(
      (scanData) async {
        log(scanData.code.toString());
        HapticFeedback.vibrate();
        setState(() {
          result = scanData;
        });
        if (scanData.code == null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            PositionedSnackBar(
              context,
              'QRコードを読み取れませんでした',
              bottom: 48,
              foreground: Theme.of(context).colorScheme.onError,
            ),
          );
        } else if (describeEnum(scanData.format) == 'qrcode') {
          final str = scanData.code.toString();
          final nowDate = DateTime.now();
          if (str.startsWith(initStr)) {
            _transitionToNextPage(
              Uri.parse(str).queryParameters['card_id'] ?? '',
            );
          } else if (openUrl != str ||
              nowDate.difference(_lastChangedDate).inSeconds >= linkTime) {
            openUrl = str;
            _lastChangedDate = nowDate;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 20,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                behavior: SnackBarBehavior.floating,
                clipBehavior: Clip.antiAlias,
                dismissDirection: DismissDirection.horizontal,
                margin: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 8,
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
                      child: await canLaunchUrl(Uri.parse(openUrl.trim()))
                          ? const Icon(Icons.link_rounded)
                          : const Icon(Icons.link_off_rounded),
                    ),
                    Expanded(
                      child: Text(
                        openUrl,
                        style: const TextStyle(
                            color: white, overflow: TextOverflow.fade),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Share.share(
                          openUrl.trim(),
                          subject: 'QRコードで読み取った文字列',
                        );
                      },
                      icon: Icon(
                        Icons.share_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: openUrl.trim()),
                        ).then((value) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            PositionedSnackBar(
                              context,
                              'クリップボードにコピーしました',
                              icon: Icons.library_add_check_rounded,
                              bottom: 48,
                            ),
                          );
                        });
                      },
                      icon: Icon(
                        Icons.copy_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    await canLaunchUrl(Uri.parse(openUrl.trim()))
                        ? IconButton(
                            onPressed: () {
                              _launchURL(openUrl.trim());
                            },
                            icon: Icon(
                              Icons.open_in_new_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.open_in_new_off_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.25),
                            ),
                          ),
                  ],
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
      controller?.pauseCamera();
      _isScanned = true;
    }

    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => AddCard(myCardId: myCardId, cardId: data),
    ))
        .then((value) {
      controller?.resumeCamera();
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        PositionedSnackBar(
          context,
          'アプリを開けません',
          icon: Icons.error_outline_rounded,
          foreground: Theme.of(context).colorScheme.onError,
          bottom: 48,
        ),
      );
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        PositionedSnackBar(
          context,
          '権限がありません',
          icon: Icons.error_outline_rounded,
          foreground: Theme.of(context).colorScheme.onError,
          bottom: MediaQuery.of(context).size.height - 140,
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
  //     debugPrint(e);
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
  //     debugPrint('Failed to pick image: $e');
  //   }
  // }
}
