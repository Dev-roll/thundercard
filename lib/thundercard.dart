import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

import 'api/colors.dart';
import 'api/export_to_image.dart';
import 'api/firebase_auth.dart';
import 'api/get_application_documents_file.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/my_card.dart';
import 'widgets/scan_qr_code.dart';
import 'constants.dart';

class Thundercard extends StatefulWidget {
  const Thundercard({Key? key}) : super(key: key);

  @override
  State<Thundercard> createState() => _ThundercardState();
}

class _ThundercardState extends State<Thundercard> {
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        statusBarIconBrightness:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Brightness.light
                : Brightness.dark,
        statusBarBrightness:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder(
                      future: users.doc(uid).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('問題が発生しました');
                        }
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text('ユーザー情報の取得に失敗しました');
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> user =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String myCardId = user['my_cards'][0];
                          String thunderCardUrl =
                              'thundercard://user?card_id=$myCardId';
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RepaintBoundary(
                                key: _globalKey,
                                child: MyCard(
                                  cardId: myCardId,
                                  cardType: CardType.normal,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: IconButton(
                                        onPressed: () async {
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
                                                '${myCardId}さんのThundercardの共有',
                                          );
                                          applicationDocumentsFile.delete();
                                        },
                                        icon: Icon(Icons.share_rounded),
                                        padding: EdgeInsets.all(20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              elevation: 20,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceVariant,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              clipBehavior: Clip.antiAlias,
                                              dismissDirection:
                                                  DismissDirection.horizontal,
                                              margin: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    180,
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 16, 0),
                                                    child: Icon(Icons
                                                        .file_download_done_rounded),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '名刺をダウンロードしました',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          overflow: TextOverflow
                                                              .fade),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // duration: const Duration(seconds: 12),
                                              action: SnackBarAction(
                                                label: 'OK',
                                                onPressed: () {},
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.save_alt_rounded),
                                        padding: EdgeInsets.all(20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
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
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              clipBehavior: Clip.antiAlias,
                                              dismissDirection:
                                                  DismissDirection.horizontal,
                                              margin: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    180,
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 16, 0),
                                                    child: Icon(Icons
                                                        .library_add_check_rounded),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'クリップボードにコピーしました',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          overflow: TextOverflow
                                                              .fade),
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
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return const CustomProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Theme(
              data: ThemeData(
                colorSchemeSeed: Theme.of(context).colorScheme.primary,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              child: const QRViewExample(),
            ),
          ));
        },
        icon: Icon(
          Icons.qr_code_scanner_rounded,
          size: 26,
        ),
        label: Text(
          '名刺を交換',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 56),
          foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
