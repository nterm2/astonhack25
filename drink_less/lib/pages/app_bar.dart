import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AppBar Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My AppBar'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('Search icon pressed');
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                print('Notifications icon pressed');
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Welcome to my app!'),
        ),
      ),
    );
  }
}
