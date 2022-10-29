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
import 'package:flutter_svg/svg.dart';
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
    final iconColorNum = 'cccccc';
    // final iconColorNum = Theme.of(context)
    //     .colorScheme
    //     .tertiary
    //     .value
    //     .toRadixString(16)
    //     .toString()
    //     .substring(2);
    return Container(
      alignment: Alignment.center,
      width: 216,
      height: 216,
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      // padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Align(
            child: Container(
              alignment: Alignment.center,
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
                    data:
                        'https://thundercard-test.web.app/?card_id=${widget.name}',
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
                    // embeddedImage: Image.asset('images/icon_for_qr.png').image,
                    // embeddedImageStyle:
                    //     QrEmbeddedImageStyle(size: Size(36, 36)),
                  ),
                ),
                // decoration: BoxDecoration(
                //     color: white, borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          Align(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              width: 32,
              height: 32,
            ),
          ),
          Align(
            child: SvgPicture.asset('images/svg/qr/icon_for_qr.svg',
                width: 24, height: 24),
            // child: Container(
            //   width: 24,
            //   height: 24,
            //   child: FittedBox(
            //     child: SvgPicture.string(
            //       "<svg width=\"400\" height=\"400\" viewBox=\"0 0 400 400\" fill=\"#$iconColorNum\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z\"/><path d=\"M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z\"/></svg>",
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
