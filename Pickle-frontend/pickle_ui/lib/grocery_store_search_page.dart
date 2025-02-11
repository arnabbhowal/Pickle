import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'grocery_store_results_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'grocery_store_parser.dart';

class GroceryStoreSearchPage extends StatefulWidget {
  final List<String> missingItems;

  const GroceryStoreSearchPage({required this.missingItems});

  @override
  _GroceryStoreSearchPageState createState() => _GroceryStoreSearchPageState();
}

class _GroceryStoreSearchPageState extends State<GroceryStoreSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _zipcodeController = TextEditingController();
  String _selectedRadius = '2';

  Future<void> _searchStores() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/findGroceryStoresUsingPerplexity'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'missing_items': widget.missingItems,
          'zipcode': _zipcodeController.text,
          'radius': int.parse(_selectedRadius)
        }),
      );

      Navigator.pop(context);
      
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroceryStoreResultsPage(stores: parseStores(response.body)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Grocery Stores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Missing Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: widget.missingItems
                    .map((item) => Chip(label: Text(item)))
                    .toList(),
              ),
              SizedBox(height: 20),
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
                onPressed: _searchStores,
                child: Text('Find Stores'),
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