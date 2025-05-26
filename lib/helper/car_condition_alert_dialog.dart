import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';
import 'language_constant.dart';

class CarConditionAlertDialog extends StatefulWidget {
  final String? intialValue;
  const CarConditionAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<CarConditionAlertDialog> createState() =>
      _CarConditionAlertDialogState();
}

List conditionTypeList = ['Fair', 'Good', 'Very good', 'Excellent'];

class _CarConditionAlertDialogState extends State<CarConditionAlertDialog> {
  String? _selectedCondition;
  @override
  void initState() {
    _selectedCondition = widget.intialValue;
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
            child:
                Text(translation(context).carCondition, style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: conditionTypeList.map(
            (e) {
              var index = conditionTypeList.indexOf(e);
              bool isSelected = _selectedCondition == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedCondition = e);
                  Navigator.pop(context, _selectedCondition);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == conditionTypeList.length - 1
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
