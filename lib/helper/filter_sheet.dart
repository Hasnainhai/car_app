import 'package:fl_carmax/pages/buy_car/search/search_provider.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:fl_carmax/utils/range_slider.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:fl_carmax/widgets/custom_range_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../models/car_brand_with_model.dart';
import '../utils/constant.dart';
import 'language_constant.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

@override
class _FilterSheetState extends State<FilterSheet> {
  @override
  void initState() {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    super.initState();
    provider.loadFilterOptions();
  }

  double start = 0;
  double end = 1000000;
  var formatter = NumberFormat("#,###", "en_US"); // Correct format
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    bool isArabic = myLocale == const Locale('ar');
    return SizedBox(
      height: 88.h,
      child: Consumer<SearchProvider>(builder: (context, provider, _) {
        return Scaffold(
          bottomSheet: _bottomSheetMethod(provider),
          backgroundColor: transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 23.5, horizontal: 20),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [myBoxShadow],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.1,
                    // ),
                    Text(translation(context).filter, style: blackMedium18),
                    // GestureDetector(
                    //     behavior: HitTestBehavior.opaque,
                    //     onTap: () {
                    //       Navigator.pop(context, {
                    //         'clear': true,
                    //       });
                    //     },
                    //     child: Text("Clear all", style: blackMedium16)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace20,
                      ..._priceMethod(provider),
                      heightSpace20,
                      ..._yearRangeSlider(provider),

                      heightSpace20,
                      //   ..._kmDrivenMethod(isArabic),
                      _customKmInput(provider),
                      heightSpace10,
                      (provider.selectedBrand.isEmpty) ?
                      SizedBox():
                      _bodyTypeMethod(provider),
                      heightSpace20,
                      (provider.selectedBrand.isEmpty) ?
                      Row(
                        children: [
                          PrimaryContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: colorE6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "No makes found for selected filters.",
                                style: colorA6Regular14,
                              ),
                            ),
                          ),
                        ],
                      ):      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Car Make", style: blackMedium16),
                            heightSpace2,
                            // _buildMakeDropdown(),
                            _buildMakeSelection(provider),
                            heightSpace10,
                            Text("Car Model", style: blackMedium16),
                            heightSpace2,
                            _buildModelSelection(provider)
                          ],
                        ),
                      ),
                      heightSpace20,
                      (provider.selectedBrand.isEmpty) ?
                     SizedBox(): _fuelTypeMethod(provider),
                      heightSpace10,
                      (provider.selectedBrand.isEmpty) ?
                      SizedBox(): _transmissionMethod(provider),
                      heightSpace10,
        ...(
        provider.selectedBrand.isEmpty
        ? []
            : _colorMethod(isArabic, provider)
        ),


                      heightSpace10,
                      heightSpace70,
                      heightSpace30,
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _fuelTypeMethod(SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translation(context).fuelType, style: blackMedium16),
          heightSpace15,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                    provider.availableFuelTypes.isEmpty ||
                            provider.availableFuelTypes.length == 1
                        ? provider.fuelTypeList.length
                        : provider.availableFuelTypes.length, (index) {
              // int index = entry.key;
              String value = provider.availableFuelTypes.isEmpty ||
                      provider.availableFuelTypes.length == 1
                  ? provider.fuelTypeList[index]
                  : provider.availableFuelTypes[index];
              bool isSelected = provider.selectedFuelTypes.contains(value);
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: PrimaryContainer(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  onTap: () {
                    provider.setFuelType(isSelected, value);
                  },
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                  borderRadius: BorderRadius.circular(5),
                  boxSadow: isSelected ? [myPrimaryShadow] : [myBoxShadow],
                  border: isSelected ? Border.all(color: primaryColor) : null,
                  child: Text(value,
                      style: isSelected ? primaryMedium14 : colorA6Regular14),
                ),
              );
            })),
          ),
        ],
      ),
    );
  }

  List<Widget> _priceMethod(SearchProvider provider) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(translation(context).price, style: blackSemiBold16),
      ),
      heightSpace10,
      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 7,
                  left: 16,
                ),
                child: Text(
                  provider.lowerValue >= 3000000
                      ? "฿ ${formatter.format(3000000)}+"
                      : "฿ ${formatter.format(provider.lowerValue)}",
                  style: primaryMedium12.copyWith(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 7),
                child: Text(
                  provider.lowerValue >= 3000000
                      ? "฿ ${formatter.format(3000000)}+"
                      : "฿ ${formatter.format(provider.upperValue)}",
                  style: primaryMedium12.copyWith(fontSize: 12),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: FlutterSlider(
              step: const FlutterSliderStep(step: 50000),
              tooltip: FlutterSliderTooltip(
                disabled: true, // 👈 Hides the thumb value completely
              ),
              selectByTap: false,
              // tooltip: FlutterSliderTooltip(
              //   alwaysShowTooltip: true,
              //   textStyle: primaryMedium14,
              //   custom: (value) => ,
              //   boxStyle: const FlutterSliderTooltipBox(
              //     decoration: BoxDecoration(color: transparent),
              //   ),
              // ),
              rightHandler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  height: 2.3.h,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [myBoxShadow],
                    color: white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  height: 2.3.h,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [myBoxShadow],
                    color: white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              values: [
                provider.lowerValue.toDouble().clamp(50000, 3000000),
                provider.upperValue.toDouble().clamp(50000, 3000000),
              ],
              trackBar: FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                inactiveTrackBar: BoxDecoration(
                  color: colorE6,
                  borderRadius: BorderRadius.circular(8),
                ),
                inactiveTrackBarHeight: 5,
                activeTrackBarHeight: 5,
              ),
              rangeSlider: true,
              max: 3000000,
              min: 50000,
              onDragging: (handlerIndex, lower, upper) {
                if (lower >= 3000000) {
                  print("lower1 $lower - upper $upper");
                  provider.setDraggingValue(
                      3000000.toDouble(), 25000000.toDouble());
                }else if(upper>=3000000){
                  print("lower2 $lower - upper $upper");
                  provider.setDraggingValue(lower, 25000000.toDouble());
                } else {
                  print("lower $lower - upper $upper");
                  provider.setDraggingValue(lower, upper);


                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: 100.w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translation(context).minPrice,
                        style: const TextStyle(fontSize: 12)),
                    Text(translation(context).maxPrice,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '฿${formatter.format(50000)}', // Format minimum price
                  style: colorA6Medium12,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  provider.lowerValue >= 3000000
                      ? "฿ ${formatter.format(3000000)}+"
                      : '฿${formatter.format(3000000)}', // Format maximum price
                  style: colorA6Medium12,
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _yearRangeSlider(SearchProvider provider) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text("Car Model Year", style: blackSemiBold16),
      ),
      heightSpace10,
      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 7,
                  left: 16,
                ),
                child: Text(
                  provider.minYear.toStringAsFixed(0),
                  style: primaryMedium12.copyWith(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 7),
                child: Text(
                  provider.maxYear.toStringAsFixed(0),
                  style: primaryMedium12.copyWith(fontSize: 12),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: FlutterSlider(
              tooltip: FlutterSliderTooltip(
                disabled: true, // 👈 Hides the thumb value completely
              ),
              selectByTap: false,
              // tooltip: FlutterSliderTooltip(
              //   alwaysShowTooltip: true,
              //   textStyle: primaryMedium14,
              //   custom: (value) => ,
              //   boxStyle: const FlutterSliderTooltipBox(
              //     decoration: BoxDecoration(color: transparent),
              //   ),
              // ),
              rightHandler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  height: 2.3.h,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [myBoxShadow],
                    color: white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  height: 2.3.h,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [myBoxShadow],
                    color: white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              values: [
                provider.minYear.toDouble(),
                provider.maxYear.toDouble()
              ],
              trackBar: FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                inactiveTrackBar: BoxDecoration(
                  color: colorE6,
                  borderRadius: BorderRadius.circular(8),
                ),
                inactiveTrackBarHeight: 5,
                activeTrackBarHeight: 5,
              ),
              rangeSlider: true,
              max: double.parse(DateTime.now().year.toString()),
              min: 1988,
              onDragging: (handlerIndex, lower, upper) {
                provider.setDraggingValueForYears(lower.toInt(), upper.toInt());
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: 100.w,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("From", style: TextStyle(fontSize: 12)),
                    Text("To", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("1988", style: colorA6Medium12),
            Text("2025", style: colorA6Medium12),
          ],
        ),
      ),
    ];
  }

  Widget _customKmInput(SearchProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Mileage (KM)", style: blackMedium16),
        ),
        heightSpace10,
        ..._kmRangeSlider(provider)
      ],
    );
  }

  List<Widget> _kmRangeSlider(SearchProvider provider) {
    final NumberFormat formatter =
        NumberFormat.decimalPattern(); // 👈 format numbers internationally

    return [
      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 16), // 👈 prevent overlap on the right
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  provider.minKm >= 150000
                      ? "${formatter.format(150000)}+"
                      : formatter.format(provider.minKm),
                  style: primaryMedium12.copyWith(fontSize: 12),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 16), // 👈 prevent overlap on the right
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  provider.maxKm >= 150000
                      ? "${formatter.format(150000)}+"
                      : formatter.format(provider.maxKm),
                  style: primaryMedium12.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FlutterSlider(
              tooltip: FlutterSliderTooltip(
                disabled: true,
              ),
              selectByTap: false,
              rightHandler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  height: 2.3.h,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [myBoxShadow],
                    color: white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  height: 2.3.h,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [myBoxShadow],
                    color: white,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              values: [provider.minKm.toDouble().clamp(0, 150000), provider.maxKm.toDouble().clamp(0, 150000)],
              trackBar: FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                inactiveTrackBar: BoxDecoration(
                  color: colorE6,
                  borderRadius: BorderRadius.circular(8),
                ),
                inactiveTrackBarHeight: 5,
                activeTrackBarHeight: 5,
              ),
              rangeSlider: true,
              max: 150000,
              min: 0,
              onDragging: (handlerIndex, lower, upper) {

                if (lower >= 150000) {
                  print("lower $lower - upper $upper");

                  provider.setDraggingValueForKMRange(
                      150000.toDouble(), 500000.toDouble());
                }else if(upper>=150000){
                  print("lower2 $lower - upper $upper");
                  provider.setDraggingValueForKMRange(lower, 500000.toDouble());
                } else {
                  print("lower4 $lower - upper $upper");

                  provider.setDraggingValueForKMRange(lower, upper);

               }
              },
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  "Min",
                  style: TextStyle(fontSize: 12),
                ),
                Text(formatter.format(0), style: colorA6Medium12),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Max",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                    provider.minKm >= 150000
                        ? "${formatter.format(150000)}+"
                        : formatter.format(150000),
                    style: colorA6Medium12),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _colorMethod(bool isArabic, SearchProvider provider) {
    List<String> colorNames =
        provider.availableColors.isEmpty || provider.availableColors.length == 1
            ? ['Any', ...provider.colors.keys.toList()]
            : [...provider.availableColors.toList()];
    List<Color> colorValues = [
      Colors.transparent,
      ...provider.colors.values.toList()
    ];

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(translation(context).color, style: blackMedium16),
      ),

     SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: colorNames.length,
          itemBuilder: (context, index) {
            final colorName = colorNames[index];
            bool isSelected = provider.selectedColors.contains(colorName);
            final isFirst = index == 0;
            final isLast = index == colorNames.length - 1;

            return PrimaryContainer(
              onTap: () {
                provider.setSelectedColor(isSelected, colorName);
              },
              margin: isArabic
                  ? isFirst
                      ? const EdgeInsets.only(left: 7.5)
                      : isLast
                          ? const EdgeInsets.only(right: 7.5)
                          : const EdgeInsets.symmetric(horizontal: 7.5)
                  : isFirst
                      ? const EdgeInsets.only(right: 7.5)
                      : isLast
                          ? const EdgeInsets.only(left: 7.5)
                          : const EdgeInsets.symmetric(horizontal: 7.5),
              padding:
                  const EdgeInsets.symmetric(vertical: 9.5, horizontal: 16),
              borderRadius: BorderRadius.circular(5),
              boxSadow: isSelected ? [myPrimaryShadow] : [myBoxShadow],
              border: isSelected ? Border.all(color: primaryColor) : null,
              child: Row(
                children: [
                  if (colorName != 'Any') ...[
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: provider.availableColors.isEmpty
                            ? colorValues[index]
                            : provider.mapThaiColorToColor(colorName),
                        shape: BoxShape.circle,
                        boxShadow: [myBoxShadow],
                      ),
                    ),
                    widthSpace10,
                  ],
                  Text(
                    colorName,
                    style: isSelected ? primaryMedium14 : colorA6Regular14,
                  ),
                ],
              ),
            );
          },
        ),
      )
    ];
  }

  Widget _transmissionMethod(SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translation(context).transmission, style: blackMedium16),
          heightSpace15,
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                      provider.availableTransmissions.isEmpty ||
                              provider.availableTransmissions.length == 1
                          ? provider.transmissionList.length
                          : provider.availableTransmissions.length, (index) {
                final data = provider.availableTransmissions.isEmpty ||
                        provider.availableTransmissions.length == 1
                    ? provider.transmissionList
                    : provider.availableTransmissions;
                bool isSelected =
                    provider.selectedTransmissions.contains(data[index]);

                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: PrimaryContainer(
                    onTap: () {
                      provider.setTransmission(isSelected, data[index]);
                    },
                    padding: const EdgeInsets.symmetric(
                        vertical: 9.5, horizontal: 16),
                    borderRadius: BorderRadius.circular(5),
                    boxSadow: isSelected ? [myPrimaryShadow] : [myBoxShadow],
                    border: isSelected ? Border.all(color: primaryColor) : null,
                    child: Text(
                      data[index],
                      style: isSelected ? primaryMedium14 : colorA6Regular14,
                    ),
                  ),
                );
              })),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMakeSelection(SearchProvider provider) {
    // Add 'Any' first, then sort the rest
    List<String> sortedKeys = [
      'Any',
      ...carData.keys.toList()..sort((a, b) => a.compareTo(b))
    ];
    if (provider.availableMakes.isEmpty || provider.availableMakes.length == 1) {
      provider.makesList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    } else {
      provider.availableMakes.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSpace10,
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    provider.availableMakes.isEmpty ||
                            provider.availableMakes.length == 1
                        ? provider.makesList.length
                        : provider.availableMakes.length, (index) {
                  final value = provider.availableMakes.isEmpty ||
                          provider.availableMakes.length == 1
                      ? provider.makesList[index]
                      : provider.availableMakes[index];
                  bool isSelected = provider.selectedMakes.contains(value.name);
                  provider.availableMakes
                      .where((make) => provider.selectedMakes.contains(make.name))
                      .forEach((selectedMake) {
                    print("Selected Make: ${selectedMake.name}");
                    selectedMake.children.forEach((model) {
                      print("  Model: ${model.name}");
                    });
                  });

                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: PrimaryContainer(
                      onTap: () {

                        provider.setCarMakes(isSelected, value, index);
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 9.5, horizontal: 16),
                      borderRadius: BorderRadius.circular(5),
                      boxSadow: isSelected ? [myPrimaryShadow] : [myBoxShadow],
                      border:
                          isSelected ? Border.all(color: primaryColor) : null,
                      child: Text(
                        value.name ?? '',
                        style: isSelected ? primaryMedium14 : colorA6Regular14,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelection(SearchProvider provider) {
    // bool isTrue = mapContainsAnyKey(provider.makesList, provider.selectedMakes);
    if (provider.availableMakes.isEmpty || provider.availableMakes.length == 1) {
      provider.makesList.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
      );
    } else {
      provider.availableMakes.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
      );
    }
    provider.selectedBrand.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
    );

    // Also sort children (models) of each selected brand
    for (var brand in provider.selectedBrand) {
      brand.children.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSpace10,
          SizedBox(
            height: 50,
            child: provider.selectedBrand.length==1
                ? Row(
              children: [
                PrimaryContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: colorE6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Model Group",
                      style: colorA6Regular14,
                    ),
                  ),
                ),
              ],
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: provider.selectedBrand.length == 1
                    ? provider.availableMakes
                    .expand((brand) => brand.children.map((model) {
                  print("this is running ${model.name}");


                  bool isSelected = provider.selectedModels
                      .contains(model.name);

                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: PrimaryContainer(
                      onTap: () {
                        provider.setCarModels(
                            isSelected, model.name ?? 'Any');
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 9.5, horizontal: 16),
                      borderRadius: BorderRadius.circular(5),
                      boxSadow: isSelected
                          ? [myPrimaryShadow]
                          : [myBoxShadow],
                      border: isSelected
                          ? Border.all(color: primaryColor)
                          : null,
                      child: Text(
                        model.name ?? 'Any',
                        style: isSelected
                            ? primaryMedium14
                            : colorA6Regular14,
                      ),
                    ),
                  );
                }))
                    .toList()
                    : provider.selectedBrand
                    .expand((brand) => brand.children.map((model) {
                  print(provider.selectedBrand.length );
                  print("---->${model.name}");
                  bool isSelected = provider.selectedModels
                      .contains(model.name);
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: PrimaryContainer(
                      onTap: () {
                        provider.setCarModels(
                            isSelected, model.name ?? 'Any');
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 9.5, horizontal: 16),
                      borderRadius: BorderRadius.circular(5),
                      boxSadow: isSelected
                          ? [myPrimaryShadow]
                          : [myBoxShadow],
                      border: isSelected
                          ? Border.all(color: primaryColor)
                          : null,
                      child: Text(
                        model.name ?? 'Any',
                        style: isSelected
                            ? primaryMedium14
                            : colorA6Regular14,
                      ),
                    ),
                  );
                }))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyTypeMethod(SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translation(context).bodyType, style: blackMedium16),
          heightSpace10,
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    provider.availableBodyTypes.isEmpty || provider.availableBodyTypes.length == 1
                        ? provider.bodyTypeList.length
                        : provider.availableBodyTypes.length,
                        (index) {
                      print('Available Body Types: ${provider.availableBodyTypes}');
                      print('Selected Body Types: ${provider.selectedBodyTypes}');

                      String value = provider.availableBodyTypes.isEmpty || provider.availableBodyTypes.length == 1
                          ? provider.bodyTypeList[index]
                          : provider.availableBodyTypes[index];

                      bool isSelected = provider.selectedBodyTypes.contains(value);

                      print('Rendering body type: $value - Selected: $isSelected');

                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: PrimaryContainer(
                          onTap: () {
                            provider.setBodyTypes(isSelected, value);
                          },
                          padding: const EdgeInsets.symmetric(vertical: 9.5, horizontal: 16),
                          borderRadius: BorderRadius.circular(5),
                          boxSadow: isSelected ? [myPrimaryShadow] : [myBoxShadow],
                          border: isSelected ? Border.all(color: primaryColor) : null,
                          child: Text(value,
                              style: isSelected ? primaryMedium14 : colorA6Regular14),
                        ),
                      );
                    }
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  _bottomSheetMethod(SearchProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryContainer(
                onTap: () {
                  print(provider.selectedMakes.length);
                  Navigator.pop(context, {
                    'minPrice': provider.lowerValue >= 3000000
                        ? 3000000
                        : provider.lowerValue,
                    'maxPrice': provider.upperValue,
                    'fuelType': provider.selectedFuelTypes.toSet(),
                    'transmission':
                        provider.selectedTransmissions.contains('Any')
                            ? ['Any'] // or ['Any'] if your API expects it
                            : provider.selectedTransmissions.toList(),
                    'colors': provider.selectedColors.contains('Any')
                        ? ['Any'] // or ['Any'] if your API expects it
                        : provider.selectedColors.toList(),
                    'bodyType': provider.selectedBodyTypes.toSet(),
                    'makes': provider.selectedMakes.contains('Any')
                        ? ['Any']
                        : provider.selectedMakes,
                    'model': provider.selectedModels.contains('Any')
                        ? ['Any']
                        : provider.selectedModels,
                    'minKmInput':
                        provider.minKm >= 150000 ? 150000 : provider.minKm,
                    'maxKmInput': provider.maxKm,
                    'location': provider.locationController.text.trim(),
                    'minYear': provider.minYear,
                    'maxYear': provider.maxYear,
                  });

                },
                padding: const EdgeInsets.symmetric(vertical: 13),
                color: primaryColor,
                borderRadius: BorderRadius.circular(0),
                child: Center(
                    child:
                        Text(translation(context).apply, style: whiteMedium16)),
              ),
            ),
            Expanded(
              child: PrimaryContainer(
                onTap: () {
                  provider.resetFilters();
                },
                padding: const EdgeInsets.symmetric(vertical: 13),
                borderRadius: BorderRadius.circular(0),
                child: Center(
                    child:
                        Text(translation(context).reset, style: blackMedium16)),
              ),
            )
          ],
        ),
      ],
    );
  }

  Map<String, List<dynamic>> getCarModelsByKeys(
      Map<String, List<dynamic>> carData, List<String> keys) {
    Map<String, List<dynamic>> result = {};

    for (final key in keys) {
      if (carData.containsKey(key)) {
        final models = carData[key];
        if (models != null && models.isNotEmpty) {
          result[key] = models;
        }
      }
    }

    return result.isNotEmpty ? result : {};
  }

// mapContainsAnyKey(List<CarBrandModel> providedMap, List<String> keyList) {
//   return providedMap.any(
//     (brand) => brand.children.any(
//       (child) => keyList.contains(child.name),
//     ),
//   );
// }
  final Map<String, List<String>> carData = {
    'BMW': [
      '2 Series',
      '3 Series',
      '4 Series',
      '5 Series',
      'X Series',
      'i Series'
    ],
    'Audi': ['A5', 'Q3', 'TT'],
    'Mercedes': [
      'A-Class',
      'C-Class',
      'CLA-Class',
      'CLC-Class',
      'CLS-Class',
      'E-Class',
      'GLA-Class',
      'GLC-Class',
      'GLE',
      'S-Class'
    ],
    'Chevrolet': ['Corvette'],
    'Toyota': ['Corolla Cross', 'Fortuner', 'Hilux', 'Innova', 'Vios'],
    'Honda': ['Civic', 'CR-V', 'City', 'HRV', 'BR-V'],
    'Volkswagen': ['Beetle'],
    'Mazda': ['CX-3', 'CX-8'],
    'Ford': ['Mustang'],
    'Porsche': ['Panamera'],
    'Ferrari': ['Portofino'],
    'Nissan': ['Leaf'],
    'Hyundai': ['Elantra'],
    'Isuzu': ['D-Max'],
    'Land Rover': ['Range Rover'],
    'Peugeot': ['508'],
    'Lexus': ['ES300H'],
    'Mazda': ['CX-3', 'CX-8'],
    'Kia': ['Carnival', 'Staria', 'Veloz', 'Seltos'],
    'Volvo': ['V40'],
    'Subaru': ['Outback']
  };
}
