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
      const Uuid().v4(),
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
      throw 'Textがありません';
    }

    value = value.where((element) => element.id != id).toList();

    Future.delayed(const Duration(seconds: 1)).then(
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
    for (var element in value) {
      element.controller.dispose();
    }
    super.dispose();
  }
}

class ReorderableMultiTextField extends StatefulWidget {
  final ReorderableMultiTextFieldController controllerController;
  const ReorderableMultiTextField({
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
    Future openAlertDialog1(BuildContext context, textFieldState) async {
      // (2) showDialogでダイアログを表示する
      await showDialog(
        context: context,
        // (3) AlertDialogを作成する
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.delete_rounded),
          title: const Text('リンクの削除'),
          content: Text(
            'このリンクを削除しますか？',
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
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                widget.controllerController.remove(textFieldState.id);
              },
              onLongPress: null,
              child: const Text('削除'),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<List<TextFieldState>>(
      valueListenable: widget.controllerController,
      builder: (context, state, _) {
        var links = linkTypes;

        final linksDropdownMenuItem = links
            .map((entry) => DropdownMenuItem(
                  value: entry,
                  alignment: AlignmentDirectional.center,
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
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
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
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                        controller: textFieldState.controller,
                        cursorHeight: 20,
                        decoration: const InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                          ),
                        ),
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
                          openAlertDialog1(context, textFieldState);
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
  CollectionReference version2 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late ReorderableMultiTextFieldController controller;
  var registrationButtonPressed = false;
  var forbiddenId = '';

  @override
  void initState() {
    controller = ReorderableMultiTextFieldController([]);
    super.initState();
  }

  registerCard() {
    FirebaseFirestore.instance
        .collection('cards')
        .where('card_id', isEqualTo: _cardIdController.text)
        .get()
        .then((snapshot) {
      final data = snapshot.docs;
      debugPrint('$data');
      if (data.isNotEmpty) {
        debugPrint(data[0]['card_id']);
        setState(() {
          registrationButtonPressed = false;
        });
        forbiddenId = _cardIdController.text;
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 20,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            behavior: SnackBarBehavior.floating,
            clipBehavior: Clip.antiAlias,
            dismissDirection: DismissDirection.horizontal,
            margin: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 24,
            ),
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Icon(
                    Icons.error_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                Expanded(
                  child: Text(
                    'ユーザーIDはすでに存在しています。別のIDを入力してください。',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        overflow: TextOverflow.fade),
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
      } else {
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
              'large': true,
              'normal': true,
            },
          });
        }
        debugPrint('$links');

        // users
        users.doc(uid).collection('cards').doc('my_cards').set({
          'my_cards': [_cardIdController.text]
        }).then((value) {
          debugPrint('User Added');
        }).catchError((error) {
          debugPrint('Failed to add user: $error');
        });

        users
            .doc(uid)
            .collection('card')
            .doc('current_card')
            .set({'current_card': _cardIdController.text}).then((value) {
          debugPrint('User Added');
        }).catchError((error) {
          debugPrint('Failed to add user: $error');
        });

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

        // notifications
        FirebaseFirestore.instance
            .collection('version')
            .doc('2')
            .collection('cards')
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c10r10u10d10')
            .collection('notifications')
            .add(registerNotificationData);

        // c10r10u10d10
        version2
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c10r10u10d10')
            .set({
          'settings': {
            'linkable': false,
            'app_theme': 0,
            'display_card_theme': 0
          },
          'applying_cards': [],
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
          debugPrint('c10r10u10d10: Registered');
        }).catchError((error) {
          debugPrint('カードの登録に失敗しました: $error');
        });

        // c10r10u21d10
        version2
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c10r10u21d10')
            .set({
          'verified_cards': [],
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
          debugPrint('c10r10u21d10: Registered');
        }).catchError((error) {
          debugPrint('カードの登録に失敗しました: $error');
        });

        // c10r10u11d10
        version2
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c10r10u11d10')
            .set({
          'exchanged_cards': [],
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
          debugPrint('c10r10u11d10: Registered');
        }).catchError((error) {
          debugPrint('カードの登録に失敗しました: $error');
        });

        // c10r20u10d10
        version2
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c10r20u10d10')
            .set({
          'name': _nameController.text,
          'public': false,
          'icon_url': '',
          'thundercard': {
            'color': {
              'seed': 0,
              'tertiary': 0,
            },
            'light_theme': true,
            'rounded': true,
            'layout': 0,
            'font_size': {
              'title': 3,
              'id': 1.5,
              'bio': 1.3,
              'profiles': 1,
              'links': 1,
            }
          },
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
          debugPrint('c10r20u10d10: Registered');
        }).catchError((error) {
          debugPrint('カードの登録に失敗しました: $error');
        });

        // c10r21u10d10
        version2
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c10r21u10d10')
            .set({
          'account': {
            'links': links,
          },
          'profiles': {
            'bio': {
              'value': _bioController.text,
              'display': {
                'normal': true,
                'large': true,
              }
            },
            'company': {
              'value': _companyController.text,
              'display': {
                'normal': true,
                'large': true,
              }
            },
            'position': {
              'value': _positionController.text,
              'display': {
                'normal': true,
                'large': true,
              }
            },
            'address': {
              'value': _addressController.text,
              'display': {
                'normal': true,
                'large': true,
              }
            },
          }
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
          debugPrint('c10r21u10d10: Registered');
        }).catchError((error) {
          debugPrint('カードの登録に失敗しました: $error');
        });

        // c11r20u00d11
        version2
            .doc(_cardIdController.text)
            .collection('visibility')
            .doc('c11r20u00d11')
            .set({
          'is_user': true,
          'uid': uid,
          'card_id': _cardIdController.text,
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthGate()),
          );
          debugPrint('c11r20u00d11: Registered');
        }).catchError((error) {
          debugPrint('カードの登録に失敗しました: $error');
        });
      }
    });
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
                ? const TextButton(
                    onPressed: null,
                    onLongPress: null,
                    child: Text('登録'),
                  )
                : registrationButtonPressed
                    ? TextButton(
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
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('ユーザーID（必須）'),
                        TextFormField(
                          controller: _cardIdController,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 20,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value!.isEmpty
                                ? '必須'
                                : value == forbiddenId
                                    ? '@$forbiddenId はすでに存在しています'
                                    : null;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.alternate_email_rounded),
                            hintText: 'userid',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const Text('表示名（必須）'),
                        TextFormField(
                          controller: _nameController,
                          maxLength: 20,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value!.isEmpty ? '必須' : null;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.account_circle_rounded),
                            hintText: '表示名',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const Text('会社'),
                        TextField(
                          controller: _companyController,
                          maxLength: 20,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(iconTypeToIconData[IconType.company]),
                            hintText: '会社・大学等',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                        const Text('部門'),
                        TextField(
                          controller: _positionController,
                          maxLength: 20,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(iconTypeToIconData[IconType.position]),
                            hintText: '○○部',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                        const Text('住所'),
                        TextField(
                          controller: _addressController,
                          maxLength: 40,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            icon: Icon(iconTypeToIconData[IconType.address]),
                            hintText: '住所',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                        const Text('自己紹介'),
                        TextField(
                          controller: _bioController,
                          maxLength: 300,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            icon: Icon(iconTypeToIconData[IconType.bio]),
                            hintText: '自己紹介',
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          maxLines: 30,
                          minLines: 1,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text('SNS・連絡先'),
                        const SizedBox(
                          height: 16,
                        ),
                        ReorderableMultiTextField(
                          controllerController: controller,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.add('url', '');
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              icon: const Icon(
                                Icons.add_link_rounded,
                              ),
                              label: const Text(
                                'SNS・連絡先を追加',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
