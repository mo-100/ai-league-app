import 'package:ai_league_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final Widget child;
  final bool disabled;
  const StyledButton({
    super.key,
    required this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
            gradient: !disabled ? LinearGradient(
              colors: [Color(0xFF2ABDA0), Color(0xFF2A77BD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ) : null,
            color: disabled ? AppConstants.matchColor : null,
            borderRadius: BorderRadius.all(
              Radius.circular(25)
            ),
          ),
      child: child,
    );
  }
}