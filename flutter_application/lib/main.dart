import 'package:flutter/material.dart';
import 'package:flutter_application/Services/AdminService.dart';
import 'package:flutter_application/View/AdminAuth.dart';
import 'package:flutter_application/View/SideNavigation.dart';
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
      home: AdminLoginPage(
          adminService: AdminService()), // Provide an instance of AdminService
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigation(),
          Expanded(
            child: CarTableView(),
          ),
        ],
      ),
    );
  }
}
