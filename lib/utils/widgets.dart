// import 'package:another_xlider/another_xlider.dart';
// import 'package:fl_carmax/pages/auth/login_page.dart';
// import 'package:fl_carmax/pages/buy_car/car_detail/car_detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../pages/auth/login_page_email.dart';
// import 'constant.dart';

// class PrimaryButton extends StatelessWidget {
//   final String? title;
//   final String? navigate;
//   final VoidCallback? onTap;

//   const PrimaryButton({Key? key, this.title, this.onTap, this.navigate})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap ??
//           () {
//             if (navigate != null) {
//               Navigator.pushNamed(context, '/$navigate');
//             }
//           },
//       child: Container(
//         width: 100.w,
//         padding: const EdgeInsets.symmetric(vertical: 11.5),
//         decoration: BoxDecoration(boxShadow: [
//           BoxShadow(blurRadius: 6, color: primaryShadow.withOpacity(.25))
//         ], borderRadius: myBorderRadius10, color: primaryColor),
//         child: Center(
//           child: Text(
//             title ?? '',
//             style: whiteSemiBold18,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomAppBar extends StatelessWidget {
//   final List<Widget>? actions;
//   final String? title;
//   const CustomAppBar({Key? key, this.title, this.actions}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarBrightness: Brightness.light,
//         statusBarIconBrightness: Brightness.light,
//         statusBarColor: primaryColor,
//       ),
//       centerTitle: false,
//       shadowColor: colorForShadow.withOpacity(.25),
//       automaticallyImplyLeading: false,
//       backgroundColor: white,
//       iconTheme: const IconThemeData(color: black),
//       // leading: IconButton(
//       //   icon: const Icon(Icons.arrow_back),
//       //   onPressed: () => Navigator.pop(context),
//       // ),
//       titleSpacing: -5,
//       title: Text(title ?? '', style: blackSemiBold16),
//       actions: actions,
//     );
//   }
// }

// class PrimaryTextField extends StatelessWidget {
//   final TextEditingController? controller;
//   final TextInputAction? textInputAction;
//   final TextInputType? keyboardType;
//   final String? hintText;
//   bool? obscureText;
//   final Function(String)? onChanged;
//   final String prefixIcon;
//   PrimaryTextField(
//       {Key? key,
//       this.hintText,
//       required this.prefixIcon,
//       this.keyboardType,
//       this.textInputAction,
//       this.obscureText,
//       this.onChanged,
//       this.controller})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: onChanged,
//       obscureText: false,
//       style: colorA6Medium15,
//       controller: controller,
//       cursorColor: primaryColor,
//       keyboardType: keyboardType,
//       textInputAction: textInputAction ?? TextInputAction.next,
//       decoration: InputDecoration(
//         prefixIconConstraints: BoxConstraints(minWidth: 2.2.h),
//         enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: colorD9, width: 2)),
//         focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: colorD9, width: 2)),
//         prefixIcon: Padding(
//           padding: const EdgeInsets.only(right: 12),
//           child: Image.asset(
//             prefixIcon,
//             height: 2.2.h,
//             color: Colors.grey,
//           ),
//         ),
//         hintText: hintText,
//         hintStyle: colorA6Medium15,
//       ),
//     );
//   }
// }

// class PushNavigate extends StatelessWidget {
//   final String navigate;
//   final Widget child;
//   const PushNavigate({Key? key, required this.navigate, required this.child})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pushNamed(context, '/$navigate'),
//       child: child,
//     );
//   }
// }

// class PrimaryContainer extends StatelessWidget {
//   final double? width;
//   final Border? border;
//   final List<BoxShadow>? boxSadow;
//   final Function()? onTap;
//   final Color? color;
//   final Widget? child;
//   final EdgeInsets? margin;
//   final EdgeInsets? padding;
//   final BorderRadiusGeometry? borderRadius;
//   const PrimaryContainer(
//       {Key? key,
//       this.margin,
//       this.padding,
//       this.borderRadius,
//       this.child,
//       this.color,
//       this.onTap,
//       this.border,
//       this.boxSadow,
//       this.width})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: width,
//         padding: padding,
//         margin: margin,
//         decoration: BoxDecoration(
//             border: border,
//             color: color ?? white,
//             borderRadius: borderRadius ?? myBorderRadius10,
//             boxShadow: [myBoxShadow]),
//         child: child,
//       ),
//     );
//   }
// }

// class SecondaryTextField extends StatelessWidget {
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final TextInputAction? textInputAction;
//   final TextInputType? keyboardType;
//   final String? hintText;
//   final String? prefixIcon;
//   final TextEditingController? controller;

//   const SecondaryTextField(
//       {Key? key,
//       this.textInputAction,
//       this.keyboardType,
//       this.hintText,
//       this.prefixIcon,
//       this.controller,
//       this.padding,
//       this.margin})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PrimaryContainer(
//       margin: margin ?? const EdgeInsets.only(bottom: 25),
//       padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           prefixIcon != null
//               ? Image.asset(
//                   prefixIcon!,
//                   height: 2.h,
//                   width: 2.h,
//                   color: colorA6,
//                 )
//               : const SizedBox(),
//           prefixIcon != null ? widthSpace12 : const SizedBox(),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               cursorColor: primaryColor,
//               style: colorA6Medium14,
//               textInputAction: textInputAction ?? TextInputAction.next,
//               keyboardType: keyboardType,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: hintText,
//                 hintStyle: colorA6Medium14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PrimarySlider extends StatelessWidget {
//   final double? min;
//   final double? max;
//   final List<double> values;
//   final bool? rangeSlider;
//   final bool? alwaysShowTooltip;
//   final bool? toolTipDisabled;
//   final bool? selectByTap;
//   final dynamic Function(int, dynamic, dynamic)? onDragging;
//   const PrimarySlider(
//       {Key? key,
//       required this.values,
//       this.rangeSlider,
//       this.onDragging,
//       this.min,
//       this.max,
//       this.alwaysShowTooltip,
//       this.selectByTap,
//       this.toolTipDisabled})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var formatter = NumberFormat('#,##,000');
//     return SizedBox(
//       height: 5.h,
//       child: FlutterSlider(
//           rangeSlider: rangeSlider ?? false,
//           selectByTap: selectByTap ?? true,
//           tooltip: FlutterSliderTooltip(
//               disabled: toolTipDisabled ?? true,
//               alwaysShowTooltip: alwaysShowTooltip ?? false,
//               textStyle: primaryMedium14,
//               custom: (value) =>
//                   Text('฿${formatter.format(value)}', style: primaryMedium14),
//               boxStyle: const FlutterSliderTooltipBox(
//                   decoration: BoxDecoration(
//                 color: transparent,
//               ))),
//           rightHandler: FlutterSliderHandler(
//               decoration: const BoxDecoration(shape: BoxShape.circle),
//               child: Container(
//                 height: 2.3.h,
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [myBoxShadow],
//                   color: white,
//                 ),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: primaryColor,
//                   ),
//                 ),
//               )),
//           handler: FlutterSliderHandler(
//               decoration: const BoxDecoration(shape: BoxShape.circle),
//               child: Container(
//                 height: 2.3.h,
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [myBoxShadow],
//                   color: white,
//                 ),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: primaryColor,
//                   ),
//                 ),
//               )),
//           values: values,
//           trackBar: FlutterSliderTrackBar(
//               activeTrackBar: BoxDecoration(
//                   color: primaryColor, borderRadius: BorderRadius.circular(8)),
//               inactiveTrackBar: BoxDecoration(
//                   color: colorE6, borderRadius: BorderRadius.circular(8)),
//               inactiveDisabledTrackBarColor: amber,
//               inactiveTrackBarHeight: 5,
//               activeTrackBarHeight: 5,
//               activeDisabledTrackBarColor: amber),
//           max: max,
//           min: min,
//           onDragging: onDragging),
//     );
//   }
// }

// class SecondaryContainer extends StatelessWidget {
//   final Function()? onTap;
//   final String title;
//   final String hintText;
//   const SecondaryContainer(
//       {Key? key, this.onTap, required this.title, required this.hintText})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: blackMedium14),
//         heightSpace10,
//         PrimaryContainer(
//           margin: const EdgeInsets.only(bottom: 20),
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
//           onTap: onTap,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(hintText, style: colorA6Medium14),
//               Icon(
//                 Icons.chevron_right,
//                 color: colorA6,
//                 size: 2.5.h,
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

// class CarCardWidget extends StatefulWidget {
//   final List<String> imageUrls;
//   final bool? isFeatured;
//   final String id;
//   final String carTag;
//   final String title;
//   final String price;
//   final String year;
//   final String mileage;
//   final String fuelType;
//   final String transmission;
//   final String bodyType;
//   final String engineCapacity;
//   final int views;
//   final Widget? favouriteIcon;
//   final bool isFavourite;
//   final VoidCallback? onFavouriteToggle;
//   final Function()? onCompareTap;
//   final bool isInCompareList;

//   const CarCardWidget({
//     Key? key,
//     required this.id,
//     required this.imageUrls,
//     required this.title,
//     required this.price,
//     required this.year,
//     required this.mileage,
//     required this.fuelType,
//     required this.transmission,
//     required this.bodyType,
//     required this.engineCapacity,
//     required this.views,
//     this.favouriteIcon,
//     required this.isFavourite,
//     this.onFavouriteToggle,
//     required this.isInCompareList,
//     this.onCompareTap,
//     this.isFeatured,
//     this.carTag = '',
//   }) : super(key: key);

//   @override
//   _CarCardWidgetState createState() => _CarCardWidgetState();
// }

// class _CarCardWidgetState extends State<CarCardWidget> {
//   int _currentIndex = 0; // Tracks the current image index
//   final NumberFormat formatter = NumberFormat("#,###", "en_US");
//   late bool _isFav;

//   @override
//   void initState() {
//     super.initState();
//     _isFav = widget.isFavourite;
//   }

//   void _handleFavouriteToggle() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id');

//     if (userId == null || userId == 0) {
//       // User is not logged in
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(
//             "Login Required",
//             style: blackMedium18,
//           ),
//           content: Text("Please login to add items to your favourites.",
//               style: blackMedium14),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 "Cancel",
//                 style: primaryMedium14,
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => LoginPageEmail()));
//               },
//               child: Text(
//                 "Login",
//                 style: whiteMedium14,
//               ),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     // If logged in, proceed to toggle favourite
//     widget.onFavouriteToggle?.call();

//     setState(() {
//       _isFav = !_isFav;
//     });
//   }
//   String _formatMileage(String rawMileage) {
//     final cleaned = rawMileage.replaceAll(RegExp(r'[^\d]'), '');
//     if (cleaned.isEmpty) return "N/A";

//     final number = int.tryParse(cleaned);
//     if (number == null || number == 0) return "N/A";

//     return "${NumberFormat.decimalPattern().format(number)} km";
//   }
//   Widget buildCarDetails() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             if (widget.year.isNotEmpty)
//               _fixedWidthChip(icon: Icons.calendar_today, label: widget.year, a: '   |   ',),

//             if (widget.mileage.isNotEmpty)
//               _fixedWidthChip(
//                 icon: Icons.speed,
//                 label: _formatMileage(widget.mileage),a: '   |   ',
//               ),
//             if (widget.fuelType.isNotEmpty)
//               _fixedWidthChip(
//                   icon: Icons.local_gas_station, label: widget.fuelType,a: '   |  '),
//                    if (widget.transmission.isNotEmpty)
//               _fixedWidthChip(icon: Icons.settings, label: widget.transmission,a: ''),

//           ],
//         ),
//         Row(
//           children: [

//             if (widget.bodyType.isNotEmpty)
//               _fixedWidthChip(
//                   icon: Icons.directions_car, label: widget.bodyType,a: '   |   '),
//             if (widget.engineCapacity.isNotEmpty)
//               _fixedWidthChip(
//                   image: AssetImage('assets/images/engine.png'),
//                   label: "${widget.engineCapacity}",a: ''),
//           ],
//         )
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         decoration: BoxDecoration(
//             // border: Border.all(color: Colors.orange),
//             borderRadius: BorderRadius.circular(10)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//                   child: GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CarDetailPage(
//                           carId: widget.id,
//                           isInitiallyFavourite: _isFav,
//                         ),
//                       ),
//                     ),

//                     // Navigator.pushNamed(
//                     //   context,
//                     //   '/CarDetailPage',
//                     //   arguments: widget.id, // or pass `item.id` from parent
//                     // ),
//                     child: CarouselSlider.builder(
//                       itemCount: widget.imageUrls.length,
//                       options: CarouselOptions(
//                         height: 200,
//                         autoPlay: false,
//                         enlargeCenterPage: false,
//                         viewportFraction: 1,
//                         onPageChanged: (index, reason) {
//                           setState(() {
//                             _currentIndex = index;
//                           });
//                         },
//                       ),
//                       itemBuilder: (context, index, realIndex) {
//                         return
//                             // Image.asset(
//                             //   widget.imageUrls[index],
//                             //   width: double.infinity,
//                             //   height: 200,
//                             //   fit: BoxFit.cover,
//                             // );
//                             Image.network(
//                           widget.imageUrls[index],
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: 200,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Image.asset(
//                                 'assets/images/placeholder.png'); // fallback
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 // **Dots Indicator**
//                 Positioned(
//                   bottom: 10,
//                   child: AnimatedSmoothIndicator(
//                     activeIndex: _currentIndex,
//                     count: widget.imageUrls.length.clamp(1, 5),
//                     effect: WormEffect(
//                       dotHeight: 8,
//                       dotWidth: 8,
//                       activeDotColor: Colors.white,
//                       dotColor: Colors.grey.shade400,
//                     ),
//                   ),
//                 ),

//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Row(
//                     children: [
//                       if (widget.isFeatured == true)
//                         _badge("Featured", Colors.black, Colors.orange, 14),
//                       if (widget.carTag.isNotEmpty) ...[
//                         const SizedBox(width: 6),
//                         _badge(widget.carTag, Colors.orange, Colors.white, 12),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: blackMedium18,
//                   ),
//                   SizedBox(height: 5),
//                   // Text(
//                   //   widget.price,
//                   //   style: TextStyle(
//                   //       fontSize: 18,
//                   //       color: Colors.orange,
//                   //       fontWeight: FontWeight.bold),
//                   // ),
//                   Text(
//                       "฿${formatter.format(int.tryParse(widget.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0)}",
//                       style: primaryMedium16),

//                   SizedBox(height: 10),
//                   buildCarDetails(),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.compare_arrows,
//                                 color: widget.isInCompareList
//                                     ? primaryColor
//                                     : colorA6),
//                             onPressed: widget.onCompareTap,
//                           ),

//                           // Padding(
//                           //   padding: const EdgeInsets.all(8.0),
//                           //   child: widget.favouriteIcon,
//                           // ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: _handleFavouriteToggle,
//                               child: Icon(
//                                 _isFav
//                                     ? Icons.favorite_rounded
//                                     : Icons.favorite_outline_rounded,
//                                 color: _isFav ? primaryColor : colorA6,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text("${widget.views} Views",
//                           style: TextStyle(color: Colors.grey, fontSize: 12)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Badge Widget

//   Widget _badge(String text, Color bgColor, Color textColor, int fontSize) {
//     return Container(
//       width: 80, // fixed width
//       padding: EdgeInsets.symmetric(vertical: 4), // no horizontal padding now
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       alignment: Alignment.center, // centers the text
//       child: Text(
//         text,
//         style: TextStyle(color: textColor, fontSize: fontSize.toDouble()),
//         overflow: TextOverflow.ellipsis,
//         maxLines: 1,
//       ),
//     );
//   }



//   Widget _infoChip({
//     IconData? icon,
//     ImageProvider? image,
//     required String text,
//     required String a
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 5),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
//         decoration: BoxDecoration(
//           //color: primaryColor,
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min, // ✅ Ensures chip shrinks to fit
//           children: [
//             if (icon != null) Icon(icon, size: 18, color: colorA6),
//             if (image != null)
//               Image(
//                 image: image,
//                 width: 18,
//                 height: 18,
//                 fit: BoxFit.contain,
//                 color: colorA6,
//               ),
//             if (icon != null || image != null) SizedBox(width: 5),
//             Text(
//               '${text   }',
//               style: colorA6Medium12,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(a, style: colorA6Medium12,),
//           ],
//         ),
//       ),
//     );
//   }

// // Widget _infoChip({IconData? icon, ImageProvider? image, required String text}) {
// //   return Padding(
// //     padding: const EdgeInsets.only(top: 5),
// //     child: Container(
// //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //       decoration: BoxDecoration(
// //         color: primaryColor,
// //         borderRadius: BorderRadius.circular(4),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           if (icon != null) Icon(icon, size: 18),
// //           if (image != null)
// //             Image(image: image, width: 18, height: 18, fit: BoxFit.contain),
// //           SizedBox(width: 5),
// //          Expanded(
// //   child: Text(
// //     text,
// //     style: TextStyle(fontSize: 10),
// //     maxLines: 1,
// //     overflow: TextOverflow.ellipsis,
// //   ),
// // ),

// //         ],
// //       ),
// //     ),
// //   );
// // }

//   /// Helper function to create chips with a fixed width
// // Widget _fixedWidthChip(
// //     {IconData? icon, ImageProvider? image, required String label}) {
// //   return SizedBox(
// //     width: 90, // Fixed width, adjust as needed
// //     child: _infoChip(icon: icon, image: image, text: label),
// //   );
// // }

//   Widget _fixedWidthChip({
//    required String a,
//     IconData? icon,
//     ImageProvider? image,
//     required String label,
//   }) {
//     return _infoChip(icon: icon, image: image, text: label,a: a);
//   }
// }


import 'package:another_xlider/another_xlider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../pages/auth/login_page_email.dart';
import '../pages/buy_car/car_detail/car_detail_page.dart';
import 'constant.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final String? navigate;
  final VoidCallback? onTap;

  const PrimaryButton({Key? key, this.title, this.onTap, this.navigate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
              () {
            if (navigate != null) {
              Navigator.pushNamed(context, '/$navigate');
            }
          },
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(vertical: 11.5),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 6, color: primaryShadow.withOpacity(.25))
        ], borderRadius: myBorderRadius10,
            color: primaryColor
        ),
        child: Center(
          child: Text(
            title ?? '',
            style: whiteSemiBold18,
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final String? title;
  const CustomAppBar({Key? key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor,
      ),
      centerTitle: false,
      shadowColor: colorForShadow.withOpacity(.25),
      automaticallyImplyLeading: false,
      backgroundColor: white,
      iconTheme: const IconThemeData(color: black),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: -5,
      title: Text(title ?? '', style: blackSemiBold16),
      actions: actions,
    );
  }
}

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;
  bool? obscureText;
  final Function(String)? onChanged;
  final String prefixIcon;
  PrimaryTextField(
      {Key? key,
        this.hintText,
        required this.prefixIcon,
        this.keyboardType,
        this.textInputAction,
        this.obscureText,
        this.onChanged,
        this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: false,
      style: colorA6Medium15,
      controller: controller,
      cursorColor: primaryColor,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(minWidth: 2.2.h),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorD9, width: 2)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorD9, width: 2)),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Image.asset(
            prefixIcon,
            height: 2.2.h,
            color: Colors.grey,
          ),
        ),
        hintText: hintText,
        hintStyle: colorA6Medium15,
      ),
    );
  }
}

class PushNavigate extends StatelessWidget {
  final String navigate;
  final Widget child;
  const PushNavigate({Key? key, required this.navigate, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, navigate),
      child: child,
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final double? width;
  final Border? border;
  final List<BoxShadow>? boxSadow;
  final Function()? onTap;
  final Color? color;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;
  const




  PrimaryContainer(


      {Key? key,
        this.margin,
        this.padding,
        this.borderRadius,
        this.child,
        this.color,
        this.onTap,
        this.border,
        this.boxSadow,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            border: border,
            color: color ?? white,
            borderRadius: borderRadius ?? myBorderRadius10,
            boxShadow: [myBoxShadow]),
        child: child,
      ),
    );
  }
}

class SecondaryTextField extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? prefixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const SecondaryTextField(
      {Key? key,
        this.textInputAction,
        this.keyboardType,
        this.hintText,
        this.prefixIcon,
        this.controller,
        this.padding,
        this.onChanged,
        this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      margin: margin ?? const EdgeInsets.only(bottom: 25),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          prefixIcon != null
              ? Image.asset(
            prefixIcon!,
            height: 2.h,
            width: 2.h,
            color: colorA6,
          )
              : const SizedBox(),
          prefixIcon != null ? widthSpace12 : const SizedBox(),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              cursorColor: primaryColor,
              style: colorA6Medium14,
              textInputAction: textInputAction ?? TextInputAction.next,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: colorA6Medium14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimarySlider extends StatelessWidget {
  final double? min;
  final double? max;
  final List<double> values;
  final bool? rangeSlider;
  final bool? alwaysShowTooltip;
  final bool? toolTipDisabled;
  final bool? selectByTap;
  final dynamic Function(int, dynamic, dynamic)? onDragging;
  const PrimarySlider(
      {Key? key,
        required this.values,
        this.rangeSlider,
        this.onDragging,
        this.min,
        this.max,
        this.alwaysShowTooltip,
        this.selectByTap,
        this.toolTipDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,000');
    return SizedBox(
      height: 5.h,
      child: FlutterSlider(
          rangeSlider: rangeSlider ?? false,
          selectByTap: selectByTap ?? true,
          tooltip: FlutterSliderTooltip(
              disabled: toolTipDisabled ?? true,
              alwaysShowTooltip: alwaysShowTooltip ?? false,
              textStyle: primaryMedium14,
              custom: (value) =>
                  Text('฿${formatter.format(value)}', style: primaryMedium14),
              boxStyle: const FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                    color: transparent,
                  ))),
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
              )),
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
              )),
          values: values,
          trackBar: FlutterSliderTrackBar(
              activeTrackBar: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(8)),
              inactiveTrackBar: BoxDecoration(
                  color: colorE6, borderRadius: BorderRadius.circular(8)),
              inactiveDisabledTrackBarColor: amber,
              inactiveTrackBarHeight: 5,
              activeTrackBarHeight: 5,
              activeDisabledTrackBarColor: amber),
          max: max,
          min: min,
          onDragging: onDragging),
    );
  }
}

class SecondaryContainer extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final String hintText;
  const SecondaryContainer(
      {Key? key, this.onTap, required this.title, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: blackMedium14),
        heightSpace10,
        PrimaryContainer(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hintText, style: colorA6Medium14),
              Icon(
                Icons.chevron_right,
                color: colorA6,
                size: 2.5.h,
              )
            ],
          ),
        )
      ],
    );
  }
}

class CarCardWidget extends StatefulWidget {
  final List<String> imageUrls;
  final bool? isFeatured;
  final String id;
  final String carTag;
  final String title;
  final String price;
  final String year;
  final String mileage;
  final String fuelType;
  final String? carModelName;
  final String transmission;
  final String bodyType;
  final String engineCapacity;
  final String views;
  final Widget? favouriteIcon;
  final bool isFavourite;
  final VoidCallback? onFavouriteToggle;
  final Function()? onCompareTap;
  final bool isInCompareList;
  final List<dynamic>? modeListD;
  final bool hideView;



  const CarCardWidget({
    Key? key,
    required this.id,
    required this.imageUrls,
    required this.title,
    required this.price,
    required this.year,
    required this.mileage,
    required this.fuelType,
     this.carModelName,
    required this.transmission,
    required this.bodyType,
    required this.engineCapacity,
    required this.views,
    this.favouriteIcon,
    required this.isFavourite,
    this.onFavouriteToggle,
    required this.isInCompareList,
    this.onCompareTap,
    this.isFeatured,
    this.carTag = '', required this.modeListD,
    this.hideView = true,
  }) : super(key: key);

  @override
  _CarCardWidgetState createState() => _CarCardWidgetState();
}

class _CarCardWidgetState extends State<CarCardWidget> {
  int _currentIndex = 0; // Tracks the current image index
  final NumberFormat formatter = NumberFormat("#,###", "en_US");
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavourite;
    // WidgetsBinding.instance.addPostFrameCallback((_) => initial());
  }
  // initial(){
  //   if (!mounted) return;
  //   for (String url in widget.imageUrls) {
  //     precacheImage(CachedNetworkImageProvider(url), context);
  //   }
  // }
  void _handleFavouriteToggle() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      // User is not logged in
      if(context.mounted){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Login Required",style: blackMedium18,),
            content: Text("Please login to add items to your favourites.",style: blackMedium14),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel",style:  primaryMedium14,),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPageEmail()));

                },
                child: Text("Login",style:whiteMedium14 ,),
              ),
            ],
          ),
        );
      }
      return;
    }

    // If logged in, proceed to toggle favourite
    widget.onFavouriteToggle?.call();

    setState(() {
      _isFav = !_isFav;
    });
  }

  // void _handleFavouriteToggle() async {
  //   widget.onFavouriteToggle?.call();

  //   setState(() {
  //     _isFav = !_isFav; // Toggle locally
  //   });
  // }
  String _formatMileage(String rawMileage) {
    final cleaned = rawMileage.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.isEmpty) return "N/A";

    final number = int.tryParse(cleaned);
    if (number == null || number == 0) return "N/A";

    return NumberFormat.decimalPattern().format(number);
  }


  Widget buildCarDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 0,
          runSpacing: 4,
          children: [
            if (widget.year.isNotEmpty)
              _fixedWidthChip(icon: Icons.calendar_today, label: widget.year, a: '   |   '),
            if (widget.mileage.isNotEmpty)
              _fixedWidthChip(icon: Icons.speed, label: _formatMileage(widget.mileage), a: '   |   '),
            if (widget.fuelType.isNotEmpty)
              _fixedWidthChip(icon: Icons.local_gas_station, label: widget.fuelType, a: ''),

          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 0,
          runSpacing: 4,
          children: [
            if (widget.transmission.isNotEmpty)
              _fixedWidthChip(icon: Icons.settings, label: widget.transmission, a: '   |   '),
            if (widget.bodyType.isNotEmpty)
              _fixedWidthChip(icon: Icons.directions_car, label: widget.bodyType, a: '   |   '),
            if (widget.engineCapacity.isNotEmpty)
              _fixedWidthChip(
                image: const AssetImage('assets/images/engine.png'),
                label: widget.engineCapacity,
                a: '',
              ),
          ],
        ),
      ],
    );
  }


//   Widget buildCarDetails() {
//     List<Widget> chips = [
//       if (widget.year.isNotEmpty)
//         _fixedWidthChip(icon: Icons.calendar_today, label: widget.year),
//       if (widget.mileage.isNotEmpty)
// _fixedWidthChip(
//   icon: Icons.speed,
//   label: _formatMileage(widget.mileage),
// ),

//       if (widget.fuelType.isNotEmpty)
//         _fixedWidthChip(icon: Icons.local_gas_station, label: widget.fuelType),
//       if (widget.transmission.isNotEmpty)
//         _fixedWidthChip(icon: Icons.settings, label: widget.transmission),
//       if (widget.bodyType.isNotEmpty)
//         _fixedWidthChip(icon: Icons.directions_car, label: widget.bodyType),
//       if (widget.engineCapacity.isNotEmpty)
//         _fixedWidthChip(
//             image: AssetImage('assets/images/engine.png'),
//             label: "${widget.engineCapacity}"),
//     ];

//     return Wrap(
//       spacing: 8, // Horizontal spacing
//       runSpacing: 8, // Vertical spacing
//       alignment: WrapAlignment.start, // Aligns items properly
//       children: chips,
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.orange),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailPage(
                          carId: widget.id,
                          isInitiallyFavourite: _isFav,
                          modelsListD: widget.modeListD,
                        ),
                      ),
                    ),
                    // Navigator.pushNamed(
                    //   context,
                    //   '/CarDetailPage',
                    //   arguments: widget.id, // or pass `item.id` from parent
                    // ),
                    child: CarouselSlider.builder(
                      itemCount: widget.imageUrls.length,
                      options: CarouselOptions(
                        height: 230,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return CachedNetworkImage(
                          imageUrl: widget.imageUrls[index],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.fitWidth,
                          errorWidget: (context, url, error) =>
                              Image.asset(
                                'assets/images/placeholder.png',
                                //  fit: BoxFit.cover,

                              ),
                        );
                      },
                    ),
                  ),
                ),
                // **Dots Indicator**
                Positioned(
                  bottom: 16,
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: widget.imageUrls.length.clamp(1, 5),
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey.shade400,
                    ),
                  ),
                ),
                // **Top Left Badges**
                // Positioned(
                //   top: 10,
                //   left: 10,
                //   child: Row(
                //     children: [
                //       _badge("Featured", Colors.black, Colors.orange),
                //       SizedBox(width: 5),
                //       _badge("Low Mileage", Colors.orange, white),
                //     ],
                //   ),
                // ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      if (widget.isFeatured == true)
                        _badge("Featured", Colors.black, Colors.orange,12),
                      if (widget.carTag.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        _badge(widget.carTag, Colors.orange, Colors.white,12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: blackMedium16.copyWith(),
                  ),
                  // Text(
                  //   widget.price,
                  //   style: TextStyle(
                  //       fontSize: 18,
                  //       color: Colors.orange,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Text(
                      "฿${formatter.format(int.tryParse(widget.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0)}",
                      style:  primaryMedium16
                  ),
                  buildCarDetails(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.compare_arrows,
                                color: widget.isInCompareList
                                    ? primaryColor
                                    : colorA6),
                            onPressed: widget.onCompareTap,
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: widget.favouriteIcon,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: _handleFavouriteToggle,
                              child: Icon(
                                _isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: _isFav ? primaryColor : colorA6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: widget.hideView,
                        child: Text("${widget.views} Views",
                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
  }

  // Badge Widget

  Widget _badge(String text, Color bgColor, Color textColor,int fontSize,
      {double vertical = 4, double horizontal = 12}) {
    return Container(
      // width: 80, // fixed width
      height: 30,
      padding:  EdgeInsets.symmetric(vertical:vertical, horizontal: horizontal ), // no horizontal padding now
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center, // centers the text
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize.toDouble()),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

//   Widget _badge(String text, Color color, Color textColor) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(color: textColor, fontSize: 12),
//       ),
//     );
//   }
// }

// Widget _badge(String text, Color color) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration:
//         BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
//     child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
//   );
// }


  Widget _infoChip({
    IconData? icon,
    ImageProvider? image,
    required String text,
    required String a
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        decoration: BoxDecoration(
          //color: primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // ✅ Ensures chip shrinks to fit
          children: [
            if (icon != null) Icon(icon, size: 18, color: colorA6),
            if (image != null)
              Image(
                image: image,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
                color: colorA6,
              ),
            if (icon != null || image != null) const SizedBox(width: 3),
            Flexible(
              child: Text(
                text,
                style: colorA6Medium12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(a, style: colorA6Medium12,),
          ],
        ),
      ),
    );
  }

// Widget _infoChip({IconData? icon, ImageProvider? image, required String text}) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 5),
//     child: Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: primaryColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null) Icon(icon, size: 18),
//           if (image != null)
//             Image(image: image, width: 18, height: 18, fit: BoxFit.contain),
//           SizedBox(width: 5),
//          Expanded(
//   child: Text(
//     text,
//     style: TextStyle(fontSize: 10),
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//   ),
// ),

//         ],
//       ),
//     ),
//   );
// }

  /// Helper function to create chips with a fixed width
// Widget _fixedWidthChip(
//     {IconData? icon, ImageProvider? image, required String label}) {
//   return SizedBox(
//     width: 90, // Fixed width, adjust as needed
//     child: _infoChip(icon: icon, image: image, text: label),
//   );
// }

  Widget _fixedWidthChip({
    required String a,
    IconData? icon,
    ImageProvider? image,
    required String label,
  }) {
    return _infoChip(icon: icon, image: image, text: label,a: a);
  }

}