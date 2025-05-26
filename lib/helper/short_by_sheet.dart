import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/constant.dart'; // for primaryColor, white, myBoxShadow, etc.

class SortBySheet extends StatefulWidget {
  final int initialIndex;
  const SortBySheet({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<SortBySheet> createState() => _SortBySheetState();
}

class _SortBySheetState extends State<SortBySheet> {
  late int _selectedSortBy;

  final List<String> sortByItems = [
    'Relevance',
    'Recently Added',
    'Price - Low to High',
    'Price - High to Low',
    'Km driven - Low to High',
    'Km driven - High to Low',
    'Year - New to Old',
    'Year - Old to New',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Title
        Container(
          padding: const EdgeInsets.symmetric(vertical: 23.5),
          decoration: BoxDecoration(
            color: white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [myBoxShadow],
          ),
          child: Center(
            child: Text(
              "Sort By",
              style: blackMedium18,
            ),
          ),
        ),

        // Sort Options
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: List.generate(sortByItems.length, (index) {
                  return ListTile(
                    onTap: () {
                      setState(() => _selectedSortBy = index);
                      Navigator.pop(context, index,);
                    },
                    leading: Text(sortByItems[index], style: blackRegular16),
                    trailing: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 2.3.h,
                          width: 2.3.h,
                          decoration: BoxDecoration(
                            color: _selectedSortBy == index
                                ? primaryColor
                                : white,
                            shape: BoxShape.circle,
                            boxShadow: _selectedSortBy == index
                                ? [myPrimaryShadow]
                                : [myBoxShadow],
                          ),
                        ),
                        if (_selectedSortBy == index)
                          const CircleAvatar(
                            backgroundColor: white,
                            radius: 3,
                          )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        )
      ],
    );
  }
}


