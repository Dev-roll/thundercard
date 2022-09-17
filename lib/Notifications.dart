import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //   border: Border(
                  //     bottom: BorderSide(
                  //       width: 4,
                  //       color: Colors.transparent,
                  //     ),
                  //   ),
                  // ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: seedColor4,
                      // border: Border.all(color: seedColor),
                      // border: const Border(
                      //   bottom: BorderSide(
                      //     color: seedColor,
                      //     width: 2,
                      //   ),
                      // ),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    // indicatorColor: seedColor,
                    tabs: [
                      Tab(
                        // child: Icon(Icons.notifications_on_rounded),
                        child: Container(
                          width: 120,
                          height: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.handshake_outlined,
                                // Icons.mail_rounded,
                                // Icons.swap_horiz_rounded,
                                // Icons.swap_horizontal_circle_rounded,
                                size: 22,
                                color: seedColorLightA,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('交流'),
                              // Text('つながり'),
                              // Text('やりとり'),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: 152,
                          height: double.infinity,
                          // decoration: BoxDecoration(
                          //   // color: seedColorLight1,
                          //   border: Border.all(color: seedColor2, width: 4),
                          //   borderRadius: BorderRadius.all(
                          //     Radius.circular(40),
                          //   ),
                          // ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.campaign_rounded,
                                size: 22,
                                color: seedColorLightA,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('お知らせ'),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: Text('hoge'),
              ),
            ),
            Center(
              child: Text('piyo'),
            ),
          ],
        ),
      ),
    );
  }
}











































































































// import 'package:flutter/material.dart';
// import 'package:thundercard/constants.dart';

// class Notifications extends StatefulWidget {
//   const Notifications({Key? key}) : super(key: key);

//   @override
//   State<Notifications> createState() => _NotificationsState();
// }

// class _NotificationsState extends State<Notifications>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   // int _selectedIndex = 0;
//   // NavigationRailLabelType labelType = NavigationRailLabelType.all;
//   // bool showLeading = false;
//   // bool showTrailing = false;
//   // double groupAligment = 1.0;

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, value) {
//           return [
//             SliverAppBar(
//                 // title: Text('Library'),
//                 bottom: PreferredSize(
//                     preferredSize: Size.fromHeight(getProportionHeight(24)),
//                     child: _buildTabsRow())),
//           ];
//         },
//         body: _tabBody(),
//       ),
//     );
//     // return Scaffold(
//     //   body: SafeArea(
//     //     child: Row(
//     //       children: <Widget>[
//     //         NavigationRail(
//     //           backgroundColor: seedColorDark,
//     //           selectedIndex: _selectedIndex,
//     //           groupAlignment: 0,
//     //           onDestinationSelected: (int index) {
//     //             setState(() {
//     //               _selectedIndex = index;
//     //             });
//     //           },
//     //           labelType: NavigationRailLabelType.all,
//     //           leading: const SizedBox(),
//     //           trailing: const SizedBox(),
//     //           destinations: const <NavigationRailDestination>[
//     //             NavigationRailDestination(
//     //               icon: Icon(Icons.mail_outline_rounded),
//     //               selectedIcon: Icon(Icons.mail_rounded),
//     //               label: Text('お知らせ'),
//     //             ),
//     //             NavigationRailDestination(
//     //               icon: Icon(Icons.campaign_outlined),
//     //               selectedIcon: Icon(Icons.campaign_rounded),
//     //               label: Text('ニュース'),
//     //             ),
//     //           ],
//     //         ),
//     //         const VerticalDivider(
//     //           thickness: 1,
//     //           width: 1,
//     //           color: Color(0x44888888),
//     //         ),
//     //         // This is the main content.
//     //         // Expanded(
//     //         //   child: Column(
//     //         //     mainAxisAlignment: MainAxisAlignment.center,
//     //         //     children: <Widget>[
//     //         //       Text('selectedIndex: $_selectedIndex'),
//     //         //       const SizedBox(height: 20),
//     //         //       Text('Label type: ${labelType.name}'),
//     //         //       const SizedBox(height: 10),
//     //         //       OverflowBar(
//     //         //         spacing: 10.0,
//     //         //         children: <Widget>[
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 labelType = NavigationRailLabelType.none;
//     //         //               });
//     //         //             },
//     //         //             child: const Text('None'),
//     //         //           ),
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 labelType = NavigationRailLabelType.selected;
//     //         //               });
//     //         //             },
//     //         //             child: const Text('Selected'),
//     //         //           ),
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 labelType = NavigationRailLabelType.all;
//     //         //               });
//     //         //             },
//     //         //             child: const Text('All'),
//     //         //           ),
//     //         //         ],
//     //         //       ),
//     //         //       const SizedBox(height: 20),
//     //         //       Text('Group alignment: $groupAligment'),
//     //         //       const SizedBox(height: 10),
//     //         //       OverflowBar(
//     //         //         spacing: 10.0,
//     //         //         children: <Widget>[
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 groupAligment = -1.0;
//     //         //               });
//     //         //             },
//     //         //             child: const Text('Top'),
//     //         //           ),
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 groupAligment = 0.0;
//     //         //               });
//     //         //             },
//     //         //             child: const Text('Center'),
//     //         //           ),
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 groupAligment = 1.0;
//     //         //               });
//     //         //             },
//     //         //             child: const Text('Bottom'),
//     //         //           ),
//     //         //         ],
//     //         //       ),
//     //         //       const SizedBox(height: 20),
//     //         //       OverflowBar(
//     //         //         spacing: 10.0,
//     //         //         children: <Widget>[
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 showLeading = !showLeading;
//     //         //               });
//     //         //             },
//     //         //             child:
//     //         //                 Text(showLeading ? 'Hide Leading' : 'Show Leading'),
//     //         //           ),
//     //         //           ElevatedButton(
//     //         //             onPressed: () {
//     //         //               setState(() {
//     //         //                 showTrailing = !showTrailing;
//     //         //               });
//     //         //             },
//     //         //             child: Text(
//     //         //                 showTrailing ? 'Hide Trailing' : 'Show Trailing'),
//     //         //           ),
//     //         //         ],
//     //         //       ),
//     //         //     ],
//     //         //   ),
//     //         // ),
//     //       ],
//     //     ),
//     //   ),
//     // );
//     // return DefaultTabController(
//     //   initialIndex: 0,
//     //   length: 2,
//     //   child: Scaffold(
//     //     appBar: AppBar(
//     //       title: const Text('datadatadatadata'),
//     //       bottom: TabBar(
//     //         tabs: [
//     //           Tab(
//     //             child: Row(
//     //               children: [
//     //                 Icon(Icons.notifications_on_rounded),
//     //                 Text('あなたへの通知'),
//     //               ],
//     //             ),
//     //           ),
//     //           Tab(
//     //             child: Row(
//     //               children: [
//     //                 Icon(Icons.notifications_on_rounded),
//     //                 Text('あなたへの通知'),
//     //               ],
//     //             ),
//     //           )
//     //         ],
//     //       ),
//     //     ),
//     //     body: TabBarView(
//     //       children: [
//     //         Center(
//     //           child: Text('hoge'),
//     //         ),
//     //         Center(
//     //           child: Text('piyo'),
//     //         ),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }

//   Widget _tabBody() {
//     return TabBarView(
//       controller: _tabController,
//       children: [
//         Container(child: Center(child: Icon(Icons.car_rental))),
//         Container(child: Center(child: Icon(Icons.car_rental))),
//         Container(child: Center(child: Icon(Icons.car_rental))),
//       ],
//     );
//   }

//   Widget _buildTabsRow() {
//     return Stack(
//       children: [
//         _buildTabTitles(),
//         _buildTabActions() // 並び替えとフィルターのactions
//       ],
//     );
//   }

//   // タブの左寄せタイトル郡
//   Widget _buildTabTitles() {
//     return Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: TabBar(
//             controller: _tabController,
//             indicator: BoxDecoration(
//               border: Border(
//                   bottom: BorderSide(
//                 width: getProportionWidth(3),
//                 color: Colors.black,
//               )),
//             ),
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               _tabTitle('Car'),
//               _tabTitle('Bike'),
//               _tabTitle('Walk'),
//             ],
//           ),
//         ),
//         Expanded(flex: 2, child: Container()),
//       ],
//     );
//   }

//   Widget _buildTabActions() {
//     return Container(
//       // tab height
//       height: getProportionWidth(40),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _tabAction(
//               icon: const Icon(Icons.sort_outlined, color: Colors.white),
//               onTap: () {}),
//           _tabAction(
//               icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
//               onTap: () {}),
//         ],
//       ),
//     );
//   }

//   Widget _tabAction({required Icon icon, required Function onTap}) {
//     return Padding(
//       padding: EdgeInsets.only(right: getProportionWidth(20)),
//       child: GestureDetector(
//         onTap: () => onTap,
//         child: icon,
//       ),
//     );
//   }

//   Widget _tabTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: getProportionWidth(6)),
//       child: Container(
//         height: getProportionHeight(40),
//         width: getProportionWidth(132),
//         child: Tab(text: title),
//       ),
//     );
//   }

//   double getProportionHeight(double inputHeight) {
//     final screenHeight = SizeConfig.screenHeight;
//     return (inputHeight / 812.0) * screenHeight;
//   }

//   double getProportionWidth(double inputWidth) {
//     final screenWidth = SizeConfig.screenWidth;
//     return (inputWidth / 375.0) * screenWidth;
//   }
// }

// class SizeConfig {
//   late MediaQueryData _mediaQueryData;
//   static double screenWidth = 80;
//   static double screenHeight = 80;
//   static double blockSizeHorizontal = 80;
//   static double blockSizeVertical = 80;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     blockSizeHorizontal = screenWidth / 100;
//     blockSizeVertical = screenHeight / 100;
//   }
// }
