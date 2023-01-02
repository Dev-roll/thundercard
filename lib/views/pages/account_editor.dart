import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../providers/firebase_firestore.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/current_brightness.dart';
import '../../utils/firebase_auth.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/error_message.dart';

class AccountEditor extends ConsumerStatefulWidget {
  const AccountEditor({Key? key, required this.cardId}) : super(key: key);
  final dynamic cardId;

  @override
  ConsumerState<AccountEditor> createState() => _AccountEditorState();
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

  void clear() {
    value = [];
  }

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

class ReorderableMultiTextField extends ConsumerStatefulWidget {
  final ReorderableMultiTextFieldController controllerController;
  const ReorderableMultiTextField({
    Key? key,
    required this.controllerController,
  }) : super(key: key);

  @override
  ConsumerState<ReorderableMultiTextField> createState() =>
      _ReorderableMultiTextFieldState();
}

class Links {
  Links(this.key, this.value);

  String key;
  int value;
}

class _ReorderableMultiTextFieldState
    extends ConsumerState<ReorderableMultiTextField> {
  @override
  Widget build(BuildContext context) {
    Future openAlertDialog1(BuildContext context, textFieldState) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.delete_rounded),
          title: const Text('リンクの削除'),
          content: Text(
            'このリンクを削除しますか？',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.controllerController.remove(textFieldState.id);
              },
              child: const Text('OK'),
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
                  child: Icon(
                    linkTypeToIconData[entry],
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
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

class _AccountEditorState extends ConsumerState<AccountEditor> {
  final String? uid = getUid();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _addressController;

  CollectionReference version2 = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards');
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
          'large': true,
          'normal': true,
        },
      });
    }
    debugPrint('$links');

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
        .collection('version')
        .doc('2')
        .collection('cards')
        .doc(widget.cardId)
        .collection('visibility')
        .doc('c10r10u10d10')
        .collection('notifications')
        .add(updateNotificationData);

    // users
    //     .doc(uid)
    //     .collection('card')
    //     .doc('current_card')
    //     .update({'current_card': widget.cardId}).then((value) {
    //   debugPrint('User Added');
    // }).catchError((error) {
    //   debugPrint('Failed to add user: $error');
    // });

    // c10r10u10d10
    // version2
    //     .doc(widget.cardId)
    //     .collection('visibility')
    //     .doc('c10r10u10d10')
    //     .set({
    //   'settings': {'linkable': false, 'app_theme': 0, 'display_card_theme': 0},
    //   'applying_cards': [],
    // }, SetOptions(merge: true)).then((value) {
    //   Navigator.of(context).pop();
    //   debugPrint('Card Updated');
    // }).catchError((error) {
    //   debugPrint('Failed to update card: $error');
    // });

    // c10r10u21d10
    // version2
    //     .doc(widget.cardId)
    //     .collection('visibility')
    //     .doc('c10r10u21d10')
    //     .set({
    //   'verified_cards': [],
    // }, SetOptions(merge: true)).then((value) {
    //   Navigator.of(context).pop();
    //   debugPrint('Card Updated');
    // }).catchError((error) {
    //   debugPrint('Failed to update card: $error');
    // });

    // c10r10u11d10
    // version2
    //     .doc(widget.cardId)
    //     .collection('visibility')
    //     .doc('c10r10u11d10')
    //     .set({
    //   'exchanged_cards': [],
    // }, SetOptions(merge: true)).then((value) {
    //   Navigator.of(context).pop();
    //   debugPrint('Card Updated');
    // }).catchError((error) {
    //   debugPrint('Failed to update card: $error');
    // });

    // c10r20u10d10
    version2
        .doc(widget.cardId)
        .collection('visibility')
        .doc('c10r20u10d10')
        .set({
      'name': _nameController.text,
      // 'public': false,
      // 'icon_url': '',
      'thundercard': {
        // 'color': {
        //   'seed': 0,
        //   'tertiary': 0,
        // },
        'light_theme': currentBrightness(Theme.of(context).colorScheme) ==
            Brightness.light,
        // 'rounded': true,
        // 'radius': 3,
        // 'layout': 0,
        // 'font_size': {
        //   'title': 3,
        //   'id': 1.5,
        //   'bio': 1.3,
        //   'profiles': 1,
        //   'links': 1,
        // }
      },
    }, SetOptions(merge: true)).then((value) {
      debugPrint('Card Updated (1/2)');
    }).catchError((error) {
      debugPrint('Failed to update card: $error');
    });

    // c10r21u10d10
    version2
        .doc(widget.cardId)
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
    }, SetOptions(merge: true)).then((value) {
      debugPrint('Card Updated (2/2)');
    }).catchError((error) {
      debugPrint('Failed to update card: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final c10r21u10d10AsyncValue = ref.watch(c10r21u10d10Stream(widget.cardId));
    return c10r21u10d10AsyncValue.when(
      error: (err, _) => ErrorMessage(err: '$err'),
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(
            child: CustomProgressIndicator(),
          ),
        ),
      ),
      data: (c10r21u10d10) {
        final c10r20u10d10AsyncValue =
            ref.watch(c10r20u10d10Stream(widget.cardId));
        return c10r20u10d10AsyncValue.when(
          error: (err, _) => ErrorMessage(err: '$err'),
          loading: () => const Scaffold(
            body: SafeArea(
              child: Center(
                child: CustomProgressIndicator(),
              ),
            ),
          ),
          data: (c10r20u10d10) {
            final c21r20u00d11AsyncValue =
                ref.watch(c21r20u00d11Stream(widget.cardId));
            return c21r20u00d11AsyncValue.when(
              error: (err, _) => ErrorMessage(err: '$err'),
              loading: () => const Scaffold(
                body: SafeArea(
                  child: Center(
                    child: CustomProgressIndicator(),
                  ),
                ),
              ),
              data: (c21r20u00d11) {
                final initName =
                    TextEditingController(text: c10r20u10d10?['name'] ?? '');
                final initBio = TextEditingController(
                    text: c10r21u10d10?['profiles']['bio']['value'] ?? '');
                final initCompany = TextEditingController(
                    text: c10r21u10d10?['profiles']['company']['value'] ?? '');
                final initPosition = TextEditingController(
                    text: c10r21u10d10?['profiles']['position']['value'] ?? '');
                final initAddress = TextEditingController(
                    text: c10r21u10d10?['profiles']['address']['value'] ?? '');

                _nameController = initName;
                _bioController = initBio;
                _companyController = initCompany;
                _positionController = initPosition;
                _addressController = initAddress;

                var links = [];
                links = c10r21u10d10?['account']['links'];
                controller.clear();
                for (var e in links) {
                  controller.add(e['key'], e['value']);
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('プロフィールを編集'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (_nameController.text == '') {
                              null;
                            } else {
                              Navigator.of(context).pop();
                              updateCard();
                            }
                          },
                          onLongPress: null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(width: 8),
                              Icon(Icons.done_rounded),
                              SizedBox(width: 4),
                              Text('保存'),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                        // : updateButtonPressed
                        //     ? TextButton(
                        //         onPressed: null,
                        //         onLongPress: null,
                        //         child: Container(
                        //           padding: const EdgeInsets.all(4),
                        //           child: const SizedBox(
                        //             height: 24,
                        //             width: 24,
                        //             child: CircularProgressIndicator(
                        //               strokeWidth: 3.0,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : TextButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             updateButtonPressed = true;
                        //           });
                        //           updateCard();
                        //         },
                        //         onLongPress: null,
                        //         child: const Text('保存'),
                        //       ),
                      ],
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    body: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          controller: scrollController,
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
                                    if (c21r20u00d11?['is_user'])
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('ユーザーID'),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '@${widget.cardId}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.7),
                                                  fontSize: 20,
                                                ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const Text('表示名（必須）'),
                                    TextFormField(
                                      controller: _nameController,
                                      maxLength: 20,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return value!.isEmpty ? '必須' : null;
                                      },
                                      decoration: InputDecoration(
                                        icon: const Icon(
                                            Icons.account_circle_rounded),
                                        hintText: '表示名',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    const Text('組織'),
                                    TextField(
                                      controller: _companyController,
                                      maxLength: 20,
                                      decoration: InputDecoration(
                                        icon: Icon(iconTypeToIconData[
                                            IconType.company]),
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
                                      decoration: InputDecoration(
                                        icon: Icon(iconTypeToIconData[
                                            IconType.position]),
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
                                      decoration: InputDecoration(
                                        icon: Icon(iconTypeToIconData[
                                            IconType.address]),
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
                                      decoration: InputDecoration(
                                        icon: Icon(
                                            iconTypeToIconData[IconType.bio]),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            controller.add('url', '');
                                            Future.delayed(
                                              const Duration(milliseconds: 20),
                                            ).then((value) {
                                              scrollController.animateTo(
                                                scrollController
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeIn,
                                              );
                                            });
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
              },
            );
          },
        );
      },
    );
  }
}