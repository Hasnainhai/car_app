import 'package:fl_carmax/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/key.dart';
import '../../../utils/widgets.dart';

class AddAddressPage extends StatelessWidget {
  final bool navigateBack;
  const AddAddressPage({Key? key, required this.navigateBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 17.5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: colorE6,
                        borderRadius: myBorderRadius10,
                        image: const DecorationImage(
                            image: AssetImage(addressLocation),
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () => showPlacePickerSheet(context),
                      child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: myBorderRadius5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                locationIcon,
                                height: 2.h,
                                color: white,
                              ),
                              widthSpace10,
                              Text(translation(context).editLocation,
                                  style: whiteMedium14),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              heightSpace20,
              Text(translation(context).addressTitle1, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                hintText: translation(context).addressTitle1,
              ),
              Text(translation(context).addressTitle2, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                hintText: translation(context).addressTitle2,
              ),
              Text(translation(context).addressTitle3, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                hintText: translation(context).addressTitle3hintText,
              ),
              Text(translation(context).addressTitle4, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                hintText: translation(context).addressTitle4hintText,
              ),
              Text(translation(context).addressTitle5, style: blackMedium14),
              heightSpace10,
              SecondaryTextField(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                hintText: translation(context).addressTitle5hintText,
              ),
              heightSpace20,
              PrimaryButton(
                title: translation(context).saveAddress,
                onTap: navigateBack
                    ? () => Navigator.pop(context)
                    : () => Navigator.pushNamed(context, '/BookInspectionPage'),
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
      child: CustomAppBar(title: translation(context).address),
    );
  }

  void showPlacePickerSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      isScrollControlled: true,
      context: context,
      builder: (context) => const PlacePickerSheet(),
    );
  }
}

class PlacePickerSheet extends StatelessWidget {
  const PlacePickerSheet({Key? key}) : super(key: key);
  static const kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: SizedBox(
        height: 88.h,
        child: Column(
          children: [
            Expanded(
              child: PlacePicker(
                apiKey: googleMapApiKey,
                initialPosition: kInitialPosition,
                useCurrentLocation: true,
                selectInitialPosition: true,
                hintText: "search ",
                searchingText: "Please wait ...",
                selectText: "Select place",
                outsideOfPickAreaText: "Place not in area",
                onPlacePicked: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
