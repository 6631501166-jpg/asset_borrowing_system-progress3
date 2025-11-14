// lib/models/asset_model.dart
import 'package:flutter/material.dart';

class Asset {
  final int assetId;
  final String assetCode;
  final String assetName;
  final String status;
  final String categoryName;
  final String categoryImage;
  final String? categoryImageUrl;

  Asset({
    required this.assetId,
    required this.assetCode,
    required this.assetName,
    required this.status,
    required this.categoryName,
    required this.categoryImage,
    this.categoryImageUrl,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetId: json['asset_id'],
      assetCode: json['asset_code'],
      assetName: json['asset_name'],
      status: json['status'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
      categoryImageUrl: json['category_image_url'],
    );
  }

  // Get image URL with IP fix
  String getImageUrl() {
    if (categoryImageUrl != null && categoryImageUrl!.isNotEmpty) {
      // Fix: Replace backend's IP with the correct one
      return categoryImageUrl!.replaceAll('192.168.56.1', '192.168.1.185');
    }
    // Fallback: construct URL
    return 'http://192.168.1.185:3000/images/categories/$categoryImage';
  }

  // Helper to get status color
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF4CAF50); // Green
      case 'borrowed':
        return const Color(0xFFFFB020); // Orange
      case 'pending':
        return const Color(0xFFFDF455); // Yellow
      case 'maintenance':
      case 'disable':
        return const Color(0xFFFF4040); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  // Check if asset can be borrowed
  bool get isAvailable => status.toLowerCase() == 'available';
}
