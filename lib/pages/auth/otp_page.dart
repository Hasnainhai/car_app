import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_carmax/bottom_navigation.dart';
import 'package:fl_carmax/pages/auth/register_page.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OtpPage({
    Key? key,
    required this.verificationId,
    required this.phone,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();
  bool isVerifying = false;

  Future<void> verifyOTP() async {
    setState(() => isVerifying = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone verified successfully')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
 
      // Navigate to home or dashboard
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
       
    } finally {
      setState(() => isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Verify ${widget.phone}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            PinCodeTextField(
              appContext: context,
              controller: _otpController,
              length: 6,
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(6),
                fieldHeight: 50,
                fieldWidth: 45,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                activeColor: primaryColor,
                selectedColor: primaryColor,
                inactiveColor: Colors.grey.shade400,
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              onCompleted: (v) {
                // Optional auto-submit here
              },
              onChanged: (value) {},
            ),
            const SizedBox(height: 30),
            PrimaryButton(
            //  navigate: 'RegisterPage',
              title: isVerifying ? 'Verifying...' : 'Verify',
              onTap: isVerifying ? null : verifyOTP,
            ),
          ],
        ),
      ),
    );
  }
}
