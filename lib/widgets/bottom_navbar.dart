import 'package:ai_league_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
      return Container(
        height: 80,
        decoration: const BoxDecoration(
          color: AppConstants.secondaryColor,
          border: Border(
            top: BorderSide(color: AppConstants.matchColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, 'Map'),
            _buildNavItem(1, 'Chatbot'),
            _buildNavItem(2, 'Home'),
            _buildNavItem(3, 'Schedule'),
            _buildNavItem(4, 'Profile'),
          ],
        ),
      );
    }

  Widget _buildNavItem(int index, String label) {
    bool isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppConstants.confirmColor : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          SizedBox(height: isSelected ? 15:5 ),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppConstants.confirmColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
