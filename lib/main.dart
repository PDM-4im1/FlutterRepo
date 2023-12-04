import 'package:flutter/material.dart';
import '../CovoituragePage.dart'; // Update with the correct path

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CovoituragePage(),
    );
  }
}
