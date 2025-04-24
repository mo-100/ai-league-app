import 'package:ai_league_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use mock profile data
    final UserProfile profile = UserProfile.mockProfile();
    
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: AppConstants.mainColor, // Dark background color
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile picture with edit icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade800, width: 2),
                    image: DecorationImage(
                      image: AssetImage(profile.profileImagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF26CBA8), // Teal edit button
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // User name
            Text(
              profile.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Profile information sections
            _buildInfoItem(
              context: context,
              icon: Icons.person_outline,
              title: 'Name',
              value: profile.name,
            ),
            _buildDivider(),
            _buildInfoItem(
              context: context,
              icon: Icons.email_outlined,
              title: 'Email',
              value: profile.email,
            ),
            _buildDivider(),
            _buildInfoItem(
              context: context,
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: profile.phone,
            ),
            _buildDivider(),
            _buildInfoItem(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: profile.address,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Divider(
        color: Color(0xFF2A2A3A),
        thickness: 1,
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.matchColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}
