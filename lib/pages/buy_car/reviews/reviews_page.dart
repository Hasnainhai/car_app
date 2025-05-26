import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map reviews = {
      'Leslie Alexander': review1,
      'Bessie Cooper': review2,
      'Jerome Bell': review3,
      'Darlene Robertson': review4,
      'Ralph Edwards': review5,
      'Marvin McKinney': review6,
    };

    return Scaffold(
        appBar: appBarMethod(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                        children: List.generate(
                      reviews.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colorA6.withOpacity(.10),
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                    reviews.values.toList()[index],
                                  ),
                                ),
                                widthSpace10,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reviews.keys.toList()[index],
                                        style: blackRegular16),
                                    Text('19 july 2022',
                                        style: colorA6Medium12),
                                  ],
                                )
                              ],
                            ),
                            heightSpace15,
                            Text(
                                'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Velit Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                                style: colorA6Medium12)
                          ],
                        ),
                      ),
                    ))),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(color: white, boxShadow: [myBoxShadow]),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: primaryColor,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: translation(context).writeYourReview,
                        hintStyle: color94Medium16,
                      ),
                    ),
                  ),
                  widthSpace10,
                  Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_outlined,
                      color: white,
                      size: 2.h,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).review,
      ),
    );
  }
}
