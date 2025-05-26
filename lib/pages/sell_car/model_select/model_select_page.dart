import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class ModelSelectPage extends StatefulWidget {
  const ModelSelectPage({Key? key}) : super(key: key);

  @override
  State<ModelSelectPage> createState() => _ModelSelectPageState();
}

List modelList = [
  'Nissan Magnita',
  'Nissan Murano',
  'Nishan kiks',
  'Nissan Terra',
  'Nissan Livina',
  'Nissan Armada',
  'Nissan GT-R',
  'Nissan Rogue',
  'Nissan Juke',
  'Nissan X-Trail',
  'Nissan X-Trail',
  'Nissan Elgrand',
  'Nissan Navara',
  'Nissan Leaf',
];

class _ModelSelectPageState extends State<ModelSelectPage> {
  int _selectedModel = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: bottomSheetMethod(),
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...appBarMethod(context), scrollableMethod()],
          )),
    );
  }

  Widget bottomSheetMethod() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0).copyWith(top: 10),
          child: PrimaryButton(
            title: translation(context).next,
            onTap: () => Navigator.pushNamed(context, '/BasicDetailPage'),
          ),
        )
      ],
    );
  }

  Expanded scrollableMethod() {
    return Expanded(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('${translation(context).allModels}(16)',
                style: blackSemiBold16),
          ),
          heightSpace20,
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = modelList[index];
                bool isSelected = _selectedModel == index;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        dense: true,
                        // contentPadding: EdgeInsets.zero,
                        onTap: () => setState(() => _selectedModel = index),
                        leading: Text(item,
                            style: isSelected
                                ? primaryRegular16
                                : blackRegular16)),
                    index == modelList.length - 1
                        ? Divider(
                            color:
                                isSelected ? primaryColor : const Color(0xffEFEFEF),
                            thickness: 2,
                          )
                        : const SizedBox()
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: _selectedModel == index
                      ? primaryColor
                      : const Color(0xffEFEFEF),
                  thickness: 2,
                );
              },
              itemCount: modelList.length),
          heightSpace50
        ],
      )),
    );
  }

  appBarMethod(BuildContext context) {
    return [
      heightSpace3,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Text(translation(context).selectCarModel, style: blackSemiBold16)
          ],
        ),
      ),
      heightSpace5,
      PrimaryContainer(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Image.asset(
              searchIcon,
              height: 2.6.h,
              width: 2.6.h,
            ),
            widthSpace10,
            Expanded(
                child: TextField(
              style: colorA6Medium14,
              cursorColor: primaryColor,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: translation(context).search,
                  hintStyle: colorA6Medium14),
            ))
          ],
        ),
      ),
      heightSpace15,
    ];
  }
}
