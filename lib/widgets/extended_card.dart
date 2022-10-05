import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/return_url.dart';
import '../constants.dart';
import 'card_element.dart';
import 'open_app.dart';

class ExtendedCard extends StatelessWidget {
  const ExtendedCard({
    Key? key,
    required this.cardId,
  }) : super(key: key);
  final String cardId;

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
          Container(
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
                              color: Theme.of(context).colorScheme.secondary,
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                      // name etc
                      Flexible(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('cards')
                              .doc(cardId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            dynamic data = snapshot.data;
                            final name = data?['account']['profiles']['name'];

                            return name == null
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.fromLTRB(
                                        2 * vw, 0 * vw, 0 * vw, 0 * vw),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CardElement(
                                          txt: name ?? '',
                                          size: 3,
                                        ),
                                        CardElement(
                                          txt: '@$cardId',
                                          size: 1.5,
                                          opacity: 0.5,
                                        ),
                                      ],
                                    ),
                                  );
                          },
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
                      // left
                      Flexible(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('cards')
                              .doc(cardId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            dynamic data = snapshot.data;
                            final profiles = data?['account']['profiles'];

                            return profiles == null
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.fromLTRB(
                                        1 * vw, 0 * vw, 0 * vw, 0 * vw),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        profiles['company']['value'] != '' &&
                                                profiles['company']['display']
                                                    ['extended']
                                            ? CardElement(
                                                txt: profiles['company']
                                                        ['value'] ??
                                                    '',
                                                type: IconType.company,
                                                size: 1.3,
                                              )
                                            : Container(),
                                        profiles['position']['value'] != '' &&
                                                profiles['position']['display']
                                                    ['extended']
                                            ? CardElement(
                                                txt: profiles['position']
                                                        ['value'] ??
                                                    '',
                                                type: IconType.position,
                                                size: 1.3,
                                              )
                                            : Container(),
                                        profiles['address']['value'] != '' &&
                                                profiles['address']['display']
                                                    ['extended']
                                            ? CardElement(
                                                txt: profiles['address']
                                                        ['value'] ??
                                                    '',
                                                type: IconType.location,
                                                size: 1.3,
                                              )
                                            : Container(),
                                        profiles['bio']['value'] != '' &&
                                                profiles['bio']['display']
                                                    ['extended']
                                            ? CardElement(
                                                txt: profiles['bio']['value'] ??
                                                    '',
                                                line: 2,
                                                height: 1.4,
                                                size: 1.3,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ),
                      // right
                      Flexible(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('cards')
                              .doc(cardId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            dynamic data = snapshot.data;
                            final links = data?['account']['links'];

                            return links == null
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.fromLTRB(
                                        1 * vw, 1 * vw, 1 * vw, 1 * vw),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: links?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            return links[index]['display']
                                                    ['extended']
                                                ? OpenApp(
                                                    url: returnUrl(
                                                        links[index]['key'],
                                                        links[index]['value']),
                                                  )
                                                : Container();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
