import 'package:ai_league_app/constants/app_constants.dart';
import 'package:ai_league_app/screens/panorama_screen.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class TimelineDetails extends StatelessWidget {
  final String title;
  final List<Event> events;
  final Color startColor;
  final Color endColor;

  const TimelineDetails({
    super.key,
    required this.title,
    required this.events,
    this.startColor = const Color(0xFF1AB6A7),
    this.endColor = const Color(0xFF2A4B9B),
  });

  @override
  Widget build(BuildContext context) {
    // Sort events only once
    final sortedEvents = List<Event>.from(events)..sort(
      (a, b) => _convertTimeToMinutes(
        a.time,
      ).compareTo(_convertTimeToMinutes(b.time)),
    );
    return Scaffold(
      backgroundColor:
          AppConstants
              .mainColor, // Consider if this is needed if the body covers everything
      body: SafeArea(
        // Wrap body content in SafeArea
        child: SingleChildScrollView(
          // Allow content to scroll if it overflows
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(
              10,
            ), // Add margin instead of padding if Scaffold bg is visible
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [startColor, endColor],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(
              10,
            ), // Keep padding inside the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Remove MainAxisSize.min - let the Column take space within SingleChildScrollView
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Timeline section
                _buildTimeline(context, sortedEvents),
                ElevatedButton(
                  child: Text('Try Your Seat'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PanoramaScreen(
                          imageUrl: 'assets/images/panorama.jpg',
                          title: 'Stadium Tour',
                        ),
                      ),
                    );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<Event> sortedEvents) {
    // Add some vertical spacing around the timeline
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          // Top row with events (even indices)
          _buildEventRow(sortedEvents, true),
          const SizedBox(height: 8), // Add spacing between rows
          // Timeline with icons
          _buildIconsRow(sortedEvents),
          const SizedBox(height: 8), // Add spacing between rows
          // Bottom row with events (odd indices)
          _buildEventRow(sortedEvents, false),
        ],
      ),
    );
  }

  Widget _buildEventRow(List<Event> sortedEvents, bool isTopRow) {
    final totalSlots = sortedEvents.isEmpty ? 0 : sortedEvents.length * 2 - 1;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Align items vertically in the center
      children: List.generate(totalSlots, (index) {
        // Odd indices are spacers (representing the lines)
        if (index % 2 == 1) {
          return Expanded(child: Container()); // Spacer
        }

        // Even indices are potential event time slots
        final eventIndex = index ~/ 2;
        if (eventIndex >= sortedEvents.length) {
          return Expanded(
            child: Container(),
          ); // Should not happen with correct totalSlots
        }
        final event = sortedEvents[eventIndex];

        // Determine if the event belongs in this row (top or bottom)
        final showEvent = isTopRow ? eventIndex % 2 == 0 : eventIndex % 2 == 1;

        return Container(
          // Use Alignment.center to center the text within the Expanded space
          alignment: Alignment.center,
          // Add some vertical padding to prevent text touching icons/lines
          padding: EdgeInsets.symmetric(vertical: 4), // Consistent padding
          child:
              showEvent
                  ? Column(
                    children: [
                      Text(
                        _formatTime(event.time),
                        textAlign: TextAlign.center, // Center text horizontally
                        style: const TextStyle(
                          fontSize: 10, // Slightly smaller font
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      _buildEventDescription(event),
                    ],
                  )
                  : const SizedBox.shrink(), // Use SizedBox.shrink() for empty slots
        );
      }),
    );
  }

  Widget _buildIconsRow(List<Event> sortedEvents) {
    final totalSlots = sortedEvents.isEmpty ? 0 : sortedEvents.length * 2 - 1;

    return SizedBox(
      height: 40, // Fixed height for the icon row
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Ensure vertical alignment
        children: List.generate(totalSlots, (index) {
          if (index % 2 == 0) {
            // Icon circles (Even indices)
            final eventIndex = index ~/ 2;
            if (eventIndex >= sortedEvents.length) {
              return Expanded(child: Container()); // Should not happen
            }
            return Expanded(
              // Wrap icon in Expanded
              child: Align(
                // Use Align to center the icon
                alignment: Alignment.center,
                child: _buildIconCircle(
                  eventIndex + 1,
                  _getIconForEventType(sortedEvents[eventIndex].type),
                ),
              ),
            );
          } else {
            // Connecting lines (Odd indices)
            return Expanded(
              // Wrap line in Expanded
              child: Center(
                // Center the line within the Expanded space
                child: Container(
                  height: 2, // Thinner line
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2.0,
                  ), // Add small horizontal margin to lines
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
                  const BorderSide(color: Colors.white, width: 1),
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

  Widget _buildEventDescription(Event event) {
    // This widget seems unused in the provided code structure for the timeline rows
    // If you intend to use it elsewhere, it's fine as is.
    // If it was meant to be part of the timeline display, it needs integration.
    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            event.activity,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.location,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 8,
            ),
          ),
          const SizedBox(),
          Text(
            event.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 8),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
    final minute = parts[1]; // Keep minute for potential future use
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    // Pad minute with leading zero if necessary
    final formattedMinute = minute.padLeft(2, '0');

    return '$hour:$formattedMinute$period'; // Re-added minute and removed space
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
