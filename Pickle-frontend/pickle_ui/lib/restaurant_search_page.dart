import 'dart:convert';
import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'restaurant_results_page.dart';
import 'package:http/http.dart' as http;
import 'restaurant_parser.dart';

class RestaurantSearchPage extends StatefulWidget {
  @override
  _RestaurantSearchPageState createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  String _selectedRadius = '2';

  Future<void> _searchRestaurants() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/findRestaurantsUsingPerplexity'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'zipcode': _zipcodeController.text,
          'cuisine_or_dish_preferred': _cuisineController.text,
          'radius': int.parse(_selectedRadius)
        }),
      );

      Navigator.pop(context);
      
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantResultsPage(restaurants: parseRestaurants(response.body)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Restaurants')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _zipcodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Zip Code',
                  hintText: 'Enter your zip code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a zip code';
                  if (!RegExp(r'^\d{5}$').hasMatch(value)) return 'Invalid zip code';
                  return null;
                },
              ),
              TextFormField(
                controller: _cuisineController,
                decoration: InputDecoration(
                  labelText: 'Cuisine or Dish',
                  hintText: 'e.g., Italian, Sushi, Burgers',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a cuisine or dish';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedRadius,
                items: ['1', '2', '5', '10']
                    .map((radius) => DropdownMenuItem(
                          value: radius,
                          child: Text('$radius miles'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRadius = value!),
                decoration: InputDecoration(labelText: 'Search Radius'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _searchRestaurants,
                child: Text('Search Restaurants'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
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