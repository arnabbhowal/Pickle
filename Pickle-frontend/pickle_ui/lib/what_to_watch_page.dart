import 'package:flutter/material.dart';
import 'watch_movies_options_page.dart'; // Import the new page

class WhatToWatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What to Watch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(context, 'Movies', true, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WatchOptionsPage()), // Redirect to WatchOptionsPage
              );
            }),
            _buildOptionButton(context, 'TV Shows', false, null),
            _buildOptionButton(context, 'Animes', false, null),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, bool enabled, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: Text(text),
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
    );
  }
}