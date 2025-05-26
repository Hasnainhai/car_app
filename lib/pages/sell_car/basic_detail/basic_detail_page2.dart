import 'package:fl_carmax/helper/insurance_alert_dialog.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:flutter/material.dart';

import '../../../helper/car_condition_alert_dialog.dart';
import '../../../helper/language_constant.dart';
import '../../../helper/loan_alert_dialog.dart';
import '../../../helper/owner_types_alert_dialog.dart';
import '../../../utils/widgets.dart';

class BasicDetailPage2 extends StatefulWidget {
  const BasicDetailPage2({Key? key}) : super(key: key);

  @override
  State<BasicDetailPage2> createState() => _BasicDetailPage2State();
}

class _BasicDetailPage2State extends State<BasicDetailPage2> {
  String? conditionResult;
  String? insuranceResult;
  String? loanResult;
  String? ownerShipResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SecondaryContainer(
                  onTap: () async {
                    conditionResult = await showDialog(
                        context: context,
                        builder: (context) => CarConditionAlertDialog(
                            intialValue: conditionResult));
                    setState(() {});
                  },
                  title: translation(context).cbd8,
                  hintText:
                      conditionResult ?? translation(context).cbd8hintText),
              SecondaryContainer(
                  onTap: () async {
                    insuranceResult = await showDialog(
                        context: context,
                        builder: (context) =>
                            InsuranceAlertDialog(intialValue: insuranceResult));
                    setState(() {});
                  },
                  title: translation(context).cbd9,
                  hintText:
                      insuranceResult ?? translation(context).cbd9hintText),
              SecondaryContainer(
                  onTap: () async {
                    loanResult = await showDialog(
                        context: context,
                        builder: (context) =>
                            LoanAlertDialog(intialValue: loanResult));
                    setState(() {});
                  },
                  title: translation(context).cbd10,
                  hintText: loanResult ?? translation(context).cbd10hintText),
              SecondaryContainer(
                  onTap: () async {
                    ownerShipResult = await showDialog(
                        context: context,
                        builder: (context) => OwnerTypesAlertDialog(
                            intialValue: ownerShipResult));
                    setState(() {});
                  },
                  title: translation(context).cbd11,
                  hintText:
                      ownerShipResult ?? translation(context).cbd11hintText),
              heightSpace40,
              PrimaryButton(
                title: translation(context).next,
                onTap: () => Navigator.pushNamed(context, '/ContactDetailPage'),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize appBarMethod() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).carBasicDetail,
      ),
    );
  }
}
