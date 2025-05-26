// class OwnershipTypeAlertDialog extends StatelessWidget {
import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/widgets.dart';

class LoanAlertDialog extends StatefulWidget {
  final String? intialValue;
  const LoanAlertDialog({Key? key, this.intialValue}) : super(key: key);

  @override
  State<LoanAlertDialog> createState() => _LoanAlertDialogState();
}

List loanList = ['Yes', 'No'];

class _LoanAlertDialogState extends State<LoanAlertDialog> {
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
        child: Center(child: Text('Car condiion', style: whiteMedium16)),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: loanList.map(
            (e) {
              var index = loanList.indexOf(e);
              bool isSelected = _selectedCondition == e;
              return PrimaryContainer(
                onTap: () {
                  setState(() => _selectedCondition = e);
                  Navigator.pop(context, _selectedCondition);
                },
                boxSadow: [isSelected ? myBoxShadow : myPrimaryShadow],
                border: isSelected ? Border.all(color: primaryColor) : null,
                margin: index == loanList.length - 1
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
