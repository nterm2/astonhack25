import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF388E3C), // Lighter dark green
      elevation: 2, // Subtle shadow
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
        mainAxisSize: MainAxisSize.min, // Shrink to fit content
        children: [
          Container(
            width: 40, // Adjust size of the circle
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white, // White background
              shape: BoxShape.circle, // Circular shape
              border: Border.all(
                color: const Color(0xFF006400), // Dark green outline
                width: 2, // Outline thickness
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Optional padding inside the circle
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8), // Space between logo and text
          const Text(
            'Grow Sober',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text
            ),
          ),
        ],
      ),
      centerTitle: true, // Centers the Row in the AppBar
    );
  }

  // Implement preferredSize for AppBar height
  @override
  Size get preferredSize => const Size.fromHeight(56.0); // Default AppBar height
}
