import 'dart:convert';

import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/functions.dart';
import 'package:ai_league_app/models/event.dart';
import 'package:ai_league_app/models/team.dart';
import 'package:ai_league_app/screens/timeline_details.dart';
import 'package:ai_league_app/widgets/custom_app_bar.dart';
import 'package:ai_league_app/widgets/match_card.dart';
import 'package:ai_league_app/widgets/timeline.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final String jsonData = """
        [
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
        ]""";

  @override
  Widget build(BuildContext context) {
    final List<dynamic> decodedData = json.decode(jsonData);
    final List<Event> events =
        decodedData.map((e) => Event.fromJson(e)).toList();
    return Scaffold(
      backgroundColor: AppConstants.mainColor,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // No Schedule Text
            const Text(
              "Your Schedule Today",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),
            Timeline(
              title: 'Todays Schedule',
              events: events,
              onPressed: () {
                pushScreen(
                  context,
                  TimelineDetails(events: events, title: 'Todays Schedule'),
                );
              },
            ),
            const SizedBox(height: 20),

            // Recommended Section
            const Text(
              "Recommended for you:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Soccer Category
            SportCategoryDivider(name: '⚽ Soccer'),

            const SizedBox(height: 10),

            // Match example (like the one in your first image)
            MatchCard(
              team1: const Team(
                name: "Al-Ittihad",
                logoPath: "assets/images/ittihad.png",
              ),
              team2: const Team(
                name: "Al-Orobah",

                logoPath: "assets/images/orobah.png",
              ),
              title: "Al-Ittihad    vs    Al-Orobah",
              time: "9:00 PM",
              timeRemaining: "11 hours, 44 minutes",
            ),

            const SizedBox(height: 20),

            // Tennis Category
            SportCategoryDivider(name: '🎾 Tennis'),

            const SizedBox(height: 10),

            // Tennis Tournament Card
            MatchCard(
              team1: const Team(name: "WTA", logoPath: "assets/images/wta.png"),
              title: "Riyadh WTA Tour Finals (Nov 3-9)",
              time: "11:00 AM",
              timeRemaining: "185 days, 6 hours, 29 minutes",
            ),
          ],
        ),
      ),
    );
  }
}

class SportCategoryDivider extends StatelessWidget {
  final String name;

  const SportCategoryDivider({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        const Spacer(),
        const Icon(Icons.chevron_right, color: Colors.white),
      ],
    );
  }
}
