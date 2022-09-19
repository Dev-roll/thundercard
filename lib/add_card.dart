import 'package:flutter/material.dart';
import 'package:thundercard/widgets/my_card.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('名刺を追加')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyCard(uid: widget.cardId),
              Text('この名刺を追加しますか？'),
            ],
          ),
        ),
      ),
    );
  }
}
