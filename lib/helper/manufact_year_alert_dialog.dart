import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';
import 'language_constant.dart';

class ManufactYearAlertDialog extends StatefulWidget {
  final String? intialValue;
  const ManufactYearAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<ManufactYearAlertDialog> createState() =>
      _ManufactYearAlertDialogState();
}

List yearList = [];

class _ManufactYearAlertDialogState extends State<ManufactYearAlertDialog> {
  String? _selectedYear;
  @override
  void initState() {
    _selectedYear = widget.intialValue;
    yearList.clear();
    for (int i = 2022; i >= 2013; i--) {
      yearList.add(i.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Center(
                child: Text(translation(context).manufacturingYear,
                    style: whiteMedium16)),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: yearList.map(
                    (e) {
                      var index = yearList.indexOf(e);
                      bool isSelected = _selectedYear == e;
                      return PrimaryContainer(
                        onTap: () {
                          setState(() => _selectedYear = e);
                          Navigator.pop(context, _selectedYear);
                        },
                        boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                        border:
                            isSelected ? Border.all(color: primaryColor) : null,
                        margin: index == 0
                            ? const EdgeInsets.all(20)
                            : index == yearList.length - 1
                                ? const EdgeInsets.symmetric(horizontal: 20)
                                    .copyWith(bottom: 20)
                                : const EdgeInsets.symmetric(horizontal: 20)
                                    .copyWith(bottom: 20),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        width: double.infinity,
                        child: Center(
                            child: Text(e,
                                style: isSelected
                                    ? primaryMedium14
                                    : colorA6Medium14)),
                      );
                    },
                  ).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
