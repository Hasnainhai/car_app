import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../common_libs.dart';
import '../../../models/car_listing_model.dart';
import '../../../utils/constant.dart';
import '../../auth/login_page_email.dart';
import 'compare_controller.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key, this.showBackButton = true});
  final bool showBackButton;
  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  @override
  void initState() {
    super.initState();
    Future.wait([loadFavourites(),]);
  }

  Set<String> _favouriteIds = {};

  Future<void> loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('favourite_ids') ?? [];
    setState(() {
      _favouriteIds = savedIds.toSet();
    });
  }

  Future<void> toggleFavourite(String carId, String carName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      if(mounted){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Login Required", style: blackMedium18),
            content: Text("Please login to add items to your favourites.",
                style: blackMedium14),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: primaryMedium14),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPageEmail()));
                },
                child: Text("Login", style: whiteMedium14),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      if (_favouriteIds.contains(carId)) {
        _favouriteIds.remove(carId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 1),
          content: Text(
            '$carName Removed from Favourites',
            style: whiteMedium14,
          ),
        ));
      } else {
        _favouriteIds.add(carId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 1),
          content: Text(
            '$carName Added to Favourites',
            style: whiteMedium14,
          ),
        ));
      }
    });

    await prefs.setStringList('favourite_ids', _favouriteIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      'BODY TYPE',
      'BRAND',
      'MODEL',
      'YEAR',
      'MILEAGE',
      'ENGINE',
      'TRANSMISSION',
      'COLOR',
    ];

    return Consumer<CompareProvider>(
      builder: (context, provider, child) {

        final bool isEmpty = provider.compareList.isEmpty;

        return Scaffold(

          appBar: widget.showBackButton ? AppBar(
            title: Text(
              "Compare",
              style: blackSemiBold16,
            ),
            leadingWidth: 35,
            actions:  [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.grey,
                ),
                tooltip: 'Reset',
                onPressed: () {
                  provider.clear();
                  // (context as Element).reassemble();
                },
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: black,
                  )),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: white,
          ) : null,

          body: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  isEmpty
                      ? _placeholderCarRow(context, labels)
                      : _comparisonSpecs(
                      labels, provider.compareList, context, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _placeholderCarRow(BuildContext context, List<String> labels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cards Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Container(
                width: 120,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_car,
                        size: 60, color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      color: primaryColor,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchPage()),
                        ),
                        child: Text('+ Add Car', style: whiteSemiBold16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        // Labels and empty values
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade200),
          ),
          columnWidths: const {
            0: FixedColumnWidth(100),
          },
          children: [
            for (final label in labels)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      // <-- Wrap with Row
                      mainAxisSize:
                      MainAxisSize.min, // <-- Only take needed width
                      children: [
                        FittedBox(
                          fit: BoxFit.none,
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: primaryColor,
                              fontFamily: 'M',
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.clip,
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(
                      3,
                          (_) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('', style: TextStyle(fontSize: 14)),
                      )),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _comparisonSpecs(List<String> labels, List<CarListing> cars,
      BuildContext context, CompareProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cars.map((car) {
          final isFavourite = _favouriteIds.contains(car.id);
          final specs = [
            car.bodyType,
            car.brand ?? '',
            car.modelsListD != null && car.modelsListD!.isNotEmpty
                ? car.modelsListD?.first["name"] ?? ""
                : "",
            car.modelVarient??"",
            (car.year),
            //(car.mileage),
             "${NumberFormat.decimalPattern('en_US').format(int.tryParse(car.mileage.replaceAll(RegExp(r'[^\d]'), '')) ?? 0)} km",
            (car.engineCapacity),
            car.transmission,
            car.color ?? 'N/A',
            //car.brand ?? '',
          ];
          final labels = [

            'BODY TYPE',
            'MAKE',
            'MODEL',
            'MODEL VARIANT',
            'YEAR',
            'MILEAGE',
            'ENGINE',
            'TRANSMISSION',
            'COLOR',
          ];

          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Image & Info Card
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CarDetailPage(carId: car.id, modelsListD: car.modelsListD,),
                        ),
                      ),
                      child: Container(
                        width: 180,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: car.imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                imageUrl: car.imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                'assets/images/placeholder.png',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                car.title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6, top: 4),
                              child: Text(
                                NumberFormat.currency(
                                    decimalDigits: 0,
                                    locale: 'en',
                                    symbol: '฿')
                                    .format(int.tryParse(car.price.replaceAll(
                                    RegExp(r'[^\d]'), '')) ?? 0),
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      left: 4,
                      child: GestureDetector(
                        onTap: () => toggleFavourite(car.id, car.title),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite ? primaryColor : white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          log("${provider.compareList}");
                          provider.removeCar(car.id);
                          (context as Element).reassemble();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
                // Labels + Values in pairs
                for (int i = 0; i < labels.length; i++)
                  Column(
                    children: [
                      Container(
                        width: 180,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(labels[i], style: primaryMedium14),
                      ),
                      Container(
                        width: 180,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          specs[i],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 180, height: 1, color: Colors.black12),
                    ],
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}