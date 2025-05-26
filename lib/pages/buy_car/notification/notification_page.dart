// import 'package:fl_carmax/helper/column_builder.dart';
// import 'package:fl_carmax/utils/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../../helper/language_constant.dart';
// import '../../../utils/widgets.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// List _notificationList = [
//   {
//     'type': 'Today',
//     'data': [
//       {
//         'title':
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero mattis a netus morbi egestas ultrices ultrices sed.',
//         'subtitle': '2 min ago'
//       },
//       {
//         'title':
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero mattis a netus morbi egestas ultrices ultrices sed.',
//         'subtitle': '5 min ago'
//       },
//     ]
//   },
//   {
//     'type': 'Yesterday',
//     'data': [
//       {
//         'title':
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero mattis a netus morbi egestas ultrices ultrices sed. ',
//         'subtitle': 'Yesterday'
//       },
//       {
//         'title':
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero mattis a netus morbi egestas ultrices ultrices sed.  ',
//         'subtitle': 'Yesterday'
//       },
//       {
//         'title':
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero mattis a netus morbi egestas ultrices ultrices sed.   ',
//         'subtitle': 'Yesterday'
//       },
//     ]
//   },
// ];

// class _NotificationPageState extends State<NotificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarMethod(context),
//       body: _notificationList.isNotEmpty
//           ? filledNotificationScreen()
//           : emptyNotificationScreen(),
//     );
//   }

//   ListView filledNotificationScreen() {
//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.zero,
//       itemCount: _notificationList.length,
//       itemBuilder: (BuildContext context, int index) {
//         final item = _notificationList[index];
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: item['data'].isNotEmpty
//                   ? const EdgeInsets.symmetric(horizontal: 20)
//                       .copyWith(top: 20, bottom: 15)
//                   : EdgeInsets.zero,
//               child: _notificationList[index]['data'].isNotEmpty
//                   ? Text(
//                       item['type'] == 'Today'
//                           ? translation(context).today
//                           : translation(context).yesterDay,
//                       style: blackSemiBold16)
//                   : null,
//             ),
//             ColumnBuilder(
//               itemCount: item['data'].length,
//               itemBuilder: (context, index) {
//                 final dataItem = item['data'][index];
//                 return Dismissible(
//                   key: Key('$dataItem'),
//                   background: Container(
//                     margin: const EdgeInsets.only(bottom: 20),
//                     //color: Colors.red,
//                     color: Color(0xff212121),
//                   ),
//                   onDismissed: (direction) {
//                     setState(() {
//                       item['data'].removeAt(index);
//                     });
//                     if (_notificationList[0]['data'].isEmpty &&
//                         _notificationList[1]['data'].isEmpty) {
//                       setState(() {
//                         _notificationList.clear();
//                       });
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         backgroundColor: primaryColor,
//                         duration: const Duration(seconds: 1),
//                         content: Text(
//                           translation(context).notificationRemoved,
//                           style: whiteMedium14,
//                         )));
//                   },
//                   child: PrimaryContainer(
//                     margin: const EdgeInsets.symmetric(horizontal: 20)
//                         .copyWith(bottom: 20),
//                     padding: const EdgeInsets.fromLTRB(14, 11, 13, 11),
//                     child: Row(children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         height: 5.h,
//                         width: 5.h,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: primaryColor,
//                             boxShadow: [myBoxShadow]),
//                         child: Image.asset(notificationLable),
//                       ),
//                       widthSpace10,
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Libero mattis a netus morbi egestas ultrices ultrices sed.',
//                                 style: blackRegular14),
//                             heightSpace3,
//                             Text('2 min ago', style: colorA6Regular14)
//                           ],
//                         ),
//                       )
//                     ]),
//                   ),
//                 );
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//   PreferredSize appBarMethod(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(56),
//       child: CustomAppBar(
//         title: translation(context).notification,
//       ),
//     );
//   }

//   Widget emptyNotificationScreen() {
//     return SafeArea(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               emptyNotification,
//               height: 4.2.h,
//             ),
//             heightSpace10,
//             Text(translation(context).emptyNotificationMsg,
//                 style: colorA6SemiBold16)
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';
import '../../../helper/column_builder.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _notificationList = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('notifications') ?? [];

    final List<Map<String, dynamic>> todayList = [];
    final List<Map<String, dynamic>> yesterdayList = [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var jsonStr in data) {
      final item = jsonDecode(jsonStr);
      final timestamp = DateTime.parse(item['timestamp']);
      final notificationDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
      final diff = today.difference(notificationDate).inDays;

      final formattedTime = diff == 0
          ? '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}'
          : 'Yesterday';

      final map = {
        'title': item['title'],
        'subtitle': formattedTime,
      };

      if (diff == 0) {
        todayList.add(map);
      } else if (diff == 1) {
        yesterdayList.add(map);
      }
    }

    setState(() {
      _notificationList = [
        if (todayList.isNotEmpty) {'type': 'Today', 'data': todayList},
        if (yesterdayList.isNotEmpty) {'type': 'Yesterday', 'data': yesterdayList},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: _notificationList.isNotEmpty
          ? filledNotificationScreen()
          : emptyNotificationScreen(),
    );
  }

  ListView filledNotificationScreen() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _notificationList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _notificationList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: item['data'].isNotEmpty
                  ? const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20, bottom: 15)
                  : EdgeInsets.zero,
              child: Text(
                item['type'] == 'Today'
                    ? translation(context).today
                    : translation(context).yesterDay,
                style: blackSemiBold16,
              ),
            ),
            ColumnBuilder(
              itemCount: item['data'].length,
              itemBuilder: (context, index) {
                final dataItem = item['data'][index];
                return Dismissible(
                  key: Key('${dataItem['title']}-$index'),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    color: const Color(0xff212121),
                  ),
                  onDismissed: (direction) async {
                    setState(() {
                      item['data'].removeAt(index);
                    });

                    if (_notificationList.every((section) => section['data'].isEmpty)) {
                      setState(() => _notificationList.clear());
                    }

                    // Update SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    List<String> currentList = prefs.getStringList('notifications') ?? [];
                    currentList.removeWhere((e) => jsonDecode(e)['title'] == dataItem['title']);
                    await prefs.setStringList('notifications', currentList);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: primaryColor,
                        duration: const Duration(seconds: 1),
                        content: Text(
                          translation(context).notificationRemoved,
                          style: whiteMedium14,
                        ),
                      ),
                    );
                  },
                  child: PrimaryContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
                    padding: const EdgeInsets.fromLTRB(14, 11, 13, 11),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 5.h,
                        width: 5.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          boxShadow: [myBoxShadow],
                        ),
                        child: Image.asset(notificationLable),
                      ),
                      widthSpace10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dataItem['title'], style: blackRegular14),
                            heightSpace3,
                            Text(dataItem['subtitle'], style: colorA6Regular14),
                          ],
                        ),
                      )
                    ]),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).notification,
      ),
    );
  }

  Widget emptyNotificationScreen() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              emptyNotification,
              height: 4.2.h,
            ),
            heightSpace10,
            Text(translation(context).emptyNotificationMsg, style: colorA6SemiBold16),
          ],
        ),
      ),
    );
  }
}