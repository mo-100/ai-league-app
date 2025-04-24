import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/models/team.dart';
import 'package:ai_league_app/widgets/custom_app_bar.dart';
import 'package:ai_league_app/widgets/match_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              "There's no schedule",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "Press 'Schedule' and make your day!",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 160),

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
            SportCategoryDivider(
              name: '⚽ Soccer',
            ),

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
            SportCategoryDivider(
              name: '🎾 Tennis',
            ),

            const SizedBox(height: 10),

            // Tennis Tournament Card
            MatchCard(
              team1: const Team(
                name: "WTA",
                logoPath: "assets/images/wta.png",
              ),
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

  const SportCategoryDivider({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: 
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
        ),
        const Spacer(),
        const Icon(Icons.chevron_right, color: Colors.white),
      ],
    );
  }
}
