import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.exchangedCards}) : super(key: key);
  final List<dynamic> exchangedCards;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> searchedCards = [];
  DateTime _lastChangedDate = DateTime.now();

  void search(String text, List<dynamic> list) {
    setState(() {
      if (text.trim().isEmpty) {
        searchedCards = [];
      } else {
        searchedCards =
            list.where((element) => element.contains(text)).toList();
      }
    });
  }

  void delayedSearch(String text, List<dynamic> list) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      final nowDate = DateTime.now();
      if (nowDate.difference(_lastChangedDate).inMilliseconds > 1000) {
        _lastChangedDate = nowDate;
        search(text, list);
      }
    });
    _lastChangedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: ((value) {
            delayedSearch(value, widget.exchangedCards);
          }),
        ),
        const SizedBox(height: 16),
        const Text('検索結果'),
        const SizedBox(height: 16),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchedCards.length,
            itemBuilder: (context, index) {
              return Text(searchedCards[index]);
            })
      ],
    );
  }
}
