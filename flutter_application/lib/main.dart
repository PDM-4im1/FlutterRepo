import 'package:flutter/material.dart';
import 'View/carView.dart'; // Assuming you named the file as car_table_view.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CarTableView(),
      ),
    );
  }
}
