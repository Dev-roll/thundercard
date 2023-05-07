import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thundercard/utils/dynamic_links.dart';

import '../../utils/constants.dart';

class MyQrCode extends StatefulWidget {
  const MyQrCode({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<MyQrCode> createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  @override
  Widget build(BuildContext context) {
    final Future<String> _dynamicLinks =
        dynamicLinks(widget.name).then((value) => value.shortUrl.toString());

    return Container(
      alignment: Alignment.center,
      width: 216,
      height: 216,
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Stack(
        children: [
          Align(
            child: Container(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCCCCCC), width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  clipBehavior: Clip.hardEdge,
                  child: FutureBuilder(
                    future: _dynamicLinks,
                    builder: (context, snapshot) {
                      return QrImage(
                        data: '${snapshot.data}',
                        version: QrVersions.auto,
                        size: 200,
                        eyeStyle: const QrEyeStyle(
                            color: Color(0xFFCCCCCC),
                            eyeShape: QrEyeShape.square),
                        dataModuleStyle: const QrDataModuleStyle(
                            color: Color(0xFFCCCCCC),
                            dataModuleShape: QrDataModuleShape.circle),
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                        padding: const EdgeInsets.all(20),
                      );
                    },
                  ),
                ),
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
          ),
        ],
      ),
    );
  }
}
