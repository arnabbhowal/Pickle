import 'package:flutter/material.dart';
import 'what_to_watch_page.dart';
import 'eating_options_page.dart'; // Add this import
import 'travel_suggestion_page.dart';
import 'what_to_do_next_page.dart'; // Import the new page
import 'restaurant_search_page.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pickle',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        dividerTheme: DividerThemeData(
          space: 32,
          thickness: 1,
          color: Colors.grey[200],
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/app_logo.png',
          height: 40, // Adjust based on your logo aspect ratio
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(

        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ..._options.map((option) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: _HomeOptionTile(option: option),
                )).toList(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<HomeOption> _options = [
    HomeOption(
      title: 'What to Watch',
      icon: Icons.movie_filter,
      enabled: true,
      onTap: (context) => Navigator.push(context, MaterialPageRoute(builder: (_) => WhatToWatchPage())),
    ),
    HomeOption(
      title: 'What to Eat',
      icon: Icons.restaurant,
      enabled: true,
      onTap: (context) => Navigator.push(context, MaterialPageRoute(builder: (_) => WhatToEatPage())),
    ),
    HomeOption(
      title: 'Where to Go',
      icon: Icons.travel_explore,
      enabled: true,
      onTap: (context) => Navigator.push(context, MaterialPageRoute(builder: (_) => TravelSuggestionPage())),
    ),
    HomeOption(
      title: 'What to Do',
      icon: Icons.bolt,
      enabled: true,
      onTap: (context) => Navigator.push(context, MaterialPageRoute(builder: (_) => WhatToDoNextPage()))
    ),
  ];
}

class _HomeOptionTile extends StatelessWidget {
  final HomeOption option;
  const _HomeOptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.enabled ? () => option.onTap!(context) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: option.enabled ? Colors.black12 : Colors.grey[200]!,
              width: 1.5
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(option.icon, 
                size: 32,
                color: option.enabled ? Colors.black : Colors.grey[400],
              ),
              SizedBox(width: 20),
              Text(option.title.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: option.enabled ? Colors.black : Colors.grey[400],
                  letterSpacing: 0.8
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeOption {
  final String title;
  final IconData icon;
  final bool enabled;
  final Function(BuildContext)? onTap;

  HomeOption({
    required this.title,
    required this.icon,
    required this.enabled,
    this.onTap,
  });
}