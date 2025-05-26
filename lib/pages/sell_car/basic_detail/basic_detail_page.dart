import 'package:fl_carmax/helper/fuel_type_alert_dialog.dart';
import 'package:fl_carmax/helper/manufact_year_alert_dialog.dart';
import 'package:fl_carmax/helper/owner_types_alert_dialog.dart';
import 'package:fl_carmax/helper/state_alert_dialog.dart';
import 'package:fl_carmax/helper/transmission_type_alert_dialog.dart';

import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../../../helper/language_constant.dart';

class BasicDetailPage extends StatefulWidget {
  const BasicDetailPage({Key? key}) : super(key: key);

  @override
  State<BasicDetailPage> createState() => _BasicDetailPageState();
}

class _BasicDetailPageState extends State<BasicDetailPage> {
  String? ownerResult;
  String? yearResult;
  String? fuelResult;
  String? transmissionResult;
  String? stateResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMethod(),
        bottomSheet: bottomSheetMethod(context),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translation(context).cbd1, style: blackMedium14),
              heightSpace10,
              const SecondaryTextField(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(bottom: 20),
                hintText: 'Ex - DL03CW4269',
              ),
              Text(translation(context).cbd2, style: blackMedium14),
              heightSpace10,
              const SecondaryTextField(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(bottom: 20),
                hintText: 'Ex - 30,000kms',
              ),
              SecondaryContainer(
                  onTap: () async {
                    ownerResult = await showDialog(
                        context: context,
                        builder: (context) =>
                            OwnerTypesAlertDialog(intialValue: ownerResult));
                    setState(() {});
                  },
                  title: translation(context).cbd3,
                  hintText: ownerResult ?? translation(context).cbd3hintText),
              SecondaryContainer(
                  onTap: () async {
                    yearResult = await showDialog(
                        context: context,
                        builder: (context) => ManufactYearAlertDialog(
                              intialValue: yearResult,
                            ));
                    setState(() {});
                  },
                  title: translation(context).cbd4,
                  hintText: yearResult ?? translation(context).cbd4hintText),
              SecondaryContainer(
                  onTap: () async {
                    fuelResult = await showDialog(
                        context: context,
                        builder: (context) => FuelTypeAlertDialog(
                              intialValue: fuelResult,
                            ));
                    setState(() {});
                  },
                  title: translation(context).cbd5,
                  hintText: fuelResult ?? translation(context).cbd5hintText),
              SecondaryContainer(
                  onTap: () async {
                    transmissionResult = await showDialog(
                        context: context,
                        builder: (context) => TransmissionTypeAlertDialog(
                              intialValue: transmissionResult,
                            ));
                    setState(() {});
                  },
                  title: translation(context).cbd6,
                  hintText:
                      transmissionResult ?? translation(context).cbd6hintText),
              SecondaryContainer(
                  onTap: () async {
                    stateResult = await showDialog(
                        context: context,
                        builder: (context) => StateAlertDialog(
                              intialValue: stateResult,
                            ));
                    setState(() {});
                  },
                  title: translation(context).cbd7,
                  hintText: stateResult ?? translation(context).cbd7hintText),
              heightSpace60,
            ],
          ),
        )));
  }

  Widget bottomSheetMethod(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0).copyWith(top: 10),
          child: PrimaryButton(
            title: translation(context).next,
            onTap: () => Navigator.pushNamed(context, '/BasicDetailPage2'),
          ),
        )
      ],
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
