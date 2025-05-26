import 'dart:convert';
import 'package:fl_carmax/common_libs.dart';
import 'package:fl_carmax/models/car_listing_model.dart';
import 'package:fl_carmax/pages/buy_car/compare_page/compare_controller.dart';
import 'package:fl_carmax/pages/buy_car/compare_page/compare_page.dart';
import 'package:fl_carmax/pages/buy_car/search/search_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../helper/language_constant.dart';
import '../../../models/car_details_model.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';
import 'package:http/http.dart' as http;

class FavouritePage extends StatefulWidget {
  final bool showAppBar;
  const FavouritePage({Key? key, required this.showAppBar}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {


  String formatNumber(dynamic value) {
    return NumberFormat.decimalPattern('en_US').format(
        int.tryParse("$value".replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? appBarMethod() : null,
      body: Consumer<CompareProvider> (
        builder: (context, provider, child) {
          return provider.loading
              ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ))
              : provider.wishlist.isNotEmpty
              ? Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: filledScreen(provider),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Consumer<CompareProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        if (provider.compareList.isNotEmpty)
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${provider.compareList.length} ${provider.compareList.length == 1 ? "car" : "cars"} selected for comparison",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                  icon: const Icon(
                                    Icons.compare_arrows,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Compare",
                                    style: whiteMedium14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5))),
                                )
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),
            ],
          )
              : emptyScreen();
        },
      ),
    );
  }


  filledScreen(CompareProvider compareProvider) {
    return FavoriteListWidget(compareProvider: compareProvider);
  }
/*  Widget filledScreen(CompareProvider compareProvider) {
    return ListView.builder(
      itemCount: compareProvider.wishlist.length,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemBuilder: (context, index) {
        final item = compareProvider.wishlist[index];
        CarListing car = CarListing(
            id: item.id,
            title: item.title,
            price: item.price,
            fuelType: item.fuelType,
            transmission: item.transmission,
            mileage: formatNumber(item.mileage),
            year: item.year,
            imageUrl: item.imageUrls.first,
            imageUrls: item.imageUrls,
            bodyType: item.bodyType,
            engineCapacity: item.engineCapacity,
            isFeatured: false,
            carTag: "",
            color: item.color,
            brand: item.make,
            location: item.location,
            modelVarient: item.modelVariant,
          modelsListD:[{"name": item.modelGroup}],
        );
        return Column(
          children: [
            Slidable(
                key: Key(item.id),
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.15,
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        if (!mounted) return;
                        compareProvider.wishlist.removeAt(index);
                        compareProvider.updateFields();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: primaryColor,
                            duration: const Duration(seconds: 1),
                            content: Text(
                              "${item.title} ${translation(context).removedFav}",
                              style: whiteMedium14,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xffD41010),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
                child: Consumer<CompareProvider>(
                  builder: (context, provider, child) {
                    final compared = compareProvider.isInCompare(car);
                  return CarCardWidget(
                  id: item.id,
                  imageUrls: item.imageUrls,
                  title: item.title,
                  price: '฿${item.price}',
                  year: item.year,
                  mileage: item.mileage,
                  fuelType: item.fuelType,
                  transmission: item.transmission,
                  bodyType: item.bodyType,
                  engineCapacity: item.engineCapacity,
                  views:  "${item.metaD?['views']??""}",
                  isInCompareList: compared,
                  isFavourite:
                  provider.favouriteIds.contains(int.tryParse(item.id) ?? 0),
                  onFavouriteToggle: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getInt('user_id') ?? 0;
                    final listingId = int.tryParse(item.id) ?? 0;
                    final isNowFavourite = provider.favouriteIds.contains(listingId);

                    final url = Uri.parse(
                      isNowFavourite
                          ? 'https://www.wowcar.app/wp-json/custom/v1/wishlist/remove'
                          : 'https://www.wowcar.app/wp-json/custom/v1/wishlist/add',
                    );

                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'user_id': userId,
                        'listing_id': item.id,
                      }),
                    );

                    if (response.statusCode == 200) {
                      if (!mounted) return;
                        if (isNowFavourite) {
                          provider.favouriteIds.remove(listingId);
                          provider.wishlist.removeWhere((car) =>
                          car.id == item.id); // 👈 remove immediately
                        } else {
                          provider.favouriteIds.add(listingId);
                        }
                        provider.updateFields();
                     // Store a reference to ScaffoldMessenger
                     final scaffoldMessenger = ScaffoldMessenger.of(context);
                     final message = isNowFavourite
                         ? '${item.title} removed from favourites'
                         : '${item.title} added to favourites';

                     // Use a single delay with mounted check
                     Future.delayed(
                       const Duration(milliseconds: 500),
                       () {
                         if (mounted) {
                           scaffoldMessenger.showSnackBar(SnackBar(
                             backgroundColor: primaryColor,
                             duration: const Duration(seconds: 1),
                             content: Text(
                               message,
                               style: whiteMedium14,
                             ),
                           ));
                         }
                       },
                     );
                    }
                  },
                 modeListD: [{"name": item.modelGroup}],
                  onCompareTap: (){
                    SearchProvider prv = Provider.of(context, listen: false);
                    prv.toggleCompare(context, car);
                  },
                    isFeatured: item.metaD?['featured'] != null ? true : false,
                    // carTag: item.carTag,
                );
  },
)
            ),
            heightSpace20,
          ],
        );
      },
    );
  }*/

  PreferredSize appBarMethod() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(title: translation(context).profileItem5),
    );
  }

  Widget emptyScreen() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_rounded, color: colorA6, size: 4.h),
            heightSpace7,
            Text(translation(context).emptyFavList, style: colorA6Medium16),
          ],
        ),
      ),
    );
  }
}
class FavoriteListWidget extends StatelessWidget {
  final CompareProvider compareProvider;

  const FavoriteListWidget({
    Key? key,
    required this.compareProvider,
  }) : super(key: key);

  String formatNumber(dynamic value) {
    return NumberFormat.decimalPattern('en_US').format(
        int.tryParse("$value".replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: compareProvider.wishlist.length,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemBuilder: (context, index) {
        final item = compareProvider.wishlist[index];
        CarListing car = CarListing(
          id: item.id,
          title: item.title,
          price: item.price,
          fuelType: item.fuelType,
          transmission: item.transmission,
          mileage: formatNumber(item.mileage),
          year: item.year,
          imageUrl: item.imageUrls.first,
          imageUrls: item.imageUrls,
          bodyType: item.bodyType,
          engineCapacity: item.engineCapacity,
          isFeatured: false,
          carTag: "",
          color: item.color,
          brand: item.make,
          location: item.location,
          modelVarient: item.modelVariant,
          modelsListD: [{"name": item.modelGroup}],
        );
        return Column(
          key: ValueKey(item.id),
          children: [
            Consumer<CompareProvider>(
              builder: (context, provider, child) {
                final compared = compareProvider.isInCompare(car);
                return CarCardWidget(
                  id: item.id,
                  imageUrls: item.imageUrls,
                  title: item.title,
                  price: '฿${item.price}',
                  year: item.year,
                  mileage: item.mileage,
                  fuelType: item.fuelType,
                  transmission: item.transmission,
                  bodyType: item.bodyType,
                  engineCapacity: item.engineCapacity,
                  views: "${item.metaD?['views'] ?? ""}",
                  isInCompareList: compared,
                  isFavourite:
                  provider.favouriteIds.contains(int.tryParse(item.id) ?? 0),
                  onFavouriteToggle: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getInt('user_id') ?? 0;
                    final listingId = int.tryParse(item.id) ?? 0;
                    final isNowFavourite = provider.favouriteIds.contains(listingId);

                    final url = Uri.parse(
                      isNowFavourite
                          ? 'https://www.wowcar.app/wp-json/custom/v1/wishlist/remove'
                          : 'https://www.wowcar.app/wp-json/custom/v1/wishlist/add',
                    );

                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'user_id': userId,
                        'listing_id': item.id,
                      }),
                    );

                    if (response.statusCode == 200) {
                      if (!context.mounted) return;
                      if (isNowFavourite) {
                        provider.favouriteIds.remove(listingId);
                        provider.removeFromWishlistById(item.id);
                      } else {
                        provider.favouriteIds.add(listingId);
                      }
                      provider.updateFields();
                      // Store a reference to ScaffoldMessenger
                      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
                      final message = isNowFavourite
                          ? '${item.title} removed from favourites'
                          : '${item.title} added to favourites';

                      // Use a single delay with mounted check
                      Future.delayed(
                        const Duration(milliseconds: 500),
                            () {
                          if (context.mounted && scaffoldMessenger != null) {
                            scaffoldMessenger.showSnackBar(SnackBar(
                              backgroundColor: primaryColor,
                              duration: const Duration(seconds: 1),
                              content: Text(
                                message,
                                style: whiteMedium14,
                              ),
                            ));
                          }
                        },
                      );
                    }
                  },
                  modeListD: [{"name": item.modelGroup}],
                  onCompareTap: () {
                    SearchProvider prv = Provider.of(context, listen: false);
                    prv.toggleCompare(context, car);
                  },
                  isFeatured: item.metaD?['featured'] != null ? true : false,
                );
              },
            ),
            /*Slidable(
                key: Key(item.id),
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.15,
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        compareProvider.removeFromWishlistByIndex(index);
                        if (ScaffoldMessenger.maybeOf(context) != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: primaryColor,
                              duration: const Duration(seconds: 1),
                              content: Text(
                                "${item.title} ${translation(context).removedFav}",
                                style: whiteMedium14,
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: const Color(0xffD41010),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
                child:
            ),*/
            heightSpace20,
          ],
        );
      },
    );
  }
}

Widget filledScreen(CompareProvider compareProvider) {
  return FavoriteListWidget(compareProvider: compareProvider);
}