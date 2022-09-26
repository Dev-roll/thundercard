import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountEditor extends StatefulWidget {
  const AccountEditor({Key? key, required this.data, required this.cardId})
      : super(key: key);
  final dynamic data;
  final dynamic cardId;

  @override
  State<AccountEditor> createState() => _AccountEditorState();
}

class _AccountEditorState extends State<AccountEditor> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.data?['profiles']['name']['value']);
  late final TextEditingController _bioController =
      TextEditingController(text: widget.data?['profiles']['bio']['value']);
  late final TextEditingController _companyController =
      TextEditingController(text: widget.data?['profiles']['company']['value']);
  late final TextEditingController _positionController =
      TextEditingController(text: widget.data?['profiles']['position']['value']);
  late final TextEditingController _addressController =
      TextEditingController(text: widget.data?['profiles']['address']['value']);
  late DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(widget.cardId);

  Future<void> updateCard() {
    return card.update({'account.profiles':{
      'name': _nameController.text,
      'bio.value': _bioController.text,
      'company.value': _companyController.text,
      'position.value': _positionController.text,
      'address.value': _addressController.text,
    }}).then((value) {
      Navigator.of(context).pop();
      print('Card Updated');
    }).catchError((error) => print('Failed to update card: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィールを編集（禁止）'),
          actions: [
            TextButton(onPressed: updateCard, child: const Text('保存')),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('ユーザー名'),
                            TextField(
                              controller: _nameController,
                            ),
                            const Text('自己紹介'),
                            TextField(
                              controller: _bioController,
                            ),
                            const Text('所属'),
                            TextField(
                              controller: _companyController,
                            ),
                            const Text('position'),
                            TextField(
                              controller: _positionController,
                            ),
                            const Text('address'),
                            TextField(
                              controller: _addressController,
                            ),
                            const Text('自分の名刺'),
                            // Image.network(data?['thumbnail']),
                          ],
                        ))))),
      ),
    );
  }
}
