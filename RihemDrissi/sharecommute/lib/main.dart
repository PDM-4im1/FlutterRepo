import 'package:flutter/material.dart';
import '/covoituragePage.dart'; //

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CovoituragePage(),
      ),
    );
  }
}
