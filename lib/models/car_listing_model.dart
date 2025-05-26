class CarListing {
  final String id;
  final String? postDate;
  final String title;
  final String price;
  final String fuelType;
  final String? modelsType;
  final String transmission;
  final String mileage;
  final String year;
  final String imageUrl;
  final List? imageUrls;
  List<dynamic>? makesList;
  List<dynamic>? modelsListD;
  final String bodyType;
  final String engineCapacity;
  final bool isFeatured;
  final String carTag;
  final String? color;
  final String? carmodels;
  final String? modelVarient;
  final String location;
  final String? brand;
  final Map<String, dynamic>? metaD;

  CarListing({
    required this.id,
    this.postDate,
    required this.title,
    required this.price,
    required this.fuelType,
    required this.transmission,
    this.modelsListD,
    required this.mileage,
    this.carmodels,
    this.modelVarient,
    this.makesList,
    required this.year,
    required this.imageUrl,
    required this.imageUrls,
    required this.bodyType,
    required this.engineCapacity,
    required this.isFeatured,
    required this.carTag,
    this.modelsType,
    this.color,
    required this.location,
    this.brand,
    this.metaD,
  });

  factory CarListing.fromJson(Map<String, dynamic> json) {
    final post = json['post'];
    final meta = json['meta'];

    final relatedGuidsRaw = json['related_guids'];
    final relatedGuids = (relatedGuidsRaw is List) ? relatedGuidsRaw : [];
    final custom225Urls = relatedGuids
        .map((e) => e['images']?['custom_225x225'] ?? '')
        .where((url) => url.isNotEmpty)
        .take(5)
        .toList();

    final taxonomy = json['taxonomy'] ?? {};

    final taxonomies1 = json['taxonomies'] as Map<String, dynamic>? ?? {};

    String getTaxName(String key) {
      final list = taxonomies1[key] as List?;
      if (list != null && list.isNotEmpty) {
        return list.first['name']?.toString() ?? '';
      }
      return '';
    }

    final taxonomies = json['taxonomies'] as Map<String, dynamic>;

    final fuelList = taxonomies['listivo_5667'] as List?;
    final transmissionList = taxonomies['listivo_5666'] as List?;
    final bodyTypeList = taxonomies['listivo_9312'] as List?;
    final engineList = taxonomies['listivo_8733'] as List?;
    final modelsList = taxonomies['listivo_946'] as List?;
    final makesList = taxonomies['listivo_945'] as List?;
    final tagList = taxonomies['listivo_12624'] as List?;
    final colorList = taxonomies['listivo_8638'] as List?;
    final metaD = json['meta'] as Map<String, dynamic>;
    final color = colorList != null && colorList.isNotEmpty
        ? colorList.first['name'] ?? 'N/A'
        : 'N/A';
    final address = meta['listivo_153_address'] ?? '';
    return CarListing(

      id: post['ID']?.toString() ?? '',
      postDate: post['post_date']?.toString() ?? '',
      title: post['post_title'] ?? '',
      modelsListD: modelsList != null && modelsList.isNotEmpty ? modelsList:[],
      makesList: makesList != null && makesList.isNotEmpty ? makesList : [],
      price: "฿${meta['listivo_130_listivo_13'] ?? 'N/A'}",
      mileage: "${meta['listivo_4686'] ?? 'N/A'} km",
      year: meta['listivo_4316'] ?? 'N/A',
      fuelType: fuelList != null && fuelList.isNotEmpty
          ? fuelList.first['name'] ?? 'N/A'
          : 'N/A',
      transmission: transmissionList != null && transmissionList.isNotEmpty
          ? transmissionList.first['name'] ?? 'N/A'
          : 'N/A',
      bodyType: bodyTypeList != null && bodyTypeList.isNotEmpty
          ? bodyTypeList.first['name'] ?? 'N/A'
          : 'N/A',
      engineCapacity: engineList != null && engineList.isNotEmpty
          ? engineList.first['name'] ?? 'N/A'
          : 'N/A',

      imageUrl: custom225Urls.isNotEmpty ? custom225Urls.first : '',
      imageUrls: custom225Urls,
      isFeatured: (meta['featured'] ?? '0') == '1' ? true : false,
      carTag: tagList != null && tagList.isNotEmpty
          ? tagList.first['name'] ?? ''
          : '',
      color: color,
      location: address,
      brand: getTaxName('listivo_945'),
      metaD: metaD,
      modelVarient: meta['listivo_13698'] ?? 'N/A',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postDate': postDate,
      'title': title,
      'price': price,
      'fuelType': fuelType,
      'transmission': transmission,
      'mileage': mileage,
      'year': year,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'bodyType': bodyType,
      'engineCapacity': engineCapacity,
      'isFeatured': isFeatured,
      'carTag': carTag,
      'color': color,
      'location': location,
      'brand': brand,
      'meta': metaD,
      'modelVariant': modelVarient,
    };
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CarListing &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

}
