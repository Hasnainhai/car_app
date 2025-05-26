
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constant.dart';
import 'language_constant.dart';

class UiHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Container(
            width: 100.w,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: primaryColor),
                heightSpace20,
                Text(
                  title,
                  style: primaryMedium16,
                ),
              ],
            )),
      ),
    );
  }

  static void showCancelDialog(BuildContext context, String title) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              actionsPadding: EdgeInsets.zero,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: blackMedium16),
                ],
              ),
              actions: [
                ...List.generate(
                    2,
                    (index) => TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(index == 0
                                ? colorD9.withOpacity(1)
                                : primaryColor.withOpacity(.3))),
                        onPressed: () {
                          Navigator.pop(context, index == 0 ? false : true);
                        },
                        child: Text(
                            index == 0
                                ? translation(context).no
                                : translation(context).yes,
                            style: index == 0
                                ? color94Medium16
                                : primaryMedium16))),
                const SizedBox(width: 10)
              ],
            ));
  }

  // static void showLogOutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             margin: const EdgeInsets.symmetric(horizontal: 40),
  //             child: Text(
  //               translation(context).areYouSureSignout,
  //               style: blackMedium16,
  //               maxLines: 2,
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           heightSpace30,
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => Navigator.pop(context),
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(vertical: 10),
  //                     decoration: BoxDecoration(
  //                       color: white,
  //                       borderRadius: BorderRadius.circular(10),
  //                       boxShadow: [myBoxShadow],
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         translation(context).cancel,
  //                         style: const TextStyle(
  //                           color: primaryColor,
  //                           fontFamily: 'M',
  //                           fontSize: 18,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               widthSpace20,
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: ()async {
  //                     await FirebaseAuth.instance.signOut();
  //                     Navigator.popUntil(context, (route) => route.isFirst);
  //                     Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPageEmail()));
  //                    // Navigator.pushReplacementNamed(context, '/LoginPage');
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(vertical: 10),
  //                     decoration: BoxDecoration(
  //                       color: primaryColor,
  //                       borderRadius: BorderRadius.circular(10),
  //                       boxShadow: [myPrimaryShadow],
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         translation(context).profileItem8,
  //                         style: const TextStyle(
  //                           color: white,
  //                           fontFamily: 'M',
  //                           fontSize: 18,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           )
  //         ],
  //       ),
  //       // actions: [
  //       //   PrimaryButton(
  //       //     title: 'Logout',
  //       //   )
  //       // ],
  //     ),
  //   );
  // }
  static void showLogOutDialog(BuildContext context, {required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              translation(context).areYouSureSignout,
              style: blackMedium16,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          heightSpace30,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [myBoxShadow],
                    ),

                    child: Center(
                      child: Text(
                        translation(context).cancel,
                        style: const TextStyle(
                          color: primaryColor,
                          fontFamily: 'M',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              widthSpace20,
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm, // ✅ Trigger your callback
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        translation(context).profileItem8,
                        style: const TextStyle(
                          color: white,
                          fontFamily: 'M',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

}
