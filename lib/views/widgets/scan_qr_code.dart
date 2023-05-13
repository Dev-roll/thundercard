import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/providers/dynamic_links_provider.dart';
import 'package:thundercard/utils/launch_url.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart';
import '../../utils/dynamic_links.dart';
import '../../utils/export_to_image.dart';
import '../../utils/get_application_documents_file.dart';
import '../../utils/input_data_processor.dart';
import '../../utils/setSystemChrome.dart';
import '../pages/add_card.dart';
import 'fullscreen_qr_code.dart';
import 'my_qr_code.dart';
import 'positioned_snack_bar.dart';

class ScanQrCode extends ConsumerStatefulWidget {
  const ScanQrCode({Key? key, required this.currentCardId}) : super(key: key);

  final String currentCardId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends ConsumerState<ScanQrCode> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanned = false;
  final GlobalKey _globalKey = GlobalKey();
  var myCardId = '';
  var openUrl = '';
  var _lastChangedDate = DateTime.now();
  final linkTime = 10;

  @override
  void initState() {
    super.initState();

    myCardId = widget.currentCardId;
  }

  Future<String?> scanSelectedImage() async {
    try {
      final inputImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (inputImage == null) return null;
      final imageTemp = File(inputImage.path);
      return await scanCode(imageTemp.path);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
      return null;
    }
  }

  Future<String> scanCode(String filePath) async {
    final InputImage inputImage = InputImage.fromFilePath(filePath);
    final barcodeScanner = BarcodeScanner();
    final barcodes = await barcodeScanner.processImage(inputImage);
    if (inputImage.inputImageData?.size == null ||
        inputImage.inputImageData?.imageRotation == null) {
      return barcodes.first.rawValue ?? '';
    }
    return '';
  }

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
    setSystemChrome(context);

    final dynamicLink = ref.watch(dynamicLinkProvider(myCardId));
    final String dynamicLinksValue = dynamicLink.when(
      data: (data) => data.shortUrl.toString(), // データを表示
      loading: () => '',
      error: (err, stack) => err.toString(),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
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
                                      colorSchemeSeed:
                                          Theme.of(context).colorScheme.primary,
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
                                setSystemChrome(context);
                              });
                              controller?.resumeCamera();
                            }),
                            child: RepaintBoundary(
                              key: _globalKey,
                              child: MyQrCode(
                                myCardId: myCardId,
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
                                  .asUint8List(
                                      bytes.offsetInBytes, bytes.lengthInBytes);
                              final applicationDocumentsFile =
                                  await getApplicationDocumentsFile(
                                      myCardId, widgetImageBytes!);

                              final path = applicationDocumentsFile.path;

                              await Share.shareXFiles(
                                [
                                  XFile(path),
                                ],
                                text: dynamicLinksValue,
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
                                  .asUint8List(
                                      bytes.offsetInBytes, bytes.lengthInBytes);
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
                                      colorSchemeSeed:
                                          Theme.of(context).colorScheme.primary,
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
                                setSystemChrome(context);
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
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () async {
                      final String data = await scanSelectedImage() ?? '';
                      final String? id = await inputToId(data);
                      if (id != null) {
                        _transitionToNextPage(id);
                      } else if (data != '') {
                        _showScanData(data);
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          PositionedSnackBar(
                            context,
                            'QRコードを読み取れませんでした',
                            bottom: 48,
                            foreground: Theme.of(context).colorScheme.onError,
                          ),
                        );
                      }
                    },
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
          final String? id = await inputToId(str);
          if (id != null) {
            _transitionToNextPage(id);
          } else if (openUrl != str ||
              nowDate.difference(_lastChangedDate).inSeconds >= linkTime) {
            openUrl = str;
            _lastChangedDate = nowDate;
            _showScanData(openUrl);
          }
        }
      },
    );
    this.controller!.pauseCamera();
    this.controller!.resumeCamera();
  }

  Future<void> _showScanData(String data) async {
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
              child: await canLaunchUrl(Uri.parse(data.trim()))
                  ? const Icon(Icons.link_rounded)
                  : const Icon(Icons.link_off_rounded),
            ),
            Expanded(
              child: Text(
                data,
                style:
                    const TextStyle(color: white, overflow: TextOverflow.fade),
              ),
            ),
            IconButton(
              onPressed: () async {
                await Share.share(
                  data.trim(),
                  subject: 'QRコードの読み取り結果',
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
                  ClipboardData(text: data.trim()),
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
            await canLaunchUrl(Uri.parse(data.trim()))
                ? IconButton(
                    onPressed: () {
                      launchURL(data.trim(), context);
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

  Future<void> _transitionToNextPage(String data) async {
    if (!_isScanned) {
      controller?.pauseCamera();
      _isScanned = true;
    }

    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => AddCard(applyingId: myCardId, cardId: data),
    ))
        .then((value) {
      controller?.resumeCamera();
      _isScanned = false;
    });
  }

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

  // Future launchURL(String url, {String? secondUrl}) async {
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
