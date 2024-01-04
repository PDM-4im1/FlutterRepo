import 'package:flutter/material.dart';
import 'package:flutter_application/Services/AdminService.dart';
import 'package:flutter_application/main.dart';

class AdminLoginPage extends StatefulWidget {
  final AdminService adminService;

  AdminLoginPage({required this.adminService});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> signIn() async {
    try {
      final response = await widget.adminService.signIn(
        emailController.text,
        passwordController.text,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // If login is successful, navigate to the main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else if (response.statusCode == 401) {
        // Invalid password
        _showLoginFailedAlert('Invalid password');
      } else if (response.statusCode == 404) {
        // User not found
        _showLoginFailedAlert('User not found');
      } else if (response.statusCode == 403) {
        // Access forbidden for non-admin users
        _showLoginFailedAlert('Access forbidden. Admins only.');
      } else {
        // Handle other error cases
        _showLoginFailedAlert('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
      _showLoginFailedAlert('Error: $e');
    }
  }

// Function to show an alert for failed login with a custom message
  void _showLoginFailedAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
