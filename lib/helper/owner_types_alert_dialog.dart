import 'package:fl_carmax/helper/language_constant.dart';
import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';

class OwnerTypesAlertDialog extends StatefulWidget {
  final String? intialValue;
  const OwnerTypesAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<OwnerTypesAlertDialog> createState() => _OwnerTypesAlertDialogState();
}

List ownerList = ['1st owner', '2nd owner', '3rd owner', '4th owner'];

class _OwnerTypesAlertDialogState extends State<OwnerTypesAlertDialog> {
  String? _selectedOwner;
  @override
  void initState() {
    _selectedOwner = widget.intialValue;
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
            child: Text(translation(context).cbd3, style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ownerList.map(
            (e) {
              var index = ownerList.indexOf(e);
              bool isSelected = _selectedOwner == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedOwner = e);
                  Navigator.pop(context, _selectedOwner);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == ownerList.length - 1
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
