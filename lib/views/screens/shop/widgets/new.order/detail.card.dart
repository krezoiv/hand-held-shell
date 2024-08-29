import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final bool isEnabled;

  const DetailsCard({
    super.key,
    required this.icon,
    required this.label,
    this.iconSize = 64.0,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Card(
        elevation: isEnabled ? 4.0 : 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: isEnabled ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
