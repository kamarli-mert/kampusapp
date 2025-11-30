class MarketplaceItem {
  final String id;
  final String title;
  final String description;
  final int price;
  final String category;
  final String condition;
  final String seller;
  final List<String> imagePaths;

  MarketplaceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.seller,
    this.imagePaths = const [],
  });
}

