import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/widgets/avatar.dart';
import '../constants.dart';
import '../api/return_url.dart';
import 'card_element.dart';
import 'open_app.dart';

class SmallCard extends StatelessWidget {
  const SmallCard({
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
                      // avatar
                      const Avatar(),
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
                                          weight: 'bold',
                                          opacity: 0.7,
                                        ),
                                        if (data?['is_user'])
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
                            const dataTypeList = dataTypes;

                            return profiles == null
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.fromLTRB(
                                        1 * vw, 0 * vw, 0 * vw, 0 * vw),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for (var i = 0;
                                            i < dataTypeList.length;
                                            i++)
                                          if (profiles[dataTypeList[i]]
                                                      ['value'] !=
                                                  '' &&
                                              profiles[dataTypeList[i]]
                                                  ['display']['normal'])
                                            dataTypeList[i] == 'address'
                                                ? OpenApp(
                                                    url: returnUrl(
                                                        'address',
                                                        profiles[
                                                                dataTypeList[i]]
                                                            ['value']),
                                                  )
                                                : CardElement(
                                                    txt: profiles[
                                                                dataTypeList[i]]
                                                            ['value'] ??
                                                        '',
                                                    type: linkTypeToIconType[
                                                            dataTypeList[i]] ??
                                                        IconType.nl,
                                                    line:
                                                        dataTypeList[i] == 'bio'
                                                            ? 2
                                                            : 1,
                                                    height:
                                                        dataTypeList[i] == 'bio'
                                                            ? 1.4
                                                            : 1.2,
                                                    size: 1.3,
                                                  ),
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
                                        for (var i = 0; i < links.length; i++)
                                          if (links[i]['display']['normal'])
                                            Expanded(
                                              child: OpenApp(
                                                url: returnUrl(links[i]['key'],
                                                    links[i]['value']),
                                              ),
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
