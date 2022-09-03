import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
      child: Column(
        children: [
          Container(
            child: QrImage(
              data: 'https://github.com/${widget.name}',
              size: 200,
              foregroundColor: Colors.black,
              backgroundColor: white,
              padding: const EdgeInsets.all(16),
              embeddedImage: Image.asset('images/icon.png').image,
            ),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(16)),
          ),
        ],
      ),
    );
  }
}
