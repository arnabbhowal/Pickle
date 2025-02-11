import 'package:flutter/material.dart';

class Restaurant {
  final String name;
  final String address;
  final double rating;
  final String priceRange;
  final List<String> favorites;

  Restaurant({
    required this.name,
    required this.address,
    required this.rating,
    required this.priceRange,
    required this.favorites,
  });
}

class RestaurantResultsPage extends StatelessWidget {
  final List<Restaurant> restaurants;

  RestaurantResultsPage({required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Results')),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${restaurant.rating} • ${restaurant.priceRange}'),
                    ],
                  ),
                  Text(restaurant.address, style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  )),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Popular Items:', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                      SizedBox(height: 8),
                      ...restaurant.favorites.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.fastfood, size: 16, color: Colors.grey),
                            SizedBox(width: 8),
                            Flexible(child: Text(item)),
                          ],
                        ),
                      )).toList(),
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
} 