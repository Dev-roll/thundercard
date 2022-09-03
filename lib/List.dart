import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thundercard/widgets/chat/room_list_page.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class List extends StatefulWidget {
  const List({Key? key, required this.uid}) : super(key: key);
  // const List({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  File? image;
  Map<String, dynamic>? data;

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

  void updateDocumentData(String imageURL) {
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc('${widget.uid}')
        .collection('cards')
        .doc('example');
    doc.update({'thumbnail': '$imageURL'}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  void uploadPic() async {
    try {
      /// 画像を選択
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      File file = File(image!.path);

      String uploadName = 'image.jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('cards/${uid}/images/$uploadName');
      final task = await storageRef.putFile(file);
      final String imageURL = await task.ref.getDownloadURL();
      print('ここ大事 -> $imageURL');
      updateDocumentData(imageURL);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                child: Column(children: [
                  Text('data'),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RoomListPage(),
                      ));
                    },
                    child: const Text('Chat'),
                  ),
                  OutlinedButton(
                    onPressed: uploadPic,
                    child: const Text('Upload'),
                  ),
                  // Text(widget.data.toString()),
                  image != null
                      ? Image.file(image!)
                      : Text("No image selected"),
                ]),
              ),
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
