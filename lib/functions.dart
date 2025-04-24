import 'package:ai_league_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

void pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: CustomAppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              body: screen,
            ),
      ),
    );
  }