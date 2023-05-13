import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.isCurrentUser = false}) : super(key: key);

  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, 0),
          child: Container(
            width: 16 * vw,
            height: 16 * vw,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
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
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0),
          child: Icon(
            Icons.account_circle_rounded,
            size: 16 * vw,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
        Align(
          alignment: const Alignment(0, 0),
          child: Icon(
            Icons.account_circle_rounded,
            size: 16 * vw,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.25),
          ),
        ),
        if (isCurrentUser &&
            FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.photoURL != null)
          Align(
            alignment: const Alignment(0, 0),
            child: Container(
              width: 16 * vw,
              height: 16 * vw,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    FirebaseAuth.instance.currentUser!.photoURL!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              clipBehavior: Clip.hardEdge,
            ),
          ),
      ],
    );
  }
}
