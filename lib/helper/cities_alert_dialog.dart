import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constant.dart';
import 'language_constant.dart';

class CitiesAlertDialog extends StatefulWidget {
  final String initialCity;
  const CitiesAlertDialog({Key? key, required this.initialCity})
      : super(key: key);

  @override
  State<CitiesAlertDialog> createState() => _CitiesAlertDialogState();
}

List citiesList = [
  'Surat',
  'Mumbai',
  'Delhi',
  'Hyderabad',
  'Pune',
  'Jaipur',
  'Ahmedabad',
  'Anand',
  'Jetpur',
  'Nagpur',
  'Vadodara',
  'Gaziyabad',
  'Agra',
  'Nashik'
];

class _CitiesAlertDialogState extends State<CitiesAlertDialog> {
  late String _selectedCity = widget.initialCity;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Column(
        children: [
          Text(translation(context).selectCity, style: blackMedium18),
        ],
      ),
      content: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                  children: List.generate(citiesList.length, (index) {
                var item = citiesList[index];
                return Padding(
                  padding: index == citiesList.length - 1
                      ? const EdgeInsets.only(left: 5, bottom: 0)
                      : const EdgeInsets.only(bottom: 0, left: 5),
                  child: SizedBox(
                    width: 60.w,
                    child: ListTile(
                        horizontalTitleGap: 0,
                        onTap: () {
                          setState(() {
                            _selectedCity = item;
                          });
                          Navigator.pop(context, _selectedCity);
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 2.7.h,
                              width: 2.7.h,
                              decoration: BoxDecoration(
                                color: _selectedCity == item
                                    ? primaryColor
                                    : white,
                                shape: BoxShape.circle,
                                boxShadow: _selectedCity == item
                                    ? [myPrimaryShadow]
                                    : [myBoxShadow],
                              ),
                            ),
                            const CircleAvatar(
                              backgroundColor: white,
                              radius: 4,
                            )
                          ],
                        ),
                        title: Text(item, style: blackRegular16)),
                  ),
                );
              })),
            ),
          )
        ],
      ),
    );
  }
}
