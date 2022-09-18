import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thundercard/upload_image_page.dart';
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
  String currentAccount = 'example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                child: Column(children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RoomListPage(),
                      ));
                    },
                    child: const Text('Chat'),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('cards')
                        .doc(currentAccount)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // 取得が完了していないときに表示するWidget
                      // if (snapshot.connectionState != ConnectionState.done) {
                      //   // インジケーターを回しておきます
                      //   return const CircularProgressIndicator();
                      // }

                      // エラー時に表示するWidget
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('error');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      // データが取得できなかったときに表示するWidget
                      if (!snapshot.hasData) {
                        return Text('no data');
                      }

                      dynamic hoge = snapshot.data;
                      final exchangedCards = hoge?['exchanged_cards'];
                      // 取得したデータを表示するWidget
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exchangedCards.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('cards')
                                .doc(exchangedCards[index])
                                .snapshots(),
                            builder: (context, snapshot) {
                              // 取得が完了していないときに表示するWidget
                              // if (snapshot.connectionState != ConnectionState.done) {
                              //   // インジケーターを回しておきます
                              //   return const CircularProgressIndicator();
                              // }
                              dynamic data = snapshot.data;

                              // エラー時に表示するWidget
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return Text('error');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              // データが取得できなかったときに表示するWidget
                              if (!snapshot.hasData) {
                                return Text('no data');
                              }

                              // 取得したデータを表示するWidget
                              return Column(
                                children: [
                                  Text('username: ${data?['name']}'),
                                  data?['thumbnail'] != null
                                      ? Image.network(data?['thumbnail'])
                                      : const Text('Loading...'),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UploadImagePage(
              data: data,
            ),
          ));
        },
        // onPressed: getImage,
        child: const Icon(
          Icons.add_a_photo_rounded,
        ),
      ),
    );
  }
}
