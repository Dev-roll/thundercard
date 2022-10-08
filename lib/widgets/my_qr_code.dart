import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants.dart';
import '../main.dart';

class MyQrCode extends StatefulWidget {
  const MyQrCode({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<MyQrCode> createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 216,
      height: 216,
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      // padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFCCCCCC), width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        // foregroundDecoration:
        //     BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          clipBehavior: Clip.hardEdge,
          child: QrImage(
            data: 'https://thundercard-test.web.app/?card_id=${widget.name}',
            // data: 'thundercard://user?card_id=${widget.name}',
            version: QrVersions.auto,
            size: 200,
            // foregroundColor: white,
            eyeStyle: QrEyeStyle(
                color: Color(0xFFCCCCCC), eyeShape: QrEyeShape.square),
            dataModuleStyle: QrDataModuleStyle(
                color: Color(0xFFCCCCCC),
                dataModuleShape: QrDataModuleShape.circle),
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
            padding: const EdgeInsets.all(20),
            embeddedImage: Image.asset('images/icon.png').image,
            embeddedImageStyle: QrEmbeddedImageStyle(size: Size(36, 36)),
          ),
        ),
        // decoration: BoxDecoration(
        //     color: white, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
