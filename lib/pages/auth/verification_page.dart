import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../helper/language_constant.dart';
import '../../helper/ui_helper.dart';
import '../../utils/constant.dart';
import '../../utils/widgets.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

final defaultPinTheme = PinTheme(
  width: 5.5.h,
  height: 5.5.h,
  textStyle:
      const TextStyle(fontSize: 18, color: primaryColor, fontFamily: 'SB'),
  decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: colorD9, width: 2))),
  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: const Border(bottom: BorderSide(color: primaryColor, width: 2)),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    border: const Border(bottom: BorderSide(color: primaryColor, width: 2)),
  ),
);

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController pinController = TextEditingController();
  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Center(
                        child: Column(
                      children: [
                        Image.asset(appLogo, height: 13.h),
                        heightSpace20,
                        heightSpace3,
                        Text(
                          translation(context).otpVerification,
                          style: primarySemiBold20,
                          textAlign: TextAlign.center,
                        ),
                        heightSpace10,
                        heightSpace2,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            translation(context).otpVerificationSubtitle,
                            style: color94Medium14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        heightSpace40,
                        Pinput(
                            controller: pinController,
                            length: 4,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            onCompleted: (pin) {
                              UiHelper.showLoadingDialog(
                                  context, translation(context).pleaseWait);
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacementNamed(
                                    context, '/BottomNavigation');
                              });
                            }),
                        heightSpace60,
                        PrimaryButton(
                          title: translation(context).verify,
                          onTap: () {
                            UiHelper.showLoadingDialog(
                                context, translation(context).pleaseWait);
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacementNamed(
                                  context, '/BottomNavigation');
                            });
                          },
                        ),
                        heightSpace20,
                        Text(translation(context).reSend,
                            style: primaryMedium14)
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
