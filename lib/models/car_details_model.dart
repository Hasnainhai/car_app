
class CarDetailModel {
  final String id;
  final String title;
  final String? postDate;
  String sellerName;
  final String content;
  final List<String> imageUrls;
final List<CarDetailModel> relatedProducts;
  final String price;
  final String mileage;
  final String year;
  final String location;

  final String fuelType;
  final String transmission;
  final String engineCapacity;
  final String bodyType;
  final String drive;
  final String color;

  final List<String> offerTags;
  final List<String> safetyFeatures;
  final List<String> comfortFeatures;

  final String referenceCode;
  final String make;
  final String modelGroup;
  final String modelVariant;
  final String doors;
final List<CarDetailModel> relatedCategoryProducts;

  final String sellerDescription;
  final Map<String, dynamic>? metaD;


  CarDetailModel({
     required this.id,
    required this.title,
    required this.postDate,
    required this.content,
    required this.imageUrls,
  required this.relatedProducts,
    required this.price,
    required this.sellerName,
    required this.mileage,
    required this.year,
    required this.location,
    required this.fuelType,
    required this.transmission,
    required this.engineCapacity,
    required this.bodyType,
    required this.drive,
    required this.color,
    required this.offerTags,
    required this.safetyFeatures,
    required this.comfortFeatures,
    required this.referenceCode,
    required this.make,
    required this.modelGroup,
    required this.modelVariant,
    required this.doors,
required this.relatedCategoryProducts,

    required this.sellerDescription,
    this.metaD,
  });

  factory CarDetailModel.fromJson(Map<String, dynamic> json) {
  final post = json['post'] ?? {};
  final meta = json['meta'] ?? {};
  final images = json['related_guids'] as List? ?? [];
  final taxonomies = json['taxonomies'] as Map<String, dynamic>? ?? {};

  String getTaxName(String key) {
    final list = taxonomies[key] as List?;
    if (list != null && list.isNotEmpty) {
      return list.first['name']?.toString() ?? '';
    }
    return '';
  }

  String _parseHtmlString(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  List<CarDetailModel> extractRelatedProducts() {
    final list = json['related_products'] as List?;
    if (list != null) {
      return list.map((e) => CarDetailModel.fromJson(e)).toList();
    }
    return [];
  }
List<CarDetailModel> extractCategoryRelatedProducts() {
  final list = json['related_category_products'] as List?;
  if (list != null) {
    return list.map((e) => CarDetailModel.fromJson(e)).toList();
  }
  return [];
}

  List<String> getTagList(String key) {
    final list = taxonomies[key] as List?;
    if (list != null) {
      return list.map((e) => e['name'].toString()).toList();
    }
    return [];
  }
   return CarDetailModel(
    id: post['ID']?.toString() ?? '',
    postDate: post['post_date']?.toString() ?? '',
    sellerDescription: _parseHtmlString(post['post_content']?.toString() ?? ''),
    title: post['post_title']?.toString() ?? '',
    content: post['post_content']?.toString() ?? '',
    imageUrls: images.map((e) => e['guid']?.toString() ?? '').where((e) => e.isNotEmpty).toList(),
    relatedProducts: extractRelatedProducts(),
    price: meta['listivo_130_listivo_13']?.toString() ?? '',
    mileage: meta['listivo_4686']?.toString() ?? '',
    year: meta['listivo_4316']?.toString() ?? '',
     sellerName: meta['listivo_14049']?.toString() ?? '',
    location: meta['listivo_153_address']?.toString() ?? '',
    fuelType: getTaxName('listivo_5667'),
    transmission: getTaxName('listivo_5666'),
    engineCapacity: getTaxName('listivo_8733'),
    bodyType: getTaxName('listivo_9312'),
    drive: getTaxName('listivo_8731'),
    color: getTaxName('listivo_8638'),
    offerTags: getTagList('listivo_5664'),
    safetyFeatures: getTagList('listivo_4318'),
    comfortFeatures: getTagList('listivo_8755'),
    referenceCode: meta['listivo_8671']?.toString() ?? '',
    make: getTaxName('listivo_945'),
    modelGroup: getTaxName('listivo_946'),
    modelVariant: meta['listivo_13698']?.toString() ?? '',
    doors: getTaxName('listivo_9311'),
    relatedCategoryProducts: extractCategoryRelatedProducts(),
     metaD: meta,

  );
}
}

class CarImage {
  final String id;
  final String url;

  CarImage({required this.id, required this.url});

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      id: json['ID'].toString(),
      url: json['guid'] ?? '',
    );
  }
}

