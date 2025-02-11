import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  // ... existing methods ...
Future<Itinerary> getTravelItinerary({
  required String destination,
  required int duration,
  required List<String> interests,
  required String budget,
  String? exclude,
}) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/api/generateTravelItineraryWithDeepSeek'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'destination': destination,
      'duration': duration,
      'interests': interests,
      'budget': budget,
      'exclude': exclude,
    }),
  );

  if (response.statusCode == 200) {
    return Itinerary.fromJson(jsonDecode(response.body));
  } else {
    // Throw a detailed exception with the status code and response body
    throw Exception('Failed to load itinerary: ${response.statusCode} - ${response.body}');
  }
}
} 