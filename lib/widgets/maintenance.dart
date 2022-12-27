// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:thundercard/api/firebase_auth.dart';

maintenance() {
  // const currentCardId = 'user';
  // const currentDocId = null;

  const cardIds = [
    // 'cardseditor',
    // 'example',
    // 'fuga',
    // 'keigomichi',
    // 'user'
    'hogehoge',

    // 'eymupktcco'
    // 'raSZmUODKP1h6LfSIvVq'
  ];

  for (var currentCardId in cardIds) {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(currentCardId)
        .get()
        .then((element) {
      final data = element.data();
      final isUser = data?['is_user'];
      final public = data?['public'];
      final uid = data?['uid'];
      final exchangedCards = data?['exchanged_cards'];
      final account = data?['account'];
      final rooms = data?['rooms'];

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((element2) {
        final data2 = element2.data();
        final myCards = data2?['my_cards'];

        if (isUser) {
          // update
          // users
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('card')
              .doc('current_card')
              .set({'current_card': currentCardId},
                  SetOptions(merge: true)).then((_) {
            debugPrint('current_card: completed');
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('cards')
              .doc('my_cards')
              .set({'my_cards': myCards}, SetOptions(merge: true)).then((_) {
            debugPrint('my_cards: completed');
          });

          // update
          // notifications
          FirebaseFirestore.instance
              .collection('cards')
              .doc(currentCardId)
              .collection('notifications')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var element in querySnapshot.docs) {
              var notificationData = {
                'title': element['title'],
                'content': element['content'],
                'created_at': element['created_at'],
                'notification_id': element['notification_id'],
                'read': element['read'],
                'tags': element['tags'],
              };
              debugPrint('$notificationData');
              FirebaseFirestore.instance
                  .collection('version')
                  .doc('2')
                  .collection('cards')
                  .doc(currentCardId)
                  .collection('visibility')
                  .doc('c10r10u10d10')
                  .collection('notifications')
                  .doc(element.id)
                  .set(notificationData, SetOptions(merge: true))
                  .then((element) {
                debugPrint('notification-writing: completed');
              });
            }
            debugPrint('notification: completed');
            // (querySnapshot.docs.map((element) {
            //   element.id;
            // }).toList());
          });

          // update
          // c10r10u10d10
          final c10r10u10d10 = {
            'settings': {
              'linkable': false,
              'app_theme': 0,
              'display_card_theme': 0,
            },
            'applying_catds': [],
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r10u10d10')
              .set(c10r10u10d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r10u10d10: completed');
          });

          // update
          // c10r10u21d10
          final c10r10u21d10 = {
            'verified_cards': [],
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r10u21d10')
              .set(c10r10u21d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r10u21d10: completed');
          });

          // update
          // c10r10u11d10
          final c10r10u11d10 = {
            'exchanged_cards': exchangedCards,
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r10u11d10')
              .set(c10r10u11d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r10u11d10: completed');
          });

          // update
          // c10r20u10d10
          final c10r20u10d10 = {
            'public': public,
            'icon_url': '',
            'name': account['profiles']['name'],
            'thundercard': {
              'color': {
                'seed': '',
                'tertiary': '',
              },
              'light_theme': true,
              'layout': 0,
              'font_size': {
                'title': 3,
                'id': 1.5,
                'bio': 1.3,
                'profiles': 1,
                'links': 1,
              }
            }
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r20u10d10')
              .set(c10r20u10d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r20u10d10: completed');
          });

          // update
          // c10r21u10d10
          final c10r21u10d10 = {
            'account': {
              'links': account['links'],
              // 'links': account['profiles']['links'],
            },
            'profiles': {
              'address': {
                'value': account['profiles']['address']['value'],
                'display': {
                  'normal': true,
                  'extended': true,
                }
              },
              'bio': {
                'value': account['profiles']['bio']['value'],
                'display': {
                  'normal': true,
                  'extended': true,
                }
              },
              'company': {
                'value': account['profiles']['company']['value'],
                'display': {
                  'normal': true,
                  'extended': true,
                }
              },
              'position': {
                'value': account['profiles']['position']['value'],
                'display': {
                  'normal': true,
                  'extended': true,
                }
              },
            }
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r21u10d10')
              .set(c10r21u10d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r21u10d10: completed');
          });

          // update
          // c10r21u21d10
          final c10r21u21d10 = {
            'rooms': rooms,
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r21u21d10')
              .set(c10r21u21d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r21u21d10: completed');
          });

          // update
          // c21r20u00d11
          final c21r20u00d11 = {
            'is_user': isUser,
            'uid': uid,
            'card_id': currentCardId,
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c21r20u00d11')
              .set(c21r20u00d11, SetOptions(merge: true))
              .then((element) {
            debugPrint('c21r20u00d11: completed');
          });
        } else {
          final cardUrl = data?['thumbnail'];
          // update
          // users
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('card')
              .doc('current_card')
              .set({'current_card': currentCardId},
                  SetOptions(merge: true)).then((_) {
            debugPrint('current_card: completed');
          });

          // // update
          // // c10r10u10d10
          // final c10r10u10d10 = {
          //   'settings': {
          //     'linkable': false,
          //     'app_theme': 0,
          //     'display_card_theme': 0,
          //   },
          //   'applying_catds': [],
          // };

          // FirebaseFirestore.instance
          //     .collection('version')
          //     .doc('2')
          //     .collection('cards')
          //     .doc(currentCardId)
          //     .collection('visibility')
          //     .doc('c10r10u10d10')
          //     .set(c10r10u10d10, SetOptions(merge: true))
          //     .then((element) {
          //   debugPrint('c10r10u10d10: completed');
          // });

          // // update
          // // c10r10u21d10
          // final c10r10u21d10 = {
          //   'verified_cards': [],
          // };

          // FirebaseFirestore.instance
          //     .collection('version')
          //     .doc('2')
          //     .collection('cards')
          //     .doc(currentCardId)
          //     .collection('visibility')
          //     .doc('c10r10u21d10')
          //     .set(c10r10u21d10, SetOptions(merge: true))
          //     .then((element) {
          //   debugPrint('c10r10u21d10: completed');
          // });

          // update
          // c10r10u11d10
          final c10r10u11d10 = {
            'exchanged_cards': exchangedCards,
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r10u11d10')
              .set(c10r10u11d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r10u11d10: completed');
          });

          // update
          // c10r20u10d10
          final c10r20u10d10 = {
            'public': public,
            'icon_url': '',
            'name': account['profiles']['name'],
            'thundercard': {
              'color': {
                'seed': '',
                'tertiary': '',
              },
              'light_theme': true,
              'layout': 0,
              'font_size': {
                'title': 3,
                'id': 1.5,
                'bio': 1.3,
                'profiles': 1,
                'links': 1,
              }
            }
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r20u10d10')
              .set(c10r20u10d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r20u10d10: completed');
          });

          // update
          // c10r21u10d10
          final c10r21u10d10 = {
            'account': {
              'links': account['profiles']['links'],
            },
            'profiles': {
              'bio': account['profiles']['bio'],
              'company': account['profiles']['company'],
              'position': account['profiles']['position'],
              'address': account['profiles']['address'],
            }
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r21u10d10')
              .set(c10r21u10d10, SetOptions(merge: true))
              .then((element) {
            debugPrint('c10r21u10d10: completed');
          });

          // update
          // c21r20u00d11
          final c21r20u00d11 = {
            'is_user': isUser,
            'uid': uid,
            'card_id': currentCardId,
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c21r20u00d11')
              .set(c21r20u00d11, SetOptions(merge: true))
              .then((element) {
            debugPrint('c21r20u00d11: completed');
          });

          // update
          // c20r11u11d11
          final c20r11u11d11 = {
            'card_url': cardUrl,
          };

          FirebaseFirestore.instance
              .collection('version')
              .doc('2')
              .collection('cards')
              .doc(currentCardId)
              .collection('visibility')
              .doc('c20r11u11d11')
              .set(c20r11u11d11, SetOptions(merge: true))
              .then((element) {
            debugPrint('c20r11u11d11: completed');
          });
        }
      });
    });
  }
}

      // final account = {
      //   'account': {
      //     'profiles': {
      //       'name': '',
      //       'bio': {
      //         'value': '',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //       'company': {
      //         'value': '',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //       'position': {
      //         'value': '',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //       'address': {
      //         'value': '',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //     },
      //     'links': [
      //       {
      //         'key': 'email',
      //         'value': 'example@example.com',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //       {
      //         'key': 'github',
      //         'value': 'example',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //       {
      //         'key': 'twitter',
      //         'value': 'example',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //       {
      //         'key': 'url',
      //         'value': 'https://github.com/',
      //         'display': {'extended': true, 'normal': true},
      //       },
      //     ],
      //   }
      // };

      // final c10r10u21d10 = {
      //   'c10r10u10d10': {
      //     'settings': {
      //       'linkable': false,
      //       'app_theme': 0,
      //       'display_card_theme': 0,
      //     },
      //     'currentCardId': currentCardId,
      //     'notifications': notificationData,
      //     'applying_cards': [],
      //   }
      // };

      // data

      // 通知用map
      // final notification = {
      //   'title': 'テスト2',
      //   'content': '2番目のテスト用通知です。',
      //   'created_at': DateTime.now(),
      //   'read': false,
      //   'tags': ['news'],
      //   'notification_id': '220926news03-test'
      // };

      // 特定位置の更新用
      // final profiles = {
      //   'account.profiles': {
      //     'name': 'CE',
      //     // 'bio.value': 'Hi',
      //   }
      // };

      // 単純なデータ
      // final public = {'public': false};

      // アカウント情報
      // final account = {
      //     'is_user': false,
      //     'name': '',
      //     'thumbnail': '',
      //     'account': {
      //       'profiles': {
      //         'name': '',
      //         'bio': {
      //           'value': '',
      //           'display': {'extended': true, 'normal': true},
      //         },
      //         'company': {
      //           'value': '',
      //           'display': {'extended': true, 'normal': true},
      //         },
      //         'position': {
      //           'value': '',
      //           'display': {'extended': true, 'normal': true},
      //         },
      //         'address': {
      //           'value': '',
      //           'display': {'extended': true, 'normal': true},
      //         },
      //       },
      //       'links': [],
      //     },
      //   };

      // function

      // 通知情報の一覧を取得
      // FirebaseFirestore.instance
      //     .collection('cards')
      //     .doc(currentCardId)
      //     .collection('notifications')
      //     .where('tags', arrayContains: 'interaction')
      //     .where('title', isEqualTo: 'テスト')
      //     .get()
      //     .then((QuerySnapshot querySnapshot) => (querySnapshot.docs.forEach((element) {debugPrint(element['created_at']);})));

      // set
      // FirebaseFirestore.instance
      //     .collection('cards')
      //     .doc(currentCardId)
      //     .set(account)
      //     .then((element) {
      //   debugPrint('completed');
      // });

      // add
      // FirebaseFirestore.instance
      //     .collection('cards')
      //     .doc(currentCardId)
      //     .collection('notifications')
      //     // .doc(currentDocId)
      //     .add(notification)
      //     .then((element) {
      //   debugPrint('completed');
      // });

      // queryを使って削除
      // num seconds;
      // num nanoseconds;

      // FirebaseFirestore.instance
      //     .collection('cards')
      //     .doc(currentCardId)
      //     .collection('notifications')
      //     .where('created_at',
      //         isGreaterThan:
      //             Timestamp(seconds = 1664097265, nanoseconds = 000000000))
      //     .where('created_at',
      //         isLessThan:
      //             Timestamp(seconds = 1664097267, nanoseconds = 000000000))
      //     .get()
      //     .then((snapshot) {
      //   snapshot.docs.forEach((element) {
      //     debugPrint('$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']}');
      //     element.reference.delete();
      //   });
      // });

      // idを使って更新
      // const notificationId = '220926news01-test';

      // FirebaseFirestore.instance
      //     .collection('cards')
      //     .doc(currentCardId)
      //     .collection('notifications')
      //     .where('notification_id', isEqualTo: notificationId)
      //     .get()
      //     .then((snapshot) {
      //   snapshot.docs.forEach((element) {
      //     debugPrint(
      //         '$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']} / ${element['notification_id']}');
      //     element.reference.update({
      //       'title': '【更新】アカウント情報の追加・更新について',
      //       'content':
      //           '更新　\nデータ構造を変更した影響により、現時点では新規のアカウント登録及びアカウント情報の更新の機能を修正できておりません。これらの操作はFirebase管理画面から手動で行ってください。',
      //       'created_at': DateTime.now(),
      //       'read': false,
      //       'tags': ['news'],
      //       'notification_id': '220926news01-test'
      //     });
      //     // element.reference.delete();
      //   });
      // });

      // idを使って削除
      // const notificationId = '220926news01-test';

      // FirebaseFirestore.instance
      //     .collection('cards')
      //     .doc(currentCardId)
      //     .collection('notifications')
      //     .where('notification_id', isEqualTo: notificationId)
      //     .get()
      //     .then((snapshot) {
      //   snapshot.docs.forEach((element) {
      //     debugPrint(
      //         '$currentCardId / ${element['title']} / ${element['content']} / ${element['created_at']} / ${element['read']} / ${element['notification_id']}');
      //     element.reference.delete();
      //     // element.reference.delete();
      //   });
      // });

      //
