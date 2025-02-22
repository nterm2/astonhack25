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
          // Left text
          const Text(
            '© 2025 Grow Sober',
            style: TextStyle(
              color: Colors.white, // White text
              fontSize: 14,
            ),
          ),
          // Right options or links
          Row(
            children: [
              TextButton(
                onPressed: () {
                  // Handle "About Us" action
                },
                child: const Text(
                  'About Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 16), // Spacing between links
              TextButton(
                onPressed: () {
                  // Handle "Contact" action
                },
                child: const Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

