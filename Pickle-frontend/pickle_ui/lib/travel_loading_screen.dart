import 'package:flutter/material.dart';
import 'api_service.dart';
import 'travel_itinerary_page.dart';

class TravelLoadingScreen extends StatefulWidget {
  final String destination;
  final int duration;
  final List<String> interests;
  final String budget;
  final String? exclude;

  const TravelLoadingScreen({
    super.key,
    required this.destination,
    required this.duration,
    required this.interests,
    required this.budget,
    this.exclude,
  });

  @override
  _TravelLoadingScreenState createState() => _TravelLoadingScreenState();
}

class _TravelLoadingScreenState extends State<TravelLoadingScreen> {
  bool _isLoading = true; // Track loading state
  String? _errorMessage; // Track error messages

  @override
  void initState() {
    super.initState();
    _fetchItinerary();
  }

  Future<void> _fetchItinerary() async {
    setState(() {
      _isLoading = true; // Set loading state to true
      _errorMessage = null; // Clear any previous error messages
    });

    try {
      final itinerary = await ApiService().getTravelItinerary(
        destination: widget.destination,
        duration: widget.duration,
        interests: widget.interests,
        budget: widget.budget,
        exclude: widget.exclude,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TravelItineraryPage(itinerary: itinerary),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false; // Set loading state to false
        _errorMessage = 'Failed to fetch itinerary: $e'; // Set error message
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch itinerary: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) // Show loading indicator if loading
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text('Planning your ${widget.duration}-day trip to ${widget.destination}...'),
                ],
              ),
            if (_errorMessage != null) // Show error message and retry button if there's an error
              Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchItinerary, // Retry the API call
                    child: Text('Retry'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}