import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:thundercard/home_page.dart';
import 'package:timeline_tile/timeline_tile.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key, required this.cardId, required this.data})
      : super(key: key);
  final String? cardId;
  final dynamic data;

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? image;
  Map<String, dynamic>? data;
  String uploadName = 'card.jpg';
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _recognizedTextController =
      TextEditingController();
  var _editText = '';
  var isCompleted = false;

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
      print('Failed to pick image: $e');
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
      print('Failed to pick image: $e');
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
    final docId = FirebaseFirestore.instance.collection('cards').doc().id;

    void updateDocumentData(String imageURL) {
      final doc = FirebaseFirestore.instance.collection('cards').doc(docId);
      doc.set({
        'thumbnail': '$imageURL',
        'name': _nameController.text,
        'is_user': false,
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    }

    void updateExchangedCards() {
      final doc =
          FirebaseFirestore.instance.collection('cards').doc(widget.cardId);
      doc.update({
        'exchanged_cards': FieldValue.arrayUnion([docId])
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    }

    void uploadPic() async {
      setState(() {
        isCompleted = true;
      });
      try {
        /// 画像を選択
        // final ImagePicker picker = ImagePicker();
        // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        File file = File(image!.path);

        final storageRef =
            FirebaseStorage.instance.ref().child('cards/$docId/$uploadName');
        final task = await storageRef.putFile(file);
        final String imageURL = await task.ref.getDownloadURL();
        print('ここ大事 -> $imageURL');
        updateDocumentData(imageURL);
        updateExchangedCards();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(index: 1),
        ));
      } catch (e) {
        print(e);
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              //1st
              TimelineTile(
                isFirst: true,
                alignment: TimelineAlign.manual,
                lineXY: 0.1,
                beforeLineStyle: LineStyle(
                  color: _nameController.text != ''
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withOpacity(0.7),
                  thickness: 2,
                ),
                indicatorStyle: IndicatorStyle(
                  indicatorXY: 0.44,
                  drawGap: true,
                  width: 30,
                  height: 30,
                  indicator: _nameController.text == '' && image != null
                      ? Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        )
                      : _nameController.text == ''
                          ? const Icon(Icons.circle_outlined)
                          : Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                ),
                startChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 12, top: 0, bottom: 0),
                  child: Column(
                    // alignment: const Alignment(0.0, 0),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
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
                endChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 32, top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Enter card name',
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
                      : Colors.white.withOpacity(0.7),
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
                            _editText = value;
                          });
                        },
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'card name',
                          hintText: 'Enter name',
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),

              // 2nd
              TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.1,
                beforeLineStyle: LineStyle(
                  color: image != null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withOpacity(0.7),
                  thickness: 2,
                ),
                indicatorStyle: IndicatorStyle(
                  indicatorXY: 0.44,
                  drawGap: true,
                  width: 30,
                  height: 30,
                  indicator: image == null
                      ? const Icon(Icons.circle_outlined)
                      : Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),
                startChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 12, top: 0, bottom: 0),
                  child: Column(
                    // alignment: const Alignment(0.0, 0),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const Text(
                        '',
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                endChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 32, top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Pick a card image',
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
                      : Colors.white.withOpacity(0.7),
                  thickness: 2,
                ),
                hasIndicator: false,
                endChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 28, right: 32, top: 24, bottom: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      image != null ? Image.file(image!) : Container(),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: pickImageC,
                            child: const Text('Take a photo'),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: pickImage,
                            child: const Text('Pick image from gallery'),
                          ),
                          const Text('検出されたテキスト'),
                        ],
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _recognizedTextController,
                      ),
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
                      : Colors.white.withOpacity(0.7),
                  thickness: 2,
                ),
                indicatorStyle: IndicatorStyle(
                  indicatorXY: 0.44,
                  drawGap: true,
                  width: 30,
                  height: 30,
                  indicator: isCompleted
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.circle_outlined),
                ),
                startChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 12, top: 0, bottom: 0),
                  child: Column(
                    // alignment: const Alignment(0.0, 0),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const Text(
                        '',
                        style: const TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                endChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 32, top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Register this card',
                        style: const TextStyle(
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
                      : Colors.white.withOpacity(0.7),
                  thickness: 2,
                ),
                hasIndicator: false,
                endChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 28, right: 32, top: 24, bottom: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _nameController.text != '' && image != null
                            ? uploadPic
                            : null,
                        child: const Text('Register'),
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
                      : Colors.white.withOpacity(0.7),
                  thickness: 2,
                ),
                indicatorStyle: IndicatorStyle(
                  indicatorXY: 0.44,
                  drawGap: true,
                  width: 30,
                  height: 30,
                  indicator: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                startChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 12, top: 0, bottom: 0),
                  child: Column(
                    // alignment: const Alignment(0.0, 0),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
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
                endChild: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 32, top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
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
    );
  }
}
