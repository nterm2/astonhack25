import 'package:flutter/material.dart';
import 'package:drink_less/global.dart'; // Import the global variable

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF388E3C), // Lighter dark green background
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements apart
        children: [
          // Left: Profile picture with name
          GestureDetector(
            onTap: () {
              _showProfileDialog(context);
            },
            child: Row(
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

  void _showProfileDialog(BuildContext context) {
    final TextEditingController targetController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController messageController = TextEditingController(text: globalMessage);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF006400), // Dark green border around the modal
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Profile Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                // Target Value Field
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target (0-100)',
                    hintText: 'Higher is more sober',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF388E3C), // Light green border on focus
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF006400), // Dark green border when not focused
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Time Notification Field
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: 'Notification Time',
                    hintText: 'e.g., 6pm-12pm',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF388E3C), // Light green border on focus
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF006400), // Dark green border when not focused
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Motivational Message Field
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Motivational Message',
                    hintText: 'Why do you want to quit?',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF388E3C), // Light green border on focus
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF006400), // Dark green border when not focused
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF388E3C)), // Light green text
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        // Save inputs or pass them to a parent/state
                        globalMessage = messageController.text.isEmpty
                            ? globalMessage
                            : messageController.text;

                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Color(0xFF388E3C)), // Light green text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}




