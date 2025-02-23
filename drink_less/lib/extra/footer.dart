import 'package:flutter/material.dart';

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
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Profile Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Target Value Field
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target (0-100)',
                    hintText: 'Higher is more sober',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                // Time Notification Field
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: 'Notification Time',
                    hintText: 'e.g., 6pm-12pm',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save inputs or pass them to a parent/state
                String target = targetController.text;
                String time = timeController.text;
                String message = messageController.text;

                // Perform your saving logic here
                print('Target: $target');
                print('Time: $time');
                print('Message: $message');

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}


