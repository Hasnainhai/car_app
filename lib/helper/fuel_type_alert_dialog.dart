import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';
import 'language_constant.dart';

class FuelTypeAlertDialog extends StatefulWidget {
  final String? intialValue;
  const FuelTypeAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<FuelTypeAlertDialog> createState() => _FuelTypeAlertDialogState();
}

List fuelTypeList = ['Petrol', 'Diesel', 'CNG'];

class _FuelTypeAlertDialogState extends State<FuelTypeAlertDialog> {
  String? _selectedFuelType;
  @override
  void initState() {
    _selectedFuelType = widget.intialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: Center(
            child: Text(translation(context).fuelType, style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: fuelTypeList.map(
            (e) {
              var index = fuelTypeList.indexOf(e);
              bool isSelected = _selectedFuelType == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedFuelType = e);
                  Navigator.pop(context, _selectedFuelType);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == fuelTypeList.length - 1
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                child: Center(
                    child: Text(e,
                        style: isSelected ? primaryMedium14 : colorA6Medium14)),
              );
            },
          ).toList()),
    );
  }
}
