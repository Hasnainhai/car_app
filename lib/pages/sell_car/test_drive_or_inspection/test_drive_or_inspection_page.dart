import 'package:fl_carmax/helper/ui_helper.dart';
import 'package:flutter/material.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class TestDriveOrInspectionPage extends StatelessWidget {
  final String pageFor;
  const TestDriveOrInspectionPage({Key? key, required this.pageFor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: bodyMethod(context),
    );
  }

  SingleChildScrollView bodyMethod(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carInfo(),
            heightSpace25,
            Text(translation(context).name, style: blackMedium14),
            heightSpace10,
            SecondaryTextField(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              hintText: translation(context).enterYourName,
            ),
            Text(translation(context).phoneNumber, style: blackMedium14),
            heightSpace10,
            SecondaryTextField(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              hintText: translation(context).enterPhoneNumber,
              keyboardType: TextInputType.number,
            ),
            Text(translation(context).location, style: blackMedium14),
            heightSpace10,
            PushNavigate(
              navigate: 'AddAddressPage',
              child: PrimaryContainer(
                padding:
                    const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                          '4517 Washington Ave. Manchester,Kentucky 39495',
                          maxLines: 2,
                          style: colorA6Medium14),
                    ),
                    const Expanded(child: SizedBox())
                  ],
                ),
              ),
            ),
            heightSpace25,
            Text(translation(context).date, style: blackMedium14),
            heightSpace10,
            SecondaryTextField(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              hintText: translation(context).enterDate,
            ),
            Text(translation(context).time, style: blackMedium14),
            heightSpace10,
            SecondaryTextField(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              hintText: translation(context).enterTime,
              textInputAction: TextInputAction.done,
            ),
            heightSpace15,
            PrimaryButton(
              title: pageFor == 'Testdrive'
                  ? translation(context).cancelTestDrive
                  : translation(context).cancelInspection,
              onTap: pageFor == 'Testdrive'
                  ? () {
                      UiHelper.showCancelDialog(
                          context, translation(context).cancelTestDrive);
                    }
                  : () {
                      UiHelper.showCancelDialog(
                          context, translation(context).cancelInspection);
                    },
            )
          ],
        ),
      ),
    );
  }

  PrimaryContainer carInfo() {
    return PrimaryContainer(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Row(children: [
        Image.asset(
          nissan1,
          height: 97,
        ),
        widthSpace20,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nissan Magnite', style: blackMedium16),
              heightSpace3,
              Text('฿5.44 lakh', style: primaryMedium14),
              heightSpace3,
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text('Diesel', style: colorA6Medium12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: VerticalDivider(
                        thickness: 1,
                        width: 10,
                        color: colorD9,
                      ),
                    ),
                    Text('48020km', style: colorA6Medium12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: VerticalDivider(
                        thickness: 1,
                        width: 10,
                        color: colorD9,
                      ),
                    ),
                    Text('2017', style: colorA6Medium12),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
          title: pageFor == 'Testdrive'
              ? translation(context).testDrive
              : translation(context).bookInspection),
    );
  }
}
