class CarBrandModel {
  final String? termId;
  final String? name;
  final String? slug;

  CarBrandModel({
    this.termId,
    this.name,
    this.slug,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json) {
    return CarBrandModel(
      termId: json['term_id']?.toString(),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}


class CarMakeModel {
  final String? termId;
  final String? name;
  final String? slug;
  final String? taxonomy;
  final List<CarBrandModel> children;

  CarMakeModel({
    this.termId,
    this.name,
    this.slug,
    this.taxonomy,
    required this.children,
  });

  factory CarMakeModel.fromJson(Map<String, dynamic> json) {
    return CarMakeModel(
      termId: json['term_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      taxonomy: json['taxonomy'] ?? '',
      children: (json['children'] as List?)
              ?.map((child) => CarBrandModel.fromJson(child))
              .toList() ??
          [],
    );
  }
}
