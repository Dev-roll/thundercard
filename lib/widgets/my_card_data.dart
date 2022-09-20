import 'package:flutter/material.dart';
import 'package:thundercard/widgets/card_element.dart';

class MyCardData extends StatelessWidget {
  const MyCardData({Key? key, required this.cardId}) : super(key: key);
  final String cardId;
  final String? userName = 'name example';
  final String? bio = 'I\'m example!';
  final String? url = 'https://keigomichi.dev';
  final String? twitterId = 'chnotchy';
  final String? gitHubId = 'notchcoder';
  final String? company = 'Devroll';
  final String? email = 'example@example.com';

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
            padding: EdgeInsets.fromLTRB(4 * vw, 4 * vw, 4 * vw, 4 * vw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * vw),
              color: Theme.of(context).colorScheme.secondaryContainer,
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
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Icon(
                            Icons.account_circle_rounded,
                            size: 16 * vw,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.7),
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
                                txt: userName,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CardElement(
                                txt: company,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CardElement(
                                txt: url,
                                type: IconType.url,
                              ),
                              CardElement(
                                txt: twitterId,
                                type: IconType.twitter,
                              ),
                              CardElement(
                                txt: gitHubId,
                                type: IconType.github,
                              ),
                              CardElement(
                                txt: email,
                                type: IconType.email,
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
          ),
          Align(
            alignment: const Alignment(1.6, 2.8),
            child: Icon(
              Icons.bolt_rounded,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
              size: 52 * vw,
            ),
          ),
        ],
      ),
    );
  }
}
