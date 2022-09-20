import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:math' as math;

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

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
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
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    int smallLetterStart = 97;
    int smallLetterCount = 26;

    var alphabetArray = [];
    // 10個のアルファベットがある文字列を作成して、最後にjoinで繋げています
    var rand = math.Random();
    for (var i = 0; i < 10; i++) {
      // 0-25の乱数を発生させます
      int number = rand.nextInt(smallLetterCount);
      int randomNumber = number + smallLetterStart;
      alphabetArray.add(String.fromCharCode(randomNumber));
    }

    String handleAccount = alphabetArray.join('');

    void updateDocumentData(String imageURL) {
      final doc =
          FirebaseFirestore.instance.collection('cards').doc(handleAccount);
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
        'exchanged_cards': FieldValue.arrayUnion([handleAccount])
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    }

    void uploadPic() async {
      try {
        /// 画像を選択
        // final ImagePicker picker = ImagePicker();
        // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        File file = File(image!.path);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('cards/$handleAccount/$uploadName');
        final task = await storageRef.putFile(file);
        final String imageURL = await task.ref.getDownloadURL();
        print('ここ大事 -> $imageURL');
        updateDocumentData(imageURL);
        updateExchangedCards();
      } catch (e) {
        print(e);
      }
    }

    var _editText = '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(children: [
                const Text('① Enter username.'),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _editText = value;
                    });
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'username',
                    hintText: 'No name entered',
                  ),
                  textInputAction: TextInputAction.done,
                ),
                _nameController.text != ''
                    ? Text('Name entered')
                    : Text('No name entered'),
                const Text('② Take a photo.'),
                image != null ? Image.file(image!) : Text("No image selected"),
                OutlinedButton(
                  onPressed: _nameController.text != '' && image != null
                      ? uploadPic
                      : null,
                  child: const Text('Upload'),
                ),
              ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImageC,
        // onPressed: getImage,
        child: const Icon(
          Icons.add_a_photo_rounded,
        ),
      ),
    );
  }
}
