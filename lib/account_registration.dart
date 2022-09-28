import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/auth_gate.dart';
import 'package:uuid/uuid.dart';
import 'api/firebase_auth.dart';

class AccountRegistration extends StatefulWidget {
  const AccountRegistration({Key? key}) : super(key: key);

  @override
  State<AccountRegistration> createState() => _AccountRegistrationState();
}

class TextFieldState {
  final String id;
  final TextEditingController controller;

  TextFieldState(this.id, this.controller);
}

class ReorderableMultiTextFieldController
    extends ValueNotifier<List<TextFieldState>> {
  ReorderableMultiTextFieldController(List<TextFieldState> value)
      : super(value);

  void add(text) {
    final state = TextFieldState(
      Uuid().v4(),
      TextEditingController(text: text),
    );

    value = [...value, state];
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
  final ReorderableMultiTextFieldController controller;
  ReorderableMultiTextField({
    Key? key,
    required this.controller,
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
      valueListenable: widget.controller,
      builder: (context, state, _) {
        String selectedKey = 'URL';

        final links = {
          'URL': 'url',
          'Twitter': 'twitter',
          'Instagram': 'instagram',
          'GitHub': 'github',
        };

        final linksDropdownMenuItem = links.entries
            .map((entry) => DropdownMenuItem(
                  child: Text(entry.key),
                  value: entry.value,
                ))
            .toList();

        return ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: state
              .map(
                (textFieldState) => Column(
                  key: ValueKey(textFieldState.id),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton(
                            items: linksDropdownMenuItem,
                            // value: selectedKey,
                            onChanged: (String? value) {
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
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.drag_indicator_rounded),
                              SizedBox(width: 12),
                              IconButton(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: () =>
                                    widget.controller.remove(textFieldState.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .toList(),
          onReorder: (oldIndex, newIndex) => widget.controller.reorder(
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

  @override
  void initState() {
    controller = ReorderableMultiTextFieldController([]);
    super.initState();
  }

  void registerCard() {
    // controller.forEach((value) {});
    final values = controller.value.map(((e) {
      return e.controller.text;
    })).toList();
    print(values);
    // users
    //     .doc(uid)
    //     .set({
    //       'my_cards': [_cardIdController.text]
    //     })
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));

    // final registerNotificationData = {
    //   'title': '登録完了のお知らせ',
    //   'content':
    //       '${_nameController.text}(@${_cardIdController.text})さんのアカウント登録が完了しました',
    //   'created_at': DateTime.now(),
    //   'read': false,
    //   'tags': ['news'],
    //   'id': 'account-added-${_cardIdController.text}',
    // };

    // FirebaseFirestore.instance
    //     .collection('cards')
    //     .doc(_cardIdController.text)
    //     .collection('notifications')
    //     .add(registerNotificationData);

    // cards.doc(_cardIdController.text).set({
    //   'name': _nameController.text,
    //   'is_user': true,
    //   'uid': uid,
    //   'exchanged_cards': [],
    // }).then((value) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => AuthGate()),
    //   );
    //   print('Card Registered');
    // }).catchError((error) => print('Failed to register card: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィールを登録'),
          actions: [
            TextButton(onPressed: registerCard, child: const Text('登録')),
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
                    Text('ID（必須）'),
                    TextFormField(
                      controller: _cardIdController,
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.isEmpty ? '必須' : null;
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
                      controller: controller,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.add("");
                      },
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
