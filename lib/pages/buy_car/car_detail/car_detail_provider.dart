import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/car_details_model.dart';

class CarDetailProvider extends ChangeNotifier {
  bool isFavourite = false;
  CarDetailModel? carDetail;
  bool isLoading = true;
  List<CarDetailModel> similarCars = [];
  setLoader(val){
    isLoading = val;
    notifyListeners();
  }
  setFavouriteLoader(val, {bool load = true}){
    isFavourite = val;
    if(load)notifyListeners();
  }
  Future<void> fetchCarDetail(carId,{bool load = true}) async {
    isLoading = true;
    if(load)notifyListeners();
    log("$carId");
    log(carId.toString());
    final response = await http.get(Uri.parse(
        'https://www.wowcar.app/wp-json/listivo/v1/single-listing/$carId'));
    log(response.request.toString());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mainCar = CarDetailModel.fromJson(data);
      final List<CarDetailModel> similar = [];
      if (data['recent'] != null && data['recent'] is List) {
        similar.addAll((data['recent'] as List)
            .map((item) => CarDetailModel.fromJson(item))
            .toList());
      }
          carDetail = mainCar;
          similarCars = carDetail!.relatedProducts;
          carDetail!.sellerName = data['author_name'];
          await fetchLocationData();
          setLoader(false);
    } else {
      setLoader(false);
    }
  }

  Future<void> checkIfFavourite(carId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;

    final response = await http.post(
      Uri.parse('https://www.wowcar.app/wp-json/custom/v1/wishlist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        final isFav = decoded.any((item) =>
        item['post'] != null &&
            item['post']['ID'].toString() == carId);
        setFavouriteLoader(isFav);
      } else {
        print('Unexpected response format: not a list');
        setFavouriteLoader(false);
      }
    } else {
      print('API error: ${response.body}');
       setFavouriteLoader(false);
    }
  }

  Future<bool> toggleWishlist(int listingId, bool isAdding) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      print('User ID not found in SharedPreferences.');
      return false;
    }

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
        return true;
      } else {
        print('Failed to update wishlist: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating wishlist: $e');
      return false;
    }
  }

  Future<bool> addToWishlist(
      {required int userId, required int listingId}) async {
    final url =
    Uri.parse('https://www.wowcar.app/wp-json/custom/v1/wishlist/add');

    final response = await http.post(url, body: {
      'user_id': userId.toString(),
      'listing_id': listingId.toString(),
    });

    if (response.statusCode == 200) {
      print('Added to wishlist: ${response.body}');
      return true;
    } else {
      print('Add to wishlist failed: ${response.body}');
      return false;
    }
  }

  Future<bool> removeFromWishlist(
      {required int userId, required int listingId}) async {
    final url =
    Uri.parse('https://www.wowcar.app/wp-json/custom/v1/wishlist/remove');

    final response = await http.post(url, body: {
      'user_id': userId.toString(),
      'listing_id': listingId.toString(),
    });

    if (response.statusCode == 200) {
      print('Removed from wishlist: ${response.body}');
      return true;
    } else {
      print('Remove from wishlist failed: ${response.body}');
      return false;
    }
  }
  // Add these properties
  bool isLoadingLocation = false;
  LatLng? locationLatLng;
  String? locationError;

  // Other existing properties and methods...

  // Replace the getLatLngFromAddress method with this method
  Future<void> fetchLocationData() async {
    if (carDetail == null || carDetail!.location.isEmpty) {
      locationError = "No location data available";
      notifyListeners();
      return;
    }

    isLoadingLocation = true;
    notifyListeners();

    try {
      List<Location> locations = await locationFromAddress(carDetail!.location);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        locationLatLng = LatLng(loc.latitude, loc.longitude);
        locationError = null;
      } else {
        locationError = "Could not find coordinates for this location";
        locationLatLng = null;
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
      locationError = "Error finding location: ${e.toString()}";
      locationLatLng = null;
    } finally {
      isLoadingLocation = false;
      notifyListeners();
    }
  }
/*  Future<LatLng?> getLatLngFromAddress() async {
    try {
      List<Location> locations = await locationFromAddress(carDetail!.location);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return LatLng(loc.latitude, loc.longitude);
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
    return null;
  }*/

}


/*  bool isLoadingLocation = false;
  LatLng? locationLatLng;
  String? locationError;
Future<void> fetchLocationData() async {
  if (carDetail == null || carDetail!.location.isEmpty) {
    locationError = "No location data available";
    notifyListeners();
    return;
  }

  // Set loading state without immediate notification
  isLoadingLocation = true;

  try {
    List<Location> locations = await locationFromAddress(carDetail!.location);
    if (locations.isNotEmpty) {
      final loc = locations.first;
      locationLatLng = LatLng(loc.latitude, loc.longitude);
      notifyListeners()
    } else {
      locationError = "Could not find coordinates for this location";
    }
  } catch (e) {
    debugPrint("Geocoding error: $e");
    locationError = "Error finding location: ${e.toString()}";
  } finally {
    isLoadingLocation = false;
    notifyListeners(); // Only notify once at the end
  }
}*/