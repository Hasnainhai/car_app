import 'package:fl_carmax/helper/language_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  contact,
                  height: 8.3.h,
                ),
              ),
              heightSpace20,
              Text(
                'Amet minim mollit non deserunt ullamco est sit dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
                style: colorA6Regular14,
                textAlign: TextAlign.center,
              ),
              heightSpace30,
              Text(translation(context).name, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(bottom: 30),
                hintText: translation(context).enterYourName,
              ),
              Text(translation(context).phoneNumber, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(bottom: 30),
                hintText: translation(context).enterPhoneNumber,
              ),
              heightSpace40,
              heightSpace2,
              PrimaryButton(
                title: translation(context).next,
                onTap: () => Navigator.pushNamed(context, '/AddAddressPage',
                    arguments: false),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).contactDetails,
      ),
    );
  }
}
