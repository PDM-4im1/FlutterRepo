import 'package:http/http.dart' as http;
import '/Models/Car_Model.dart';
import 'dart:convert';

class CarService {
  static Future<List<Car>> fetchCars() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/moyenDeTransport/findAllMoyenDeTransport'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Car.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<void> editCar(Car car) async {
    final response = await http.put(
      Uri.parse('http://localhost:9090/moyenDeTransport/editMoyenDeTransport/${car.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'marque': car.marque,
        'type': car.type,
        'matricule': car.matricule,
      }),
    );

    if (response.statusCode != 200) {
      print(car.marque);
      print(car.type);
      print(car.matricule);
      throw Exception('Failed to edit car');
    }
  }

  static Future<void> deleteCar(String carId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:9090/moyenDeTransport/deleteMoyenDeTransport/$carId'),
      );

      if (response.statusCode != 200) {
        print('Failed to delete car. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete car');
      }
    } catch (e) {
      print('Error in deleteCar: $e');
      throw Exception('Failed to delete car');
    }
  }

  static Future<void> addCar(Car car) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:9090/moyenDeTransport/saveMoyenDeTransport'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'marque': car.marque,
          'type': car.type,
          'matricule': car.matricule,
        }),
      );

      if (response.statusCode != 201) {
        print('Failed to add car. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add car');
      }
    } catch (e) {
      print('Error in addCar: $e');
      throw Exception('Failed to add car');
    }
  }
}
