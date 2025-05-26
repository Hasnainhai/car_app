import 'package:fl_carmax/pages/buy_car/search/search_page.dart';
import 'package:flutter/material.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: bodyMethod(),
    );
  }

  GridView bodyMethod() {
    List popularBrandList = [
      brand2,
      brand7,
      brand8,
      brand5,
      brand9,
      brand10,
      brand3,
      brand11,
      brand12,
      brand6,
      brand4,
      brand13,
      brand14,
      brand15,
      brand1,
      brand16,
      brand17,
      brand18,
    ];
    return GridView.builder(
      itemCount: popularBrandList.length,
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () =>
          // Navigator.pushNamed(context, '/BrandRelatedCarsPage'),
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SearchPage())),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: white,
                borderRadius: myBorderRadius10,
                boxShadow: [myBoxShadow]),
            child: Image.asset(popularBrandList[index]),
          ),
        );
      },
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(title: translation(context).brand),
    );
  }
}
