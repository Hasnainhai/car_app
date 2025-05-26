import 'package:fl_carmax/pages/buy_car/search/search_provider.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../helper/language_constant.dart';
import '../../../utils/constant.dart';
import '../compare_page/compare_controller.dart';
import '../compare_page/compare_page.dart';
import 'car_card_shimmer.dart';

class SearchPage extends StatefulWidget {
  final String? brandSlug;
  const SearchPage({Key? key, this.brandSlug}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchProvider provider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<SearchProvider>(context, listen: false);
    provider.searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => initial());
  }

  initial() async {
    await Future.wait([
      provider.fetchCarListings(forceRefresh: true, brandSlug: widget.brandSlug),
      provider.fetchWishlist(),
      provider.fetchCarsForFilter(),
    ]);
  }

@override
  void dispose() {
    provider.searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    provider.getBrandSlug(widget.brandSlug);
    Locale currentLocale = Localizations.localeOf(context);
    bool isArabic = currentLocale == const Locale('ar');
    return Consumer2<SearchProvider, CompareProvider>(
        builder: (context, provider, compareProvider, child) {
      return WillPopScope(
        onWillPop: () async {
         // compareProvider.clear();
          return true;
        },
        child: Scaffold(
          appBar: appBarMethod(context, isArabic, provider, compareProvider),
          body: provider.isLoading || provider.isSearching
              ? ListView.builder(
                  itemCount: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15).copyWith(bottom: 20),
                  itemBuilder: (context, index) => const CarCardShimmer(),
                )
              : RefreshIndicator(
                  onRefresh: () => provider.isFilterApplied
                      ? provider.applyFiltersFromApi(provider.filterSheet!,
                          forceRefresh: true)
                      : provider.fetchCarListings(
                          forceRefresh: true, brandSlug: widget.brandSlug),
                  child: bodyMethod(provider, compareProvider),
                ),
          // bodyMethod(),
          bottomNavigationBar: compareProvider.compareList.isNotEmpty
              ? Container(
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
                        icon: const Icon(Icons.compare_arrows,color: Colors.white,),
                        label: Text("Compare",style: whiteMedium14,),
                        style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )),
                    ],
                  ),
                )
              : null,
        ),
      );
    });
  }



  PreferredSize appBarMethod(BuildContext context, bool isArabic,
      SearchProvider provider, CompareProvider compareProvider) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: primaryColor,
        ),
        automaticallyImplyLeading: false,
        shadowColor: colorForShadow.withOpacity(.25),
        backgroundColor: white,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: black,
          ),
          onPressed: () {
            //compareProvider.clear();
            Navigator.pop(context);
          },
        ),
        titleSpacing: -5,
        title: Text(translation(context).search, style: blackSemiBold16),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                 provider.showSortBySheet(context);
              },
              child: Row(
                children: [
                  Text(translation(context).sortBy1, style: primaryMedium14),
                  Image.asset(
                    sortBy,
                    height: 18,
                    color: primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
        flexibleSpace: Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: 60,
            width: 100.w,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: isArabic
                        ? const EdgeInsets.only(right: 20, bottom: 10)
                        : const EdgeInsets.only(left: 20, bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 9.5),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [myBoxShadow]),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: colorA6),
                        widthSpace10,
                        Expanded(
                            child: TextField(
                          controller: provider.searchController,
                          onChanged: (value) {
                            final currentPosition = provider.searchController.selection.baseOffset;
                            provider.filterBySearch(value);
                            // Preserve cursor position after filtering
                            if (currentPosition >= 0 && currentPosition <= value.length) {
                              provider.searchController.selection = TextSelection.fromPosition(
                                TextPosition(offset: currentPosition)
                              );
                            }
                          },
                          cursorColor: primaryColor,
                          style: colorA6SemiBold14,
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: translation(context).searchYourCar,
                              hintStyle: colorA6SemiBold14),
                        ))
                      ],
                    ),
                  ),
                ),
                widthSpace10,
                PrimaryContainer(
                  onTap: () {
                    provider.showFilterSheet(context);
                  },
                  borderRadius: BorderRadius.circular(5),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    filter,
                    height: 26,
                    color: primaryColor,
                  ),
                ),
                widthSpace30,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyMethod(SearchProvider provider, CompareProvider compareProvider) {
    if ((provider.searchController.text.isEmpty && provider.apiCarList.isEmpty) ||
        (provider.searchController.text.isNotEmpty && provider.searchCarList.isEmpty)) {
      return Center(
        child: ListView(
          // The mainAxisAlignment and crossAxisAlignment won't work directly on ListView
          children: [
            // Directly place the widgets inside the ListView
            const SizedBox(height: 250), // Adjust height for centering if needed
            const Icon(Icons.no_accounts),
            const SizedBox(height: 20),
            Text(
              'No cars found',
              style: blackSemiBold16,
              textAlign: TextAlign.center, // Optional for centering the text
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: colorA6Regular14,
              textAlign: TextAlign.center, // Optional for centering the text
            ),
            const SizedBox(height: 100), // Adjust height for centering if needed
          ],
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            !provider.isLoading &&
            !provider.isLoadingMore) {
          // Add this condition to handle search results
          if (provider.searchController.text.isNotEmpty && provider.hasMoreSearchResults) {
            // Call loadMoreSearchResults for search pagination
            provider.loadMoreSearchResults();
          }
          // Existing code for normal listings
          else if (provider.hasMoreData) {
            provider.isFilterApplied
                ? provider.applyFiltersFromApi(
                forceRefresh: false, provider.filterSheet!, loadMore: true)
                : provider.fetchCarListings(
                brandSlug: widget.brandSlug,
                loadMore: true,
                runAPI: provider.selectedSortIndex == 1 ? false : true);
          }
        }
        return false;
      },
      child: ListView.builder(
        itemCount: provider.searchController.text.isEmpty
            ? provider.apiCarList.length + (provider.isLoadingMore ? 1 : 0)
            : provider.searchCarList.length + (provider.isLoadingMore || provider.hasMoreSearchResults ? 1 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15).copyWith(bottom: 20),
        itemBuilder: (context, index) {
          // Handle loading indicator
          final usingSearchResults = provider.searchController.text.isNotEmpty;
          final currentList = usingSearchResults ? provider.searchCarList : provider.apiCarList;

          if (index >= currentList.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(color: Colors.grey),
              ),
            );
          }

          // Use the correct list based on search state
          var item = currentList[index];

          return CarCardWidget(
            id: item.id,
            imageUrls: (item.imageUrls ?? []).cast<String>().take(5).toList(),
            title: item.title,
            price: item.price,
            year: item.year,
            mileage: item.mileage,
            fuelType: item.fuelType,
            transmission: item.transmission,
            bodyType: item.bodyType,
            engineCapacity: item.engineCapacity,
            views: "${item.metaD?["views"] ?? "153"}",
            isFavourite: provider.favouriteIds.contains(int.parse(item.id)),
            onCompareTap: () => provider.toggleCompare(context, item),
            isInCompareList: compareProvider.isInCompare(item),
            onFavouriteToggle: () async {
              provider.handleFavouriteToggle(item, context, mounted,context);
            },
            isFeatured: item.isFeatured,
            carTag: item.carTag,
            modeListD: const [],
          );
        },
      )
    );
  }
}
