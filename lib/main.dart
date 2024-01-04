import 'package:flutter/material.dart';
import './views/colis_list.dart';
import './services/colis_provider.dart';
import './services/colis_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColisProvider()), // Provide ColisProvider
        Provider(create: (_) => ColisService()), // Provide ColisService
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colis List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ColisList(),
    );
  }
}
