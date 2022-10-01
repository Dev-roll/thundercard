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
        searchedCards = [];
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchedCardsLength = searchedCards.length;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '名刺を検索',
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: ((value) {
                    delayedSearch(value, cardsToSearch);
                  }),
                ),
                const SizedBox(height: 16),
                const Text('検索結果'),
                (searchedCardsLength != 0)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchedCards.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CardDetails(
                                  cardId: searchedCards[index]['cardId'],
                                  card: searchedCards[index]['card'],
                                ),
                              ));
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 24),
                                MyCard(
                                    cardId: searchedCards[index]['cardId'],
                                    cardType: CardType.normal),
                              ],
                            ),
                          );
                        })
                    : Text('検索結果はありません'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
