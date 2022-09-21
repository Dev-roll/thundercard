import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/widgets/card_element.dart';
import 'package:thundercard/widgets/open_app.dart';

class MyCardData extends StatelessWidget {
  const MyCardData({Key? key, required this.cardId}) : super(key: key);
  final String cardId;
  final String? userName = 'no username';
  final String? bio = 'no bio';
  final String? url = 'no url';
  final String? twitterId = 'no twitter id';
  final String? gitHubId = 'no github id';
  final String? company = 'no company';
  final String? email = 'no email';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    return SizedBox(
      width: 91 * vw,
      height: 55 * vw,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * vw),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          Align(
            alignment: const Alignment(1.6, 2.8),
            child: Icon(
              Icons.bolt_rounded,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
              size: 52 * vw,
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('cards')
                  .doc(cardId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                dynamic cardInfo = snapshot.data;
                return Container(
                  padding: EdgeInsets.fromLTRB(4 * vw, 4 * vw, 4 * vw, 4 * vw),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * vw),
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 16,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 16 * vw,
                                  height: 16 * vw,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(0, 0),
                                  child: Padding(
                                    padding: EdgeInsets.all(2 * vw),
                                    child: Container(
                                      width: 12 * vw,
                                      height: 12 * vw,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.account_circle_rounded,
                                  size: 16 * vw,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                                Icon(
                                  Icons.account_circle_rounded,
                                  size: 16 * vw,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withOpacity(0.25),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    2 * vw, 0 * vw, 0 * vw, 0 * vw),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardElement(
                                      txt: cardInfo?['name'] ?? userName,
                                      size: 3,
                                    ),
                                    CardElement(
                                      txt: '@$cardId',
                                      size: 1.5,
                                      opacity: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 31,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    1 * vw, 0 * vw, 0 * vw, 0 * vw),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CardElement(
                                      txt: cardInfo?['company'] ?? company,
                                      type: IconType.company,
                                      size: 1.5,
                                    ),
                                    CardElement(
                                      txt:
                                          '$bio Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                      line: 3,
                                      height: 1.4,
                                      size: 1.5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    1 * vw, 1 * vw, 1 * vw, 1 * vw),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OpenApp(
                                      url: 'https://keigomichi.dev/',
                                      child: CardElement(
                                        txt: cardInfo?['url'] ?? url,
                                        type: IconType.url,
                                      ),
                                    ),
                                    OpenApp(
                                      url: 'https://twitter.com/chnotchy',
                                      child: CardElement(
                                        txt: cardInfo?['twitter'] ?? twitterId,
                                        type: IconType.twitter,
                                      ),
                                    ),
                                    OpenApp(
                                      url: 'https://github.com/notchcoder',
                                      child: CardElement(
                                        txt: cardInfo?['github'] ?? gitHubId,
                                        type: IconType.github,
                                      ),
                                    ),
                                    OpenApp(
                                      url:
                                          'mailto:example@example.com?subject=hoge&body=test',
                                      child: CardElement(
                                        txt: cardInfo?['email'] ?? email,
                                        type: IconType.email,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
