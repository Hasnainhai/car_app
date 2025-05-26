class CarMake {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int count;
  final String link;

  CarMake({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.count,
    required this.link,
  });

  factory CarMake.fromJson(Map<String, dynamic> json) {
    return CarMake(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      count: json['count'] ?? 0,
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'count': count,
      'link': link,
    };
  }
}
