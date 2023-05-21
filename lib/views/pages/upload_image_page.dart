import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../widgets/positioned_snack_bar.dart';

// import 'dart:math' as math;
// import 'package:google_fonts/google_fonts.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key, required this.cardId}) : super(key: key);
  final String? cardId;

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? image;
  String uploadName = 'card.jpg';
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _recognizedTextController =
      TextEditingController();
  var editText = '';
  var isCompleted = false;
  var uploadButtonPressed = false;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      final recognizedTextTemp = await recognizeText(imageTemp.path);
      this.image = imageTemp;
      setState(() {
        this.image = imageTemp;
        _recognizedTextController.text = recognizedTextTemp;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  // カメラを使う関数
  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      final recognizedTextTemp = await recognizeText(imageTemp.path);
      this.image = imageTemp;
      setState(() {
        this.image = imageTemp;
        _recognizedTextController.text = recognizedTextTemp;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future<String> recognizeText(String filePath) async {
    final InputImage imageFile = InputImage.fromFilePath(filePath);
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.japanese);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(imageFile);
    return recognizedText.text;
  }

  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    final docId = FirebaseFirestore.instance
        .collection('version')
        .doc('2')
        .collection('cards')
        .doc()
        .id;

    void updateDocumentData(String imageURL) {
      FirebaseFirestore.instance
          .collection('version')
          .doc('2')
          .collection('cards')
          .doc(docId)
          .set({
        'card_id': docId,
      }, SetOptions(merge: true)).then((element) {
        debugPrint('set cardid directory: completed');
      });

      final CollectionReference newCard = FirebaseFirestore.instance
          .collection('version')
          .doc('2')
          .collection('cards')
          .doc(docId)
          .collection('visibility');

      final c21r20u00d11 = {
        'is_user': false,
        'card_id': docId,
      };

      newCard
          .doc('c21r20u00d11')
          .set(c21r20u00d11, SetOptions(merge: true))
          .then((value) {
        debugPrint('Card successfully added!');
      }, onError: (e) {
        debugPrint('Error updating document $e');
      });

      final c10r20u10d10 = {
        'public': false,
        'name': _nameController.text,
      };

      newCard
          .doc('c10r20u10d10')
          .set(c10r20u10d10, SetOptions(merge: true))
          .then((value) {
        debugPrint('Card successfully added!');
      }, onError: (e) {
        debugPrint('Error updating document $e');
      });

      newCard.doc('c20r11u11d11').set({
        'card_url': imageURL,
      });

      newCard.doc('c10r21u10d10').set({
        'profiles': {
          'bio': {
            'value': '',
            'display': {'large': true, 'normal': true},
          },
          'company': {
            'value': '',
            'display': {'large': true, 'normal': true},
          },
          'position': {
            'value': '',
            'display': {'large': true, 'normal': true},
          },
          'address': {
            'value': '',
            'display': {'large': true, 'normal': true},
          },
        },
        'account': {
          'links': [],
        },
      }).then((value) {
        debugPrint('DocumentSnapshot successfully updated!');
      }, onError: (e) {
        debugPrint('Error updating document $e');
      });
    }

    void updateExchangedCards() {
      final doc = FirebaseFirestore.instance
          .collection('version')
          .doc('2')
          .collection('cards')
          .doc(widget.cardId)
          .collection('visibility')
          .doc('c10r10u11d10');
      doc.update({
        'exchanged_cards': FieldValue.arrayUnion([docId])
      }).then((value) {
        debugPrint('DocumentSnapshot successfully updated!');
      }, onError: (e) {
        debugPrint('Error updating document $e');
      });
    }

    void uploadPic() async {
      setState(() {
        isCompleted = true;
        uploadButtonPressed = true;
      });
      try {
        /// 画像を選択
        // final ImagePicker picker = ImagePicker();
        // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        File file = File(image!.path);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('version/2/cards/not_user/$docId/$uploadName');
        final task = await storageRef.putFile(file);
        final String imageURL = await task.ref.getDownloadURL();
        debugPrint('ここ大事 -> $imageURL');
        updateDocumentData(imageURL);
        updateExchangedCards();
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          PositionedSnackBar(
            context,
            'カードを追加しました',
            icon: Icons.file_download_done_rounded,
          ),
        );
      } catch (e) {
        debugPrint('$e');
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('画像からカードを追加'),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    // 1st
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: image != null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      indicatorStyle: IndicatorStyle(
                        indicatorXY: 0.44,
                        drawGap: true,
                        width: 30,
                        height: 30,
                        indicator: image == null && _nameController.text != ''
                            ? Icon(
                                Icons.error_outline_rounded,
                                color: Theme.of(context).colorScheme.error,
                              )
                            : _nameController.text == ''
                                ? const Icon(Icons.circle_outlined)
                                : Icon(
                                    Icons.check_circle_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                      ),
                      startChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 12, top: 0, bottom: 0),
                        child: Column(
                          // alignment: const Alignment(0.0, 0),
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      endChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 12, right: 32, top: 0, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '名刺等の画像を設定',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: image != null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      hasIndicator: false,
                      endChild: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 24, 32, 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (image != null) Image.file(image!),
                            const SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: pickImageC,
                                  icon: const Icon(Icons.photo_camera_rounded),
                                  label: const Text('写真を撮影'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: pickImage,
                                  icon: const Icon(Icons.photo_rounded),
                                  label: const Text('画像を選択'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                            if (image != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text('検出されたテキスト'),
                                  TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: _recognizedTextController,
                                  ),
                                ],
                              ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    //2nd
                    TimelineTile(
                      isFirst: true,
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: _nameController.text != ''
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      indicatorStyle: IndicatorStyle(
                        indicatorXY: 0.44,
                        drawGap: true,
                        width: 30,
                        height: 30,
                        indicator: _nameController.text == ''
                            ? const Icon(Icons.circle_outlined)
                            : Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      startChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 12, top: 0, bottom: 0),
                        child: Column(
                          // alignment: const Alignment(0.0, 0),
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      endChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 12, right: 32, top: 0, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '表示名を入力',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: _nameController.text != ''
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      hasIndicator: false,
                      endChild: Padding(
                        padding: const EdgeInsets.only(
                            left: 28, right: 32, top: 24, bottom: 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  editText = value;
                                });
                              },
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '表示名',
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),

                    // 3rd
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      indicatorStyle: IndicatorStyle(
                        indicatorXY: 0.44,
                        drawGap: true,
                        width: 30,
                        height: 30,
                        indicator: isCompleted
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : const Icon(Icons.circle_outlined),
                      ),
                      startChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 12, top: 0, bottom: 0),
                        child: Column(
                          // alignment: const Alignment(0.0, 0),
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      endChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 12, right: 32, top: 0, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'カードを登録',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      hasIndicator: false,
                      endChild: Padding(
                        padding: const EdgeInsets.only(
                            left: 28, right: 32, top: 24, bottom: 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            uploadButtonPressed
                                ? ElevatedButton(
                                    onPressed: null,
                                    onLongPress: null,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      child: const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: _nameController.text != '' &&
                                            image != null
                                        ? uploadPic
                                        : null,
                                    onLongPress: null,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    icon: const Icon(Icons.done_rounded),
                                    label: const Text('登録'),
                                  ),
                          ],
                        ),
                      ),
                    ),

                    // 4th
                    TimelineTile(
                      isLast: true,
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      beforeLineStyle: LineStyle(
                        color: _nameController.text != ''
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                        thickness: 2,
                      ),
                      indicatorStyle: IndicatorStyle(
                        indicatorXY: 0.44,
                        drawGap: true,
                        width: 30,
                        height: 30,
                        indicator: Icon(
                          Icons.task_alt_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      startChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 12, top: 0, bottom: 0),
                        child: Column(
                          // alignment: const Alignment(0.0, 0),
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      endChild: const Padding(
                        padding: EdgeInsets.only(
                            left: 12, right: 32, top: 0, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
