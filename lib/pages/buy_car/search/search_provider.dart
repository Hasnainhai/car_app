import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fl_carmax/models/car_brand_with_model.dart';
import 'package:fl_carmax/models/car_make_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/filter_sheet.dart';
import '../../../helper/short_by_sheet.dart';
import '../../../models/car_listing_model.dart';
import '../../../utils/constant.dart';
import '../../auth/login_page_email.dart';
import '../compare_page/compare_controller.dart';

enum ViewState { normal, loading, error }

class SearchProvider extends ChangeNotifier {
  SearchProvider() {
    loadFilterOptions();
  }
  List<CarListing> apiCarList = [];
  List<CarListing> searchCarList = [];
  List<CarListing> originalCarList = [];
  List<CarListing> featuredCarList = [];
  static List<CarListing>? cachedCarList;
  List<CarListing> forFilterData = [];
  bool isLoading = false;
  bool isFilterApplied = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  Map<String, dynamic>? filterSheet;
  Set<int> favouriteIds = {};

  ViewState _state = ViewState.normal;
  ViewState get state => _state;
  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  int selectedSortIndex = 0;
  int _currentPage = 1;
  String? _brandSlug;
  void getBrandSlug(String?  slg){
    _brandSlug = slg;
  }

  Future<void> fetchCarListings({
    bool forceRefresh = false,
    String? brandSlug,
    Map<String, dynamic>? filters,
    bool loadMore = false,
    bool runAPI = true,
  }) async {
    print("Filters +++++++++++ $filters");
    if (forceRefresh) {
      apiCarList.clear();
      _currentPage = 1;
      hasMoreData = true;
      featuredCarList.clear();
    }
    try {
      if (!loadMore) {
        isLoading = true;
        notifyListeners();
      } else {
        isLoadingMore = true;
        notifyListeners();
      }
      final sortBy = _getSortByParam(selectedSortIndex);
      print("Sort By +++++++++ $sortBy");
      final String url = _buildUrl(
        brandSlug: brandSlug ?? _brandSlug,
        filters: filters,
        sortBy: sortBy,
        page: _currentPage,
        loadMore: loadMore,
      );

      log('🌐 Fetching car listings with URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        log("$loadMore");
        if (loadMore) {
          apiCarList
              .addAll(results.map((e) => CarListing.fromJson(e)).toList());
        } else {
          apiCarList = results.map((e) => CarListing.fromJson(e)).toList();
        }
        print("First Data +++++++++++ ${originalCarList.length}");
        cachedCarList = apiCarList;
        ;
        originalCarList = List.from(apiCarList);
        if (sortBy == null && featuredCarList.isEmpty && runAPI) {
          await fetchFeaturedCars(brandSlug: brandSlug);
        }
        final currentPage = data['pagination']['current_page'];
        final totalPages = data['pagination']['total_pages'];

        hasMoreData = currentPage < totalPages;
        if (hasMoreData) {
          _currentPage = currentPage + 1;
        }
      } else {
        log('❌ Failed to fetch car listings: Status ${response.statusCode}');
        apiCarList = [];
      }
    } finally {
      log("WORKING");
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
      log("HERE IS API CAR LIST LENFTH:${apiCarList.length}");
    }
  }

  //filter by search
  TextEditingController searchController = TextEditingController();
  String searchUrl = "https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids?per_page=14&page=1&search=";
  // Add these at the class level alongside your other properties
  Timer? _searchDebounceTimer;
  bool isSearching = false;
  int _searchPage = 1;
  bool hasMoreSearchResults = true;

  // This method debounces the search and calls the API
  Future<void> searchFilter(String query, {bool loadMore = false}) async {
    // Cancel previous timer if it exists
    _searchDebounceTimer?.cancel();

    if (query.isEmpty) {
      searchCarList = [];
      notifyListeners();
      return fetchCarListings(forceRefresh: true);
    }

    // Set a new timer for 2 seconds
    _searchDebounceTimer = Timer(const Duration(seconds: 2), () async {
      try {
        if (!loadMore) {
          isSearching = true;
          _searchPage = 1;
          searchCarList.clear();
          hasMoreSearchResults = true;
          notifyListeners();
        } else {
          isLoadingMore = true;
          notifyListeners();
        }

        final url = Uri.parse('$searchUrl$query');
        log('🔍 Searching with URL: $url');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<dynamic> results = data['results'] ?? [];

          if (loadMore) {
            searchCarList.addAll(results.map((e) => CarListing.fromJson(e)).toList());
          } else {
            searchCarList = results.map((e) => CarListing.fromJson(e)).toList();
            notifyListeners();
          }

          // Handle pagination if available in the response
          if (data['pagination'] != null) {
            final currentPage = data['pagination']['current_page'];
            final totalPages = data['pagination']['total_pages'];

            hasMoreSearchResults = currentPage < totalPages;
            if (hasMoreSearchResults) {
              _searchPage = currentPage + 1;
            }
          }
        } else {
          log('❌ Failed to fetch search results: Status ${response.statusCode}');
          if (!loadMore) searchCarList = [];
        }
      } catch (e) {
        log('❌ Error during search: $e');
        if (!loadMore) searchCarList = [];
      } finally {
        isSearching = false;
        isLoadingMore = false;
        notifyListeners();
      }
    });
  }

  // Updated filterBySearch to use the new searchFilter method
  void filterBySearch(String query,)async {
    searchController.text = query;
    await searchFilter(query);
  }

  // Method to load more search results when scrolling
  Future<void> loadMoreSearchResults() async {
    if (!isLoadingMore && hasMoreSearchResults && searchController.text.isNotEmpty) {
      await searchFilter(searchController.text, loadMore: true);
    }
  }

  // Build URL
  String _buildUrl({
    String? brandSlug,
    Map<String, dynamic>? filters,
    String? sortBy,
    int? page,
    String perPage = '10',
    bool loadMore = false,
  }) {
    final Map<String, dynamic> queryParams = {
      'per_page': perPage,
      'page': page?.toString() ?? '1',
    };
    brandSlug = _brandSlug;
    // Add brandSlug if provided
    if (brandSlug != null) {
      queryParams['car_maker[]'] = brandSlug;
    }

    // Handle filters
    if (filters != null) {
      final List<String>? bodyTypes = (filters['bodyType'] as Set<dynamic>?)
          ?.where((e) => e != 'Any')
          .map((e) => e.toString()) // Make sure to call toString if necessary
          .toList();

      // For transmissions: Check if it is a List<dynamic> and cast it to List<String>
      final List<String>? transmissions =
          filters['transmission'] is List<dynamic>
              ? (filters['transmission'] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList()
              : null;

      // For fuels: Convert Set<dynamic> to List<String>
      final List<String>? fuels = (filters['fuelType'] as Set<dynamic>?)
          ?.where((e) => e != 'Any')
          .map((e) => e.toString()) // Ensure the type is String
          .toList();

      // For colors: Cast to List<String> if not null
      final List<String>? colors = (filters['colors'] as List<dynamic>?)
          ?.map((e) => e.toString()) // Convert to String if necessary
          .toList();

      // For makes and models: Safely cast if not null
      final List<String>? make = (filters['makes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList();
      final List<String>? model = (filters['model'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList();

      final double? minPrice = filters['minPrice'];
      final double? maxPrice = filters['maxPrice'];
      final int? minKmInput = filters['minKmInput'];
      final int? maxKmInput = filters['maxKmInput'];
      final int? minYear = filters['minYear'];
      final int? maxYear = filters['maxYear'];
      final String? location = filters['location'];
      if (minPrice != null && maxPrice != null) {
        queryParams['price'] = '${minPrice.toInt()}-${maxPrice.toInt()}';
      }
      if (minYear != null && maxYear != null) {
        queryParams['car_modal'] = '$minYear-$maxYear';
      }
      if (minKmInput != null) {
        queryParams['mileage_min'] = minKmInput.toString();
      }
      if (maxKmInput != null) {
        queryParams['mileage_max'] = maxKmInput.toString();
      }
      if (colors != null && colors.isNotEmpty) {
        for (var i = 0; i < colors.length; i++) {
          log("colors[i].toString()");
          log(colors[i].toString());
          queryParams['color[$i]'] = colors[i];
        }
      }
      if (transmissions != null && transmissions.isNotEmpty) {
        for (var i = 0; i < transmissions.length; i++) {
          queryParams['transmission[$i]'] = transmissions[i];
        }
      }
      if (fuels != null && fuels.isNotEmpty) {
        for (var i = 0; i < fuels.length; i++) {
          queryParams['fuel_type[$i]'] = fuels[i];
        }
      }
      if (bodyTypes != null && bodyTypes.isNotEmpty) {
        for (var i = 0; i < bodyTypes.length; i++) {
          queryParams['body_type[$i]'] = bodyTypes[i];
        }
      }
      if (make != null && make.isNotEmpty) {
        for (var i = 0; i < make.length; i++) {
          queryParams['car_maker[$i]'] = make[i];
        }
      }
      if (model != null && model.isNotEmpty) {
        for (var i = 0; i < model.length; i++) {
          queryParams['car_model[$i]'] = model[i];
        }
      }
      // if (location != null && location.isNotEmpty) {
      //   queryParams['location'] = location;
      // }
    }

    // Add sortBy if provided
    if (sortBy != null) {
      queryParams.addAll(Uri.splitQueryString(sortBy));
    }

    final uri = Uri.https('www.wowcar.app',
        '/wp-json/listivo/v1/all-listings-with-guids', queryParams);

    return uri.toString();
  }

  // Helper to map sort index to sortBy param
  String? _getSortByParam(int index) {
    switch (index) {
      case 2:
        return "price_sort=asc"; // Price Low to High
      case 3:
        return "price_sort=desc"; // Price High to Low
      case 4:
        return "mileage_sort=asc"; // KM driven Low to High
      case 5:
        return "mileage_sort=desc"; // KM driven High to Low
      case 6:
        return "year_sort=desc"; // Year New to Old
      case 7:
        return "year_sort=asc"; // Year Old to New
      default:
        return null;
    }
  }

  Future<void> fetchCarsForFilter() async {
    forFilterData.clear();
    final String url = _buildUrl(
      perPage: '200',
      sortBy: sortBy,
      page: 1,
    );
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? [];
      print("Filters Length +++++++++++ ${results.length}");
      forFilterData.addAll(results.map((e) => CarListing.fromJson(e)).toList());
      for (var m in forFilterData) {
        print("${m.color}");
      }
      notifyListeners();
    }
  }

  Future<void> fetchFeaturedCars({String? brandSlug}) async {
    final featuredUrl = Uri.parse(
      brandSlug != null
          ? 'https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids?is_featured=1&car_maker[]=$brandSlug'
          : 'https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids?is_featured=1',
    );
    final response = await http.get(featuredUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? [];
      featuredCarList = results.map((e) => CarListing.fromJson(e)).toList();
      sortCarList(0);
    }
  }

  // Sort car list
  void sortCarList(int index, {bool notify = true}) {
    selectedSortIndex = index;
    if (index == 0) {
      if (_brandSlug != null) {
        apiCarList = [...featuredCarList];
      } else {
        apiCarList = [...featuredCarList];
      }
    } else {
      switch (index) {
        case 1: // Recently Added (newest first)
          log("WORKING");
          apiCarList.sort((a, b) {
            final dateA = DateTime.tryParse(a.postDate ?? '');
            final dateB = DateTime.tryParse(b.postDate ?? '');
            log(dateA.toString());
            log(dateB.toString());
            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1; // put nulls last
            if (dateB == null) return -1;
            return dateB.compareTo(dateA); // newest first
          });
          break;
        // Other cases commented because API handles them
      }
    }
    if (notify) {
      notifyListeners();
    }
  }

  // Show sort options
  void showSortBySheet(BuildContext context) async {
    final selectedIndex = await showModalBottomSheet<int>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => SortBySheet(initialIndex: selectedSortIndex),
    );

    if (selectedIndex != null) {
      selectedSortIndex = selectedIndex;
      if (selectedIndex == 1 ||
          selectedIndex == 2 ||
          selectedIndex == 3 ||
          selectedIndex == 4 ||
          selectedIndex == 5 ||
          selectedIndex == 6 ||
          selectedIndex == 7) {
        fetchCarListings(filters: {
          'minPrice': lowerValue,
          'maxPrice': upperValue,
          'fuelType': selectedFuelTypes.toSet(),
          'transmission': selectedTransmissions.contains('Any')
              ? ['Any'] // or ['Any'] if your API expects it
              : selectedTransmissions.toList(),
          'colors': selectedColors.contains('Any')
              ? ['Any'] // or ['Any'] if your API expects it
              : selectedColors.toList(),
          'bodyType': selectedBodyTypes.toSet(),
          /*'makes': _brandSlug != null ? [_brandSlug] :
          (selectedMakes.contains('Any') ? ['Any'] : selectedMakes),*/
           'makes': selectedMakes.contains('Any') ? ['Any'] : selectedMakes,
          'model': selectedModels.contains('Any') ? ['Any'] : selectedModels,
          'minKmInput': minKm,
          'maxKmInput': maxKm,
          'location': locationController.text.trim(),
          'minYear': minYear,
          'maxYear': maxYear,
        }, forceRefresh: true, runAPI: selectedIndex == 1 ? false : true);
      } else {
        isLoading = true;
        isLoadingMore = true;
        notifyListeners();
        await fetchFeaturedCars(
          brandSlug: _brandSlug,
        );
        isLoading = false;
        isLoadingMore = false;
        notifyListeners();
        sortCarList(selectedIndex);
      }
    }
  }

  // Show filter options
  void showFilterSheet(BuildContext context) async {
    filterSheet = await showModalBottomSheet<Map<String, dynamic>>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => const FilterSheet(),
    );

    debugPrint("Filter Data $filterSheet");
    if (filterSheet != null) {
      if (filterSheet?["clear"] == true) {
        isFilterApplied = false;
        notifyListeners();
        featuredCarList.clear();
        fetchCarListings(forceRefresh: true);
      } else {
        isFilterApplied = true;
        notifyListeners();
        await applyFiltersFromApi(filterSheet!);
      }
    }
  }

  // In applyFiltersFromApi method
/*  Future<void> applyFiltersFromApi(
    Map<String, dynamic> filters, {
    bool forceRefresh = true,
    bool loadMore = false,
  }) async {
    await fetchCarListings(
      filters: {
        ...filters,
        // Prioritize brand slug over general make selection
        'makes': _brandSlug != null ? [_brandSlug] :
                (selectedMakes.contains('Any') ? ['Any'] : selectedMakes),
      },
      forceRefresh: forceRefresh,
      loadMore: loadMore,
    );
  }*/
  //old
  Future<void> applyFiltersFromApi(
    Map<String, dynamic> filters, {
    bool forceRefresh = true,
    bool loadMore = false,
  }) async {
    print("Filters $filters");
    await fetchCarListings(
        forceRefresh: forceRefresh,
        filters: filters,
        loadMore: loadMore,
        runAPI: false);
  }

  Future<void> fetchWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;

    final response = await http.post(
      Uri.parse('https://www.wowcar.app/wp-json/custom/v1/wishlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body is List ? body : (body['data'] ?? []);
      favouriteIds = data
          .map<int>(
              (e) => int.tryParse(e['post']?['ID']?.toString() ?? '0') ?? 0)
          .where((id) => id != 0)
          .toSet();
      notifyListeners();
    }
  }
  //old filter search
  // void filterBySearch(String query, SearchProvider provider) {
  //   if (query.isEmpty) {
  //     provider.fetchCarListings(); // Reload full list if cleared
  //   } else {
  //     provider.apiCarList = provider.apiCarList.where((car) {
  //       return car.title.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   }
  //   notifyListeners();
  // }

  void toggleCompare(context, CarListing car) {
    CompareProvider provider = Provider.of<CompareProvider>(context, listen: false);

    provider.toggleCar(car);
  }

  void handleFavouriteToggle(
      CarListing item,
      BuildContext context,
      bool mounted,
      BuildContext ctx,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      // User is not logged in
    if(ctx.mounted){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Required", style: blackMedium18),
          content: Text("Please login to add items to your favourites.", style: blackMedium14),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: primaryMedium14),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPageEmail()));
              },
              child: Text("Login", style: whiteMedium14),
            ),
          ],
        ),
      );
    }
      return;
    }

    if(ctx.mounted){
      toggleFavouriteOptimistic(item, context, mounted, userId);
    }
  }

  Future<void> toggleFavouriteOptimistic(
      CarListing item,
      BuildContext context,
      bool mounted,
      int userId,
      ) async {
    final listingId = int.tryParse(item.id.toString()) ?? 0;
    final isAdding = !favouriteIds.contains(listingId);

    if (isAdding) {
      favouriteIds.add(listingId);
    } else {
      favouriteIds.remove(listingId);
    }
    notifyListeners();

    // Prepare the API
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
          'listing_id': item.id,
        }),
      );

      if (response.statusCode != 200) {
        // ❗ Revert if server failed
        if (isAdding) {
          favouriteIds.remove(listingId);
        } else {
          favouriteIds.add(listingId);
        }
        notifyListeners();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update favourite")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: primaryColor,
              duration: const Duration(seconds: 4),
              content: Text(
                isAdding
                    ? '${item.title} Added to Favourites'
                    : '${item.title} Removed from Favourites',
                style: whiteMedium14,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // ❗ Handle network error
      if (isAdding) {
        favouriteIds.remove(listingId);
      } else {
        favouriteIds.add(listingId);
      }
      notifyListeners();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error occurred")),
        );
      }
    }
  }

  Future<void> toggleFavourite(
      CarListing item, BuildContext context, mounted) async {
    final listingId = int.tryParse(item.id.toString()) ?? 0;
    final isAdding = !favouriteIds.contains(listingId);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;

    final url = Uri.parse(
      isAdding
          ? 'https://www.wowcar.app/wp-json/custom/v1/wishlist/add'
          : 'https://www.wowcar.app/wp-json/custom/v1/wishlist/remove',
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
      if (isAdding) {
        favouriteIds.add(listingId);
      } else {
        favouriteIds.remove(listingId);
      }
      notifyListeners();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 1),
        content: Text(
          isAdding
              ? '${item.title} Added to Favourites'
              : '${item.title} Removed from Favourites',
          style: whiteMedium14,
        ),
      ));
    }
  }

  ///FilterSheet Functions
  List<String> _extractNames(List? items) {
    return items?.map((e) => e['name'].toString()).toList() ?? [];
  }

  List<CarMakeModel> _extractMakeData(List? items) {
    return items?.map((e) => CarMakeModel.fromJson(e)).toList() ?? [];
  }

  List<String> fuelTypeList = ['Any'];
  List<String> transmissionList = ['Any'];
  List<String> bodyTypeList = ['Any'];
  List<String> modelsList = ['Any'];
  List<CarMakeModel> makesList = [];
  Map<String, Color> colors = {};
  List<String> availableColors = ['Any'];
  List<String> availableBodyTypes = ['Any'];
  List<String> availableTransmissions = ['Any'];
  List<String> availableFuelTypes = ['Any'];
  List<CarMakeModel> availableMakes = [];
  List<String> availableModels = ['Any'];
  Set<String> selectedColors = {'Any'};
  Set<String> selectedFuelTypes = {};
  Set<String> selectedTransmissions = {'Any'};
  Set<String> selectedBodyTypes = {};
  double lowerValue = 50000;
  double upperValue = 3000000;
  int minYear = 1988;
  int maxYear = 2025;
  final TextEditingController locationController = TextEditingController();
  String? selectedMake;
  String? selectedModel;

  List<String> selectedMakes = [];
  List<String> selectedModels = ['Any'];

  int minKm = 0;
  int maxKm = 150000;
  void loadFilterOptions() async {
    final response = await getFilterOptionsFromApi(); // simulate or call real API
    final taxonomies = response['taxonomies'];

    fuelTypeList = ['Any', ..._extractNames(taxonomies['listivo_5667'])];
    transmissionList = ['Any', ..._extractNames(taxonomies['listivo_5666'])];
    bodyTypeList = ['Any', ..._extractNames(taxonomies['listivo_9312'])];
    print('Loaded bodyTypeList: $bodyTypeList');

    modelsList = ['Any', ..._extractNames(taxonomies['listivo_946'])];
    print("Texonmie ++++++++++++++ ${taxonomies['listivo_945'].where((e) => e['name'] == 'Haval').toList()}");

    makesList = [
      CarMakeModel(name: "Any", children: [CarBrandModel(name: 'Any')]),
      ..._extractMakeData(taxonomies['listivo_945'])
    ];

    colors = {
      for (var e in (taxonomies['listivo_8638'] ?? []))
        e['name']: mapThaiColorToColor(e['name']),
    };

    if (fuelTypeList.isNotEmpty && selectedFuelTypes.isEmpty) {
      selectedFuelTypes.add('Any');
    }
    if (bodyTypeList.isNotEmpty && selectedBodyTypes.isEmpty) {
      selectedBodyTypes.add('Any');
    }
    if (selectedMakes.isEmpty) {
      selectedMakes.add('Any');
    }

    notifyListeners();
  }


  Color mapThaiColorToColor(String name) {
    switch (name) {
      case 'สีขาว':
        return Color(0xFFFFFFFF);
      case 'สีดำ':
        return Color(0xFF000000);
      case 'สีเงิน':
        return Color(0xFFC0C0C0);
      case 'สีชาร์โคล':
        return Color(0xFF36454F);
      case 'สีน้ำเงิน':
        return Color(0xFF0000FF);
      case 'สีแดง':
        return Color(0xFFFF0000);
      case 'สีเทา':
        return Color(0xFF808080);
      case 'สีบรอนซ์':
        return Color(0xFFCD7F32);
      case 'สีทอง':
        return Color(0xFFFFD700);
      default:
        return Color(0xFF000000); // Default to black if not found
    }
  }

  Future<Map<String, dynamic>> getFilterOptionsFromApi() async {
    final url = Uri.parse(
        'https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData is Map && responseData['results'] is List) {
        final List<dynamic> listings = responseData['results'];

        if (listings.isNotEmpty) {
          final Map<String, List<Map<String, dynamic>>> mergedTaxonomies = {};

          for (final listing in listings) {
            final taxonomies = listing['taxonomies'] as Map<String, dynamic>?;

            if (taxonomies != null) {
              taxonomies.forEach((key, value) {
                final terms = value as List<dynamic>;
                if (!mergedTaxonomies.containsKey(key)) {
                  mergedTaxonomies[key] = [];
                }

                for (final term in terms) {
                  final existingIndex = mergedTaxonomies[key]!
                      .indexWhere((t) => t['term_id'] == term['term_id']);

                  if (existingIndex == -1) {
                    // No existing make, add new
                    mergedTaxonomies[key]!.add(term);
                  } else {
                    // Make exists, merge children uniquely
                    final existingMake = mergedTaxonomies[key]![existingIndex];

                    List existingChildren =
                        (existingMake['children'] as List<dynamic>?) ?? [];
                    List newChildren = (term['children'] as List<dynamic>?) ?? [];

                    for (var newChild in newChildren) {
                      final exists = existingChildren.any(
                              (child) => child['term_id'] == newChild['term_id']);
                      if (!exists) {
                        existingChildren.add(newChild);
                      }
                    }

                    existingMake['children'] = existingChildren;
                    mergedTaxonomies[key]![existingIndex] = existingMake;
                  }
                }
              });
            }
          }

          return {'taxonomies': mergedTaxonomies};
        }
      }
    }

    return {'taxonomies': {}};
  }



  setFuelType(isSelected, String value) {
    if (value == 'Any') {
      selectedFuelTypes.clear();
      selectedFuelTypes.add('Any');
    } else {
      selectedFuelTypes.remove('Any');

      if (isSelected) {
        _selectedBrand = [carMake];
        selectedFuelTypes.remove(value);
      } else {
        selectedFuelTypes.add(value);
      }
    }
    filterFuel();
    notifyListeners();
  }

  setDraggingValue(lower, upper) {
    lowerValue = lower;
    upperValue = upper;
    print(lowerValue);
    print(upperValue);
    filterPrice();
    notifyListeners();
  }

  setDraggingValueForYears(min, max) {
    minYear = min;
    maxYear = max;
    filterYears();
    notifyListeners();
  }

  setDraggingValueForKMRange(min, max) {
    minKm = min.toInt();
    maxKm = max.toInt();
    print("filter $minKm");
    print("filter $maxKm");
    filterMilage();

    notifyListeners();
  }

  setSelectedColor(isSelected, colorName) {
    if (colorName == 'Any') {
      selectedColors.clear();
      selectedColors.add('Any');
    } else {
      selectedColors.remove('Any');
      if (isSelected) {
        // _selectedBrand = [carMake];
        // availableMakes = [carMake];
        selectedColors.remove(colorName);
      } else {
        selectedColors.add(colorName);
      }
    }
    filterColorType();
    notifyListeners();
  }

  setTransmission(isSelected, value) {
    if (value == 'Any') {
      selectedTransmissions.clear();
      selectedTransmissions.add('Any');
    } else {
      selectedTransmissions.remove('Any');
      if (isSelected) {
        selectedTransmissions = {'Any'};
        selectedTransmissions.remove(value);
      } else {
        selectedTransmissions.add(value);
        filterTransmissions(value);
      }
    }

    notifyListeners();
  }

  void setBodyTypes(bool isSelected, String value) {
    if (value == 'Any') {
      selectedBodyTypes.clear();
      selectedBodyTypes.add('Any');

      // Reset available makes to ['Any'] when 'Any' is selected
      availableMakes = [carMake];
      selectedMakes = ['Any'];
      availableModels = ['Any'];
      selectedModels = ['Any'];
    } else {
      availableModels = ['Any'];
      selectedModels = ['Any'];
      _selectedBrand = [
        CarMakeModel(name: 'Any', children: [CarBrandModel(name: 'Any')])
      ];
      selectedBodyTypes.remove('Any');
      if (isSelected) {
        selectedBodyTypes.remove(value);
      } else {
        selectedBodyTypes.add(value);
      }
    }
    filterBody();
    notifyListeners();
  }

  List<CarMakeModel> _selectedBrand = [
    CarMakeModel(name: 'Any', children: [CarBrandModel(name: 'Any')])
  ];
  List<CarMakeModel> get selectedBrand => _selectedBrand;

  void setCarMakes(bool isSelected, CarMakeModel value, int index) {
    if (value.name == 'Any') {
      // If "Any" is selected, clear all selected makes
      _selectedBrand = [carMake];
      selectedMakes = ['Any'];
      // _selectedBrand = availableMakes;
      availableColors = ['Any'];
      final uniqueColors = <String>{};

      for (var car in forFilterData) {
        // Check if car matches other filters (excluding make filter since we selected "Any")
        final matchBodyType = selectedBodyTypes.contains('Any') ||
            (car.bodyType != null && selectedBodyTypes.contains(car.bodyType));

        final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
            int.parse(formatter(car.price)) >= lowerValue &&
            int.parse(formatter(car.price)) <= upperValue;

        final isYearInRange = int.tryParse(formatter(car.year)) != null &&
            int.parse(formatter(car.year)) >= minYear &&
            int.parse(formatter(car.year)) <= maxYear;

        final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
            double.parse(formatter(car.mileage)) >= minKm &&
            double.parse(formatter(car.mileage)) <= maxKm;

        // if (matchBodyType) {
        if (matchBodyType && isPriceInRange && isYearInRange && isKmInRange) {
          if (car.color?.isNotEmpty == true) {
            uniqueColors.add(car.color!);
          }
        }
      }

      availableColors.addAll(uniqueColors.toList());
      selectedColors = {'Any'};
      selectedModels = ['Any'];
      // _selectedBrand = availableMakes;
      // availableColors = forFilterData.where((element) => makesList.co)
      // Reset available models to ['Any']
      // availableModels = ['Any'];
      selectedModels = ['Any'];
    } else {
      if (isSelected) {
        // If the make is selected, remove it from selected makes and reset models
        // availableModels.clear();

        // _selectedBrand = [carMake];
        print("this is removed selectedBrand ${_selectedBrand}");
        _selectedBrand.remove(value);
        print("this is after removed selectedBrand ${_selectedBrand.length}");

        // selectedModels = ['Any'];
        selectedMakes.remove(value.name);
        print("this is after removed selected makes ${selectedMakes.length}");

        final uniqueColors = <String>{};

        for (var car in forFilterData) {
          final carMakes =
              _extractMakeData(car.makesList ?? []).map((e) => e.name).toSet();

          final matchMake = carMakes.any(selectedMakes.contains);
          // Check if car matches other filters (excluding make filter since we selected "Any")
          final matchBodyType = selectedBodyTypes.contains('Any') ||
              (car.bodyType != null &&
                  selectedBodyTypes.contains(car.bodyType));

          final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
              int.parse(formatter(car.price)) >= lowerValue &&
              int.parse(formatter(car.price)) <= upperValue;

          final isYearInRange = int.tryParse(formatter(car.year)) != null &&
              int.parse(formatter(car.year)) >= minYear &&
              int.parse(formatter(car.year)) <= maxYear;

          final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
              double.parse(formatter(car.mileage)) >= minKm &&
              double.parse(formatter(car.mileage)) <= maxKm;

          if (matchBodyType &&
              matchMake
          &&
              isPriceInRange &&
              isYearInRange &&
              isKmInRange
          ) {
            if (car.color?.isNotEmpty == true) {
              uniqueColors.add(car.color!);
            }
          }
        }

        availableColors = ['Any']..addAll(uniqueColors);
      } else {
        // _selectedBrand.ad;
        // If the make is deselected, add it back and update models
        selectedMakes.remove('Any');
        _selectedBrand.add(value);
        selectedModels = ['Any'];
        selectedMakes.add(value.name ?? 'Any');

        // Filter makes based on selected values
      }
    }

    filterMakes();
    // Reset available models to 'Any' if 'Any' is selected in selectedMakes
    // if (selectedMakes.contains('Any')) {
    //   availableModels = ['Any'];
    // }
    availableMakes.sort((a, b) => a.name!.compareTo(b.name!));
    notifyListeners();
  }

  void setCarModels(bool isSelected, String model) {
    // filterModel(model);
    if (model == "Any") {
      selectedModels = ["Any"]; // Use List here, not Set
    } else {
      selectedModels.remove("Any");
      if (isSelected) {
        selectedModels.remove(model);
      } else {
        selectedModels.add(model);
      }
    }

    notifyListeners();
  }

  resetFilters() {
    selectedBodyTypes.clear();
    selectedFuelTypes.clear();
    selectedColors.clear();
    selectedMakes.clear();
    selectedModels.clear();
    _selectedBrand.clear();
    selectedTransmissions.clear();
    availableBodyTypes.clear();
    availableFuelTypes.clear();
    availableColors.clear();
    availableMakes.clear();
    availableModels.clear();
    _selectedBrand = [carMake];
    availableMakes = [carMake];
    selectedFuelTypes
        .add('Any'); // Assuming '0' represents 'Any' for fuel types
    selectedBodyTypes.add('Any');
    selectedMakes = ['Any'];
    selectedColors.add('Any');
    selectedTransmissions.add('Any');
    selectedModels = ['Any'];

    selectedMake = null;
    selectedModel = null;
    lowerValue = 50000;
    upperValue = 25000000;
    minKm = 0;
    maxKm = 500000;
    minYear = 1988; // ✅ Reset year min
    maxYear = 2025;
    notifyListeners();
  }

  filterPrice() {
    final filteredCars = forFilterData.where((car) {
      final priceStr = car.price.toString().replaceAll('฿', '').replaceAll(',', '');
      final price = int.tryParse(priceStr) ?? 0;

      final year = int.tryParse(car.year) ?? 0;

      final mileageStr = car.mileage.toString().replaceAll(RegExp(r'[^0-9]'), '');
      final mileage = int.tryParse(mileageStr) ?? 0;

      return price >= lowerValue &&
          price <= upperValue &&
          year >= minYear &&
          year <= maxYear &&
          mileage >= minKm &&
          mileage <= maxKm;
    }).toList();

    print("Filtered cars count: ${filteredCars.length}");

    if (filteredCars.isEmpty) {
      print("❌ No cars matched price/year/mileage filter.");

      // Set everything to empty to reflect 'no match'
      availableMakes.clear();
      selectedMakes = ['Any'];
      _selectedBrand.clear();

      notifyListeners();
      return;
    }


    availableColors.clear();
    availableColors.add('Any');
    for (var car in filteredCars) {
      if (!availableColors.contains(car.color)) {
        availableColors.add(car.color ?? '');
      }
    }

    final colorFilteredCars = filteredCars.where((car) {
      return availableColors.contains(car.color);
    }).toList();

    print("Available Colors: $availableColors");

    availableBodyTypes.clear();
    availableFuelTypes.clear();
    availableModels.clear();
    availableMakes.clear();
    availableTransmissions.clear();

    availableFuelTypes.add('Any');
    availableBodyTypes.add('Any');
    availableMakes.add(carMake);
    availableModels.add('Any');
    availableTransmissions.add('Any');
    selectedColors.clear();
    selectedColors = {'Any'};
    selectedFuelTypes.clear();
    selectedFuelTypes = {'Any'};
    selectedTransmissions.clear();
    selectedTransmissions = {'Any'};
    selectedBodyTypes.clear();
    selectedBodyTypes = {'Any'};

    for (var car in filteredCars) {
      if (!availableBodyTypes.contains(car.bodyType)) {
        availableBodyTypes.add(car.bodyType ?? 'Any');
      }
      if (!availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType ?? "Any");
      }

      List<CarMakeModel> makeData = _extractMakeData(car.makesList);
      for (var v in makeData) {
        print("✅ Found make: ${v.name}");
        if (!availableMakes.any((x) => x.name == v.name)) {
          availableMakes.add(v);
        }
      }

      if (!availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission);
      }
    }

    final filterBodyType = filteredCars.where((car) {
      return availableBodyTypes.contains(car.bodyType);
    }).toList();

    final filterFuelType = filteredCars.where((car) {
      return availableFuelTypes.contains(car.fuelType);
    }).toList();

    final filterMakesType = filteredCars.where((car) {
      final _generated = _extractMakeData(car.makesList);
      return _generated.any((v) => availableMakes.any((x) => x.name == v.name));
    }).toList();

    final filterTransmitions = filteredCars.where((car) {
      return availableTransmissions.contains(car.transmission);
    }).toList();

    final currentMakeNames = availableMakes.map((make) => make.name).toSet();

    // ✅ Keep only selected makes that still exist
    final updatedSelectedMakes = selectedMakes.where((makeName) => currentMakeNames.contains(makeName)).toList();

    if (selectedMakes.contains('Any') && updatedSelectedMakes.isEmpty) {
      updatedSelectedMakes.add('Any');
    }

    if (updatedSelectedMakes.isEmpty) {
      updatedSelectedMakes.add('Any');
    }

    selectedMakes = updatedSelectedMakes;

    // ✅ Same for brands
    _selectedBrand = _selectedBrand.where((brand) => currentMakeNames.contains(brand.name)).toList();
    if (_selectedBrand.isEmpty && selectedMakes.contains('Any')) {
      _selectedBrand = [carMake];
    }

    availableMakes.sort((a, b) => a.name!.compareTo(b.name!));
    availableModels.sort((a, b) => a.compareTo(b));

    if (colorFilteredCars.isEmpty) print("❌ No cars matched color filter.");
    if (filterTransmitions.isEmpty) print("❌ No cars matched transmission filter.");
    if (filterMakesType.isEmpty) print("❌ No cars matched make filter.");
    if (filterFuelType.isEmpty) print("❌ No cars matched fuel type filter.");
    if (filterBodyType.isEmpty) print("❌ No cars matched body type filter.");

    if (colorFilteredCars.isEmpty ||
        filterTransmitions.isEmpty ||
        filterMakesType.isEmpty ||
        filterFuelType.isEmpty ||
        filterBodyType.isEmpty) {
      return;
    }

    notifyListeners();
  }

  CarMakeModel carMake =
      CarMakeModel(name: 'Any', children: [CarBrandModel(name: 'Any')]);
  filterYears() {
    final filteredCars = forFilterData.where((car) {
      final year = int.tryParse(car.year) ?? 0;

      final priceStr = car.price.toString().replaceAll('฿', '').replaceAll(',', '');
      final price = int.tryParse(priceStr) ?? 0;

      final mileageStr = car.mileage.toString().replaceAll(RegExp(r'[^0-9]'), '');
      final mileage = int.tryParse(mileageStr) ?? 0;

      return year >= minYear &&
          year <= maxYear &&
          price >= lowerValue &&
          price <= upperValue &&
          mileage >= minKm &&
          mileage <= maxKm;
    }).toList();
    if (filteredCars.isEmpty) {
      return;
    }

    // final prices = filteredCars
    //     .map((car) => double.parse(
    //         car.price.toString().replaceAll('฿', '').replaceAll(',', '')))
    //     .toList();
    // final minP = prices.reduce((a, b) => a < b ? a : b);
    // final maxP = prices.reduce((a, b) => a > b ? a : b);
    //
    // lowerValue = minP;
    // upperValue = maxP;
    // final mileages = filteredCars.map((car) {
    //   final mileageStr =
    //       car.mileage.toString().replaceAll(RegExp(r'[^0-9]'), '');
    //   return int.tryParse(mileageStr) ?? 0;
    // }).toList();
    //
    // minKm = mileages.reduce((a, b) => a < b ? a : b);
    // maxKm = mileages.reduce((a, b) => a > b ? a : b);
    availableColors.clear();
    availableColors.add('Any');
    filteredCars.forEach((e) {
      if (!availableColors.contains(e.color)) {
        availableColors.add(e.color ?? 'Any');
      }
    });

    final colorFilteredCars = filteredCars.where((car) {
      return selectedColors.contains(car.color);
    }).toList();
    availableBodyTypes.clear();
    availableFuelTypes.clear();
    availableModels.clear();
    availableMakes.clear();
    availableTransmissions.clear();
    availableBodyTypes.clear();
    availableFuelTypes.clear();
    availableModels.clear();
    availableMakes.clear();
    availableTransmissions.clear();

    availableFuelTypes.add('Any');
    availableBodyTypes.add('Any');
    availableMakes.add(carMake);
    availableModels.add('Any');
    availableTransmissions.add('Any');
    selectedColors.clear();
    selectedColors = {'Any'};
    selectedFuelTypes.clear();
    selectedFuelTypes = {'Any'};
    // selectedMakes.clear();
    // selectedMakes = ['Any'];
    // selectedModels.clear();
    // selectedModels = ['Any'];
    selectedTransmissions.clear();
    selectedTransmissions = {'Any'};
    selectedBodyTypes.clear();
    selectedBodyTypes = {'Any'};
    for (var car in filteredCars) {
      if (!availableBodyTypes.contains(car.bodyType)) {
        availableBodyTypes.add(car.bodyType ?? 'Any');
      }
      if (!availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType ?? "Any");
      }
      List<CarMakeModel> makeData = _extractMakeData(car.makesList);
      for (var v in makeData) {
        if (!availableMakes.any((x) => x.name == v.name)) {
          availableMakes.add(v);
        }
      }
      if (!availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission);
      }
    }

    final filterBodyType = filteredCars.where((car) {
      return availableBodyTypes.contains(car.bodyType);
    }).toList();
    final filterFuelType = filteredCars.where((car) {
      return availableFuelTypes.contains(car.fuelType);
    }).toList();

    final filterMakesType = filteredCars.where((car) {
      final _generated = _extractMakeData(car.makesList);
      return _generated.any((v) => availableMakes.any((x) => x.name == v.name));
    }).toList();
    final filterModelType = filteredCars.where((car) {
      return availableModels.contains(car.carmodels);
    }).toList();
    final filterTransmitions = filteredCars.where((car) {
      return availableTransmissions.contains(car.transmission);
    }).toList();
    // Get current valid make names
    final currentMakeNames = availableMakes.map((make) => make.name).toSet();

// ✅ Keep only the selected makes that still exist OR 'Any'
    final updatedSelectedMakes = selectedMakes.where((makeName) => currentMakeNames.contains(makeName)).toList();

// ✅ If 'Any' was selected and is still relevant, keep it
    if (selectedMakes.contains('Any') && updatedSelectedMakes.isEmpty) {
      updatedSelectedMakes.add('Any');
    }

// ✅ Only fallback to 'Any' if nothing valid remains
    if (updatedSelectedMakes.isEmpty) {
      updatedSelectedMakes.add('Any');
    }

// Apply back
    selectedMakes = updatedSelectedMakes;

// Same logic for _selectedBrand
    _selectedBrand = _selectedBrand.where((brand) => currentMakeNames.contains(brand.name)).toList();
    if (_selectedBrand.isEmpty && selectedMakes.contains('Any')) {
      _selectedBrand = [carMake];
    }

    availableMakes.sort((a, b) => a.name!.compareTo(b.name!));
    availableModels.sort((a, b) => a.compareTo(b));
    if (colorFilteredCars.isEmpty ||
        filterTransmitions.isEmpty ||
        filterModelType.isEmpty ||
        filterMakesType.isEmpty ||
        filterFuelType.isEmpty ||
        filterBodyType.isEmpty) {
      return;
    }

    notifyListeners();
  }

  void filterMilage() {
    final filteredCars = forFilterData.where((car) {
      final mileageStr = car.mileage.toString().replaceAll(RegExp(r'[^0-9]'), '');
      final mileage = int.tryParse(mileageStr) ?? 0;

      final priceStr = car.price.toString().replaceAll('฿', '').replaceAll(',', '');
      final price = int.tryParse(priceStr) ?? 0;

      final year = int.tryParse(car.year) ?? 0;

      return mileage >= minKm &&
          mileage <= maxKm &&
          price >= lowerValue &&
          price <= upperValue &&
          year >= minYear &&
          year <= maxYear;
    }).toList();

    if (filteredCars.isEmpty) return;

    // final prices = filteredCars
    //     .map((car) => double.parse(car.price.toString().replaceAll('฿', '').replaceAll(',', '')))
    //     .toList();
    // lowerValue = prices.reduce((a, b) => a < b ? a : b);
    // upperValue = prices.reduce((a, b) => a > b ? a : b);
    //
    // final years = filteredCars.map((car) => int.parse(car.year)).toList();
    // minYear = years.reduce((a, b) => a < b ? a : b);
    // maxYear = years.reduce((a, b) => a > b ? a : b);

    // Clear and repopulate color list
    availableColors.clear();
    availableColors.add('Any');
    for (var car in filteredCars) {
      if (!availableColors.contains(car.color)) {
        availableColors.add(car.color ?? 'Any');
      }
    }

    // Start collecting available filter values
    availableBodyTypes = ['Any'];
    availableFuelTypes = ['Any'];
    availableMakes = [carMake];
    availableModels = ['Any'];
    availableTransmissions = ['Any'];

    for (var car in filteredCars) {
      if (!availableBodyTypes.contains(car.bodyType)) {
        availableBodyTypes.add(car.bodyType ?? 'Any');
      }

      if (!availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType ?? 'Any');
      }

      List<CarMakeModel> makeData = _extractMakeData(car.makesList);
      for (var v in makeData) {
        if (!availableMakes.any((x) => x.name == v.name)) {
          availableMakes.add(v);
        }
      }

      if (!availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission);
      }
    }


    final currentMakeNames = availableMakes.map((make) => make.name).toSet();

// ✅ Keep only the selected makes that still exist OR 'Any'
    final updatedSelectedMakes = selectedMakes.where((makeName) => currentMakeNames.contains(makeName)).toList();

// ✅ If 'Any' was selected and is still relevant, keep it
    if (selectedMakes.contains('Any') && updatedSelectedMakes.isEmpty) {
      updatedSelectedMakes.add('Any');
    }

// ✅ Only fallback to 'Any' if nothing valid remains
    if (updatedSelectedMakes.isEmpty) {
      updatedSelectedMakes.add('Any');
    }

// Apply back
    selectedMakes = updatedSelectedMakes;

// Same logic for _selectedBrand
    _selectedBrand = _selectedBrand.where((brand) => currentMakeNames.contains(brand.name)).toList();
    if (_selectedBrand.isEmpty && selectedMakes.contains('Any')) {
      _selectedBrand = [carMake];
    }

    // Sort
    availableMakes.sort((a, b) => a.name!.compareTo(b.name!));
    availableModels.sort((a, b) => a.compareTo(b));

    notifyListeners();
  }

  String formatter(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void filterBody() {
    // Step 0: Handle "Any" logic for selected body types
    selectedBodyTypes.remove('Any');
    final useAnyBody = selectedBodyTypes.isEmpty;

    // Apply price, year, and km filters first
    List<CarListing> filteredCars = forFilterData.where((car) {
      final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
          int.parse(formatter(car.price)) >= lowerValue &&
          int.parse(formatter(car.price)) <= upperValue;

      final isYearInRange = int.tryParse(formatter(car.year)) != null &&
          int.parse(formatter(car.year)) >= minYear &&
          int.parse(formatter(car.year)) <= maxYear;

      final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
          double.parse(formatter(car.mileage)) >= minKm &&
          double.parse(formatter(car.mileage)) <= maxKm;

      return isPriceInRange && isYearInRange && isKmInRange;
    }).toList();

    if (useAnyBody) {
      selectedBodyTypes.add('Any'); // Restore "Any" after checking logic
    } else {
      // Step 1: Further filter cars by selected body types
      filteredCars = filteredCars.where((car) {
        return selectedBodyTypes.contains(car.bodyType);
      }).toList();
    }

    if (filteredCars.isEmpty) {
      notifyListeners();
      return;
    }

    checkUpperRange(filteredCars); // Optional: adjust UI slider bounds

    // Step 2: Reset all available and selected filter lists
    availableColors = ['Any'];
    availableFuelTypes = ['Any'];
    availableMakes = [carMake];
    availableModels = ['Any'];
    availableTransmissions = ['Any'];

    selectedColors = {'Any'};
    selectedFuelTypes = {'Any'};
    selectedMakes = ['Any'];
    selectedModels = ['Any'];
    selectedTransmissions = {'Any'};

    // Step 3: Extract filter values from filtered cars
    final Set<String> seenMakeNames = {};

    for (var car in filteredCars) {
      // Colors
      if (car.color?.isNotEmpty == true &&
          !availableColors.contains(car.color)) {
        availableColors.add(car.color!);
      }

      // Fuel Types
      if (car.fuelType?.isNotEmpty == true &&
          !availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType!);
      }

      // Makes and Models
      final makeData = _extractMakeData(car.makesList ?? []);
      for (var make in makeData) {
        print("loop ${make.taxonomy}");
        if (!seenMakeNames.contains(make.name)) {
          print("none ${make.name}");
          availableMakes.add(make);
          seenMakeNames.add(make.name!);
        }

        for (var model in make.children) {
          final modelName = model.name;
          if (modelName?.isNotEmpty == true &&
              !availableModels.contains(modelName)) {
            availableModels.add(modelName!);
          }
        }
      }

      // Transmissions
      if (car.transmission?.isNotEmpty == true &&
          !availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission!);
      }
    }

    // Step 4: Sort and finalize
    availableMakes.sort((a, b) => a.name!.compareTo(b.name!));

    availableModels.sort();
    print("Available Makes: ${availableMakes.map((e) => e.name).toList()}");
    notifyListeners(); // Final step: update UI
  }

  void filterMakes() {
    // Handle "Any" logic for makes
    selectedMakes.remove('Any');
    final useAnyMake = selectedMakes.isEmpty;
    if (useAnyMake) selectedMakes.add('Any');

    // Filter car list
    List<CarListing> filteredCars = forFilterData.where((car) {
      final carMakes =
          _extractMakeData(car.makesList ?? []).map((e) => e.name).toSet();

      final matchMake = useAnyMake || carMakes.any(selectedMakes.contains);

      final matchBodyType = selectedBodyTypes.contains('Any') ||
          (car.bodyType != null && selectedBodyTypes.contains(car.bodyType));

      final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
          int.parse(formatter(car.price)) >= lowerValue &&
          int.parse(formatter(car.price)) <= upperValue;

      final isYearInRange = int.tryParse(formatter(car.year)) != null &&
          int.parse(formatter(car.year)) >= minYear &&
          int.parse(formatter(car.year)) <= maxYear;

      final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
          double.parse(formatter(car.mileage)) >= minKm &&
          double.parse(formatter(car.mileage)) <= maxKm;

      return matchMake &&
          matchBodyType &&
          isPriceInRange &&
          isYearInRange &&
          isKmInRange;
    }).toList();

    if (filteredCars.isEmpty) return;

    checkUpperRange(filteredCars);

    // Reset dependent filters
    availableColors = ['Any'];
    availableFuelTypes = ['Any'];
    availableTransmissions = ['Any'];
    availableModels = ['Any'];

    selectedColors = {'Any'};
    selectedFuelTypes = {'Any'};
    selectedModels = ['Any'];
    selectedTransmissions = {'Any'};

    Set<String> bodyTypesSet = {};

    for (var car in filteredCars) {
      if (car.color?.isNotEmpty == true &&
          !availableColors.contains(car.color)) {
        availableColors.add(car.color!);
      }

      if (car.fuelType?.isNotEmpty == true &&
          !availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType!);
      }

      if (car.transmission?.isNotEmpty == true &&
          !availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission!);
      }

      // Gather body types
      if (car.bodyType?.isNotEmpty == true) {
        bodyTypesSet.add(car.bodyType!);
      }
    }

    availableBodyTypes = ['Any', ...bodyTypesSet.toList()..sort()];

    notifyListeners();
  }

  void filterFuel() {
    // Step 1: Remove 'Any' from selectedFuelTypes, and add it back if empty
    selectedFuelTypes.remove('Any');
    final useAnyFuel = selectedFuelTypes.isEmpty;
    if (useAnyFuel) {
      selectedFuelTypes.add('Any');
    }

    final shouldFilterMakesByFuel =
        selectedMakes.isEmpty || selectedMakes.contains('Any');

    // Step 2: Filter cars based on current selection
    List<CarListing> filteredCars = forFilterData.where((car) {
      final matchFuel = useAnyFuel ||
          (car.fuelType != null && selectedFuelTypes.contains(car.fuelType));

      final matchBodyType = selectedBodyTypes.contains('Any') ||
          (car.bodyType != null && selectedBodyTypes.contains(car.bodyType));

      final makesList = _extractMakeData(car.makesList ?? []);
      final carMakes = makesList.map((e) => e.name).toSet();

      final matchMake = shouldFilterMakesByFuel
          ? matchFuel &&
              (selectedMakes.contains('Any') ||
                  carMakes.any(selectedMakes.contains))
          : (selectedMakes.contains('Any') ||
              carMakes.any(selectedMakes.contains));

      final modelNames =
          makesList.expand((e) => e.children).map((e) => e.name).toSet();
      final matchModel = selectedModels.contains('Any') ||
          modelNames.any(selectedModels.contains);

      final matchTransmission = selectedTransmissions.contains('Any') ||
          (car.transmission != null &&
              selectedTransmissions.contains(car.transmission));

      final matchColor = selectedColors.contains('Any') ||
          (car.color != null && selectedColors.contains(car.color));

      final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
          int.parse(formatter(car.price)) >= lowerValue &&
          int.parse(formatter(car.price)) <= upperValue;

      final isYearInRange = int.tryParse(formatter(car.year)) != null &&
          int.parse(formatter(car.year)) >= minYear &&
          int.parse(formatter(car.year)) <= maxYear;

      final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
          double.parse(formatter(car.mileage)) >= minKm &&
          double.parse(formatter(car.mileage)) <= maxKm;

      return matchFuel &&
          matchBodyType &&
          matchMake &&
          matchModel &&
          matchTransmission &&
          matchColor &&
          isPriceInRange &&
          isYearInRange &&
          isKmInRange;
    }).toList();

    if (filteredCars.isEmpty) return;

    // Step 3: Update price/year/km upper ranges based on filtered results
    checkUpperRange(filteredCars);

    // Step 4: Reset filter values
    availableBodyTypes = ['Any'];
    availableColors = ['Any'];
    availableTransmissions = ['Any'];
    availableModels = ['Any'];

    final Set<String> updatedMakeNames = {
      for (var make in availableMakes) make.name ?? ''
    };

    // Step 5: Extract new filter data from filtered cars
    for (var car in filteredCars) {
      if (car.bodyType?.isNotEmpty == true &&
          !availableBodyTypes.contains(car.bodyType)) {
        availableBodyTypes.add(car.bodyType!);
      }

      if (car.color?.isNotEmpty == true &&
          !availableColors.contains(car.color)) {
        availableColors.add(car.color!);
      }

      if (car.transmission?.isNotEmpty == true &&
          !availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission!);
      }

      final makeData = _extractMakeData(car.makesList ?? []);
      for (var make in makeData) {
        if (make.name != null && !updatedMakeNames.contains(make.name!)) {
          availableMakes.add(make);
          updatedMakeNames.add(make.name!);
        }

        for (var model in make.children) {
          final modelName = model.name;
          if (modelName?.isNotEmpty == true &&
              !availableModels.contains(modelName)) {
            availableModels.add(modelName!);
          }
        }
      }
    }

    availableModels.sort();

    // Step 6: Filter availableMakes based on current selection context
    final shouldFilterMakesBySelection = selectedMakes.isEmpty ||
        (selectedMakes.length == 1 && selectedMakes.contains('Any'));

    if (shouldFilterMakesBySelection) {
      final Set<String> matchingMakeNamesFromData = {};

      for (var car in forFilterData) {
        if (car.fuelType != null && selectedFuelTypes.contains(car.fuelType)) {
          final makesList = _extractMakeData(car.makesList ?? []);
          for (var make in makesList) {
            final matchBodyType = selectedBodyTypes.contains('Any') ||
                selectedBodyTypes.contains(car.bodyType);

            final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
                int.parse(formatter(car.price)) >= lowerValue &&
                int.parse(formatter(car.price)) <= upperValue;

            final isYearInRange = int.tryParse(formatter(car.year)) != null &&
                int.parse(formatter(car.year)) >= minYear &&
                int.parse(formatter(car.year)) <= maxYear;

            final isKmInRange =
                double.tryParse(formatter(car.mileage)) != null &&
                    double.parse(formatter(car.mileage)) >= minKm &&
                    double.parse(formatter(car.mileage)) <= maxKm;

            if (matchBodyType &&
                isPriceInRange &&
                isYearInRange &&
                isKmInRange) {
              if (make.name != null) matchingMakeNamesFromData.add(make.name!);
            }
          }
        } else if (selectedFuelTypes.contains('Any')) {
          final makesList = _extractMakeData(car.makesList ?? []);
          for (var make in makesList) {
            final matchBodyType = selectedBodyTypes.contains('Any') ||
                selectedBodyTypes.contains(car.bodyType);

            final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
                int.parse(formatter(car.price)) >= lowerValue &&
                int.parse(formatter(car.price)) <= upperValue;

            final isYearInRange = int.tryParse(formatter(car.year)) != null &&
                int.parse(formatter(car.year)) >= minYear &&
                int.parse(formatter(car.year)) <= maxYear;

            final isKmInRange =
                double.tryParse(formatter(car.mileage)) != null &&
                    double.parse(formatter(car.mileage)) >= minKm &&
                    double.parse(formatter(car.mileage)) <= maxKm;

            if (matchBodyType &&
                isPriceInRange &&
                isYearInRange &&
                isKmInRange) {
              if (make.name != null) matchingMakeNamesFromData.add(make.name!);
            }
          }
        }
      }

      availableMakes.removeWhere(
        (make) =>
            make.name != null && !matchingMakeNamesFromData.contains(make.name),
      );
    }

    // Step 7: Ensure 'Any' is always the first option in makes
    if (!availableMakes.any((make) => make.name == 'Any')) {
      availableMakes.insert(0, carMake);
    }

    // Step 8: Notify listeners
    notifyListeners();
  }

//Old
  // void filterFuel() {
  //   // Handle "Any" logic for fuel types
  //   selectedFuelTypes.remove('Any');
  //   final useAnyFuel = selectedFuelTypes.isEmpty;
  //   if (useAnyFuel) selectedFuelTypes.add('Any');

  //   // Filter car list
  //   List<CarListing> filteredCars = forFilterData.where((car) {
  //     final carFuel = car.fuelType;

  //     final matchFuel = useAnyFuel ||
  //         (carFuel != null && selectedFuelTypes.contains(carFuel));

  //     final matchBodyType = selectedBodyTypes.contains('Any') ||
  //         (car.bodyType != null && selectedBodyTypes.contains(car.bodyType));

  //     final makesList = _extractMakeData(car.makesList ?? []);
  //     final carMakes = makesList.map((e) => e.name).toSet();

  //     final matchMake =
  //         selectedMakes.contains('Any') || carMakes.any(selectedMakes.contains);

  //     final matchModel = selectedModels.contains('Any') ||
  //         makesList
  //             .expand((m) => m.children.map((c) => c.name))
  //             .whereType<String>()
  //             .any(selectedModels.contains);

  //     final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
  //         int.parse(formatter(car.price)) >= lowerValue &&
  //         int.parse(formatter(car.price)) <= upperValue;

  //     final isYearInRange = int.tryParse(formatter(car.year)) != null &&
  //         int.parse(formatter(car.year)) >= minYear &&
  //         int.parse(formatter(car.year)) <= maxYear;

  //     final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
  //         double.parse(formatter(car.mileage)) >= minKm &&
  //         double.parse(formatter(car.mileage)) <= maxKm;

  //     return matchFuel &&
  //         matchBodyType &&
  //         matchMake &&
  //         matchModel &&
  //         isPriceInRange &&
  //         isYearInRange &&
  //         isKmInRange;
  //   }).toList();

  //   if (filteredCars.isEmpty) return;

  //   checkUpperRange(filteredCars);

  //   // Reset dependent filters
  //   availableColors = ['Any'];
  //   availableTransmissions = ['Any'];
  //   availableModels = ['Any'];

  //   selectedColors = {'Any'};
  //   selectedTransmissions = {'Any'};
  //   selectedModels = ['Any'];

  //   for (var car in filteredCars) {
  //     if (car.color?.isNotEmpty == true &&
  //         !availableColors.contains(car.color)) {
  //       availableColors.add(car.color!);
  //     }

  //     if (car.transmission?.isNotEmpty == true &&
  //         !availableTransmissions.contains(car.transmission)) {
  //       availableTransmissions.add(car.transmission!);
  //     }

  //     final makeData = _extractMakeData(car.makesList ?? []);
  //     for (var make in makeData) {
  //       for (var model in make.children) {
  //         final modelName = model.name;
  //         if (modelName?.isNotEmpty == true &&
  //             !availableModels.contains(modelName)) {
  //           availableModels.add(modelName!);
  //         }
  //       }
  //     }
  //   }

  //   availableMakes.sort((a, b) => a.name!.compareTo(b.name!));
  //   notifyListeners();
  // }

  void filterTransmissions(String selectedData) {
    // Step 1: Remove 'Any' if it's present in selectedTransmissions
    selectedTransmissions.remove('Any');
    final useAnyTransmission = selectedTransmissions.isEmpty;
    if (useAnyTransmission) {
      selectedTransmissions.add('Any'); // If none selected, default to 'Any'
    }

    final shouldFilterMakesByTransmission =
        selectedMakes.isEmpty || selectedMakes.contains('Any');

    // Step 2: Filter cars based on selected criteria
    List<CarListing> filteredCars = forFilterData.where((car) {
      final matchTransmission = useAnyTransmission ||
          (car.transmission != null &&
              selectedTransmissions.contains(car.transmission));

      final matchBodyType = selectedBodyTypes.contains('Any') ||
          (car.bodyType != null && selectedBodyTypes.contains(car.bodyType));

      final makesList = _extractMakeData(car.makesList ?? []);
      final carMakes = makesList.map((e) => e.name).toSet();

      final matchMake = shouldFilterMakesByTransmission
          ? matchTransmission &&
              (selectedMakes.contains('Any') ||
                  carMakes.any(selectedMakes.contains))
          : (selectedMakes.contains('Any') ||
              carMakes.any(selectedMakes.contains));

      final modelNames =
          makesList.expand((e) => e.children).map((e) => e.name).toSet();
      final matchModel = selectedModels.contains('Any') ||
          modelNames.any(selectedModels.contains);

      final matchFuel = selectedFuelTypes.contains('Any') ||
          (car.fuelType != null && selectedFuelTypes.contains(car.fuelType));

      final matchColor = selectedColors.contains('Any') ||
          (car.color != null && selectedColors.contains(car.color));

      final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
          int.parse(formatter(car.price)) >= lowerValue &&
          int.parse(formatter(car.price)) <= upperValue;

      final isYearInRange = int.tryParse(formatter(car.year)) != null &&
          int.parse(formatter(car.year)) >= minYear &&
          int.parse(formatter(car.year)) <= maxYear;

      final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
          double.parse(formatter(car.mileage)) >= minKm &&
          double.parse(formatter(car.mileage)) <= maxKm;

      return matchBodyType &&
          matchMake &&
          matchModel &&
          matchFuel &&
          matchColor &&
          matchTransmission &&
          isPriceInRange &&
          isYearInRange &&
          isKmInRange;
    }).toList();

    if (filteredCars.isEmpty) return;

    // Step 3: Update upper range if needed
    checkUpperRange(filteredCars);

    // Step 4: Reset and rebuild filter options
    availableBodyTypes = ['Any'];
    availableFuelTypes = ['Any'];
    availableColors = ['Any'];
    availableModels = ['Any'];
    // Don't reset availableMakes yet — refine it conditionally below

    final Set<String> updatedMakeNames = {
      for (var make in availableMakes) make.name ?? ''
    };

    for (var car in filteredCars) {
      if (car.bodyType?.isNotEmpty == true &&
          !availableBodyTypes.contains(car.bodyType)) {
        availableBodyTypes.add(car.bodyType!);
      }

      if (car.fuelType?.isNotEmpty == true &&
          !availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType!);
      }

      if (car.color?.isNotEmpty == true &&
          !availableColors.contains(car.color)) {
        availableColors.add(car.color!);
      }

      final makeData = _extractMakeData(car.makesList ?? []);
      for (var make in makeData) {
        if (make.name != null && !updatedMakeNames.contains(make.name!)) {
          availableMakes.add(make);
          updatedMakeNames.add(make.name!);
        }

        for (var model in make.children) {
          final modelName = model.name;
          if (modelName?.isNotEmpty == true &&
              !availableModels.contains(modelName)) {
            availableModels.add(modelName!);
          }
        }
      }
    }

    availableModels.sort();

    // Step 5: Refine availableMakes based on transmission selection logic
    final shouldFilterMakesBySelection = selectedMakes.isEmpty ||
        (selectedMakes.length == 1 && selectedMakes.contains('Any'));

    if (shouldFilterMakesBySelection) {
      final Set<String> matchingMakeNamesFromData = {};

      for (var car in forFilterData) {
        if (car.transmission != null &&
            selectedTransmissions.contains(car.transmission)) {
          final makesList = _extractMakeData(car.makesList ?? []);
          for (var make in makesList) {
            final matchBodyType = selectedBodyTypes.contains('Any') ||
                selectedBodyTypes.contains(car.bodyType);

            final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
                int.parse(formatter(car.price)) >= lowerValue &&
                int.parse(formatter(car.price)) <= upperValue;

            final isYearInRange = int.tryParse(formatter(car.year)) != null &&
                int.parse(formatter(car.year)) >= minYear &&
                int.parse(formatter(car.year)) <= maxYear;

            final isKmInRange =
                double.tryParse(formatter(car.mileage)) != null &&
                    double.parse(formatter(car.mileage)) >= minKm &&
                    double.parse(formatter(car.mileage)) <= maxKm;

            if (matchBodyType &&
                isPriceInRange &&
                isYearInRange &&
                isKmInRange) {
              if (make.name != null) matchingMakeNamesFromData.add(make.name!);
            }
          }
        } else if (selectedTransmissions.contains('Any')) {
          final makesList = _extractMakeData(car.makesList ?? []);
          for (var make in makesList) {
            final matchBodyType = selectedBodyTypes.contains('Any') ||
                selectedBodyTypes.contains(car.bodyType);

            final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
                int.parse(formatter(car.price)) >= lowerValue &&
                int.parse(formatter(car.price)) <= upperValue;

            final isYearInRange = int.tryParse(formatter(car.year)) != null &&
                int.parse(formatter(car.year)) >= minYear &&
                int.parse(formatter(car.year)) <= maxYear;

            final isKmInRange =
                double.tryParse(formatter(car.mileage)) != null &&
                    double.parse(formatter(car.mileage)) >= minKm &&
                    double.parse(formatter(car.mileage)) <= maxKm;

            if (matchBodyType &&
                isPriceInRange &&
                isYearInRange &&
                isKmInRange) {
              if (make.name != null) matchingMakeNamesFromData.add(make.name!);
            }
          }
        }
      }

      availableMakes.removeWhere(
        (make) =>
            make.name != null && !matchingMakeNamesFromData.contains(make.name),
      );
    }

    // Step 6: Ensure 'Any' is present
    if (!availableMakes.any((make) => make.name == 'Any')) {
      availableMakes.insert(0, carMake); // Add 'Any' back at the top
    }

    // Step 7: Notify listeners
    notifyListeners();
  }

  // void filterColorType(String selectedColorType) {
  //   if (availableColors.contains('Any')) {
  //     selectedColors.remove('Any');
  //   }
  //   if (selectedColors.isEmpty) {
  //     selectedColors.add('Any');
  //   }
  //   List<CarListing> filteredCars = forFilterData.where((car) {
  //     return selectedColors.contains(car.color);
  //   }).toList();

  //   if (filteredCars.isEmpty) return;

  //   checkUpperRange(filteredCars);

  //   availableBodyTypes.clear();
  //   availableFuelTypes.clear();
  //   availableModels.clear();
  //   availableMakes.clear();
  //   availableTransmissions.clear();

  //   availableBodyTypes.add('Any');
  //   availableFuelTypes.add('Any');
  //   // availableMakes.add(
  //   //   CarMakeModel(name: 'Any', children: [CarBrandModel(name: 'Any')]),
  //   // );
  //   // availableTransmissions.add('Any');

  //   // selectedFuelTypes.add('Any');
  //   // selectedBodyTypes.add('Any');
  //   // selectedMakes.add('Any');
  //   // selectedModels.add('Any');
  //   // selectedTransmissions.add('Any');

  //   // Build available filter options based on filtered cars
  //   for (var car in filteredCars) {
  //     if (car.bodyType != null && !availableBodyTypes.contains(car.bodyType)) {
  //       availableBodyTypes.add(car.bodyType!);
  //     }

  //     if (car.fuelType != null && !availableFuelTypes.contains(car.fuelType)) {
  //       availableFuelTypes.add(car.fuelType!);
  //     }

  //     List<CarMakeModel> makeData = _extractMakeData(car.makesList);
  //     for (var v in makeData) {
  //       if (!availableMakes.any((x) => x.name == v.name)) {
  //         availableMakes.add(v);
  //       }
  //     }

  //     if (car.transmission != null &&
  //         !availableTransmissions.contains(car.transmission)) {
  //       availableTransmissions.add(car.transmission!);
  //     }
  //   }

  //   // Re-filter by each type only if 'Any' is selected
  //   final filterBodyType = availableBodyTypes.contains('Any')
  //       ? filteredCars
  //           .where((car) => availableBodyTypes.contains(car.bodyType))
  //           .toList()
  //       : filteredCars;

  //   final filterFuelType = availableFuelTypes.contains('Any')
  //       ? filteredCars
  //           .where((car) => availableFuelTypes.contains(car.fuelType))
  //           .toList()
  //       : filteredCars;

  //   final filterMakesType = availableMakes.any((m) => m.name == carMake.name)
  //       ? filteredCars.where((car) {
  //           final extracted = _extractMakeData(car.makesList);
  //           return extracted
  //               .any((v) => availableMakes.any((x) => x.name == v.name));
  //         }).toList()
  //       : filteredCars;

  //   final filterTransmissions = availableTransmissions.contains('Any')
  //       ? filteredCars
  //           .where((car) => availableTransmissions.contains(car.transmission))
  //           .toList()
  //       : filteredCars;

  //   // If any re-filtered list is empty, return early
  //   if (filterBodyType.isEmpty ||
  //       filterFuelType.isEmpty ||
  //       filterMakesType.isEmpty ||
  //       filterTransmissions.isEmpty) {
  //     return;
  //   }

  //   notifyListeners();
  // }
  void filterColorType() {
    // Step 1: Remove 'Any' if it's present in selectedColors
    selectedColors.remove('Any');
    final useAnyColor = selectedColors.isEmpty;
    if (useAnyColor) {
      selectedColors.add('Any'); // If no color selected, use 'Any'
    }

    final shouldFilterMakesByColor =
        selectedMakes.isEmpty || selectedMakes.contains('Any');

    // Step 2: Filter cars based on selected criteria
    List<CarListing> filteredCars = forFilterData.where((car) {
      final matchColor = useAnyColor ||
          (car.color != null && selectedColors.contains(car.color));

      final matchBodyType = selectedBodyTypes.contains('Any') ||
          (car.bodyType != null && selectedBodyTypes.contains(car.bodyType));

      final makesList = _extractMakeData(car.makesList ?? []);
      final carMakes = makesList.map((e) => e.name).toSet();

      final matchMake = shouldFilterMakesByColor
          ? matchColor &&
              (selectedMakes.contains('Any') ||
                  carMakes.any(selectedMakes.contains))
          : (selectedMakes.contains('Any') ||
              carMakes.any(selectedMakes.contains));

      final modelNames =
          makesList.expand((e) => e.children).map((e) => e.name).toSet();
      final matchModel = selectedModels.contains('Any') ||
          modelNames.any(selectedModels.contains);

      final matchFuel = selectedFuelTypes.contains('Any') ||
          (car.fuelType != null && selectedFuelTypes.contains(car.fuelType));

      final matchTransmission = selectedTransmissions.contains('Any') ||
          (car.transmission != null &&
              selectedTransmissions.contains(car.transmission));

      final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
          int.parse(formatter(car.price)) >= lowerValue &&
          int.parse(formatter(car.price)) <= upperValue;

      final isYearInRange = int.tryParse(formatter(car.year)) != null &&
          int.parse(formatter(car.year)) >= minYear &&
          int.parse(formatter(car.year)) <= maxYear;

      final isKmInRange = double.tryParse(formatter(car.mileage)) != null &&
          double.parse(formatter(car.mileage)) >= minKm &&
          double.parse(formatter(car.mileage)) <= maxKm;

      return matchBodyType &&
          matchMake &&
          matchModel &&
          matchFuel &&
          matchTransmission &&
          isPriceInRange &&
          isYearInRange &&
          isKmInRange;
    }).toList();

    if (filteredCars.isEmpty) return;

    // Step 3: Update upper range if needed
    checkUpperRange(filteredCars);

    // Step 4: Reset and rebuild filter options
    availableBodyTypes = ['Any'];
    availableFuelTypes = ['Any'];
    availableTransmissions = ['Any'];
    availableModels = ['Any'];
    // Do not clear availableMakes yet — we’ll update it conditionally below

    final Set<String> updatedMakeNames = {
      for (var make in availableMakes) make.name ?? ''
    };

    // Step 5: Process filtered cars to build filter options
    for (var car in filteredCars) {
      if (car.bodyType?.isNotEmpty == true &&
          !availableBodyTypes.contains(car.bodyType)) {
        availableBodyTypes.add(car.bodyType!);
      }

      if (car.fuelType?.isNotEmpty == true &&
          !availableFuelTypes.contains(car.fuelType)) {
        availableFuelTypes.add(car.fuelType!);
      }

      if (car.transmission?.isNotEmpty == true &&
          !availableTransmissions.contains(car.transmission)) {
        availableTransmissions.add(car.transmission!);
      }

      final makeData = _extractMakeData(car.makesList ?? []);
      for (var make in makeData) {
        if (make.name != null && !updatedMakeNames.contains(make.name!)) {
          availableMakes.add(make);
          updatedMakeNames.add(make.name!);
        }

        for (var model in make.children) {
          final modelName = model.name;
          if (modelName?.isNotEmpty == true &&
              !availableModels.contains(modelName)) {
            availableModels.add(modelName!);
          }
        }
      }
    }

    availableModels.sort();

    // Step 6: Refine availableMakes based on selection logic
    final shouldFilterMakesBySelection = selectedMakes.isEmpty ||
        (selectedMakes.length == 1 && selectedMakes.contains('Any'));

    if (shouldFilterMakesBySelection) {
      final Set<String> matchingMakeNamesFromData = {};

      for (var car in forFilterData) {
        if (car.color != null && selectedColors.contains(car.color)) {
          final makesList = _extractMakeData(car.makesList ?? []);
          for (var make in makesList) {
            final matchBodyType = selectedBodyTypes.contains('Any') ||
                selectedBodyTypes.contains(car.bodyType);

            final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
                int.parse(formatter(car.price)) >= lowerValue &&
                int.parse(formatter(car.price)) <= upperValue;

            final isYearInRange = int.tryParse(formatter(car.year)) != null &&
                int.parse(formatter(car.year)) >= minYear &&
                int.parse(formatter(car.year)) <= maxYear;

            final isKmInRange =
                double.tryParse(formatter(car.mileage)) != null &&
                    double.parse(formatter(car.mileage)) >= minKm &&
                    double.parse(formatter(car.mileage)) <= maxKm;

            if (matchBodyType &&
                isPriceInRange &&
                isYearInRange &&
                isKmInRange) {
              if (make.name != null) matchingMakeNamesFromData.add(make.name!);
            }
          }
        } else if (selectedColors.contains('Any')) {
          final makesList = _extractMakeData(car.makesList ?? []);
          for (var make in makesList) {
            final matchBodyType = selectedBodyTypes.contains('Any') ||
                selectedBodyTypes.contains(car.bodyType);

            final isPriceInRange = int.tryParse(formatter(car.price)) != null &&
                int.parse(formatter(car.price)) >= lowerValue &&
                int.parse(formatter(car.price)) <= upperValue;

            final isYearInRange = int.tryParse(formatter(car.year)) != null &&
                int.parse(formatter(car.year)) >= minYear &&
                int.parse(formatter(car.year)) <= maxYear;

            final isKmInRange =
                double.tryParse(formatter(car.mileage)) != null &&
                    double.parse(formatter(car.mileage)) >= minKm &&
                    double.parse(formatter(car.mileage)) <= maxKm;

            if (matchBodyType &&
                isPriceInRange &&
                isYearInRange &&
                isKmInRange) {
              if (make.name != null) matchingMakeNamesFromData.add(make.name!);
            }
          }
        }
      }

      availableMakes.removeWhere(
        (make) =>
            make.name != null && !matchingMakeNamesFromData.contains(make.name),
      );
    }

    // Step 7: Ensure 'Any' is always present in availableMakes
    if (!availableMakes.any((make) => make.name == 'Any')) {
      availableMakes.insert(0, carMake);
    }

    // Step 8: Notify listeners
    notifyListeners();
  }

  checkUpperRange(List<CarListing> filteredCars) {
    availableMakes.sort((a, b) => a.name!.compareTo(b.name!));
    availableModels.sort((a, b) => a.compareTo(b));
    if (lowerValue == 50000 && upperValue == 25000000) {
      final prices = filteredCars
          .map((car) => double.parse(
              car.price.toString().replaceAll('฿', '').replaceAll(',', '')))
          .toList();
      final minP = prices.reduce((a, b) => a < b ? a : b);
      final maxP = prices.reduce((a, b) => a > b ? a : b);

      // lowerValue = minP;
      // upperValue = maxP;
    }
    if (minKm == 0 && maxKm == 1000000) {
      final mileages = filteredCars.map((car) {
        final mileageStr =
            car.mileage.toString().replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(mileageStr) ?? 0;
      }).toList();

      // minKm = mileages.reduce((a, b) => a < b ? a : b);
      // maxKm = mileages.reduce((a, b) => a > b ? a : b);
    }
    if (minYear == 1988 && maxYear == DateTime.now().year) {
      final years = filteredCars.map((car) => int.parse(car.year)).toList();
      // minYear = years.reduce((a, b) => a < b ? a : b);
      // maxYear = years.reduce((a, b) => a > b ? a : b);
    }
    notifyListeners();
  }
}
