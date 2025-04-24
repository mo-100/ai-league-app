class Event {
  final String time;
  final String activity;
  final String location;
  final String description;
  final String type;

  Event({
    required this.time,
    required this.activity,
    required this.location,
    required this.description,
    required this.type,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: json['time'] ?? '',
      activity: json['activity'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }
}