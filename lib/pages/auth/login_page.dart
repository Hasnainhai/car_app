import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_carmax/helper/language_constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../utils/constant.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PhoneNumber? phoneNumber;
  String verificationId = '';
  bool isLoading = false;

  Future<void> sendOTP() async {
    if (phoneNumber == null || phoneNumber!.phoneNumber == null) {
      showMessage("Please enter a valid phone number");
      return;
    }

    setState(() => isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber!.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setState(() => isLoading = false);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => isLoading = false);
        showMessage("Verification failed: ${e.message}");
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(
              verificationId: verificationId,
              phone: phoneNumber!.phoneNumber!,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heightSpace80,
              heightSpace25,
              heightSpace2,
              Image.asset(
                appLogo,
                height: 150,
              ),
              heightSpace20,
              heightSpace3,
              Text(
                translation(context).login,
                style: primarySemiBold20,
                textAlign: TextAlign.center,
              ),
              heightSpace10,
              heightSpace2,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  translation(context).loginSubtitle,
                  style: color94Medium14,
                  textAlign: TextAlign.center,
                ),
              ),
              heightSpace60,
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(() => phoneNumber = number);
                },
                onInputValidated: (bool value) {},
                initialValue: PhoneNumber(isoCode: 'TH'),
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true,
                  showFlags: false,
                  useEmoji: false,
                ),
                countries: ['TH'],
                inputDecoration: InputDecoration(
                  hintText: translation(context).enterMobileNumber,
                  hintStyle: color94Medium15,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorD9, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorD9, width: 2),
                  ),
                ),
                textStyle: color94Medium15,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: blackMedium15,
                formatInput: true,
                keyboardType: TextInputType.number,
                inputBorder: InputBorder.none,
                onSaved: (PhoneNumber number) {},
              ),
              heightSpace60,
              PrimaryButton(
                title: isLoading ? "Sending..." : translation(context).login,
                onTap: isLoading ? null : sendOTP,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
