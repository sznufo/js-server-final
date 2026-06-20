import 'dart:typed_data';

class FashionItem {
  Uint8List imageBytes;
  String category;
  String brand;
  String name;
  String description;
  double price;

  FashionItem({
    required this.imageBytes,
    required this.category,
    required this.brand,
    required this.name,
    required this.description,
    required this.price,
  });
}
