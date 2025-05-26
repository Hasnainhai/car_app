import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class BookInspectionPage extends StatelessWidget {
  const BookInspectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryContainer(
                width: 100.w,
                child: Column(
                  children: [
                    Container(
                      height: 83,
                      width: 100.w,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                              image: AssetImage(paperSpray),
                              fit: BoxFit.cover)),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(translation(context).congretulations,
                                style: blackSemiBold20),
                          )),
                    ),
                    heightSpace12,
                    const Text(
                      '฿2,43,000',
                      style: TextStyle(
                          fontSize: 40, color: primaryColor, fontFamily: 'M'),
                    ),
                    heightSpace20,
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 55),
                      padding:
                          const EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                      decoration: BoxDecoration(
                        color: const Color(0xffC09300),
                        borderRadius: myBorderRadius10,
                      ),
                      child: Text(translation(context).assuredBestCarPrice,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: whiteSemiBold16),
                    ),
                    heightSpace45,
                    heightSpace2,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Text(
                        translation(context).thisIsNotFinalPrice,
                        style: colorA6Medium12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    heightSpace10
                  ],
                ),
              ),
              heightSpace60,
              PrimaryButton(
                title: translation(context).bookInspection,
                onTap: () => Navigator.pushNamed(
                    context, '/BookInspectionWithLocationPage'),
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
        title: translation(context).bookInspection,
      ),
    );
  }
}
