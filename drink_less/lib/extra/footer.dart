import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF388E3C), // Lighter dark green background
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements apart
        children: [
          // Left: Profile picture with name
          Row(
            children: [
              Container(
                width: 40, // Size of the circle
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  shape: BoxShape.circle, // Circular shape
                  border: Border.all(
                    color: const Color(0xFF006400), // Dark green outline
                    width: 2, // Outline thickness
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/pfp/pfp.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8), // Space between the profile picture and the name
              const Text(
                'Jonathan',
                style: TextStyle(
                  color: Colors.white, // White text
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Right: Copyright text
          const Text(
            '© 2025 Grow Sober',
            style: TextStyle(
              color: Colors.white, // White text
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}


