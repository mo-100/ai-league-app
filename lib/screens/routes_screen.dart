import 'dart:convert';
import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/functions.dart';
import 'package:ai_league_app/models/event.dart';
import 'package:ai_league_app/screens/timeline_details.dart';
import 'package:ai_league_app/widgets/timeline.dart';
import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});
  static const String jsonData = '''
      {
        "1": [
            {
                "time": "11:00", "activity": "Arrive at Jeddah Airport", 
                "location": "King Abdulaziz Intl Airport (JED)", 
                "description": "Collect baggage and proceed through immigration.",
                "type": "transport"
            },
            {
                "time": "12:30", "activity": "Transfer & Hotel Check-in", 
                "location": "Your Hotel, Jeddah", 
                "description": "Take a taxi/ride-share to the hotel and check in.",
                "type": "accommodation"
            },
            {
                "time": "14:00", "activity": "Lunch near Hotel", 
                "location": "Local Restaurant", 
                "description": "Grab a quick and tasty Saudi lunch nearby.",
                "type": "food"
            },
            {
                "time": "16:00", "activity": "Explore Jeddah Corniche", 
                "location": "Jeddah Waterfront", 
                "description": "Relaxing walk along the Red Sea coast.",
                "type": "sightseeing"
            },
            {
                "time": "18:30", "activity": "Football: Al-Ittihad vs Al-Orobah", 
                "location": "King Abdullah Sports City Stadium", 
                "description": "Attend the exciting Saudi Pro League match.",
                "type": "football"
            },
            {
                "time": "21:00", "activity": "Return to Hotel", 
                "location": "Your Hotel, Jeddah", 
                "description": "Head back after the match to rest.",
                "type": "accommodation"
            }
        ],
        "2": [
            {
                "time": "09:00", "activity": "Breakfast at Hotel", 
                "location": "Hotel Restaurant", 
                "description": "Start the day with a good breakfast.",
                "type": "food"
            },
            {
                "time": "10:30", "activity": "Visit Al-Balad (Old Town)", 
                "location": "Historic Jeddah", 
                "description": "Explore the traditional architecture and souqs.",
                "type": "sightseeing"
            },
            {
                "time": "13:00", "activity": "Lunch in Al-Balad", 
                "location": "Traditional Restaurant", 
                "description": "Enjoy authentic Hijazi cuisine.",
                "type": "food"
            },
            {
                "time": "16:00", "activity": "Formula 1 Race", 
                "location": "Jeddah Street Circuit", 
                "description": "Experience the speed and excitement of F1.",
                "type": "sport"
            },
            {
                "time": "19:30", "activity": "Return to Hotel", 
                "location": "Your Hotel, Jeddah", 
                "description": "Relax after an exciting day at the race.",
                "type": "accommodation"
            }
        ],
        "3": [
            {
                "time": "08:30", "activity": "Breakfast & Check-out", 
                "location": "Your Hotel, Jeddah", 
                "description": "Enjoy breakfast and complete hotel check-out.",
                "type": "food"
            },
            {
                "time": "10:00", "activity": "Souvenir Shopping", 
                "location": "Local Souq or Mall", 
                "description": "Buy some gifts and mementos.",
                "type": "shopping"
            },
            {
                "time": "12:30", "activity": "Lunch", 
                "location": "Restaurant near Shopping Area", 
                "description": "Have a final Saudi meal before the match.",
                "type": "food"
            },
            {
                "time": "16:00", "activity": "Attend Judo Match", 
                "location": "Jeddah Sports Arena", 
                "description": "Watch a local or regional Judo competition.",
                "type": "judo"
            },
            {
                "time": "18:30", "activity": "Head to Airport", 
                "location": "Transfer to JED", 
                "description": "Allow ample time for travel and check-in.",
                "type": "transport"
            },
            {
                "time": "21:00", "activity": "Depart from Jeddah", 
                "location": "King Abdulaziz Intl Airport (JED)", 
                "description": "Board your flight home.",
                "type": "transport"
            }
        ]
      }
    ''';
  List<List<Event>> eventsfromJson(Map<String, dynamic> json) {
    final Map<String, List<Event>> result = {};

    json.forEach((day, events) {
      result[day] =
          (events as List)
              .map((event) => Event.fromJson(event as Map<String, dynamic>))
              .toList();
    });
    List<List<Event>> res = List.empty(growable: true);
    result.forEach((key, value) {
      res.add(value);
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> decodedData = json.decode(jsonData);
    List<List<Event>> eventslist = eventsfromJson(decodedData);
    
    final List<String> dayTitles = [
      'Day 1: April 23 - Sports Day',
      'Day 2: April 24 - Cultural Day',
      'Day 3: April 25 - Departure Day'
    ];
    
    return Scaffold(
      backgroundColor: AppConstants.mainColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Your Roadmaps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'For everyday you have a different roadmap',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              // Use Expanded for the ListView
              Expanded(
                child: ListView.builder(
                  itemCount: eventslist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Timeline(
                        title: index < dayTitles.length 
                            ? dayTitles[index] 
                            : 'Day ${index + 1}',
                        events: eventslist[index],
                        onPressed: (){
                          pushScreen(context, TimelineDetails(
                            events: eventslist[index],
                            title: index < dayTitles.length 
                            ? dayTitles[index] 
                            : 'Day ${index + 1}',
                          ));
                        }
                      ),
                    );
                  },
                ),
              ),
            ],
        ),
      ),
    );
  }
}
