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
      if (keyword.trim().isEmpty) {
        // searchedCards = [];
        searchedCards = cardsToSearch;
      } else {
        searchedCards = cardsToSearch
            .where((element) =>
                element['cardId']!
                    .toLowerCase()
                    .contains(keyword.toLowerCase()) ||
                element['name']!.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  void delayedSearch(String text, List<Map<String, dynamic>> cardsToSearch) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final nowDate = DateTime.now();
      if (nowDate.difference(_lastChangedDate).inMilliseconds > 500) {
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
      final DocumentSnapshot card = await getCard(exchangedCardId);
      cardsToSearch.add({
        'cardId': exchangedCardId,
        'name': displayName,
        'card': card,
      });
    });
    delayedSearch('', cardsToSearch);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchedCardsLength = searchedCards.length;
    return Scaffold(
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
                    margin: EdgeInsets.fromLTRB(24, 16, 24, 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      // .withOpacity(0.16),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: GestureDetector(
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
                              padding: EdgeInsets.fromLTRB(20, 12, 0, 12),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 16),
                              child: TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: '名刺を検索',
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
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
                      SizedBox(
                        width: 16,
                      ),
                      Text('検索結果'),
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
                                SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CardDetails(
                                        cardId: searchedCards[index]['cardId'],
                                        card: searchedCards[index]['card'],
                                      ),
                                    ));
                                  },
                                  child: MyCard(
                                      cardId: searchedCards[index]['cardId'],
                                      cardType: CardType.normal),
                                ),
                              ],
                            );
                          })
                      : Container(
                          padding: EdgeInsets.all(40),
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
                              SizedBox(
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
    );
  }
}
