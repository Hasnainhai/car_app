import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../helper/language_constant.dart';
import '../../../models/car_details_model.dart';
import '../../../models/car_listing_model.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';
import '../compare_page/compare_controller.dart';
import '../compare_page/compare_page.dart';
import '../search/search_page.dart';
import '../search/search_provider.dart';
import 'car_detail_provider.dart';
import 'car_detail_screen.dart';
import 'dart:math';

class CarDetailPage extends StatefulWidget {
  final String carId;
  final bool isInitiallyFavourite;
  final  List<dynamic>? modelsListD;
  const CarDetailPage({
    Key? key,
    required this.carId,
    this.isInitiallyFavourite = false,
    required this.modelsListD,
  }) : super(key: key);

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  String? _expandedTile;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CarDetailProvider>(context,listen: false);
     provider.setFavouriteLoader(widget.isInitiallyFavourite,load: false);
    Future.wait([provider.fetchCarDetail(widget.carId,load: false),]);
    // checkIfFavourite();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<CompareProvider,CarDetailProvider>(
        builder: (context, compareProvider,provider, child) {
          if (provider.isLoading || provider.carDetail == null) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  )),
            );
          }
        return Scaffold(
          bottomSheet: bottomSheetMethod(compareProvider),
          appBar: appBarMethod(context,provider),
          body: bodyMethod(context,compareProvider,provider),
        );
      }
    );
  }

  Widget bottomSheetMethod(CompareProvider compareProvider) {
     return Container(
       color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(compareProvider.compareList.isNotEmpty)Container(
                color: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${compareProvider.compareList.length} ${compareProvider.compareList.length == 1 ? "car" : "cars"} selected for comparison",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ComparePage(), // no argument needed
                          ),
                        );
                      },
                      icon:  const Icon(Icons.compare_arrows,color: Colors.white,),
                      label: Text("Compare",style: whiteMedium14,),
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                        final Uri url = Uri.parse(
                            'http://line.me/ti/p/%40koonyingcar');
                        if (!await launchUrl(url)) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Could not launch website')),
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            // boxShadow: [myPrimaryShadow],
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Call Seller',
                                  // translation(context).continueBooking,
                                  style: whiteSemiBold16),
                              const SizedBox(
                                width: 10,
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(3.1416),
                                child: Image.asset(
                                  'assets/images/phone.png',
                                  color: Colors.white,
                                  height: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  widthSpace15,
                  Expanded(
                    child: GestureDetector(
                      onTap: ()async{
                    final Uri url = Uri.parse(
                        'http://line.me/ti/p/%40koonyingcar');
                    if (!await launchUrl(url)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not launch website')),
                        );
                      }
                    }
                  },
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                            color: const Color(0xff38AE41),
                            // boxShadow: [myPrimaryShadow],
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //  Icon(Icons.),

                            Text('Contact on',
                                //translation(context).bookTestdrive,
                                style: whiteSemiBold16),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/images/line1.png',
                              color: white,
                              height: 25,
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
  }

  Widget bodyMethod(BuildContext context,CompareProvider compareProvider,CarDetailProvider provider) {
    Locale myLocale = Localizations.localeOf(context);
    bool isArabic = myLocale == const Locale('ar');

    if (provider.isLoading ) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<String>? imageUrls = provider.carDetail?.imageUrls;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarDetailWidget(
            carDetail: provider.carDetail!,
            carId: widget.carId,
            imageUrls: imageUrls??[],
            title: provider.carDetail!.title,
            sellerName: provider.carDetail!.sellerName,
            mileage: provider.carDetail!.mileage,
            year: provider.carDetail!.year,
            transmission: provider.carDetail!.transmission,
            fuelType: provider.carDetail!.fuelType,
            location: provider.carDetail!.location,
            modelsListD: widget.modelsListD,
            modelVarient: provider.carDetail!.modelVariant,
           carModel: provider.carDetail?.modelGroup,
          ),
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),
          ...carPriceMethod(provider),
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),
          ...carOverviewMethod(provider.carDetail!),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: DottedDecoration(color: color94, dash: const [2, 3]),
            ),
          ),
          // ...morePhotosMethod('More Image'),
          // Container(
          //   decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          // ),
          heightSpace20,
          ...carConditionMethod(provider.carDetail!),
          ...faqMethod(),
          heightSpace20,
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),

          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),

          heightSpace20,
          ...carSellerMethod(provider.carDetail!),
          heightSpace20,
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),
          heightSpace20,


          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),
          heightSpace20,

          ...mapMethod(provider),
          heightSpace20,
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),
          heightSpace20,
          // ...morePhotosMethod('More from this seller'),

          ...recentlyAddedCarMethod(
              isArabic, 'More From This Seller', provider.similarCars,compareProvider),

          heightSpace20,
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),
          heightSpace20,
          ...recentlyAddedCarMethod1(
            false,
            "You Might Like This",
              provider.carDetail!.relatedCategoryProducts,
              compareProvider
          ),

          // ...recentlyAddedCarMethod(
          //     isArabic, 'You Might Like This', similarCars),
          heightSpace20,
          Container(
            decoration: DottedDecoration(color: color94, dash: const [2, 3]),
          ),

          SizedBox(height: compareProvider.compareList.isNotEmpty?150:70,)
        ],
      ),
    );
  }

  List<Widget> carPriceMethod(CarDetailProvider provider) {
    return [
      heightSpace20,
      const SizedBox(height: 10),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(translation(context).price, style: primaryMedium16),
                Text(
                  NumberFormat.currency(
                    locale: 'en_US',
                    symbol: '฿',
                    decimalDigits: 0, // <-- removes .00
                  ).format(int.tryParse(provider.carDetail!.price) ?? 0),
                  style: blackMedium16,
                ),
              ],
            ),

          ],
        ),
      ),
      heightSpace9,
      // GestureDetector(
      //   onTap: showBenefitsSheet,
      //   child: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      //     color: colorED,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text(
      //             '${translation(context).benefits} (฿21,500) ${translation(context).inculudesInPrice}',
      //             style: blackRegular14),
      //         const Icon(Icons.chevron_right)
      //       ],
      //     ),
      //   ),
      // ),
      GestureDetector(
        onTap: showEMISheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Finance Calculator",
                  //translation(context).customizeEMIPlans,
                  style: blackRegular14),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
      heightSpace20,
    ];
  }

  PreferredSize appBarMethod(BuildContext context,CarDetailProvider provider) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: provider.carDetail!.title,
        // '2013 BMW 4 Series 420d M-Sport',
        actions: const [
          widthSpace20
        ],
      ),
    );
  }

  String formatNumber(dynamic value) {
    return NumberFormat.decimalPattern('en_US').format(
        int.tryParse(value.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
  }

  List<Widget> carOverviewMethod(CarDetailModel carDetail) {
    Map<String, String> overviewMap = {
      'Reference Code': carDetail.referenceCode, // Replace with dynamic if available
      'Registered': carDetail.year,
      'Mileage': '${formatNumber(carDetail.mileage)} km',
      'Make': carDetail.make,
      'Model Group': carDetail.modelGroup,
      'Model Variant': carDetail.modelVariant,
      //'TAGS': carDetail..,
      'Body Type': carDetail.bodyType,
      'Doors': carDetail.doors,
      'Transmission': carDetail.transmission,
      'Drive': carDetail.drive,
      'Engine Size': carDetail.engineCapacity,
      'Fuel Type': carDetail.fuelType,
      'Color': carDetail.color,
    };

    List<String> keyList = overviewMap.keys.toList();
    List<String> valueList = overviewMap.values.toList();

    return [
      heightSpace20,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('Overview', style: primarySemiBold16),
      ),
      heightSpace15,
      Column(
        children: List.generate(keyList.length, (index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            color: index % 2 == 0 ? colorED : white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(keyList[index], style: blackRegular14),
                Text(valueList[index], style: blackMedium14),
              ],
            ),
          );
        }),
      ),
    ];
  }

  List<Widget> morePhotosMethod(String text) {
    List imageList = [moreImage1, moreImage2, moreImage1, moreImage2];
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(text,
            // translation(context).moreImage,
            style: primaryMedium16),
      ),
      SizedBox(
        height: 122,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemBuilder: (context, index) => Container(
            margin: index == 0
                ? const EdgeInsets.only(right: 10)
                : index == imageList.length - 1
                    ? const EdgeInsets.only(left: 10)
                    : const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            decoration: BoxDecoration(
                color: white,
                borderRadius: myBorderRadius10,
                boxShadow: [myBoxShadow]),
            child: Image.asset(
              imageList[index],
              height: 108,
              width: 108,
            ),
          ),
        ),
      ),
      heightSpace5,
    ];
  }

  List<Widget> carConditionMethod(CarDetailModel carDetail) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
            Text(translation(context).carCondition, style: primarySemiBold16),
      ),
      heightSpace15,

      // Offer Tags
      if (carDetail.offerTags.isNotEmpty)
        _buildFeatureExpansionTile('Why Buy this Car', carDetail.offerTags,_expandedTile),

      // Safety Features
      if (carDetail.safetyFeatures.isNotEmpty)
        _buildFeatureExpansionTile('Safety Features', carDetail.safetyFeatures,_expandedTile),

      // Comfort Features
      if (carDetail.comfortFeatures.isNotEmpty)
        _buildFeatureExpansionTile(
            'Comfort Features', carDetail.comfortFeatures,_expandedTile),
    ];
  }

  Widget _buildFeatureExpansionTile(String title, List<String> features,String? expandedValue) {
    return Theme(
      data: ThemeData(dividerColor: transparent),
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
          key: ValueKey('$title-$expandedValue'),
          childrenPadding: EdgeInsets.zero,
          iconColor: black,
          collapsedIconColor: black,
          backgroundColor: white,
          collapsedBackgroundColor: colorED,
          maintainState: false,
          title: Text(title, style: blackMedium14),
           onExpansionChanged: (isExpanded){
             setState(() {
               if (isExpanded) {
                 _expandedTile = title; // Set the currently expanded tile
               } else if (_expandedTile == title) {
                 _expandedTile = null; // Collapse the tile if it's already expanded
               }
             });
           },
          initiallyExpanded: _expandedTile == title,
          children: [
            Container(
              color: white,
              child: Column(
                children: [
                  heightSpace15,
                  Column(
                    children: features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 18, right: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 55.w,
                              child: Text(feature, style: blackRegular14),
                            ),
                            Image.asset(
                              circleCheck,
                              height: 1.9.h,
                              color: primaryColor,
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> carSellerMethod(CarDetailModel carDetail) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Seller Description',
          style: primarySemiBold16,
        ),
      ),
      heightSpace15,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
        Text(
          carDetail.sellerDescription,
          style: blackRegular14,
        ),
      ),
    ];
  }


  List<Widget> mapMethod(CarDetailProvider provider) {


    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Dealer Location',
          style: primarySemiBold16,
        ),
      ),
      heightSpace15,
      SizedBox(
        height: 25.h,
        width: 100.w,
        child: provider.isLoadingLocation
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : provider.locationError != null
            ? Container(
                height: 25.h,
                width: 100.w,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(provider.locationError!),
                ),
              )
            : provider.locationLatLng != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 25.h,
                    width: 100.w,
                    child: GoogleMap(
                      myLocationEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: provider.locationLatLng!,
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('dealer_location'),
                          position: provider.locationLatLng!,
                        )
                      },
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: true,
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Unable to load map for this location."),
                ),
      ),
    ];
  }
  /*List<Widget> mapMethod(CarDetailProvider provider) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Dealer Location',
          style: primarySemiBold16,
        ),
      ),
      heightSpace15,
      SizedBox(
        height: 25.h,
        width: 100.w,
        child: FutureBuilder<LatLng?>(
          future: provider.getLatLngFromAddress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: 25.h,
                  width: 100.w,
                  child:const Center(child: CircularProgressIndicator(color: primaryColor)));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Container(
                height: 25.h,
                width: 100.w,
                alignment: Alignment.center,
                child:const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Unable to load map for this location."),
                ),
              );
            }

            final LatLng position = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 25.h,
                width: 100.w,
                child: GoogleMap(
                  myLocationEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: position,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('dealer_location'),
                      position: position,
                    )
                  },
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: true,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }*/

  List<Widget> faqMethod() {
    return [
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   child: Text(translation(context).faqS, style: blackSemiBold16),
      // ),
      // heightSpace15,
      Column(
        children: List.generate(
            1,
            (index) => PrimaryContainer(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: ListTileTheme(
                  dense: true,
                  child: Theme(
                    data: ThemeData(dividerColor: transparent),
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      iconColor: black,
                      collapsedIconColor: black,
                      backgroundColor: white,
                      collapsedBackgroundColor: colorED,
                      maintainState: false,
                      title: Row(
                        children: [
                          Text('Review',
                              style: blackMedium14)
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'The 2013 BMW 420d M-Sport F32 offers a truly enjoyable driving experience. '
                                  'Its handling is remarkably agile, making winding roads a delight, thanks '
                                  'to precise steering and a well-balanced chassis. The rear-wheel-drive '
                                  'configuration enhances this sporty feel, providing a strong connection to the road. '
                                  'The diesel engine delivers a smooth and responsive power delivery, offering ample '
                                  'torque for swift acceleration and effortless overtaking.',
                                  style: colorA6Regular14),
                              const SizedBox(height: 10),
                              Text(
                                  'The M-Sport package elevates the experience with its sport-tuned suspension '
                                  'and stylish aesthetic. Inside, the cabin is crafted with high-quality materials, '
                                  'exuding a sense of luxury, and the iDrive infotainment system is intuitive and user-friendly. '
                                  'The M-Sport seats provide excellent support, ensuring comfort during both spirited drives '
                                  'and long journeys, and the driving position is perfectly tailored for control. Even with the '
                                  'sport-tuned suspension, the car maintains a refined ride on motorway journeys. '
                                  'A standout feature is the engine\'s impressive fuel efficiency, allowing for extended driving ranges. '
                                  'Its sleek and stylish coupe design, with its long hood and flowing lines, creates a striking road presence. '
                                  'In essence, this 420d M-Sport blends sporty driving dynamics, refined comfort, and exceptional fuel economy into a compelling package.',
                                  style: colorA6Regular14),
                              const SizedBox(height: 10),
                              Text('Conclusion:', style: blackMedium14),
                              const SizedBox(height: 5),
                              Text(
                                'The 2013 BMW 420d M-Sport F32 offers a compelling blend of sporty handling, '
                                'luxurious comfort, and exceptional fuel efficiency, making it a desirable '
                                'choice for drivers seeking a refined and engaging driving experience.',
                                style: colorA6Regular14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
      )
    ];
  }

  void showBenefitsSheet() {
    Map benefits = {
      '1 year insurance': '฿6000',
      'RC transfer(average cost)': '฿4000',
      'Servicing, washing and dry cleaning': '฿4000',
      'FASTtag': '฿500',
      'Shipping charge': '฿5000',
      '5 day money back guarantee': '',
    };
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [myBoxShadow],
              ),
              child: Center(
                  child: Text('${translation(context).yourBenefits} (฿21,500)',
                      style: primaryMedium16)),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  heightSpace20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        children: List.generate(benefits.length, (index) {
                      var keys = benefits.keys.toList()[index];
                      var value = benefits.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('\u2022'),
                                widthSpace5,
                                SizedBox(
                                    width: 55.w,
                                    child: Text(keys, style: blackMedium14)),
                              ],
                            ),
                            Column(
                              children: [
                                value.isEmpty
                                    ? const SizedBox()
                                    : Text(
                                        value,
                                        style: TextStyle(
                                            color: black,
                                            fontFamily: 'M',
                                            fontSize: 9.7.sp,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                Text(translation(context).included,
                                    style: primaryMedium14)
                              ],
                            )
                          ],
                        ),
                      );
                    })),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void showEMISheet() {
    CarDetailProvider provider =
        Provider.of<CarDetailProvider>(context, listen: false);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (context) {
        return EMICalculator(price: int.tryParse(provider.carDetail?.price ?? '0') ?? 0);
      },
    );
  }

  List<Widget> recentlyAddedCarMethod(bool isArabic, String title, List<CarDetailModel> relatedCars,CompareProvider compareProvider) {
    Locale myLocale = Localizations.localeOf(context);
    isArabic = myLocale == const Locale('ar');

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: primaryMedium16),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchPage()));
              },
              child: Text(translation(context).viewAll, style: primaryMedium14),
            ),
          ],
        ),
      ),
      heightSpace2,
      Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
          return SizedBox(
            height: 280,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: relatedCars.length,
              itemBuilder: (context, index) {
                final car = relatedCars[index];
                for (final car in relatedCars.take(6)) {
                  precacheImage(CachedNetworkImageProvider(car.imageUrls.first), context);
                }
                final isFav =
                searchProvider.favouriteIds.contains(int.parse(car.id));
                final compared = compareProvider.isInCompare(CarListing(
                    id: car.id,
                    title: car.title,
                    price: car.price,
                    fuelType: car.fuelType,
                    transmission: car.transmission,
                    mileage: car.mileage,
                    year: car.year,
                    imageUrl: car.imageUrls[index],
                    imageUrls: car.imageUrls,
                    bodyType: car.bodyType,
                    engineCapacity: car.engineCapacity,
                    isFeatured: false,
                    carTag: "",
                    location: car.location,
                    color: car.color,
                    brand: car.make,
                    modelsListD: widget.modelsListD,

                ));
                return PushNavigate(
                  navigate: 'CarDetailPage',
                  child: Container(
                    margin: isArabic
                        ? index == 0
                        ? const EdgeInsets.only(left: 10)
                        : index == 2
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.symmetric(horizontal: 0)
                        : index == 0
                        ? const EdgeInsets.only(right: 10)
                        : index == 2
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.only(right: 10),
                    width: 200,
                    decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: CachedNetworkImage(
                            imageUrl: car.imageUrls.first,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                                color: Colors.grey.shade300,
                                height: 150),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.title,
                                  style: blackMedium14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '฿',
                                  decimalDigits: 0,
                                ).format(
                                  double.tryParse(
                                    car.price.replaceAll(
                                        RegExp(r'[^0-9.]'), ''),
                                  ) ??
                                      0,
                                ),
                                style: primaryMedium14,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text(car.fuelType, style: colorA6Medium12),
                                    VerticalDivider(
                                        thickness: 1, width: 10, color: colorD9),
                                    Text('${car.mileage} km',
                                        style: colorA6Medium12),
                                    // VerticalDivider(
                                    //     thickness: 1, width: 10, color: colorD9),
                                    //  Text(car.year, style: colorA6Medium12),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: isArabic
                              //       ? const EdgeInsets.only(top: 7, left: 8)
                              //       : const EdgeInsets.only(top: 7, right: 8),
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       setState(() {
                              //         _recentlyAddedFav.contains(index)
                              //             ? _recentlyAddedFav.remove(index)
                              //             : _recentlyAddedFav.add(index);
                              //       });
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           backgroundColor: primaryColor,
                              //           duration: const Duration(seconds: 3),
                              //           content: Text(
                              //             _recentlyAddedFav.contains(index)
                              //                 ? '${car.title} ${translation(context).addedFav}'
                              //                 : '${car.title} ${translation(context).removedFav}',
                              //             style: whiteMedium14,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     child: Icon(
                              //       _recentlyAddedFav.contains(index)
                              //           ? Icons.favorite_rounded
                              //           : Icons.favorite_outline_rounded,
                              //       color: _recentlyAddedFav.contains(index)
                              //           ? primaryColor
                              //           : colorA6,
                              //       size: 2.5.h,
                              //     ),
                              //   ),
                              // ),
                              Row(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => searchProvider.toggleCompare(context, CarListing(
                                        id: car.id,
                                        title: car.title,
                                        price: car.price,
                                        fuelType: car.fuelType,
                                        transmission: car.transmission,
                                        mileage: formatNumber(car.mileage),
                                        year: car.year,
                                        imageUrl: car.imageUrls.first,
                                        imageUrls: car.imageUrls,
                                        bodyType: car.bodyType,
                                        engineCapacity: car.engineCapacity,
                                        isFeatured: false,
                                        carTag: "",
                                        color: car.color,
                                        brand: car.make,
                                        location: car.location,
                                        modelVarient: car.modelVariant,
                                        modelsListD:[{"name": car.modelGroup,
                                        }]),
                                    ),
                                    child: Icon(Icons.compare_arrows,
                                        color: compared
                                            ? primaryColor
                                            : colorA6),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () => searchProvider.handleFavouriteToggle(
                                        CarListing(
                                            id: car.id,
                                            postDate: car.postDate,
                                            title: car.title,
                                            price: car.price,
                                            fuelType: car.fuelType,
                                            transmission: car.transmission,
                                            mileage: car.mileage,
                                            year: car.year,
                                            imageUrl: car.imageUrls[index],
                                            imageUrls: car.imageUrls,
                                            bodyType: car.bodyType,
                                            engineCapacity: car.engineCapacity,
                                            isFeatured: false,
                                            color: car.color,
                                            carTag: car.offerTags.first,
                                            brand: car.make,
                                            location: car.location,
                                        ), context, mounted,context),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border,
                                      color: isFav ? primaryColor : colorA6,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            //         FutureBuilder<List<CarListing>>(
            //   future: futureCars,
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return SizedBox(
            //         height: 280,
            //         child: SingleChildScrollView(
            //           scrollDirection: Axis.horizontal,
            //           physics: const BouncingScrollPhysics(),
            //           padding:
            //               const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //           child: Row(
            //             children: List.generate(
            //               6,
            //               (index) {
            //                 return buildCarShimmerCard();
            //               },
            //             ),
            //           ),
            //         ),
            //       );
            //     }

            //     final cars = snapshot.data!;
            //     for (final car in cars.take(6)) {
            //       precacheImage(CachedNetworkImageProvider(car.imageUrl), context);
            //     }
            //     return SizedBox(
            //       height: 280,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         physics: const BouncingScrollPhysics(),
            //         padding:
            //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //         child: Row(
            //           children: cars.take(6).map((car) {
            //             final isFav =
            //                 searchProvider.favouriteIds.contains(int.parse(car.id));
            //             final compared = compareProvider.isInCompare(car);
            //             return GestureDetector(
            //               onTap: () => Navigator.pushNamed(
            //                 context,
            //                 '/CarDetailPage',
            //                 arguments: car.id,
            //               ),
            //               child: Container(
            //                 width: 200,
            //                 margin: const EdgeInsets.symmetric(horizontal: 5),
            //                 decoration: BoxDecoration(
            //                   color: white,
            //                   borderRadius: myBorderRadius10,
            //                 ),
            //                 child: Column(
            //                   children: [
            //                     ClipRRect(
            //                       borderRadius: const BorderRadius.only(
            //                         topLeft: Radius.circular(10),
            //                         topRight: Radius.circular(10),
            //                       ),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             width: double.infinity,
            //                             height: 150,
            //                             child: CachedNetworkImage(
            //                               imageUrl: car.imageUrl,
            //                               fit: BoxFit.fill,
            //                               placeholder: (context, url) => Container(
            //                                   color: Colors.grey.shade300,
            //                                   height: 150),
            //                               errorWidget: (context, url, error) =>
            //                                   Image.asset(
            //                                       'assets/images/placeholder.png',
            //                                       fit: BoxFit.cover),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             car.title,
            //                             style: blackMedium14,
            //                             maxLines: 1,
            //                             overflow: TextOverflow.ellipsis,
            //                           ),
            //                           Text(
            //                             NumberFormat.currency(
            //                               locale: 'en_US',
            //                               symbol: '\฿',
            //                               decimalDigits: 0,
            //                             ).format(
            //                               double.tryParse(
            //                                     car.price.replaceAll(
            //                                         RegExp(r'[^0-9.]'), ''),
            //                                   ) ??
            //                                   0,
            //                             ),
            //                             style: primaryMedium14,
            //                           ),
            //                           IntrinsicHeight(
            //                             child: Row(
            //                               children: [
            //                                 Text(car.fuelType,
            //                                     style: colorA6Medium12),
            //                                 VerticalDivider(
            //                                     thickness: 1,
            //                                     width: 10,
            //                                     color: colorD9),
            //                                 Text(
            //                                   '${NumberFormat.decimalPattern().format(int.tryParse(car.mileage.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)} km',
            //                                   style: colorA6Medium12,
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                           const SizedBox(height: 6),
            //                           Row(
            //                             children: [
            //                               GestureDetector(
            //                                 behavior: HitTestBehavior.opaque,
            //                                 onTap: () => searchProvider
            //                                     .toggleCompare(context, car),
            //                                 child: Icon(Icons.compare_arrows,
            //                                     color: compared
            //                                         ? primaryColor
            //                                         : colorA6),
            //                               ),
            //                               const SizedBox(width: 10),
            //                               GestureDetector(
            //                                 onTap: () => searchProvider
            //                                     .handleFavouriteToggle(
            //                                         car, context, mounted),
            //                                 child: Icon(
            //                                   isFav
            //                                       ? Icons.favorite_rounded
            //                                       : Icons.favorite_border,
            //                                   color: isFav ? primaryColor : colorA6,
            //                                   size: 20,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     );
            //   },
            // ),
          );
        }
      )
    ];
  }

  List<Widget> recentlyAddedCarMethod1(
      bool isArabic, String title, List<CarDetailModel> relatedCars,CompareProvider compareProvider) {
    Locale myLocale = Localizations.localeOf(context);
    isArabic = myLocale == const Locale('ar');

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: primaryMedium16),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchPage()));
              },
              child: Text(translation(context).viewAll, style: primaryMedium14),
            ),
          ],
        ),
      ),
      heightSpace2,
      Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
          return SizedBox(
            height: 280,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: relatedCars.length,
              itemBuilder: (context, index) {
                final car = relatedCars[index];
                for (final car in relatedCars.take(6)) {
                  precacheImage(CachedNetworkImageProvider(car.imageUrls.first), context);
                }
                final isFav =
                searchProvider.favouriteIds.contains(int.parse(car.id));
                final compared = compareProvider.isInCompare(CarListing(
                  id: car.id,
                  title: car.title,
                  price: car.price,
                  fuelType: car.fuelType,
                  transmission: car.transmission,
                  mileage: car.mileage,
                  year: car.year,
                  imageUrl: car.imageUrls[index],
                  imageUrls: car.imageUrls,
                  bodyType: car.bodyType,
                  engineCapacity: car.engineCapacity,
                  isFeatured: false,
                  carTag: "",
                  location: car.location,
                  color: car.color,
                  brand: car.make,
                ));
              return PushNavigate(
                  navigate: 'CarDetailPage',
                  child: Container(
                    margin: isArabic
                        ? index == 0
                        ? const EdgeInsets.only(left: 10)
                        : index == 2
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.symmetric(horizontal: 0)
                        : index == 0
                        ? const EdgeInsets.only(right: 10)
                        : index == 2
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.only(right: 10),
                    width: 200,
                    decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: CachedNetworkImage(
                            imageUrl: car.imageUrls.first,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                                color: Colors.grey.shade300,
                                height: 150),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.title,
                                  style: blackMedium14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '\฿',
                                  decimalDigits: 0,
                                ).format(
                                  double.tryParse(
                                    car.price.replaceAll(
                                        RegExp(r'[^0-9.]'), ''),
                                  ) ??
                                      0,
                                ),
                                style: primaryMedium14,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text(car.fuelType, style: colorA6Medium12),
                                    VerticalDivider(
                                        thickness: 1, width: 10, color: colorD9),
                                    Text('${car.mileage} km',
                                        style: colorA6Medium12),
                                    // VerticalDivider(
                                    //     thickness: 1, width: 10, color: colorD9),
                                    // Text(car.year, style: colorA6Medium12),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: isArabic
                              //       ? const EdgeInsets.only(top: 7, left: 8)
                              //       : const EdgeInsets.only(top: 7, right: 8),
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       setState(() {
                              //         _recentlyAddedFav.contains(index)
                              //             ? _recentlyAddedFav.remove(index)
                              //             : _recentlyAddedFav.add(index);
                              //       });
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           backgroundColor: primaryColor,
                              //           duration: const Duration(seconds: 3),
                              //           content: Text(
                              //             _recentlyAddedFav.contains(index)
                              //                 ? '${car.title} ${translation(context).addedFav}'
                              //                 : '${car.title} ${translation(context).removedFav}',
                              //             style: whiteMedium14,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     child: Icon(
                              //       _recentlyAddedFav.contains(index)
                              //           ? Icons.favorite_rounded
                              //           : Icons.favorite_outline_rounded,
                              //       color: _recentlyAddedFav.contains(index)
                              //           ? primaryColor
                              //           : colorA6,
                              //       size: 2.5.h,
                              //     ),
                              //   ),
                              // ),
                              Row(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => searchProvider
                                        .toggleCompare(context, CarListing(
                                        id: car.id,
                                        title: car.title,
                                        price: car.price,
                                        fuelType: car.fuelType,
                                        transmission: car.transmission,
                                        mileage: car.mileage,
                                        year: car.year,
                                        imageUrl: car.imageUrls.first,
                                        imageUrls: car.imageUrls,
                                        bodyType: car.bodyType,
                                        engineCapacity: car.engineCapacity,
                                        isFeatured: false,
                                        carTag: "",
                                        brand: car.make,
                                        location: car.location,
                                        modelVarient: car.modelVariant,
                                    )),
                                    child: Icon(Icons.compare_arrows,
                                        color: compared
                                            ? primaryColor
                                            : colorA6),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () => searchProvider
                                        .handleFavouriteToggle(
                                        CarListing(
                                            id: car.id,
                                            title: car.title,
                                            price: car.price,
                                            fuelType: car.fuelType,
                                            transmission: car.transmission,
                                            mileage: car.mileage,
                                            year: car.year,
                                            imageUrl: car.imageUrls[index],
                                            imageUrls: car.imageUrls,
                                            bodyType: car.bodyType,
                                            engineCapacity: car.engineCapacity,
                                            isFeatured: false,
                                            carTag: "",
                                            location: car.location,
                                              color: car.color,
                                              brand: car.make,), context, mounted,context),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border,
                                      color: isFav ? primaryColor : colorA6,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      )
    ];
  }

}

class EMICalculator extends StatefulWidget {
  final int? price;
  const EMICalculator({Key? key,this.price}) : super(key: key);

  @override
  State<EMICalculator> createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {

  var formatter = NumberFormat('#,##,000');
  // double _loanAmountSlider = 205900;
  // double _downPaymentSlider = 82100;
  // double _loanPeriodSlider = 6;
  // double _price = 520000; // or wherever you're getting the price
  double _loanPeriodSlider = 6;
  late double _downPaymentSlider;
  late double _loanAmountSlider;
  double _interestRateSlider = 5.0;
  double calculateMonthlyEMI(double principal, double annualRate, int loanYears) {
    final r = annualRate / 12 / 100; // monthly interest rate
    final n = loanYears * 12;        // total months

    if (r == 0) return principal / n;

    final emi = (principal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);

    return emi;
  }

  @override
  void initState() {
    super.initState();
    _downPaymentSlider = (widget.price ?? 0) * 0.20;
    _loanAmountSlider = (widget.price ?? 0) - _downPaymentSlider;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: transparent,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: primaryColor,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: '฿${formatter.format(calculateMonthlyEMI((_loanAmountSlider ).toDouble(), _interestRateSlider.toDouble(), _loanPeriodSlider.toInt()))}',
                    style: whiteMedium24,
                    children: [
                      TextSpan(
                        text: translation(context).perMonth,
                        style: whiteMedium14,
                      ),
                    ],
                  ),
                ),
                /*Text.rich(TextSpan(
                    text: '฿19,337',
                    style: whiteMedium24,
                    children: [
                      TextSpan(
                          text: translation(context).perMonth,
                          style: whiteMedium14)
                    ])),*/
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              color: white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [myBoxShadow],
            ),
            child: Center(
                child: Column(
              children: [
                Text('Finance Calculator',
                    //translation(context).emiCalculator,
                    style: primaryMedium16),
                Text('${translation(context).intrestRate}(1-10%)',
                    style: colorA6Medium14),
              ],
            )),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                heightSpace20,
                interestRateMethod(),
                loanAmontMethod(),
                downPaymentMethod(),
                loanPeriodMethod(),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Padding interestRateMethod() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(translation(context).intrestRate, style: blackMedium16),
                Text('${_interestRateSlider.toStringAsFixed(1)}%',
                    style: primaryMedium14),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: PrimarySlider(
              values: [_interestRateSlider],
              min: 1,
              max: 10,
              onDragging: (p0, p1, p2) =>
                  setState(() => _interestRateSlider = p1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1%', style: colorA6Medium14),
                Text('10%', style: colorA6Medium14),
              ],
            ),
          ),
          heightSpace30,
        ],
      ),
    );
  }

  Padding loanPeriodMethod() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(translation(context).loanPeriod, style: blackMedium16),
                Text('${_loanPeriodSlider.toStringAsFixed(0)} year',
                    style: primaryMedium14),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: PrimarySlider(
              values: [_loanPeriodSlider],
              min: 1,
              max: 7,
              onDragging: (p0, p1, p2) =>
                  setState(() => _loanPeriodSlider = p1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1 year', style: colorA6Medium14),
                Text('7 year', style: colorA6Medium14),
              ],
            ),
          ),
          heightSpace30,
        ],
      ),
    );
  }

  Padding downPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(translation(context).downPayment, style: blackMedium16),
                Text('฿${currencyFormatter.format(_downPaymentSlider)}',
                    style: primaryMedium14),
              ],
            ),
          ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 5),
           child: PrimarySlider(
             values: [_downPaymentSlider.clamp(57600, 188000)],
             min: 57600,
             max: 188000,
             onDragging: (p0, p1, p2) =>
                 setState(() => _downPaymentSlider = p1),
           ),
         ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('฿0', style: colorA6Medium14),
                Text('฿$_downPaymentSlider', style: colorA6Medium14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final NumberFormat currencyFormatter = NumberFormat('#,##0', 'en_US');
  Padding loanAmontMethod() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(translation(context).loanAmount, style: blackMedium16),
                // Text('฿${formatter.format(_loanAmountSlider)}',
                //     style: primaryMedium14),
                Text(translation(context).loanAmount, style: blackMedium16),
                Text('฿${currencyFormatter.format(_loanAmountSlider)}',
                    style: primaryMedium14),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: PrimarySlider(
              values: [_loanAmountSlider.clamp(0, 230400)],
              min: 100000,
              max: 230400,
              onDragging: (p0, p1, p2) =>
                  setState(() => _loanAmountSlider = p1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('฿0', style: colorA6Medium14),
                Text('฿$_loanAmountSlider', style: colorA6Medium14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Inside your mapMethod function
/*  List<Widget> mapMethod(CarDetailProvider provider) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Dealer Location',
          style: primarySemiBold16,
        ),
      ),
      heightSpace15,
      if (provider.isLoadingLocation)
        SizedBox(
          height: 25.h,
          width: 100.w,
          child: const Center(
            child: CircularProgressIndicator(color: primaryColor)
          )
        )
      else if (provider.locationError != null)
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(provider.locationError!),
        )
      else if (provider.locationLatLng != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 25.h,
            width: 100.w,
            child: GoogleMap(
              myLocationEnabled: false,
              initialCameraPosition: CameraPosition(
                target: provider.locationLatLng!,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('dealer_location'),
                  position: provider.locationLatLng!,
                )
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: true,
            ),
          ),
        )
      else
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Location data not available"),
        ),
    ];
  }*/