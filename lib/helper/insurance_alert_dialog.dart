// class InsuranceAlertDialog extends StatelessWidget {
import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';
import 'language_constant.dart';

class InsuranceAlertDialog extends StatefulWidget {
  final String? intialValue;
  const InsuranceAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<InsuranceAlertDialog> createState() => _InsuranceAlertDialogState();
}

List insuranceTypeList = [
  'Comprehensive',
  'Third party',
  'Zero depreciation',
  'Expired'
];

class _InsuranceAlertDialogState extends State<InsuranceAlertDialog> {
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
                Text(translation(context).insuranceType, style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: insuranceTypeList.map(
            (e) {
              var index = insuranceTypeList.indexOf(e);
              bool isSelected = _selectedCondition == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedCondition = e);
                  Navigator.pop(context, _selectedCondition);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == insuranceTypeList.length - 1
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
