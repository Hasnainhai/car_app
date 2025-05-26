import 'dart:convert';
import 'dart:developer';

import 'package:fl_carmax/models/car_details_model.dart';
import '../../../common_libs.dart';
import '../../../models/car_listing_model.dart';
import 'package:http/http.dart' as http;

class CompareProvider extends ChangeNotifier {
  final List<CarListing> _compareList = [];

  List<CarListing> get compareList => List.unmodifiable(_compareList);

  // void toggleCar(CarListing car) {
  //   if (_compareList.contains(car)) {
  //     _compareList.remove(car);
  //   } else {
  //     _compareList.add(car);
  //   }
  //   notifyListeners();
  // }

  void toggleCar(CarListing car) {
    if (car.id.isEmpty) {
      log('Error: Attempted to toggle car with empty ID');
      return;
    }

    final index = _compareList.indexWhere((item) => item.id == car.id);
    if (index != -1) {
      _compareList.removeAt(index);
      log('Removed car with ID: ${car.id}, Compare list: ${_compareList.map((c) => c.id).toList()}');
    } else {
      if (_compareList.length >= 4) { // Optional: Limit compare list size
        log('Compare list limit reached (4 cars)');
        return;
      }
      _compareList.add(car);
      log('Added car with ID: ${car.id}, Compare list: ${_compareList.map((c) => c.id).toList()}');
    }
    notifyListeners();
  }


  // bool isInCompare(CarListing car) {
  //   return _compareList.contains(car);
  // }

  bool isInCompare(CarListing car) {
    final isInList = _compareList.any((item) => item.id == car.id);
    log('Checking if car ID: ${car.id} is in compare: $isInList');
    return isInList;
  }


  // void remove(CarListing car) {
  //   _compareList.remove(car);
  //   notifyListeners();
  // }

  void remove(CarListing car) {
    final index = _compareList.indexWhere((item) => item.id == car.id);
    if (index != -1) {
      _compareList.removeAt(index);
      log('Removed car with ID: ${car.id}, Compare list: ${_compareList.map((c) => c.id).toList()}');
      notifyListeners();
    }
  }
  void removeCar(String id) {
    _compareList.removeWhere((car) => car.id == id);
    notifyListeners();
  }
void updateData(){
    notifyListeners();
}
  void clear() {
    _compareList.clear();
    notifyListeners();
  }

  ///---------- Get Favourites
  bool loading = false;
  List<CarDetailModel> wishlist = [];
  Set<int> favouriteIds = {};

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    debugPrint("Loaded user_id: $userId");
    loading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('https://www.wowcar.app/wp-json/custom/v1/wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      debugPrint("Wishlist response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['wishlist'] ?? [];

        final List<Future<CarDetailModel?>> detailFutures =
        data.map((item) async {
          final listingId = item['post']?['ID']?.toString();

          debugPrint("Fetching detail for listing_id: $listingId");

          final detailResponse = await http.get(
            Uri.parse(
                'https://www.wowcar.app/wp-json/listivo/v1/single-listing/$listingId'),
          );

          if (detailResponse.statusCode == 200) {
            final carDetailJson = jsonDecode(detailResponse.body);
            return CarDetailModel.fromJson(carDetailJson);
          } else {
            debugPrint(
                "Failed to fetch detail for ID $listingId: ${detailResponse.body}");
          }

          return null;
        }).toList();

        final List<CarDetailModel> detailedWishlist =
        (await Future.wait(detailFutures))
            .whereType<CarDetailModel>()
            .toList();

        debugPrint("Detailed cars fetched: ${detailedWishlist.length}");

        wishlist = detailedWishlist;
        favouriteIds = detailedWishlist.map((e) => int.tryParse(e.id) ?? 0).toSet();
        loading = false;
        notifyListeners();
      }
      else {
        loading = false;
        notifyListeners();
        debugPrint("Failed to load wishlist: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching wishlist: $e");
      loading = false;
      notifyListeners();
    }
  }
  void updateFields(){
    notifyListeners();
  }
  // Add safe mutation methods for wishlist
  void removeFromWishlistByIndex(int index) {
    if (index >= 0 && index < wishlist.length) {
      wishlist.removeAt(index);
      notifyListeners();
    }
  }

  void removeFromWishlistById(String id) {
    wishlist.removeWhere((car) => car.id == id);
    notifyListeners();
  }
}
