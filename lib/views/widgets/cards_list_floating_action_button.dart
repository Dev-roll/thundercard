import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../providers/current_card_id_provider.dart';
import '../pages/exchange_card.dart';
import '../pages/upload_image_page.dart';

class CardsListFloatingActionButton extends ConsumerWidget {
  CardsListFloatingActionButton({super.key});

  final isDialOpen = ValueNotifier<bool>(false);
  final customDialRoot = false;
  final buttonSize = const Size(56.0, 56.0);
  final childrenButtonSize = const Size(56.0, 56.0);
  final extend = false;
  final visible = true;
  final rmicons = false;

  @override
  build(BuildContext context, WidgetRef ref) {
    final currentCardId = ref.watch(currentCardIdProvider);

    return SpeedDial(
      animatedIconTheme: const IconThemeData(size: 24.0),
      icon: Icons.add_rounded,
      activeIcon: Icons.close_rounded,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      spacing: 16,
      openCloseDial: isDialOpen,
      activeBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      childPadding: const EdgeInsets.all(0),
      spaceBetweenChildren: 0,
      dialRoot: customDialRoot
          ? (ctx, open, toggleChildren) {
              return ElevatedButton(
                onPressed: toggleChildren,
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                ),
                child: const Text(
                  'Custom Dial Root',
                  style: TextStyle(fontSize: 17),
                ),
              );
            }
          : null,
      buttonSize:
          buttonSize, // it's the SpeedDial size which defaults to 56 itself
      iconTheme: const IconThemeData(size: 24),
      label:
          extend ? const Text('Open') : null, // The label of the main button.
      /// The active label of the main button, Defaults to label if not specified.
      activeLabel: extend ? const Text('Close') : null,

      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,

      /// If true user is forced to close dial manually
      closeManually: false,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: true,
      // overlayColor: Colors.black,
      overlayOpacity: 0.9,
      // onOpen: () {debugPrint('OPENING DIAL');},
      // onClose: () {debugPrint('DIAL CLOSED');},
      useRotationAnimation: true,
      tooltip: '',
      heroTag: 'speed-dial-hero-tag',
      // foregroundColor: Colors.black,
      // backgroundColor: Colors.white,
      // activeForegroundColor: Colors.red,
      // activeBackgroundColor: Colors.blue,
      elevation: 8.0,
      animationCurve: Curves.easeInOut,
      isOpenOnStart: false,
      animationDuration: const Duration(milliseconds: 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      childMargin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      children: [
        SpeedDialChild(
          child: !rmicons
              ? Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xaa000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                        spreadRadius: -2,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : null,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          label: '画像をもとに追加',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UploadImagePage(
                cardId: currentCardId,
              ),
              fullscreenDialog: true,
            ));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelBackgroundColor: Colors.transparent,
          labelShadow: [],
          elevation: 0,
        ),
        SpeedDialChild(
          child: !rmicons
              ? Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xaa000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                        spreadRadius: -2,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : null,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          label: 'カードを交換',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme,
                    brightness: Brightness.dark,
                    useMaterial3: true,
                  ),
                  child: ExchangeCard(currentCardId: currentCardId),
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelBackgroundColor: Colors.transparent,
          labelShadow: [],
          elevation: 0,
        ),
      ],
    );
  }
}
