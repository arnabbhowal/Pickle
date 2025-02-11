import 'package:flutter/material.dart';

class MovieResultsPage extends StatelessWidget {
  final dynamic movie;

  const MovieResultsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Year: ${movie['year']}'),
            SizedBox(height: 20),
            Text('Details:'),
            // Add more movie details here
          ],
        ),
      ),
    );
  }
} 