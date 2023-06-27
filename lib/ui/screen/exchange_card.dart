import 'package:flutter/material.dart';
import 'package:thundercard/ui/component/input_link.dart';
import 'package:thundercard/ui/component/scan_qr_code.dart';
import 'package:thundercard/utils/colors.dart';

class ExchangeCard extends StatefulWidget {
  const ExchangeCard({super.key, required this.currentCardId});

  final String currentCardId;

  @override
  State<ExchangeCard> createState() => _ExchangeCardState();
}

class _ExchangeCardState extends State<ExchangeCard>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    const Tab(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
          ),
          Icon(Icons.qr_code_rounded),
          SizedBox(
            width: 8,
          ),
          Text('QRコード'),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    ),
    const Tab(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
          ),
          Icon(Icons.link_rounded),
          SizedBox(
            width: 8,
          ),
          Text('リンク'),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              ScanQrCode(currentCardId: widget.currentCardId),
              const InputLink(),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                8,
                8 + MediaQuery.of(context).padding.top,
                0,
                0,
              ),
              child: Hero(
                tag: 'back_button',
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: alphaBlend(
          Theme.of(context).colorScheme.primary.withOpacity(0.08),
          Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                tabs: tabs,
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).colorScheme.primary,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: const EdgeInsets.fromLTRB(-8, 0, -8, 0),
              ),
            ),
            SizedBox(
              height: 16 + MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
