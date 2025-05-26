import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_carmax/pages/auth/login_page_email.dart';
import 'package:fl_carmax/pages/buy_car/compare_page/compare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../helper/language_constant.dart';
import '../../../models/car_details_model.dart';
import '../../../models/car_listing_model.dart';
import '../../../utils/constant.dart';
import '../search/search_provider.dart';

class CarDetailWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String title;
  final String carId;
  final String sellerName;
  final String mileage;
  final String year;
  final CarDetailModel carDetail;
  final String transmission;
  final String fuelType;
  final String location;
  final String? modelVarient;
  final String? carModel;
  final  List<dynamic>? modelsListD;

  const CarDetailWidget({
    Key? key,
    required this.imageUrls,
    required this.title,
    required this.sellerName,
    required this.mileage,
    required this.year,
    required this.transmission,
    required this.fuelType,
    required this.carDetail,
    required this.carId,
    required this.location,
    required this.modelsListD,
    this.modelVarient,
    this.carModel,
  }) : super(key: key);

  @override
  State<CarDetailWidget> createState() => _CarDetailWidgetState();
}

class _CarDetailWidgetState extends State<CarDetailWidget> {
  // final String carDetailMain = 'assets/images/BMW-420d/1.webp';
  bool showAll = false;
  late List<String> allImages;
/*  final List<String> carImages = [
    'assets/images/BMW-420d/12.webp',
    'assets/images/BMW-420d/4.webp',
    'assets/images/BMW-420d/5.webp',
    'assets/images/BMW-420d/6.webp',
    'assets/images/BMW-420d/7.webp',
    'assets/images/BMW-420d/8.webp',
    'assets/images/BMW-420d/9.webp',
    'assets/images/BMW-420d/10.webp',
    'assets/images/BMW-420d/11.webp',
    'assets/images/BMW-420d/13.webp',
    'assets/images/BMW-420d/3.webp',
    'assets/images/BMW-420d/4.webp',
    'assets/images/BMW-420d/5.webp',
    'assets/images/BMW-420d/2.webp',
  ];*/
  bool _isFavourite = false;
  @override
  void initState() {
    super.initState();
    allImages = widget.imageUrls;
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      String? userID = await getUserIdMethod();
      if(userID == null) return;
      _isFavourite = await toggleWishlist(int.parse(widget.carId), false);
    });
  }

Future<String?> getUserIdMethod()async{
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  return "$userId";
}

Future<bool> toggleWishlist(int listingId, bool isAdding) async {
    String? userId = await getUserIdMethod();
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getInt('user_id');
      final url = Uri.parse(
        isAdding
            ? 'https://www.wowcar.app/wp-json/custom/v1/wishlist/add'
            : 'https://www.wowcar.app/wp-json/custom/v1/wishlist/remove',
      );

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': userId,
            'listing_id': listingId,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _isFavourite = true;
          });
          return true;
        } else {
          setState(() {
            _isFavourite = false;
          });
          print('Failed to update wishlist: ${response.body}');
          return false;
        }
      } catch (e) {
        print('Error updating wishlist: $e');
        return false;
      }

  }

  void openLightbox(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LightboxScreen(
          images: allImages,
          initialIndex: index,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GestureDetector(
        //   onTap: () => openLightbox(context, 0),
        //   child: Image.asset(carDetailMain),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Add padding
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // Make it rounded
            child: GestureDetector(
              onTap: () => openLightbox(context, 0), // Assuming openLightbox is defined
              child: CachedNetworkImage(
                width: MediaQuery.sizeOf(context).width,
                height: 200,
                imageUrl: allImages.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[300], // Placeholder background
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        heightSpace5,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.w,
              mainAxisSpacing:4.4.w,
              childAspectRatio: 1.5,
            ),
            itemCount: showAll ? allImages.length - 1 : 4,
            itemBuilder: (context, index) {
              final actualIndex = index + 1; // skip the first image (main one shown above)
              return GestureDetector(
                onTap: () {
                  if (index == 3 && !showAll) {
                    openLightbox(context, 1);
                  } else {
                    openLightbox(context, actualIndex);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: allImages[actualIndex],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[300], // Placeholder background
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      if (index == 3 && !showAll)
                        Container(
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Text(
                                  "Show All",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // itemCount: showAll
                //     ? carImages.length
                //     : 4, // Show 4 initially, all when expanded
                // itemBuilder: (context, index) {
                //   return GestureDetector(
                //     onTap: () {
                //       // if (index == 3 && !showAll) {
                //       //   // Toggle showAll when clicking the last image
                //       //   setState(() {
                //       //     showAll = true;
                //       //   });
                //       // } else {
                //       //   openLightbox(context, index);
                //       // }

                //       if (index == 3 && !showAll) {
                //         openLightbox(
                //             context, 1); // Open lightbox from the first car image
                //       } else {
                //         openLightbox(context,
                //             index + 1); // Adjust index as carDetailMain is at 0
                //       }
                //     },
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(8),
                //       child: Stack(
                //         fit: StackFit.expand,
                //         children: [
                //           Image.network(allImages[index], fit: BoxFit.cover),
                //           if (index == 3 &&
                //               !showAll) // Show overlay only on the 4th image before expanding
                //             Container(
                //               color: Colors.black.withOpacity(0.6),
                //               child: Center(
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       color: primaryColor,
                //                       borderRadius: BorderRadius.circular(8)),
                //                   child: Padding(
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 12, vertical: 8),
                //                     child: Text(
                //                       "Show All",
                //                       style: TextStyle(
                //                         color: black,
                //                         fontSize: 8.sp,
                //                         fontWeight: FontWeight.w500,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //         ],
                //       ),
                //     ),
              );
            },
          ),
        ),
        heightSpace10,

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSpace10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () async {
                    //     // final newValue = !_isFavourite;
                    //     // final updated = await toggleWishlist(
                    //     //   int.parse(widget.carId),
                    //     //   newValue,
                    //     // );

                    //     // if (updated && mounted) {
                    //     //   setState(() {
                    //     //     _isFavourite = newValue;
                    //     //   });
                    //     // }
                    //     // if(!mounted) return;
                    //     // ScaffoldMessenger.of(context).showSnackBar(
                    //     //   SnackBar(
                    //     //     backgroundColor: primaryColor,
                    //     //     duration: const Duration(seconds: 1),
                    //     //     content: Text(
                    //     //       _isFavourite
                    //     //           ? '${widget.title ?? ''} ${translation(context).addedFav}'
                    //     //           : '${widget?.title ?? ''} ${translation(context).removedFav}',
                    //     //       style: whiteMedium14,
                    //     //     ),
                    //     //   ),
                    //     //       );
                    //   },
                    //   child: Icon(
                    //     // _isFavourite
                    //     //     ? Icons.favorite_rounded
                    //     //  :
                    //     Icons.favorite_outline_rounded,
                    //     size: 2.7.h,
                    //     color: _isFavourite ? colorA6 : colorA6,
                    //   ),
                    // ),
                    Consumer2<SearchProvider,CompareProvider>(builder: (context, searchProvider,compareProvider, child) {
                      final compared = compareProvider.isInCompare(
                          CarListing(
                              id: widget.carId,
                              title: widget.title,
                              price: widget.carDetail.price,
                              fuelType: widget.carDetail.fuelType,
                              transmission: widget.carDetail.transmission,
                              mileage: widget.carDetail.mileage,
                              year: widget.carDetail.year,
                              imageUrl: widget.carDetail.imageUrls.first,
                              imageUrls: widget.carDetail.imageUrls,
                              bodyType: widget.carDetail.bodyType,
                              engineCapacity: widget.carDetail.engineCapacity,
                              isFeatured: false,
                              carTag: "",
                              location: widget.carDetail.location,
                              color:widget.carDetail.color,
                              brand: widget.carDetail.make,
                              modelsListD: widget.modelsListD,
                              carmodels: widget.carModel
                          )
                      );
                      print("Manan${compared}");
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => searchProvider
                            .toggleCompare(context, CarListing(
                          id: widget.carId,
                          title: widget.title,
                          price: widget.carDetail.price,
                          fuelType: widget.carDetail.fuelType,
                          transmission: widget.carDetail.transmission,
                          mileage: widget.carDetail.mileage,
                          year: widget.carDetail.year,
                          imageUrl: widget.carDetail.imageUrls.first,
                          imageUrls: widget.carDetail.imageUrls,
                          bodyType: widget.carDetail.bodyType,
                          engineCapacity: widget.carDetail.engineCapacity,
                          isFeatured: false,
                          carTag: "",
                          location: widget.carDetail.location,
                          color: widget.carDetail.color,
                          brand: widget.carDetail.make,
                          modelsListD: widget.modelsListD,
                          modelVarient: widget.modelVarient,
                          modelsType: widget.carModel,
                        )),
                        child: Icon(Icons.compare_arrows,
                            color:  compared
                                ? primaryColor
                                : colorA6),
                      );
                    },),
                    widthSpace10,
                    GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getInt('user_id');
                        final newValue = !_isFavourite;
                        if(userId == null){
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text(
                                        "Login Required",
                                        style: blackMedium18,
                                      ),
                                      content: Text("Please login to add items to your favourites.",
                                          style: blackMedium14),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            "Cancel",
                                            style: primaryMedium14,
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) => const LoginPageEmail()));
                                          },
                                          child: Text(
                                            "Login",
                                            style: whiteMedium14,
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            }
                            debugPrint('User ID not found in SharedPreferences.');

                          //  await toggleWishlist(
                          //   int.parse(widget.carId),
                          //   newValue,
                          // );
                          return;
                        }
                        final updated = await toggleWishlist(
                          int.parse(widget.carId),
                          newValue,
                        );

                        if (updated && mounted) {
                          setState(() {
                            _isFavourite = newValue;
                          });
                        }
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: primaryColor,
                            duration: const Duration(seconds: 1),
                            content: Text(
                              _isFavourite
                                  ? '${widget.carDetail.title ?? ''} ${translation(context).addedFav}'
                                  : '${widget.carDetail.title ?? ''} ${translation(context).removedFav}',
                              style: whiteMedium14,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        _isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        size: 2.7.h,
                        color: _isFavourite ? primaryColor : colorA6,
                      ),
                    ),
                    // Text(
                    //   'Share with',
                    //   style: colorA6Medium12,
                    // ),

                    // // SizedBox(width: 20,),
                    // widthSpace10,
                    // Image.asset(
                    //   'assets/images/inst.png',
                    //   color: primaryColor,
                    //   height: 25,
                    // ),
                    // widthSpace10,
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: primaryColor,
                    //       borderRadius: BorderRadius.circular(5)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(2.0),
                    //     child: Image.asset(
                    //       'assets/images/facebool.png',
                    //       height: 17,
                    //       color: white,
                    //     ),
                    //   ),
                    // ),
                    // widthSpace10,
                    // Image.asset(
                    //   'assets/images/twiter.png',
                    //   height: 25,
                    //   color: primaryColor,
                    // ),
                  ],
                ),
              ),
              heightSpace10,
              Text(widget.title, style: blackSemiBold18),
              heightSpace5,
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text('${widget.transmission}|', style: colorA6Medium12),
                    Text(widget.fuelType, style: colorA6Medium12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: VerticalDivider(
                          thickness: 1, width: 10, color: colorD9),
                    ),
                    Text(
                      '${NumberFormat.decimalPattern().format(int.tryParse(widget.mileage.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)} km',
                      style: colorA6Medium12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: VerticalDivider(
                          thickness: 1, width: 10, color: colorD9),
                    ),
                    Text(widget.year, style: colorA6Medium12),
                  ],
                ),
              ),
              heightSpace5,

              Row(
                children: [
                  const Text(
                    "Seller Name: ",
                    style: TextStyle(
                      color: primaryColor, // Make it look like a link
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.sellerName,
                    style: const TextStyle(
                      color: Colors.black, // Make it look like a link
                      fontSize: 12,
                    ),
                  )
                ],
              ),

              heightSpace5,

              // Row(
              //   children: [
              //     Image.asset(locationIcon, color: colorA6, height: 1.7.h),
              //     widthSpace5,
              //     Flexible(
              //       child: Text(
              //           'Koonying Used Cars - 62/2 Kanchanaphisek Rd, Taling Chan, Bangkok',
              //           style: colorA6Medium12),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  Image.asset(locationIcon, color: primaryColor, height: 1.7.h),
                  widthSpace5,
                  Flexible(
                    child: Text(
                      widget.location, // ← Use the dynamic location from model
                      style: colorA6Medium12,
                    ),
                  ),
                ],
              ),

              /*heightSpace10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "View Dealer Listings",
                    style: TextStyle(
                      color: primaryColor, // Make it look like a link
                      fontSize: 12,
                      decoration:
                          TextDecoration.underline, // Underline for link effect
                    ),
                  ),
                ),
              ),*/
              // heightSpace10,
              // Row(
              //   children: [
              //     const Text(
              //       "Seller Name: ",
              //       style: TextStyle(
              //         color: Colors.black, // Make it look like a link
              //         fontSize: 12,
              //       ),
              //     ),
              //     Text(
              //       widget.sellerName,
              //       style: const TextStyle(
              //         color: Colors.black, // Make it look like a link
              //         fontSize: 12,
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),

        heightSpace23,
      ],
    );
  }
}

class LightboxScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const LightboxScreen(
      {Key? key, required this.images, required this.initialIndex})
      : super(key: key);

  @override
  _LightboxScreenState createState() => _LightboxScreenState();
}

class _LightboxScreenState extends State<LightboxScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  late PhotoViewController photoViewController; // Changed to PhotoViewController

  @override
  void initState() {
    super.initState();
    photoViewController = PhotoViewController();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    photoViewController.dispose(); // Important to dispose the controller
    _pageController.dispose();
    super.dispose();
  }

  void _nextImage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _zoomIn() {
    final currentScale = photoViewController.scale;
    if (currentScale != null) {
      photoViewController.scale = currentScale * 1.5;
    }
  }

  void _zoomOut() {
    final currentScale = photoViewController.scale;
    if (currentScale != null) {
      photoViewController.scale = currentScale / 1.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.images.length,
            pageController: _pageController,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.images[index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 3,
                initialScale: PhotoViewComputedScale.contained,
                basePosition: Alignment.center,
                controller: photoViewController,
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: primaryColor,),
            ),
          ),

          // Navigation and zoom controls remain the same...
          // Left Arrow Button
          if (_currentIndex > 0)
            Positioned(
              left: 10,
              child: GestureDetector(
                onTap: _prevImage,
                child:  CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  radius: 22,
                  child:
                  const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),

          // Right Arrow Button
          if (_currentIndex < widget.images.length - 1)
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: _nextImage,
                child:  CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  radius: 22,
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),

          // Zoom Out Button
          Positioned(
              bottom: 30,
              left: 20,
              child: GestureDetector(
                onTap: _zoomOut,
                child:  CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 20,
                  child: SvgPicture.asset(
                    'assets/images/zoom_out.svg',
                    color: Colors.white,
                    height: 19,
                    width: 19,
                  ),
                  // child: Icon(Icons.remove, color: Colors.white, size: 20),
                ),
              )
          ),

          // Zoom In Button
          Positioned(
            bottom: 30,
            right: 20,
            child:  GestureDetector(
              onTap: _zoomIn,
              child:  CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 20,
                child: SvgPicture.asset(
                  'assets/images/zoom_in.svg',
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
                // child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),

          // Image counter
          Positioned(
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${_currentIndex + 1}/${widget.images.length}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

