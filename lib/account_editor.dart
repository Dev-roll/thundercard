import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'api/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'auth_gate.dart';
import 'constants.dart';

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
    Future _openAlertDialog1(BuildContext context, textFieldState) async {
      // (2) showDialogでダイアログを表示する
      var ret = await showDialog(
          context: context,
          // (3) AlertDialogを作成する
          builder: (context) => AlertDialog(
                title: Text("リンクの削除"),
                content: Text("リンクを削除しますか？"),
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
                      child: Text("OK")),
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
                  child: Icon(
                    linkTypeToIconData[entry],
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
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
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
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
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer),
                        controller: textFieldState.controller,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
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

class _AccountEditorState extends State<AccountEditor> {
  final String? uid = getUid();
  late final TextEditingController _nameController =
      TextEditingController(text: widget.data?['account']['profiles']['name']);
  late final TextEditingController _bioController = TextEditingController(
      text: widget.data?['account']['profiles']['bio']['value']);
  late final TextEditingController _companyController = TextEditingController(
      text: widget.data?['account']['profiles']['company']['value']);
  late final TextEditingController _positionController = TextEditingController(
      text: widget.data?['account']['profiles']['position']['value']);
  late final TextEditingController _addressController = TextEditingController(
      text: widget.data?['account']['profiles']['address']['value']);
  late DocumentReference card =
      FirebaseFirestore.instance.collection('cards').doc(widget.cardId);
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late ReorderableMultiTextFieldController controller;
  var updateButtonPressed = false;

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
      'content': '@${widget.cardId}さんのアカウント情報の更新が完了しました',
      'created_at': DateTime.now(),
      'read': false,
      'tags': ['news'],
      'notification_id':
          'account-update-${widget.cardId}-${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}',
    };

    FirebaseFirestore.instance
        .collection('cards')
        .doc(widget.cardId)
        .collection('notifications')
        .add(updateNotificationData);

    card.set({
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
    }, SetOptions(merge: true)).then((value) {
      Navigator.of(context).pop();
      print('Card Updated');
    }).catchError((error) => print('Failed to update card: $error'));
  }

  @override
  Widget build(BuildContext context) {
    () {
      var links = [];
      links = widget.data?['account']['links'];
      links.forEach((e) => controller.add(e['key'], e['value']));
    }();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィールを編集'),
          actions: [
            updateButtonPressed
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
                        updateButtonPressed = true;
                      });
                      updateCard();
                    },
                    onLongPress: null,
                    child: const Text('保存'),
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
                    if (widget.data?['is_user'])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ユーザーID'),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '@${widget.cardId}',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.7),
                                      fontSize: 20,
                                    ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 24,
                    ),
                    Text('表示名（必須）'),
                    TextFormField(
                      controller: _nameController,
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.isEmpty ? '必須' : null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_circle_rounded),
                        hintText: '表示名',
                      ),
                    ),
                    const Text('会社'),
                    TextField(
                      controller: _companyController,
                      maxLength: 20,
                      decoration: InputDecoration(
                        icon: Icon(iconTypeToIconData[IconType.company]),
                        hintText: '会社・大学等',
                      ),
                    ),
                    const Text('部門'),
                    TextField(
                      controller: _positionController,
                      maxLength: 20,
                      decoration: InputDecoration(
                        icon: Icon(iconTypeToIconData[IconType.position]),
                        hintText: '○○部',
                      ),
                    ),
                    const Text('住所'),
                    TextField(
                      controller: _addressController,
                      maxLength: 40,
                      decoration: InputDecoration(
                        icon: Icon(iconTypeToIconData[IconType.address]),
                        hintText: '住所',
                      ),
                    ),
                    Text('自己紹介'),
                    TextField(
                      controller: _bioController,
                      maxLength: 300,
                      decoration: InputDecoration(
                        icon: Icon(iconTypeToIconData[IconType.bio]),
                        hintText: '自己紹介',
                      ),
                      maxLines: 30,
                      minLines: 1,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text('SNS・連絡先'),
                    SizedBox(
                      height: 16,
                    ),
                    ReorderableMultiTextField(
                      controllerController: controller,
                    ),
                    SizedBox(
                      height: 16,
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
