import 'package:flutter/material.dart';

class NotFoundCard extends StatelessWidget {
  const NotFoundCard({super.key, required this.cardId});
  final String cardId;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return Container(
      width: 91 * vw,
      height: 55 * vw,
      padding: EdgeInsets.fromLTRB(4 * vw, 4 * vw, 4 * vw, 4 * vw),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.25),
        borderRadius: BorderRadius.circular(3 * vw),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, 0),
                    child: Container(
                      width: 16 * vw,
                      height: 16 * vw,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0),
                    child: Icon(
                      Icons.no_accounts_rounded,
                      size: 16 * vw,
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(2 * vw, 0 * vw, 0 * vw, 0 * vw),
                  child: Text(
                    '@$cardId',
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
