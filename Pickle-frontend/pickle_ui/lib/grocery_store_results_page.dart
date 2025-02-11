import 'package:flutter/material.dart';

class GroceryStore {
  final String name;
  final String address;
  final List<String> itemsAvailable;

  GroceryStore({
    required this.name,
    required this.address,
    required this.itemsAvailable,
  });
}

class GroceryStoreResultsPage extends StatelessWidget {
  final List<GroceryStore> stores;

  const GroceryStoreResultsPage({required this.stores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Stores')),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
                  SizedBox(height: 4),
                  Text(store.address, style: TextStyle(
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
                      Text('Available Items:', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                      SizedBox(height: 8),
                      ...store.itemsAvailable.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.shopping_basket, size: 16, color: Colors.green),
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