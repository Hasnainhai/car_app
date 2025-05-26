import 'package:flutter/material.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class OwnerDetailsPage extends StatelessWidget {
  const OwnerDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          SecondaryTextField(
            prefixIcon: userIcon,
            hintText: translation(context).enterYourName,
          ),
          SecondaryTextField(
            prefixIcon: mailIcon,
            hintText: translation(context).enterYourEmailId,
            keyboardType: TextInputType.emailAddress,
          ),
          SecondaryTextField(
            prefixIcon: mobileIcon,
            hintText: translation(context).enterMobileNumber,
            keyboardType: TextInputType.number,
          ),
          SecondaryTextField(
            prefixIcon: locationIcon,
            hintText: translation(context).enterYourAddress,
          ),
          SecondaryTextField(
            prefixIcon: locationIcon,
            hintText: translation(context).enterYourCity,
          ),
          SecondaryTextField(
            prefixIcon: locationIcon,
            hintText: translation(context).enterYourPincode,
            textInputAction: TextInputAction.done,
          ),
          heightSpace60,
          PrimaryButton(
            navigate: 'CheckOutPage',
            title: translation(context).conti,
          ),
          heightSpace20,
        ],
      ),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).ownerDetail,
      ),
    );
  }
}
