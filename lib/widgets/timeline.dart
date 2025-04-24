import 'package:flutter/material.dart';
import '../models/event.dart';

class Timeline extends StatelessWidget {
  final String title;
  final List<Event> events;
  final Color startColor;
  final Color endColor;
  final VoidCallback? onPressed;

  const Timeline({
    super.key,
    required this.title,
    required this.events,
    this.startColor = const Color(0xFF1AB6A7),
    this.endColor = const Color(0xFF2A4B9B),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Sort events only once
    final sortedEvents = List<Event>.from(events)
      ..sort((a, b) => _convertTimeToMinutes(a.time).compareTo(_convertTimeToMinutes(b.time)));

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [startColor, endColor],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title section
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8), // Increased spacing

            // Timeline section
            _buildTimeline(context, sortedEvents),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<Event> sortedEvents) {
    // No need to split events here anymore
    return Column(
      children: [
        // Top row with events (even indices)
        _buildEventRow(sortedEvents, true),

        // Timeline with icons
        _buildIconsRow(sortedEvents),

        // Bottom row with events (odd indices)
        _buildEventRow(sortedEvents, false),
      ],
    );
  }

  Widget _buildEventRow(List<Event> sortedEvents, bool isTopRow) {
    // Generate a list with placeholders for alignment
    // Length is events * 2 - 1 to match the icon row structure
    final totalSlots = sortedEvents.isEmpty ? 0 : sortedEvents.length * 2 - 1;

    return Row(
      children: List.generate(totalSlots, (index) {
        // Odd indices are spacers (representing the lines)
        if (index % 2 == 1) {
          return Expanded(child: Container()); // Spacer
        }

        // Even indices are potential event time slots
        final eventIndex = index ~/ 2;
        final event = sortedEvents[eventIndex];

        // Determine if the event belongs in this row (top or bottom)
        final showEvent = isTopRow ? eventIndex % 2 == 0 : eventIndex % 2 == 1;

        return Expanded(
          child: Container(
            // Use Alignment.center to center the text within the Expanded space
            alignment: Alignment.center,
            // Add some vertical padding to prevent text touching icons/lines
            padding: EdgeInsets.symmetric(vertical: isTopRow ? 0 : 4), // Add padding below bottom text
            child: showEvent
                ? Text(
                    _formatTime(event.time),
                    textAlign: TextAlign.center, // Center text horizontally
                    style: const TextStyle(
                      fontSize: 10, // Slightly smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(), // Use SizedBox.shrink() for empty slots
          ),
        );
      }),
    );
  }

  Widget _buildIconsRow(List<Event> sortedEvents) {
    final totalSlots = sortedEvents.isEmpty ? 0 : sortedEvents.length * 2 - 1;

    return SizedBox(
      height: 40, // Fixed height for the icon row
      child: Row(
        // Let Expanded handle the spacing
        children: List.generate(totalSlots, (index) {
          if (index % 2 == 0) {
            // Icon circles (Even indices)
            final eventIndex = index ~/ 2;
            return Expanded( // Wrap icon in Expanded
              child: Align( // Use Align to center the icon
                alignment: Alignment.center,
                child: _buildIconCircle(eventIndex + 1, _getIconForEventType(sortedEvents[eventIndex].type)),
              ),
            );
          } else {
            // Connecting lines (Odd indices)
            return Expanded( // Wrap line in Expanded
              child: Center( // Center the line within the Expanded space
                child: Container(
                  height: 2, // Thinner line
                  color: Colors.black45,
                ),
              ),
            );
          }
        }),
      ),
    );
  }
  // ... existing code for _buildIconCircle, _buildEventDescription, _formatTime, etc. ...

  Widget _buildIconCircle(int number, IconData icon) {
    return Container(
      width: 36, // Slightly smaller icon circle
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.black54, // Slightly transparent black
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Allow badge to overflow slightly if needed
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18, // Slightly smaller icon
          ),
          Positioned(
            bottom: -2, // Adjust position
            right: -2, // Adjust position
            child: Container(
              width: 16, // Smaller badge
              height: 16,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white, width: 1)
                ),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatTime(String time) {
    // Convert to 12-hour format with am/pm
    final parts = time.split(':');
    if (parts.length != 2) return time;

    int hour = int.tryParse(parts[0]) ?? 0;
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour $period'; // Removed space before AM/PM for compactness
  }

  int _convertTimeToMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return hour * 60 + minute;
  }

  IconData _getIconForEventType(String type) {
    switch (type.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'table-tennis':
        return Icons.sports_tennis;
      case 'judo':
        return Icons.sports_kabaddi;
      case 'airport':
        return Icons.flight_land;
      case 'hotel':
        return Icons.hotel;
      case 'food':
        return Icons.restaurant;
      case 'museum':
        return Icons.museum;
      case 'walk':
        return Icons.directions_walk;
      case 'rest':
        return Icons.hotel;
      default:
        return Icons.event;
    }
  }
}