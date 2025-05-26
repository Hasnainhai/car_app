import 'package:fl_carmax/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/widgets.dart';

class BrandRelatedCarsPage extends StatefulWidget {
  const BrandRelatedCarsPage({Key? key}) : super(key: key);

  @override
  State<BrandRelatedCarsPage> createState() => _BrandRelatedCarsPageState();
}

List _carList = [
  {
    'image': nissan1,
    'title': 'Nissan Magnite',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2017',
  },
  {
    'image': nissan2,
    'title': 'Nissan Kicks',
    'subtitle': '฿7.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2018',
  },
  {
    'image': nissan3,
    'title': 'Nissan Sentra',
    'subtitle': '฿5.44 lakh',
    'fueltype': '฿2.79 lakh',
    'km': '48020km',
    'year': '2016',
  },
  {
    'image': nissan4,
    'title': 'Nissan Sunny',
    'subtitle': '฿6.40 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2014',
  },
  {
    'image': nissan5,
    'title': 'Nissan GT-R',
    'subtitle': '฿8.42 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2015',
  },
  {
    'image': nissan6,
    'title': 'Nissan Terrano',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2016',
  },
  {
    'image': nissan7,
    'title': 'Nissan Micra',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2015',
  },
  {
    'image': nissan2,
    'title': 'Nissan GTR',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2017',
  },
];

class _BrandRelatedCarsPageState extends State<BrandRelatedCarsPage> {
  final Set _favourite = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMethod(),
        body: ListView.builder(
          itemCount: _carList.length,
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            var item = _carList[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/CarDetailPage'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: index == _carList.length - 1
                        ? EdgeInsets.zero
                        : const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: myBorderRadius10,
                      color: white,
                      boxShadow: [myBoxShadow],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          item['image'],
                          height: 109,
                          width: 38.w,
                        ),
                        widthSpace20,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'], style: blackMedium14),
                              Text(item['subtitle'], style: primaryMedium14),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text(item['fueltype'],
                                        style: colorA6Medium12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: VerticalDivider(
                                        thickness: 1,
                                        width: 10,
                                        color: colorD9,
                                      ),
                                    ),
                                    Text(item['km'], style: colorA6Medium12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: VerticalDivider(
                                        thickness: 1,
                                        width: 10,
                                        color: colorD9,
                                      ),
                                    ),
                                    Text(item['year'], style: colorA6Medium12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _favourite.contains(index)
                              ? _favourite.remove(index)
                              : _favourite.add(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: primaryColor,
                            duration: const Duration(seconds: 1),
                            content: Text(
                              _favourite.contains(index)
                                  ? '${item['title']} ${translation(context).addedFav}'
                                  : '${item['title']} ${translation(context).removedFav}',
                              style: whiteMedium14,
                            )));
                      },
                      child: Icon(
                        _favourite.contains(index)
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color:
                            _favourite.contains(index) ? primaryColor : colorA6,
                        size: 2.5.h,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  PreferredSize appBarMethod() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: CustomAppBar(title: 'Nissan'),
    );
  }
}
