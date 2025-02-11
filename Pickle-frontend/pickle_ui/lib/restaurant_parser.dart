import 'dart:convert';
import 'restaurant_results_page.dart';

List<Restaurant> parseRestaurants(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return (parsed['restaurants'] as List)
      .map<Restaurant>((json) => Restaurant(
            name: json['restaurant_name'] as String,
            address: json['address'] as String,
            rating: (json['rating'] as num).toDouble(),
            priceRange: json['price_range'] as String,
            favorites: List<String>.from(json['favorites']),
          ))
      .toList();
} 