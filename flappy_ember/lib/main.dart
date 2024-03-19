import 'package:flutter/material.dart';
import 'layout_connection.dart'; // Import the connection screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Ember',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConnectionScreen(),
      debugShowCheckedModeBanner: false
    );
  }
}