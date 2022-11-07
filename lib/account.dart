// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:thundercard/api/current_brightness.dart';
// import 'package:thundercard/api/current_brightness_reverse.dart';
// import 'package:thundercard/api/firebase_firestore.dart';
// import 'package:thundercard/api/settings/display_card_theme.dart';
// import 'package:thundercard/constants.dart';
// import 'package:thundercard/link_auth.dart';
// import 'package:thundercard/main.dart';
// import 'package:thundercard/widgets/avatar.dart';
// import 'package:thundercard/widgets/custom_skeletons/skeleton_card_info.dart';
// import 'package:thundercard/widgets/dialog_util.dart';
// import 'package:thundercard/widgets/my_card.dart';
// import 'package:thundercard/widgets/normal_card.dart';
// import 'package:thundercard/widgets/preview_card.dart';

// import 'api/colors.dart';
// import 'api/firebase_auth.dart';
// import 'api/settings/app_theme.dart';
// import 'home_page.dart';
// import 'widgets/card_info.dart';
// import 'widgets/custom_progress_indicator.dart';
// import 'widgets/maintenance.dart';
// import 'auth_gate.dart';

// class Account extends ConsumerWidget {
//   Account({Key? key}) : super(key: key);
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         systemNavigationBarColor: alphaBlend(
//             Theme.of(context).colorScheme.primary.withOpacity(0.08),
//             Theme.of(context).colorScheme.surface),
//         statusBarIconBrightness:
//             currentBrightnessReverse(Theme.of(context).colorScheme),
//         statusBarBrightness: currentBrightness(Theme.of(context).colorScheme),
//         statusBarColor: Colors.transparent,
//       ),
//     );
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     final String? uid = getUid();
//     final appTheme = ref.watch(appThemeProvider);
//     final displayCardTheme = ref.watch(displayCardThemeProvider);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                   child: FutureBuilder<DocumentSnapshot>(
//                     future: users.doc(uid).get(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<DocumentSnapshot> snapshot) {
//                       Map<String, dynamic> user = {};
//                       if (snapshot.hasError) {
//                         return Text('問題が発生しました');
//                       }

//                       if (snapshot.hasData && !snapshot.data!.exists) {
//                         return Text('ユーザー情報の取得に失敗しました');
//                       }

//                       if (snapshot.connectionState == ConnectionState.done) {
//                         user = snapshot.data!.data() as Map<String, dynamic>;
//                         return CardInfo(
//                             cardId: user['my_cards'][0], editable: true);
//                       }

//                       return const SkeletonCardInfo();
//                     },
//                   ),
//                 ),
//                 Divider(
//                   height: 32,
//                   thickness: 1,
//                   indent: 16,
//                   endIndent: 16,
//                   color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Icon(
//                           //   Icons.settings_rounded,
//                           //   color: Theme.of(context)
//                           //       .colorScheme
//                           //       .onBackground
//                           //       .withOpacity(0.7),
//                           // ),
//                           // SizedBox(
//                           //   width: 8,
//                           // ),
//                           Text(
//                             '認証方法',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       // Container(
//                       //   padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
//                       //   child: Row(children: [
//                       //     Icon(
//                       //       Icons.lock_rounded,
//                       //       color:
//                       //           Theme.of(context).colorScheme.onSurfaceVariant,
//                       //     ),
//                       //     SizedBox(
//                       //       width: 8,
//                       //     ),
//                       //     Text(
//                       //       '（認証方法）',
//                       //       style: TextStyle(
//                       //         color: Theme.of(context)
//                       //             .colorScheme
//                       //             .onSurfaceVariant,
//                       //       ),
//                       //     ),
//                       //   ]),
//                       // ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
//                         alignment: Alignment.center,
//                         child: ElevatedButton.icon(
//                           icon: Icon(
//                             // Icons.add_link_rounded,
//                             Icons.add_circle_outline_rounded,
//                           ),
//                           // label: const Text('他の認証方法とリンク'),
//                           label: const Text('認証方法を追加'),
//                           style: ElevatedButton.styleFrom(
//                             elevation: 0,
//                             foregroundColor: Theme.of(context)
//                                 .colorScheme
//                                 .onSecondaryContainer,
//                             backgroundColor: Theme.of(context)
//                                 .colorScheme
//                                 .secondaryContainer,
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (context) => LinkAuth()),
//                             );
//                           },
//                           onLongPress: null,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(
//                   height: 32,
//                   thickness: 1,
//                   indent: 16,
//                   endIndent: 16,
//                   color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Icon(
//                           //   Icons.settings_rounded,
//                           //   color: Theme.of(context)
//                           //       .colorScheme
//                           //       .onBackground
//                           //       .withOpacity(0.7),
//                           // ),
//                           // SizedBox(
//                           //   width: 8,
//                           // ),
//                           Text(
//                             'アプリの設定',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () async {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (context) => HomePage(index: 3),
//                             ),
//                           );
//                           await DialogUtil.show(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 icon: [
//                                   Icon(Icons.brightness_medium_rounded),
//                                   Icon(Icons.brightness_low_rounded),
//                                   Icon(Icons.brightness_high_rounded),
//                                 ][appTheme.currentAppThemeIdx],
//                                 title: Text('アプリのテーマ'),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Divider(
//                                       height: 16,
//                                       thickness: 1,
//                                       indent: 0,
//                                       endIndent: 0,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .outline
//                                           .withOpacity(0.5),
//                                     ),
//                                     RadioListTile(
//                                       title: Text('自動切り替え'),
//                                       activeColor:
//                                           Theme.of(context).colorScheme.primary,
//                                       value: 0,
//                                       groupValue: appTheme.currentAppThemeIdx,
//                                       onChanged: (value) {
//                                         appTheme.change(value as int);
//                                       },
//                                     ),
//                                     RadioListTile(
//                                       title: Text('ダークモード'),
//                                       activeColor:
//                                           Theme.of(context).colorScheme.primary,
//                                       value: 1,
//                                       groupValue: appTheme.currentAppThemeIdx,
//                                       onChanged: (value) {
//                                         appTheme.change(value as int);
//                                       },
//                                     ),
//                                     RadioListTile(
//                                       title: Text('ライトモード'),
//                                       activeColor:
//                                           Theme.of(context).colorScheme.primary,
//                                       value: 2,
//                                       groupValue: appTheme.currentAppThemeIdx,
//                                       onChanged: (value) {
//                                         appTheme.change(value as int);
//                                       },
//                                     ),
//                                     Divider(
//                                       height: 16,
//                                       thickness: 1,
//                                       indent: 0,
//                                       endIndent: 0,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .outline
//                                           .withOpacity(0.5),
//                                     ),
//                                   ],
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       appTheme.change(appTheme.appThemeIdx);
//                                       Navigator.pop(context, false);
//                                     },
//                                     child: Text('キャンセル'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       appTheme.update();
//                                       Navigator.pop(context, false);
//                                     },
//                                     child: Text('決定'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
//                           child: Row(children: [
//                             [
//                               Icon(
//                                 Icons.brightness_medium_rounded,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                               Icon(
//                                 Icons.brightness_low_rounded,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                               Icon(
//                                 Icons.brightness_high_rounded,
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                             ][appTheme.currentAppThemeIdx],
//                             SizedBox(
//                               width: 8,
//                             ),
//                             Text(
//                               'アプリのテーマ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             Expanded(
//                               child: Container(
//                                 alignment: Alignment.centerRight,
//                                 child: [
//                                   Text(
//                                     '自動切り替え',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   ),
//                                   Text(
//                                     'ダークモード',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   ),
//                                   Text(
//                                     'ライトモード',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   )
//                                 ][appTheme.currentAppThemeIdx],
//                               ),
//                             )
//                           ]),
//                         ),
//                       ),
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () async {
//                           await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 icon: Icon(Icons.settings_brightness_rounded),
//                                 title: Text('カードのテーマ'),
//                                 scrollable: true,
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Divider(
//                                       height: 16,
//                                       thickness: 1,
//                                       indent: 0,
//                                       endIndent: 0,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .outline
//                                           .withOpacity(0.5),
//                                     ),
//                                     Text(
//                                       '現在のプレビュー',
//                                       style: TextStyle(
//                                         height: 1.6,
//                                         fontSize: 12,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurfaceVariant
//                                             .withOpacity(0.7),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.fromLTRB(16, 8, 16, 8),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Flexible(
//                                                 child: Container(
//                                                   padding: EdgeInsets.fromLTRB(
//                                                     0,
//                                                     0,
//                                                     4,
//                                                     0,
//                                                   ),
//                                                   child: FittedBox(
//                                                     child: MyCard(
//                                                       cardId: 'Light',
//                                                       cardType:
//                                                           CardType.preview,
//                                                       light: true,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: Container(
//                                                   padding: EdgeInsets.fromLTRB(
//                                                       4, 0, 0, 0),
//                                                   child: FittedBox(
//                                                     child: MyCard(
//                                                       cardId: 'Dark',
//                                                       cardType:
//                                                           CardType.preview,
//                                                       light: false,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Divider(
//                                       height: 16,
//                                       thickness: 1,
//                                       indent: 0,
//                                       endIndent: 0,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .outline
//                                           .withOpacity(0.5),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                       child: RadioListTile(
//                                         title: Text('オリジナル'),
//                                         subtitle: Text(
//                                           'カードのテーマを変更せずに表示',
//                                           style: TextStyle(
//                                             height: 1.6,
//                                             fontSize: 12,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurfaceVariant
//                                                 .withOpacity(0.7),
//                                           ),
//                                         ),
//                                         activeColor: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                         value: 0,
//                                         groupValue: displayCardTheme
//                                             .currentDisplayCardThemeIdx,
//                                         onChanged: (value) {
//                                           displayCardTheme.update(value as int);
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                       child: RadioListTile(
//                                         title: Text('自動切り替え'),
//                                         subtitle: Text(
//                                           'アプリと同じテーマでカードを表示',
//                                           style: TextStyle(
//                                             height: 1.6,
//                                             fontSize: 12,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurfaceVariant
//                                                 .withOpacity(0.7),
//                                           ),
//                                         ),
//                                         activeColor: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                         value: 1,
//                                         groupValue: displayCardTheme
//                                             .currentDisplayCardThemeIdx,
//                                         onChanged: (value) {
//                                           displayCardTheme.update(value as int);
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                       child: RadioListTile(
//                                         title: Text('ダークモード'),
//                                         subtitle: Text(
//                                           'カードをダークモードで表示',
//                                           style: TextStyle(
//                                             height: 1.6,
//                                             fontSize: 12,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurfaceVariant
//                                                 .withOpacity(0.7),
//                                           ),
//                                         ),
//                                         activeColor: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                         value: 2,
//                                         groupValue: displayCardTheme
//                                             .currentDisplayCardThemeIdx,
//                                         onChanged: (value) {
//                                           displayCardTheme.update(value as int);
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                       child: RadioListTile(
//                                         title: Text('ライトモード'),
//                                         subtitle: Text(
//                                           'カードをライトモードで表示',
//                                           style: TextStyle(
//                                             height: 1.6,
//                                             fontSize: 12,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurfaceVariant
//                                                 .withOpacity(0.7),
//                                           ),
//                                         ),
//                                         activeColor: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                         value: 3,
//                                         groupValue: displayCardTheme
//                                             .currentDisplayCardThemeIdx,
//                                         onChanged: (value) {
//                                           displayCardTheme.update(value as int);
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ),
//                                     Divider(
//                                       height: 16,
//                                       thickness: 1,
//                                       indent: 0,
//                                       endIndent: 0,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .outline
//                                           .withOpacity(0.5),
//                                     ),
//                                   ],
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context, false);
//                                     },
//                                     child: Text('キャンセル'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
//                           child: Row(children: [
//                             Icon(
//                               Icons.settings_brightness_rounded,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurfaceVariant,
//                             ),
//                             SizedBox(
//                               width: 8,
//                             ),
//                             Text(
//                               'カードのテーマ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             Expanded(
//                               child: Container(
//                                 alignment: Alignment.centerRight,
//                                 child: [
//                                   Text(
//                                     'オリジナル',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   ),
//                                   Text(
//                                     '自動切り替え',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   ),
//                                   Text(
//                                     'ダークモード',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   ),
//                                   Text(
//                                     'ライトモード',
//                                     softWrap: false,
//                                     overflow: TextOverflow.fade,
//                                   )
//                                 ][displayCardTheme.currentDisplayCardThemeIdx],
//                               ),
//                             )
//                           ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(
//                   height: 32,
//                   thickness: 1,
//                   indent: 16,
//                   endIndent: 16,
//                   color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
//                 ),
//                 SizedBox(
//                   height: 28,
//                 ),
//                 ElevatedButton.icon(
//                   icon: Icon(
//                     Icons.logout_rounded,
//                   ),
//                   label: const Text('サインアウト'),
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0,
//                     foregroundColor: Theme.of(context).colorScheme.secondary,
//                     backgroundColor: Theme.of(context)
//                         .colorScheme
//                         .onSecondary
//                         .withOpacity(1),
//                   ),
//                   onPressed: () async {
//                     await showDialog(
//                         context: context,
//                         // (3) AlertDialogを作成する
//                         builder: (context) => AlertDialog(
//                               icon: Icon(Icons.logout_rounded),
//                               title: Text('サインアウト'),
//                               content: Text(
//                                 'このアカウントからサインアウトしますか？',
//                                 style: TextStyle(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurfaceVariant,
//                                 ),
//                               ),
//                               // (4) ボタンを設定
//                               actions: [
//                                 TextButton(
//                                     onPressed: () => {
//                                           //  (5) ダイアログを閉じる
//                                           Navigator.pop(context, false)
//                                         },
//                                     onLongPress: null,
//                                     child: Text('キャンセル')),
//                                 TextButton(
//                                     onPressed: () async {
//                                       Navigator.pop(context, true);
//                                       await FirebaseAuth.instance.signOut();
//                                       Navigator.of(context).pushAndRemoveUntil(
//                                         MaterialPageRoute(
//                                           builder: (context) => AuthGate(),
//                                         ),
//                                         (_) => false,
//                                       );
//                                     },
//                                     onLongPress: null,
//                                     child: Text('サインアウト')),
//                               ],
//                             ));
//                   },
//                   onLongPress: null,
//                 ),
//                 // メンテナンス
//                 SizedBox(height: 28),
//                 OutlinedButton(
//                   onPressed: maintenance,
//                   onLongPress: null,
//                   child: Text('管理者用'),
//                 ),
//                 SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
