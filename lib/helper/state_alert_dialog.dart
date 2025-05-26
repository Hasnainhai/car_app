import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';
import 'language_constant.dart';

class StateAlertDialog extends StatefulWidget {
  final String? intialValue;
  const StateAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<StateAlertDialog> createState() => _StateAlertDialogState();
}

List stateList = [
  'Delhi',
  'Gujrat',
  'Maharashtra',
  'Haryana',
  'Karnataka',
  'Andhra Pradesh',
  'Uttar Pradesh',
  'Rajasthan',
  'Punjab',
];

class _StateAlertDialogState extends State<StateAlertDialog> {
  String? _selectedState;
  @override
  void initState() {
    _selectedState = widget.intialValue;
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
            child: Text(translation(context).carRegistrationState,
                style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: stateList.map(
            (e) {
              var index = stateList.indexOf(e);
              bool isSelected = _selectedState == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedState = e);
                  Navigator.pop(context, _selectedState);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == stateList.length - 1
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
