// lib/models/category_model.dart
class Category {
  final int categoryId;
  final String name;
  final String image;
  final String? imageUrl; // Nullable in case backend doesn't provide it

  Category({
    required this.categoryId,
    required this.name,
    required this.image,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'],
      imageUrl: json['imageUrl'], // ✅ camelCase to match backend API response
    );
  }

  // Get image URL directly from backend (already has full URL)
  String getImageUrl() {
    // Backend already provides full URL in imageUrl field
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Fix: Replace backend's IP with the correct one that Flutter can reach
      return imageUrl!.replaceAll('192.168.56.1', '192.168.1.185');
    }
    // Fallback: construct URL if backend doesn't provide it
    return 'http://192.168.1.185:3000/images/categories/$image';
  }

  // Check if category is disabled based on name
  bool get isDisabled => name.toLowerCase().contains('disable') || name.toLowerCase() == 'vr headset';
}
