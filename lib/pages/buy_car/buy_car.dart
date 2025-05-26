
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_carmax/pages/buy_car/provider/home_provider.dart';
import 'package:fl_carmax/pages/buy_car/search/search_provider.dart';

import 'package:intl/intl.dart';

import '../../common_libs.dart';
import '../../helper/language_constant.dart';
import '../../models/car_listing_model.dart';
import '../../utils/constant.dart';
import '../../utils/widgets.dart';

import 'compare_page/compare_controller.dart';
import 'compare_page/compare_page.dart';
import 'component/car_card_shimmer.dart';

class BuyCar extends StatefulWidget {
  const BuyCar({Key? key}) : super(key: key);

  @override
  State<BuyCar> createState() => _BuyCarState();
}

class _BuyCarState extends State<BuyCar> {
  late Future<List<CarListing>> _recentlyAddedFuture;
  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _recentlyAddedFuture = homeProvider.fetchRecentlyAddedCars(); // first load
  }

  /*initial() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    await searchProvider.fetchWishlist();
  }*/

  Future<void> _handleRefresh() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final data = await homeProvider.refreshRecentlyAddedCars();
    setState(() {
      _recentlyAddedFuture = Future.value(data); // ✅ now this is valid
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    bool isArabic = myLocale == const Locale('ar');
    return Consumer3<HomeProvider, SearchProvider, CompareProvider>(builder:
        (context, homeProvider, searchProvider, compareProvider, child) {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  carouselSliderMethod(context, isArabic),
                  heightSpace20,
                  recentlyAddedCarMethod(
                      isArabic,
                      homeProvider.getRecentlyAddedCarsOnce(),
                      searchProvider,
                      compareProvider),
                  // heightSpace25,
                  ...recommendedMethod(
                      isArabic,
                      context,
                      homeProvider.getRecentlyAddedCarsOnce(),
                      searchProvider,
                      compareProvider),

                  heightSpace15,
                  ...popularBrandMethod(isArabic),
                  heightSpace15,
                  // ...serviceMethod(),
                  heightSpace10,
                  //  customerReviewMethod(),
                  // PushNavigate(
                  //   navigate: 'ReviewsPage',
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 6),
                  //     margin: const EdgeInsets.symmetric(horizontal: 20),
                  //     decoration:
                  //         BoxDecoration(color: colorF4, boxShadow: [myBoxShadow]),
                  //     child: Center(
                  //         child: Text(translation(context).viewMore,
                  //             style: primaryMedium16)),
                  //   ),
                  // ),
                  heightSpace40,
                ],
              ),
            ),
            if(compareProvider.compareList.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
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
              )
            else const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox()
            )
          ],
        ),
      );
    });
  }

  Widget customerReviewMethod() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translation(context).ourCustomerReview, style: blackMedium16),
            heightSpace15,
            Column(
                children: List.generate(
                  3,
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
                                index == 0
                                    ? review1
                                    : index == 1
                                    ? review2
                                    : review3,
                              ),
                            ),
                            widthSpace10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    index == 0
                                        ? 'Leslie Alexander'
                                        : index == 1
                                        ? 'Bessie Cooper'
                                        : 'Jerome Bell',
                                    style: blackRegular16),
                                Text('19 july 2022', style: colorA6Medium12),
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
                )),
          ],
        ));
  }

  Stack carouselSliderMethod(BuildContext context, bool isArabic) {
    List sliderList = [autoSlider1]; // Only one image now
    return Stack(
      children: [
        // Single Image
        Container(
          height: 273,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.10),
          ),
          child: Image.asset(
            sliderList[0], // Displaying only one image
            fit: BoxFit.cover,
          ),
        ),

        // Color Overlay
        Container(
          height: 273,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFF2c3640)
              .withOpacity(0.7), // Adjust opacity as needed
        ),

        Positioned(
          bottom: 21,
          child: Column(
            children: [
              Image.asset('assets/images/WowFoot.png', height: 60, width: 200),
              heightSpace60,
              PushNavigate(
                navigate: Routes.searchPage,
                child: Container(
                  width: 90.w,
                  padding: isArabic
                      ? const EdgeInsets.fromLTRB(6, 5, 13, 5)
                      : const EdgeInsets.fromLTRB(13, 5, 6, 5),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: colorForShadow.withOpacity(.25),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Find Your Next Car',
                        // translation(context).searchYourCar,
                        style: color94Medium14,
                      ),
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: myBorderRadius5,
                        ),
                        child: const Icon(Icons.search, color: white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget recentlyAddedCarMethod(
      bool isArabic,
      Future<List<CarListing>> futureCars,
      SearchProvider searchProvider,
      CompareProvider compareProvider,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translation(context).recentlyAddedCar,
                style: blackSemiBold16,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                ),
                child: Text(
                  translation(context).viewAll,
                  style: primaryMedium14,
                ),
              ),
            ],
          ),
        ),
        heightSpace2,
        FutureBuilder<List<CarListing>>(
          future: futureCars,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: 280,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: List.generate(
                      6,
                          (index) {
                        return buildCarShimmerCard();
                      },
                    ),
                  ),
                ),
              );
            }

            final cars = snapshot.data!;
            for (final car in cars.take(6)) {
              precacheImage(CachedNetworkImageProvider(car.imageUrl), context);
            }
            return SizedBox(
              height: 282,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: cars.take(6).map((car) {
                    final isFav = searchProvider.favouriteIds.contains(int.parse(car.id));
                    final compared = compareProvider.isInCompare(car);
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(
                            carId: car.id,
                            isInitiallyFavourite: isFav,
                            modelsListD: car.modelsListD,
                          ),
                        ),
                      ),
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: myBorderRadius10,
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: CachedNetworkImage(
                                      imageUrl: car.imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                          color: Colors.grey.shade300,
                                          height: 150),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car.title,
                                    style: blackMedium14,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                        Text(car.fuelType,
                                            style: colorA6Medium12),
                                        VerticalDivider(
                                            thickness: 1,
                                            width: 10,
                                            color: colorD9),
                                        Text(
                                          '${NumberFormat.decimalPattern().format(int.tryParse(car.mileage.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)} km',
                                          style: colorA6Medium12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          searchProvider.toggleCompare(context, car);
                                        },
                                        child: Icon(Icons.compare_arrows,
                                            color: compared
                                                ? primaryColor
                                                : colorA6),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () => searchProvider
                                            .handleFavouriteToggle(
                                            car, context, mounted,context),
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
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> recommendedMethod(
      bool isArabic,
      BuildContext context,
      Future<List<CarListing>> futureCars,
      SearchProvider searchProvider,
      CompareProvider compareProvider,
      ) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(translation(context).recommendedForYou,
                style: blackSemiBold16),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ),
              child: Text(translation(context).viewAll, style: primaryMedium14),
            ),
          ],
        ),
      ),
      heightSpace2,
      FutureBuilder<List<CarListing>>(
        future: futureCars,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: 280,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: List.generate(
                    6,
                        (index) {
                      return buildCarShimmerCard();
                    },
                  ),
                ),
              ),
            );
          }

          //final cars = snapshot.data!..shuffle();
          final allCars = snapshot.data!;
          final featuredCars = allCars.where((car) => car.isFeatured).toList();

          if (featuredCars.length < 6) {
            final remaining = 6 - featuredCars.length;
            final nonFeatured = allCars.where((car) => !car.isFeatured).toList();
            featuredCars.addAll(nonFeatured.take(remaining));
          }

          final cars = featuredCars.take(6).toList();

          // Precache images
          for (final car in cars.take(6)) {
            precacheImage(CachedNetworkImageProvider(car.imageUrl), context);
          }

          return SizedBox(
            height: 303,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: List.generate(
                  cars.length > 6 ? 6 : cars.length,
                      (index) {
                    final car = cars[index];
                    final isFav = searchProvider.favouriteIds.contains(int.parse(car.id));
                    final compared = compareProvider.isInCompare(car);
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(
                            carId: car.id,
                            isInitiallyFavourite: isFav,
                            modelsListD: car.modelsListD,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? 10 : 5,
                          right: index == cars.length - 1 ? 10 : 5,
                        ),
                        width: 200,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: myBorderRadius10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 150,
                                    child: CachedNetworkImage(
                                      imageUrl: car.imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                          color: Colors.grey.shade300,
                                          height: 150),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car.title,
                                    style: blackMedium14,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                        Text(car.fuelType,
                                            style: colorA6Medium12),
                                        VerticalDivider(
                                            thickness: 1,
                                            width: 10,
                                            color: colorD9),
                                        Text(
                                          '${NumberFormat.decimalPattern().format(int.tryParse(car.mileage.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)} km',
                                          style: colorA6Medium12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => searchProvider
                                            .toggleCompare(context, car),
                                        child: Icon(Icons.compare_arrows,
                                            color: compared
                                                ? primaryColor
                                                : colorA6),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () => searchProvider
                                            .handleFavouriteToggle(
                                            car, context, mounted,context),
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
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> popularBrandMethod(bool isArabic) {
    final List<Map<String, String>> popularBrands = [
      {"image": brand4, "slug": "toyota"},
      {"image": brand2, "slug": "nissan"},
      {"image": brand1, "slug": "bmw"},
      {"image": brand9, "slug": "honda"},
      {"image": mercadies, "slug": "mercedes-benz"},
      {"image": brand7, "slug": "mazda"},
      {"image": brand14, "slug": "ford"},
      {"image": brand13, "slug": "mitsubishi"},
      {"image": isuzu, "slug": "isuzu"},
    ];

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(translation(context).mostPopularBrand, style: blackSemiBold16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(), // All cars
                  ),
                );
              },
              child: Text(translation(context).viewAll, style: primaryMedium14),
            ),
          ],
        ),
      ),
      heightSpace2,
      SizedBox(
        height: 155,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: popularBrands.length,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemBuilder: (context, index) {
            final brand = popularBrands[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(brandSlug: brand['slug']),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: isArabic ? 0 : 10,
                  left: isArabic ? 10 : 0,
                ),
                padding: const EdgeInsets.all(20),
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: myBorderRadius10,
                  boxShadow: [myBoxShadow],
                ),
                child: Image.asset(
                  brand['image']!,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> serviceMethod() {
    List serviceList = [
      {'image': service1, 'title': translation(context).easyFinancing},
      {'image': service2, 'title': translation(context).doorStepDelivery},
      {'image': service3, 'title': translation(context).dayReturn},
      {'image': service4, 'title': translation(context).yearWarranty}
    ];
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(translation(context).services, style: blackSemiBold16),
          ],
        ),
      ),
      SizedBox(
        height: 301,
        child: GridView.builder(
          itemCount: serviceList.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 3 / 2),
          itemBuilder: (context, index) {
            var item = serviceList[index];
            return Container(
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0xffFADAD8),
                borderRadius: myBorderRadius10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(item['image'],
                      height: 40, width: index == 1 ? 60 : 40),
                  heightSpace10,
                  Text(item['title'], style: primaryMedium16)
                ],
              ),
            );
          },
        ),
      ),
    ];
  }
}
