import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/api/colors.dart';
import 'package:uuid/uuid.dart';
import 'api/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'auth_gate.dart';
import 'constants.dart';

class AccountRegistration extends StatefulWidget {
  const AccountRegistration({Key? key}) : super(key: key);

  @override
  State<AccountRegistration> createState() => _AccountRegistrationState();
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
    Future _openAlertDialog1(BuildContext context, textFieldState) async {
      // (2) showDialogでダイアログを表示する
      var ret = await showDialog(
          context: context,
          // (3) AlertDialogを作成する
          builder: (context) => AlertDialog(
                icon: Icon(Icons.delete_rounded),
                title: Text("リンクの削除"),
                content: Text(
                  "このリンクを削除しますか？",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                // (4) ボタンを設定
                actions: [
                  TextButton(
                      onPressed: () => {
                            //  (5) ダイアログを閉じる
                            Navigator.pop(context, false)
                          },
                      onLongPress: null,
                      child: Text("キャンセル")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        widget.controllerController.remove(textFieldState.id);
                      },
                      onLongPress: null,
                      child: Text("削除")),
                ],
              ));
    }

    return ValueListenableBuilder<List<TextFieldState>>(
      valueListenable: widget.controllerController,
      builder: (context, state, _) {
        var links = linkTypes;

        final linksDropdownMenuItem = links
            .map((entry) => DropdownMenuItem(
                  value: entry,
                  child: Row(children: [
                    const SizedBox(
                      width: 4,
                    ),
                    Icon(linkTypeToIconData[entry])
                  ]),
                ))
            .toList();

        return ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: state.map(
            (textFieldState) {
              dynamic selectedKey = textFieldState.selector;
              return Container(
                key: ValueKey(textFieldState.id),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ),
                margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.drag_indicator_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.4),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    DropdownButton(
                      items: linksDropdownMenuItem,
                      value: selectedKey,
                      underline: const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      dropdownColor: alphaBlend(
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        Theme.of(context).colorScheme.surface,
                      ),
                      focusColor: alphaBlend(
                        Theme.of(context).colorScheme.primary.withOpacity(0.12),
                        Theme.of(context).colorScheme.surface,
                      ),
                      onChanged: (value) {
                        widget.controllerController
                            .setKey(textFieldState.id, value);
                        setState(() {
                          selectedKey = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: textFieldState.controller,
                        decoration:
                            const InputDecoration.collapsed(hintText: ""),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: IconButton(
                        icon: const Icon(Icons.delete_rounded),
                        onPressed: () {
                          _openAlertDialog1(context, textFieldState);
                        },
                      ),
                    ),
                  ],
                ),
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

class _AccountRegistrationState extends State<AccountRegistration> {
  final String? uid = getUid();
  final TextEditingController _cardIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late ReorderableMultiTextFieldController controller;
  var registrationButtonPressed = false;

  @override
  void initState() {
    controller = ReorderableMultiTextFieldController([]);
    super.initState();
  }

  void registerCard() {
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

    users
        .doc(uid)
        .set({
          'my_cards': [_cardIdController.text]
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    final registerNotificationData = {
      'title': '登録完了のお知らせ',
      'content':
          '${_nameController.text}(@${_cardIdController.text})さんのアカウント登録が完了しました',
      'created_at': DateTime.now(),
      'read': false,
      'tags': ['news'],
      'notification_id':
          'account-registration-${_cardIdController.text}-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
    };

    FirebaseFirestore.instance
        .collection('cards')
        .doc(_cardIdController.text)
        .collection('notifications')
        .add(registerNotificationData);

    cards.doc(_cardIdController.text).set({
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
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
      print('Card Registered');
    }).catchError((error) => print('名刺の登録に失敗しました: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィールを登録'),
          actions: [
            _cardIdController.text == '' || _nameController.text == ''
                ? TextButton(
                    onPressed: null,
                    onLongPress: null,
                    child: const Text('登録'),
                  )
                : registrationButtonPressed
                    ? TextButton(
                        onPressed: null,
                        onLongPress: null,
                        child: Container(
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                            height: 24,
                            width: 24,
                          ),
                          padding: EdgeInsets.all(4),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            registrationButtonPressed = true;
                          });
                          registerCard();
                        },
                        onLongPress: null,
                        child: const Text('登録'),
                      ),
          ],
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ユーザーID（必須）'),
                    TextFormField(
                      controller: _cardIdController,
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.isEmpty ? '必須' : null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Text('表示名（必須）'),
                    TextFormField(
                      controller: _nameController,
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.isEmpty ? '必須' : null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Text('自己紹介'),
                    TextField(
                      controller: _bioController,
                      maxLength: 300,
                    ),
                    const Text('会社'),
                    TextField(
                      controller: _companyController,
                      maxLength: 20,
                    ),
                    const Text('部門'),
                    TextField(
                      controller: _positionController,
                      maxLength: 20,
                    ),
                    const Text('住所'),
                    TextField(
                      controller: _addressController,
                      maxLength: 40,
                    ),
                    Text('SNS・連絡先'),
                    ReorderableMultiTextField(
                      controllerController: controller,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.add('url', '');
                      },
                      onLongPress: null,
                      child: Text("追加"),
                    ),
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
