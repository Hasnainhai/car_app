import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/car_listing_model.dart';

class SearchFilterController extends GetxController {
  // Observable list of cars
  var carList = <CarListing>[].obs;

  // Original list for filtering reference
  List<CarListing> originalList = [];

  // Loading state
  var isLoading = true.obs;

  // Favourite car IDs
  var favouriteIds = <int>{}.obs;

  // Current selected sort index
  int selectedSortIndex = 0;

  // Local cache of cars
  static List<CarListing>? _cachedCarList;

  /// Fetch car listings from the API or use cache.
  Future<void> fetchCarListings({bool forceRefresh = false, String? brandSlug}) async {
    try {
      if (!forceRefresh && _cachedCarList != null) {
        carList.assignAll(_cachedCarList!);
        originalList = List.from(_cachedCarList!);
        isLoading.value = false;
        return;
      }

      isLoading.value = true;

      final url = Uri.parse('https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        List<CarListing> allListings = jsonData.map((e) => CarListing.fromJson(e)).toList();

        if (brandSlug != null && brandSlug.isNotEmpty) {
          allListings = jsonData
              .where((e) {
                final brandList = e['taxonomies']?['listivo_945'] as List?;
                return brandList != null &&
                    brandList.any((b) => b['slug'].toString().toLowerCase() == brandSlug.toLowerCase());
              })
              .map((e) => CarListing.fromJson(e))
              .toList();
        }

        _cachedCarList = allListings;
        carList.assignAll(allListings);
        originalList = List.from(allListings);
      } else {
        debugPrint("Failed to fetch car listings: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching listings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch wishlist items for the logged-in user
  Future<void> fetchWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 0;

      final response = await http.post(
        Uri.parse('https://www.wowcar.app/wp-json/custom/v1/wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> data =
            body is List ? body : (body['data'] ?? []);

        favouriteIds.value = data
            .map<int>((e) => int.tryParse(e['post']?['ID']?.toString() ?? '0') ?? 0)
            .where((id) => id != 0)
            .toSet();
      } else {
        debugPrint("Failed to fetch wishlist: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching wishlist: $e");
    }
  }

  /// Filter the car list based on search query
  void filterBySearch(String query) {
    if (query.isEmpty) {
      carList.assignAll(originalList);
    } else {
      carList.assignAll(originalList.where((car) =>
          car.title.toLowerCase().contains(query.toLowerCase())));
    }
  }

  /// Sort the car list based on selected index
  void sortCarList(int index) {
    selectedSortIndex = index;
    switch (index) {
      case 1:
        carList.sort((a, b) => DateTime.parse(b.postDate!).compareTo(DateTime.parse(a.postDate!)));
        break;
      case 2:
        carList.sort((a, b) => parsePrice(a.price).compareTo(parsePrice(b.price)));
        break;
      case 3:
        carList.sort((a, b) => parsePrice(b.price).compareTo(parsePrice(a.price)));
        break;
      case 4:
        carList.sort((a, b) => parseKm(a.mileage).compareTo(parseKm(b.mileage)));
        break;
      case 5:
        carList.sort((a, b) => parseKm(b.mileage).compareTo(parseKm(a.mileage)));
        break;
      case 6:
        carList.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 7:
        carList.sort((a, b) => a.year.compareTo(b.year));
        break;
    }
  }

  /// Parse price string to integer (safe)
  int parsePrice(String price) {
    return int.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }

  /// Parse mileage string to integer (safe)
  int parseKm(String mileage) {
    return int.tryParse(mileage.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }
}
