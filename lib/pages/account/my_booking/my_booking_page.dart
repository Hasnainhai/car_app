import 'package:fl_carmax/helper/column_builder.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/widgets.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  @override
  Widget build(BuildContext context) {
    List myBookingList = [
      {
        'type': translation(context).testDrive,
        'data': [
          {
            'image': nissan1,
            'name': 'Nissan Magnite',
            'price': '฿5.44 lakh',
            'fuelType': 'Diesel',
            'kmDriven': '48020km',
            'year': '2017',
          },
          {
            'image': nissan2,
            'name': 'Nissan Magnite',
            'price': '฿7.44 lakh',
            'fuelType': 'Diesel',
            'kmDriven': '48020km',
            'year': '2016',
          },
        ]
      },
      {
        'type': translation(context).bookInspection,
        'data': [
          {
            'image': nissan8,
            'name': 'Nissan Magnite',
            'price': '฿5.20 lakh',
            'fuelType': 'Diesel',
            'kmDriven': '48020km',
            'year': '2015',
          },
        ]
      },
    ];

    return Scaffold(
        appBar: appBarMethod(),
        body: ListView.builder(
          itemCount: myBookingList.length,
          itemBuilder: (context, index) {
            final item = myBookingList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: index == 0
                      ? const EdgeInsets.symmetric(horizontal: 20)
                          .copyWith(top: 20, bottom: 15)
                      : item['data'].isNotEmpty
                          ? const EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(bottom: 15, top: 5)
                          : EdgeInsets.zero,
                  child: myBookingList[index]['data'].isNotEmpty
                      ? Text(item['type'], style: blackMedium16)
                      : null,
                ),
                ColumnBuilder(
                  itemCount: item['data'].length,
                  itemBuilder: (BuildContext context, int index) {
                    final dataItem = item['data'][index];
                    return PrimaryContainer(
                      margin: const EdgeInsets.symmetric(horizontal: 20)
                          .copyWith(bottom: 20),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
                      child: Row(
                        children: [
                          Image.asset(
                            dataItem['image'],
                            height: 9.8.h,
                            width: 16.h,
                          ),
                          widthSpace24,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dataItem['name'], style: blackMedium16),
                                heightSpace3,
                                Text(dataItem['price'], style: primaryMedium14),
                                heightSpace3,
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Text('Diesel', style: colorA6Medium12),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: VerticalDivider(
                                          thickness: 1,
                                          width: 10,
                                          color: colorD9,
                                        ),
                                      ),
                                      Text('48020km', style: colorA6Medium12),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: VerticalDivider(
                                          thickness: 1,
                                          width: 10,
                                          color: colorD9,
                                        ),
                                      ),
                                      Text(dataItem['year'],
                                          style: colorA6Medium12),
                                    ],
                                  ),
                                ),
                                heightSpace20,
                                GestureDetector(
                                  onTap: () {
                                    if (item['type'] == 'Testdrive') {
                                      Navigator.pushNamed(
                                          context, '/TestDriveOrInspectionPage',
                                          arguments: 'testDrive');
                                    } else {
                                      Navigator.pushNamed(context,
                                          '/TestDriveOrInspectionPage');
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.5, vertical: 5.5),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(translation(context).goDetail,
                                        style: whiteSemiBold14),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ));
  }

  PreferredSize appBarMethod() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(title: translation(context).profileItem2),
    );
  }
}
