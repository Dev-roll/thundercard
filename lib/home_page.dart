import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/api/firebase_auth.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/thundercard.dart';
import 'package:thundercard/list.dart';
import 'package:thundercard/notifications.dart';
import 'package:thundercard/account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  final String? uid = getUid();
  DocumentReference user =
      FirebaseFirestore.instance.collection('users').doc(getUid());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.contact_mail,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.contact_mail_outlined,
              color: seedColorLightA,
            ),
            label: 'Thundercard',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.ballot_rounded,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.ballot_outlined,
              color: seedColorLightA,
            ),
            label: 'List',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.notifications_rounded,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.notifications_none_rounded,
              color: seedColorLightA,
            ),
            label: 'Notifications',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.account_circle_rounded,
              size: 26,
              color: seedColorLightE,
            ),
            icon: Icon(
              Icons.account_circle_outlined,
              color: seedColorLightA,
            ),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        Thundercard(),
        List(),
        // List(uid: uid),
        Notifications(),
        Account(),
      ][currentPageIndex],
    );
  }
}
