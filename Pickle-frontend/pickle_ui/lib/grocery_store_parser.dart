import 'dart:convert';
import 'grocery_store_results_page.dart';

List<GroceryStore> parseStores(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return (parsed['stores'] as List)
      .map<GroceryStore>((json) => GroceryStore(
            name: json['store_name'] as String,
            address: json['address'] as String,
            itemsAvailable: List<String>.from(json['items_sold']),
          ))
      .toList();
} 