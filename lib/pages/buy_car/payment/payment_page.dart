import 'package:fl_carmax/helper/language_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: Column(
        children: [
          heightSpace20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CreditCardWidget(
              backgroundImage: creditCardBg,
              cardBgColor: white,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardType: CardType.visa,
              onCreditCardWidgetChange: (e) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CreditCardForm(
              cursorColor: primaryColor,
              textColor: colorA6,
              formKey: formKey,
              onCreditCardModelChange: onCreditCardModelChange,
              obscureCvv: true,
              obscureNumber: true,
              cardHolderDecoration: InputDecoration(
                labelText: translation(context).cardName,
                hintText: translation(context).cardName,
                hintStyle: colorA6Medium15,
                labelStyle: blackMedium16,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
              ),
              cardNumberDecoration: InputDecoration(
                // fillColor: color23,
                labelText: translation(context).cardNumber,
                hintText: translation(context).cardNumber,
                hintStyle: colorA6Medium15,
                labelStyle: blackMedium16,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
              ),
              expiryDateDecoration: InputDecoration(
                labelText: translation(context).expiryDate,
                hintText: translation(context).expiryDate,
                hintStyle: colorA6Medium15,
                labelStyle: blackMedium16,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
              ),
              cvvCodeDecoration: InputDecoration(
                labelText: translation(context).cvv,
                hintText: translation(context).cvv,
                hintStyle: colorA6Medium15,
                labelStyle: blackMedium16,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
              ),
              cardHolderName: '',
              cardNumber: '',
              cvvCode: '',
              expiryDate: '',
              themeColor: white,
            ),
          ),
          heightSpace40,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryButton(
              title: translation(context).conti,
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, '/BottomNavigation');
                Navigator.pushReplacementNamed(context, '/PaymentSucessPage',
                    arguments: 0);
              },
            ),
          )
        ],
      ),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).creditCard,
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
