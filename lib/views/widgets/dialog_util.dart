import 'package:flutter/material.dart';

class DialogUtil {
  static Future<void> show({
    required BuildContext context,
    required Widget Function(
      BuildContext context,
    )
        builder,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          // 戻るボタンを無効にする
          onWillPop: () async => false,
          child: builder(context),
        );
      },
    );
  }
}
