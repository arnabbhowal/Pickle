import 'dart:math';
import 'package:flutter/material.dart';
import 'cook_at_home_page.dart';
import 'restaurant_search_page.dart';

class WhatToEatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eating Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(context, 'Cook at Home', true, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CookAtHomePage()),
              );
            }),
            _buildOptionButton(context, 'Eat Outside', true, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RestaurantSearchPage()),
              );
            }),
            _buildOptionButton(context, 'Decide for Me', true, () {
              final random = Random();
              final randomChoice = random.nextBool();
              if (randomChoice) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CookAtHomePage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantSearchPage()),
                );
              }
            }),
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