import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/auth_gate.dart';
import 'package:uuid/uuid.dart';
import 'api/firebase_auth.dart';
import 'package:intl/intl.dart';

class AccountEditor extends StatefulWidget {
  const AccountEditor({Key? key, required this.data, required this.cardId})
      : super(key: key);
  final dynamic data;
  final dynamic cardId;

  @override
  State<AccountEditor> createState() => _AccountEditorState();
}

class TextFieldState {
  final String id;
  String selector;
  final TextEditingController controller;

  TextFieldState(this.id, this.selector, this.controller);
}

class ReorderableMultiTextFieldController
    extends ValueNotifier<List<TextFieldState>> {
  ReorderableMultiTextFieldController(List<TextFieldState> value)
      : super(value);

  void add(key, text) {
    final state = TextFieldState(
      Uuid().v4(),
      key,
      TextEditingController(text: text),
    );

    value = [...value, state];
  }

  void setKey(id, newValue) {
    final keyIndex = value.indexWhere((element) => element.id == id);
    value[keyIndex].selector = newValue;
  }

  void remove(String id) {
    final removedText = value.where((element) => element.id == id);
    if (removedText.isEmpty) {
      throw "Textがありません";
    }

    value = value.where((element) => element.id != id).toList();

    Future.delayed(Duration(seconds: 1)).then(
      (value) => removedText.first.controller.dispose(),
    );
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = value.removeAt(oldIndex);
    value = [...value..insert(newIndex, item)];
  }

  @override
  void dispose() {
    value.forEach((element) {
      element.controller.dispose();
    });
    super.dispose();
  }
}

class ReorderableMultiTextField extends StatefulWidget {
  final ReorderableMultiTextFieldController controllerController;
  ReorderableMultiTextField({
    Key? key,
    required this.controllerController,
  }) : super(key: key);

  @override
  State<ReorderableMultiTextField> createState() =>
      _ReorderableMultiTextFieldState();
}

class Links {
  Links(this.key, this.value);

  String key;
  int value;
}

class _ReorderableMultiTextFieldState extends State<ReorderableMultiTextField> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<TextFieldState>>(
      valueListenable: widget.controllerController,
      builder: (context, state, _) {
        final links = [
          'url',
          'twitter',
          'instagram',
          'github',
        ];

        final linksDropdownMenuItem = links
            .map((entry) => DropdownMenuItem(
                  child: Text(entry),
                  value: entry,
                ))
            .toList();

        return ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: state.map(
            (textFieldState) {
              dynamic selectedKey = textFieldState.selector;
              return Column(
                key: ValueKey(textFieldState.id),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                          items: linksDropdownMenuItem,
                          value: selectedKey,
                          onChanged: (value) {
                            widget.controllerController
                                .setKey(textFieldState.id, value);
                            setState(() {
                              selectedKey = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: textFieldState.controller,
                          decoration: InputDecoration.collapsed(hintText: ""),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.drag_indicator_rounded),
                            SizedBox(width: 12),
                            IconButton(
                              icon: Icon(Icons.delete_rounded),
                              onPressed: () => widget.controllerController
                                  .remove(textFieldState.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ).toList(),
          onReorder: (oldIndex, newIndex) =>
              widget.controllerController.reorder(
            oldIndex,
            newIndex,
          ),
        );
      },
    );
  }
}

class _AccountEditorState extends State<AccountEditor> {
  final String? uid = getUid();
  late final TextEditingController _nameController =
      TextEditingController(text: widget.data?['profiles']['name']['value']);
  late final TextEditingController _bioController =
      TextEditingController(text: widget.data?['profiles']['bio']['value']);
  late final TextEditingController _companyController =
      TextEditingController(text: widget.data?['profiles']['company']['value']);
  late final TextEditingController _positionController = TextEditingController(
      text: widget.data?['profiles']['position']['value']);
  late final TextEditingController _addressController =
      TextEditingController(text: widget.data?['profiles']['address']['value']);
  late DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(widget.cardId);
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late ReorderableMultiTextFieldController controller;

  @override
  void initState() {
    controller = ReorderableMultiTextFieldController([]);
    super.initState();
  }

  void updateCard() {
    final values = controller.value.map(((e) {
      return e.controller.text;
    })).toList();
    final keys = controller.value.map(((e) {
      return e.selector;
    })).toList();

    var links = [];
    for (var i = 0; i < keys.length; i++) {
      links.add({
        'key': keys[i],
        'value': values[i],
        'display': {
          'extended': true,
          'normal': true,
        },
      });
    }
    print(links);

    final updateNotificationData = {
      'title': 'アカウント情報更新のお知らせ',
      'content': '${_nameController.text}アカウント情報の更新が完了しました',
      'created_at': DateTime.now(),
      'read': false,
      'tags': ['news'],
      'id':
          'account-update-${widget.cardId}-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
    };

    FirebaseFirestore.instance
        .collection('cards')
        .doc(widget.cardId)
        .collection('notifications')
        .add(updateNotificationData);

    card.update({
      'is_user': true,
      'public': false,
      'uid': uid,
      'exchanged_cards': [],
      'account': {
        'profiles': {
          'name': _nameController.text,
          'bio': {
            'value': _bioController.text,
            'display': {'extended': true, 'normal': true},
          },
          'company': {
            'value': _companyController.text,
            'display': {'extended': true, 'normal': true},
          },
          'position': {
            'value': _positionController.text,
            'display': {'extended': true, 'normal': true},
          },
          'address': {
            'value': _addressController.text,
            'display': {'extended': true, 'normal': true},
          },
        },
        'links': links,
      }
    }).then((value) {
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
          title: const Text('プロフィールを編集'),
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
                    Text('プロフィールを入力してください。'),
                    Text('ID（変更不可）: ${widget.cardId}'),
                    Text('表示名（必須）'),
                    TextFormField(
                      controller: _nameController,
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.isEmpty ? '必須' : null;
                      },
                    ),
                    Text('自己紹介'),
                    TextField(
                      controller: _bioController,
                      maxLength: 300,
                    ),
                    const Text('company'),
                    TextField(
                      controller: _companyController,
                      maxLength: 20,
                    ),
                    const Text('position'),
                    TextField(
                      controller: _positionController,
                      maxLength: 20,
                    ),
                    const Text('address'),
                    TextField(
                      controller: _addressController,
                      maxLength: 40,
                    ),
                    Text('リンクを任意で追加してください。'),
                    ReorderableMultiTextField(
                      controllerController: controller,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.add('url', '');
                      },
                      child: Text("追加"),
                    ),
                    // Image.network(data?['thumbnail']),
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
