import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/models/team.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final Team team1;
  final Team? team2;
  final String title;
  final String time;
  final String timeRemaining;

  const MatchCard({
    super.key,
    required this.team1,
    this.team2,
    required this.title,
    required this.time,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppConstants.matchColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Row(
          children: [
            // First team logo
            SizedBox(
              width: team2 == null ? 40 : 70,
              child: Stack(
                children: [
                  _buildTeamLogo(team1.logoPath),

                  // Second team logo (if available)
                  if (team2 != null)
                    Positioned(
                      left: 30,
                      child: _buildTeamLogo(team2!.logoPath),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Center content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeRemaining,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Time
            Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamLogo(String logoPath) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(
        logoPath,
        width: 35,
        height: 35,
      ),
    );
  }
}
