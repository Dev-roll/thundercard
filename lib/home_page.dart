import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/firebase_auth.dart';
import 'api/colors.dart';
import 'account.dart';
import 'list.dart';
import 'notifications.dart';
import 'thundercard.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.user, required this.index}) : super(key: key);
  final User? user;
  int index;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String? uid = getUid();
  DocumentReference user =
      FirebaseFirestore.instance.collection('users').doc(getUid());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        // systemNavigationBarIconBrightness: ThemeData(),
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            widget.index = index;
          });
        },
        selectedIndex: widget.index,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.contact_mail,
              size: 26,
            ),
            icon: Icon(
              Icons.contact_mail_outlined,
            ),
            label: 'ホーム',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.ballot_rounded,
              size: 26,
            ),
            icon: Icon(
              Icons.ballot_outlined,
            ),
            label: 'カード',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.notifications_rounded,
              size: 26,
            ),
            icon: Icon(
              Icons.notifications_none_rounded,
            ),
            label: '通知',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.account_circle_rounded,
              size: 26,
            ),
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            label: 'アカウント',
          ),
        ],
      ),
      body: <Widget>[
        Thundercard(),
        List(),
        // List(uid: uid),
        Notifications(),
        Account(),
      ][widget.index],
    );
  }
}
