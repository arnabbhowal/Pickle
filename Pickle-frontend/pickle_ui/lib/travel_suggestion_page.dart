import 'package:flutter/material.dart';
import 'travel_loading_screen.dart';
import 'package:intl/intl.dart';

class TravelSuggestionPage extends StatefulWidget {
  const TravelSuggestionPage({super.key});

  @override
  _TravelSuggestionPageState createState() => _TravelSuggestionPageState();
}

class _TravelSuggestionPageState extends State<TravelSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  String? destination;
  DateTime? startDate;
  DateTime? endDate;
  List<String> interests = [];
  String? budget;
  String? exclude;
  final TextEditingController _interestsController = TextEditingController();

  // Full list of possible interests
  final List<String> _allInterests = [
    'Adventure', 'Culture', 'Nature', 'Food', 'History',
    'Beaches', 'Shopping', 'Wildlife', 'Architecture', 
    'Local Cuisine', 'Nightlife', 'Wellness', 'Road Trips',
    'Photography', 'Museums', 'Festivals', 'Hiking', 'Art'
  ];

  // Gets first 5 unselected interests from the full list
  List<String> get _currentSuggestions => _allInterests
      .where((interest) => !interests.contains(interest))
      .take(5)
      .toList();

  int? get duration {
    if (startDate == null || endDate == null) return null;
    return endDate!.difference(startDate!).inDays + 1;
  }

  bool get isFormValid => 
      destination != null && 
      duration != null && 
      interests.isNotEmpty && 
      budget != null;

  Future<void> _selectDates() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _addInterest(String interest) {
    final trimmedInterest = interest.trim();
    if (trimmedInterest.isNotEmpty && !interests.contains(trimmedInterest)) {
      setState(() {
        interests.add(trimmedInterest);
        _interestsController.clear();
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TravelLoadingScreen(
            destination: destination!,
            duration: duration!,
            interests: interests,
            budget: budget!,
            exclude: exclude,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Destination*'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                onChanged: (value) => setState(() => destination = value),
                onSaved: (value) => destination = value,
              ),
              
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Travel Dates*', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _selectDates,
                    child: Text(
                      startDate == null 
                          ? 'Select travel dates'
                          : '${DateFormat('MMM dd').format(startDate!)} - ${DateFormat('MMM dd').format(endDate!)} (${duration} days)',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Interests*', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 8,
                    children: interests.map((interest) => Chip(
                      label: Text(interest),
                      onDeleted: () => setState(() => interests.remove(interest)),
                    )).toList(),
                  ),
                  TextField(
                    controller: _interestsController,
                    decoration: const InputDecoration(
                      labelText: 'Add interests',
                      hintText: 'Type and press enter (comma separated)',
                    ),
                    onSubmitted: (value) {
                      value.split(',').forEach((interest) => _addInterest(interest));
                    },
                  ),
                  Wrap(
                    spacing: 8,
                    children: _currentSuggestions
                        .map((interest) => ActionChip(
                              label: Text(interest),
                              onPressed: () => _addInterest(interest),
                            ))
                        .toList(),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Budget*'),
                items: ['Low', 'Medium', 'High']
                    .map((value) => DropdownMenuItem(
                          value: value.toLowerCase(),
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => budget = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exclude (optional)'),
                onSaved: (value) => exclude = value,
              ),
              
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isFormValid ? _submitForm : null,
                child: const Text('Generate Itinerary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 