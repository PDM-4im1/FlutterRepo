import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminService {
  Future<http.Response> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:9090/signinadmin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return response; // Return the response for further handling
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
