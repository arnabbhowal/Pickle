import 'package:flutter/material.dart';
import 'models.dart'; // Assuming you have an Itinerary model

class TravelItineraryPage extends StatelessWidget {
  final Itinerary itinerary;

  const TravelItineraryPage({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Travel Plan')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itinerary.days.length,
        itemBuilder: (context, index) {
          final day = itinerary.days[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${day.day}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  _buildSection('Recommended Areas to Stay', day.areaToStay.join(', ')),
                  _buildSection('Transportation', day.transportation),
                  const SizedBox(height: 12),
                  Text(
                    'Activities:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...day.activities.map((activity) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• $activity'),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(content),
        ],
      ),
    );
  }
} 