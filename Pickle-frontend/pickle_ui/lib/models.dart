class Itinerary {
  final List<DayItinerary> days;

  Itinerary({required this.days});

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      days: (json['itinerary'] as List)
          .map((dayJson) => DayItinerary.fromJson(dayJson))
          .toList(),
    );
  }
}

class DayItinerary {
  final int day;
  final String date;
  final List<String> areaToStay;
  final String transportation;
  final List<String> activities;

  DayItinerary({
    required this.day,
    required this.date,
    required this.areaToStay,
    required this.transportation,
    required this.activities,
  });

  factory DayItinerary.fromJson(Map<String, dynamic> json) {
    return DayItinerary(
      day: json['day'],
      date: json['date'],
      areaToStay: List<String>.from(json['area_to_stay']),
      transportation: json['transportation'],
      activities: List<String>.from(json['activities']),
    );
  }
} 