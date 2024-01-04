import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/CarProvider.dart';
import '../View/carView.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarTableView(),
    );
  }
}
