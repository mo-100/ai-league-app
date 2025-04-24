import 'package:ai_league_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';


class PanoramaScreen extends StatefulWidget {
  final String imageUrl;
  final String title;

  const PanoramaScreen({
    super.key,
    required this.imageUrl,
    this.title = 'Try your seat',
  });

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: Stack(
        children: [
          // Panorama view
          PanoramaViewer(
            onViewChanged: (longitude, latitude, zoom) {
              setState(() {
              });
            },
            minZoom: 0.5,
            maxZoom: 2.0,
            sensitivity: 1.0,
            animSpeed: 0.5,
            child: Image.asset(widget.imageUrl),
          ),
          ],
      ),
    );
  }
}