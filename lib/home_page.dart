import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thundercard/widgets/avatar.dart';

import 'api/firebase_auth.dart';
import 'api/colors.dart';
import 'account.dart';
import 'list.dart';
import 'notifications.dart';
import 'thundercard.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

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
    final iconColorNum = Theme.of(context)
        .colorScheme
        .onBackground
        .value
        .toRadixString(16)
        .substring(2);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.01),
            Theme.of(context).colorScheme.surface),
        statusBarIconBrightness:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Brightness.light
                : Brightness.dark,
        statusBarBrightness:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      key: drawerKey,
      // appBar: widget.index == 0
      //     ? AppBar(
      //         backgroundColor: alphaBlend(
      //             Theme.of(context).colorScheme.primary.withOpacity(0.08),
      //             Theme.of(context).colorScheme.surface),
      //         systemOverlayStyle: SystemUiOverlayStyle(
      //           systemNavigationBarColor: alphaBlend(
      //               Theme.of(context).colorScheme.primary.withOpacity(0.08),
      //               Theme.of(context).colorScheme.surface),
      //           statusBarColor: Colors.transparent,
      //         ),
      //         title: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             SvgPicture.string(
      //               '<svg width="400" height="400" viewBox="0 0 400 400" fill="#$iconColorNum" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
      //               width: 18,
      //             ),
      //             const SizedBox(width: 8),
      //             const Text(
      //               'Thundercard',
      //               style: TextStyle(fontSize: 18),
      //             ),
      //           ],
      //         ),
      //         centerTitle: true,
      //       )
      //     : null,
      onDrawerChanged: (isOpened) {
        isOpened
            ? SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor: alphaBlend(
                    Color(0x80000000),
                    alphaBlend(
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                        Theme.of(context).colorScheme.surface),
                  ),
                ),
              )
            : SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor: alphaBlend(
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      Theme.of(context).colorScheme.surface),
                ),
              );
      },
      drawerScrimColor: Color(0x80000000),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.5,
      drawer: Drawer(
        backgroundColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
            Theme.of(context).colorScheme.surface),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(18),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.menu_open_rounded),
                ),
                const SizedBox(width: 16),
                SvgPicture.string(
                  '<svg width="400" height="400" viewBox="0 0 400 400" fill="#$iconColorNum" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
                  width: 18,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Thundercard',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Divider(
              height: 2,
              thickness: 2,
              indent: 0,
              endIndent: 0,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            SizedBox(
              height: 16,
            ),
            // DrawerHeader(
            //   decoration: BoxDecoration(color: Colors.lightBlue),
            //   child: Text('Test App'),
            // ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        SizedBox(width: 32, child: FittedBox(child: Avatar())),
                    title: Text('username'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.policy_rounded),
              title: Text('プライバシーポリシー'),
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => const LinkAuth()),
                // );
              },
            ),
          ],
        ),
      ),
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
