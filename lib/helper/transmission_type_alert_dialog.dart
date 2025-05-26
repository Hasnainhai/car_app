import 'package:fl_carmax/helper/language_constant.dart';
import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';

class TransmissionTypeAlertDialog extends StatefulWidget {
  final String? intialValue;
  const TransmissionTypeAlertDialog({Key? key, this.intialValue})
      : super(key: key);

  @override
  State<TransmissionTypeAlertDialog> createState() =>
      _TransmissionTypeAlertDialogState();
}

List transmissonList = ['Manual', 'Automatic'];

class _TransmissionTypeAlertDialogState
    extends State<TransmissionTypeAlertDialog> {
  String? _selectedTransmission;
  @override
  void initState() {
    _selectedTransmission = widget.intialValue;
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
            child: Text(translation(context).cbd6, style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: transmissonList.map(
            (e) {
              var index = transmissonList.indexOf(e);
              bool isSelected = _selectedTransmission == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedTransmission = e);
                  Navigator.pop(context, _selectedTransmission);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == transmissonList.length - 1
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
