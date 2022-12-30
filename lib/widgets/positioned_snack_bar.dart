import 'package:flutter/material.dart';

class PositionedSnackBar extends SnackBar {
  PositionedSnackBar(
    BuildContext context,
    String text, {
    super.key,
    IconData? icon,
    SnackBarAction? snackbarAction,
    Color? background,
    Color? foreground,
    double? bottom,
    int? seconds,
  }) : super(
          elevation: 20,
          backgroundColor:
              background ?? Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          dismissDirection: DismissDirection.down,
          margin: EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: bottom ?? MediaQuery.of(context).size.height - 220,
          ),
          duration: Duration(seconds: seconds ?? 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon == null)
                const SizedBox(
                  width: 8,
                ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Icon(
                    icon,
                    size: 22,
                    color: foreground?.withOpacity(0.8) ??
                        Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.8),
                  ),
                ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        foreground ?? Theme.of(context).colorScheme.onSecondary,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
          action: snackbarAction,
        );
}
