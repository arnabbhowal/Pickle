import 'package:flutter/material.dart';
import 'grocery_store_search_page.dart';

class Meal {
  final String name;
  final String cookingTime;
  final Map<String, dynamic> nutritionInfo;
  final String cookingInstructions;
  final Map<String, dynamic> ingredientsNeeded;
  final List<String> missingIngredients;
  final String storageTips;
  final List<String> dietaryTags;
  final List<String> allergyConcerns;

  Meal({
    required this.name,
    required this.cookingTime,
    required this.nutritionInfo,
    required this.cookingInstructions,
    required this.ingredientsNeeded,
    required this.missingIngredients,
    required this.storageTips,
    required this.dietaryTags,
    required this.allergyConcerns,
  });
}

class MealSuggestionsPage extends StatefulWidget {
  final List<Meal> meals;

  MealSuggestionsPage({required this.meals});

  @override
  _MealSuggestionsPageState createState() => _MealSuggestionsPageState();
}

class _MealSuggestionsPageState extends State<MealSuggestionsPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggested Meals'),
      ),
      body: ListView.builder(
        itemCount: widget.meals.length,
        itemBuilder: (context, index) {
          final meal = widget.meals[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.name, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 4),
                  Text('Cooking Time: ${meal.cookingTime}'),
                  Text('Calories: ${meal.nutritionInfo['calories']} • Protein: ${meal.nutritionInfo['protein']}g'),
                ],
              ),
              initiallyExpanded: _expandedIndex == index,
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedIndex = expanded ? index : null;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cooking Instructions:', style: Theme.of(context).textTheme.titleMedium),
                      Text(meal.cookingInstructions),
                      SizedBox(height: 16),
                      Text('Available Ingredients:', style: Theme.of(context).textTheme.titleMedium),
                      Wrap(
                        spacing: 8.0,
                        children: meal.ingredientsNeeded.entries
                            .where((entry) => entry.value == true)
                            .map((entry) => Chip(
                                  label: Text(entry.key),
                                  backgroundColor: Colors.green[100],
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Text('Missing Ingredients:', style: Theme.of(context).textTheme.titleMedium),
                      Wrap(
                        spacing: 8.0,
                        children: meal.missingIngredients
                            .map((ingredient) => Chip(
                                  label: Text(ingredient),
                                  backgroundColor: Colors.red[100],
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => _navigateToGrocerySearch(context, meal.missingIngredients),
                        child: Text('Order Missing Ingredients →'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.black),
                          textStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Dietary Tags:', style: Theme.of(context).textTheme.titleMedium),
                      Wrap(
                        spacing: 8.0,
                        children: meal.dietaryTags
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: Colors.blue[100],
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Text('Storage Tips:', style: Theme.of(context).textTheme.titleMedium),
                      Text(meal.storageTips),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToGrocerySearch(BuildContext context, List<String> missingItems) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroceryStoreSearchPage(missingItems: missingItems),
      ),
    );
  }
} 