import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/api/firebase_firestore.dart';
import 'package:thundercard/widgets/my_card.dart';

import 'card_details.dart';
import 'constants.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.exchangedCardIds}) : super(key: key);
  final List<dynamic> exchangedCardIds;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> searchedCards = [];
  late List<Map<String, dynamic>> cardsToSearch;
  DateTime _lastChangedDate = DateTime.now();

  void search(String keyword, List<Map<String, dynamic>> cardsToSearch) {
    setState(() {
      String kw = keyword.trim();
      if (kw.length > 100) {
        searchedCards = [];
      }
      kw = kw.toLowerCase();
      if (kw.isEmpty) {
        searchedCards = cardsToSearch;
      } else {
        searchedCards = cardsToSearch
            .where((element) =>
                element['isUser'] &&
                    element['cardId']!.toLowerCase().contains(kw) ||
                element['name']!.toLowerCase().contains(kw))
            .toList();
      }
    });
  }

  void delayedSearch(String text, List<Map<String, dynamic>> cardsToSearch,
      {int time = 100}) {
    Future.delayed(Duration(milliseconds: time), () {
      final nowDate = DateTime.now();
      if (nowDate.difference(_lastChangedDate).inMilliseconds > time) {
        _lastChangedDate = nowDate;
        search(text, cardsToSearch);
      }
    });
    _lastChangedDate = DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    cardsToSearch = [];
    widget.exchangedCardIds.forEach((exchangedCardId) async {
      final String displayName = await getDisplayName(exchangedCardId);
      final bool isUser = await getIsUser(exchangedCardId);
      final DocumentSnapshot card = await getCard(exchangedCardId);
      cardsToSearch.add({
        'cardId': exchangedCardId,
        'name': displayName,
        'isUser': isUser,
        'card': card,
      });
    });
    delayedSearch('', cardsToSearch, time: 500);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchedCardsLength = searchedCards.length;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        // appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 52,
                      margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Search(exchangedCardIds: exchangedCards),
                          //   ),
                          // );
                        },
                        child: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 12, 0, 12),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                child: TextField(
                                  autofocus: true,
                                  maxLength: 128,
                                  decoration: const InputDecoration(
                                    hintText: 'カードを検索',
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                    ),
                                    counterText: '',
                                  ),
                                  onChanged: ((value) {
                                    delayedSearch(value, cardsToSearch);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text('検索結果'),
                        const SizedBox(
                          width: 16,
                        ),
                        Text('$searchedCardsLength件'),
                      ],
                    ),
                    (searchedCardsLength != 0)
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: searchedCards.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CardDetails(
                                            cardId: searchedCards[index]
                                                ['cardId'],
                                            card: searchedCards[index]['card'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 400,
                                      ),
                                      child: FittedBox(
                                        child: MyCard(
                                            cardId: searchedCards[index]
                                                ['cardId'],
                                            cardType: CardType.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.all(40),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.priority_high_rounded,
                                  size: 120,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.3),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '検索結果はありません',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
