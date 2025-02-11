import 'dart:convert';
import 'meal_suggestions_page.dart';

List<Meal> parseMeals(String responseBody) {
  final parsed = jsonDecode(responseBody);
  final mealsData = parsed is List ? parsed : parsed['meal_suggestions'] as List;
  
  return mealsData.map<Meal>((json) {
    return Meal(
      name: json['meal_name'] as String,
      cookingTime: json['cooking_time'] as String,
      nutritionInfo: Map<String, dynamic>.from(json['nutrition_info']),
      cookingInstructions: json['cooking_instructions'] as String,
      ingredientsNeeded: Map<String, dynamic>.from(json['ingredients_needed']),
      missingIngredients: List<String>.from(json['missing_ingredients']),
      storageTips: json['storage_prep_tips'] as String,
      dietaryTags: List<String>.from(json['dietary_tags']),
      allergyConcerns: List<String>.from(json['allergy_concerns']),
    );
  }).toList();
} 