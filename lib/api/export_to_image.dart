import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<ByteData?> exportToImage(GlobalKey globalKey) async {
  final boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(
    pixelRatio: 3,
  );
  final byteData = image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return byteData;
}
