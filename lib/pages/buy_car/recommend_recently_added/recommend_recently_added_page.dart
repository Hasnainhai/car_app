import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';

class RecommendRecentlyAddedPage extends StatefulWidget {
  final int pageWithLogic;
  const RecommendRecentlyAddedPage({Key? key, required this.pageWithLogic})
      : super(key: key);

  @override
  State<RecommendRecentlyAddedPage> createState() =>
      _RecommendRecentlyAddedPageState();
}

List _recentyAddedCarList = [
  {
    'image': recommended1,
    'title': 'Maruti Baleno',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2017',
  },
  {
    'image': recentyAdded1,
    'title': 'Maruti suzuki alto K10',
    'subtitle': '฿6.40 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2016',
  },
  {
    'image': recommended3,
    'title': 'Honda city',
    'subtitle': '฿8.52 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2018',
  },
  {
    'image': recentyAdded3,
    'title': 'Maruti suzuki swift',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2015',
  },
  {
    'image': recommended2,
    'title': 'Audi a8',
    'subtitle': '฿2.52 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2020',
  },
  {
    'image': recentyAdded1,
    'title': 'Mercedes-BenzEQS',
    'subtitle': '฿7.35 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2016',
  },
];
List _recommendedList = [
  {
    'image': recommended1,
    'title': 'Maruti Baleno',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2017',
  },
  {
    'image': recentyAdded1,
    'title': 'Maruti suzuki alto K10',
    'subtitle': '฿6.40 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2016',
  },
  {
    'image': recommended3,
    'title': 'Honda city',
    'subtitle': '฿8.52 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2018',
  },
  {
    'image': recentyAdded3,
    'title': 'Maruti suzuki swift',
    'subtitle': '฿5.44 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2015',
  },
  {
    'image': recommended2,
    'title': 'Audi a8',
    'subtitle': '฿2.52 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2020',
  },
  {
    'image': recentyAdded1,
    'title': 'Mercedes-BenzEQS',
    'subtitle': '฿7.35 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2016',
  },
  {
    'image': recommended2,
    'title': 'Audi a8',
    'subtitle': '฿2.52 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2020',
  },
  {
    'image': recentyAdded1,
    'title': 'Mercedes-BenzEQS',
    'subtitle': '฿7.35 lakh',
    'fueltype': 'Diesel',
    'km': '48020km',
    'year': '2016',
  },
];

class _RecommendRecentlyAddedPageState
    extends State<RecommendRecentlyAddedPage> {
  final Set _favourites = {3};
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    bool isArabic = myLocale == const Locale('ar');
    return Scaffold(
      appBar: appBarMethod(),
      body: bodyMethod(isArabic),
    );
  }

  GridView bodyMethod(bool isArabic) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.pageWithLogic == 0
          ? _recentyAddedCarList.length
          : _recommendedList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4.25,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20),
      itemBuilder: (context, index) {
        var item = widget.pageWithLogic == 0
            ? _recentyAddedCarList[index]
            : _recommendedList[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/CarDetailPage'),
          child: Container(
            width: 184,
            decoration: BoxDecoration(
                color: white,
                borderRadius: myBorderRadius10,
                boxShadow: [myBoxShadow]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: colorF4,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: isArabic
                            ? const EdgeInsets.only(top: 7, left: 8)
                            : const EdgeInsets.only(top: 7, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _favourites.contains(index)
                                  ? _favourites.remove(index)
                                  : _favourites.add(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: primaryColor,
                                duration: const Duration(seconds: 1),
                                content: Text(
                                  _favourites.contains(index)
                                      ? '${item['title']} ${translation(context).addedFav}'
                                      : '${item['title']} ${translation(context).removedFav}',
                                  style: whiteMedium14,
                                )));
                          },
                          child: Icon(
                            _favourites.contains(index)
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: _favourites.contains(index)
                                ? primaryColor
                                : colorA6,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Image.asset(
                          item['image'],
                          width: 184,
                          height: 100,
                        ),
                      ),
                      heightSpace25,
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'], style: blackMedium14),
                      Text(item['subtitle'], style: primaryMedium14),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text(item['fueltype'], style: colorA6Medium12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: VerticalDivider(
                                thickness: 1,
                                width: 10,
                                color: colorD9,
                              ),
                            ),
                            Text(item['km'], style: colorA6Medium12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSize appBarMethod() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
          title: widget.pageWithLogic == 0
              ? translation(context).recentlyAddedCar
              : translation(context).recommendedForYou),
    );
  }
}
