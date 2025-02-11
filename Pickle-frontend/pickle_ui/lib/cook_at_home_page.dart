import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'meal_suggestions_page.dart';
import 'loading_screen.dart';
import 'package:http/http.dart' as http;
import 'meal_parser.dart';

class CookAtHomePage extends StatefulWidget {
  @override
  _CookAtHomePageState createState() => _CookAtHomePageState();
}

class _CookAtHomePageState extends State<CookAtHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  final List<String> _ingredients = [];
  final TextEditingController _ingredientController = TextEditingController();

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _ingredients.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/suggestHomeMealsUsingDeepSeek'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ingredients': _ingredients,
          'calorie': _calorieController.text.isNotEmpty ? int.parse(_calorieController.text) : null,
          'protein': _proteinController.text.isNotEmpty ? int.parse(_proteinController.text) : null,
          'preferences': _preferencesController.text,
        }),
      );

      Navigator.pop(context);
      
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealSuggestionsPage(meals: parseMeals(response.body)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cook at Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Ingredients Available (required):'),
              Wrap(
                spacing: 8.0,
                children: _ingredients.map((ingredient) => Chip(
                  label: Text(ingredient),
                  onDeleted: () => setState(() => _ingredients.remove(ingredient)),
                )).toList(),
              ),
              TextField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Add ingredients you have',
                  hintText: 'e.g. eggs, flour, milk...',
                ),
                onSubmitted: (value) => _addIngredient(),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _calorieController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Calorie Specs (optional)',
                  hintText: 'Enter desired calories',
                ),
              ),
              TextFormField(
                controller: _proteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Protein Specs (optional)',
                  hintText: 'Enter desired protein in grams',
                ),
              ),
              TextFormField(
                controller: _preferencesController,
                decoration: InputDecoration(
                  labelText: 'Preferences (likes, dislikes, allergies)',
                  hintText: 'Enter any food preferences',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ingredients.isNotEmpty ? _submitForm : null,
                child: Text('Suggest Dishes'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 