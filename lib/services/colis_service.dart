import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/colis.dart';

class ColisService {
  Future<List<Colis>> fetchColis() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:9090/colis/get'));

      // Add additional logging here
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Colis> colisList = data.map((item) => Colis.fromJson(item)).toList();
        return colisList;
      } else {
        throw Exception('Failed to load colis - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load colis - Error: $e');
    }
  }
  Future<Colis> updateColis(Colis colis) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:9090/colis/${colis.id}'), // Replace 'id' with your Colis ID field
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(colis.toJson()), // Assuming toJson() is defined in your Colis model
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> updatedData = json.decode(response.body);
        return Colis.fromJson(updatedData);
      } else {
        throw Exception('Failed to update colis - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating colis: $e');
      throw Exception('Failed to update colis - Error: $e');
    }
  }

  Future<void> deleteColis(int? id) async {
  try {
    if (id == null) {
      throw Exception('ID is null');
    }

    final response = await http.delete(
      Uri.parse('http://localhost:9090/colis/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Colis deleted successfully');
    } else {
      throw Exception('Failed to delete colis - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting colis: $e');
    throw Exception('Failed to delete colis - Error: $e');
  }
}

   Future<Colis> postColis(Colis newColis) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:9090/colis'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newColis.toJson()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return Colis.fromJson(responseData);
      } else {
        throw Exception('Failed to create colis - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating colis: $e');
      throw Exception('Failed to create colis - Error: $e');
    }
  }
  Future<void> changeEtatColis(int? id, String etat) async {
  try {
    if (id == null) {
      throw Exception('ID is null');
    }

    final response = await http.post(
      Uri.parse('http://localhost:9090/colis/changeEtatColis'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id, 'etat': etat}),
    );

    if (response.statusCode == 200) {
      print('Colis etat changed successfully');
      
    } else {
      throw Exception('Failed to change colis etat - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error changing colis etat: $e');
    throw Exception('Failed to change colis etat - Error: $e');
  }
}
 Future<List<Colis>> findUnassignedColis() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:9090/colis/getunassigned'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Colis> unassignedColisList = data.map((item) => Colis.fromJson(item)).toList();
        return unassignedColisList;
      } else {
        throw Exception('Failed to load unassigned colis - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unassigned colis: $e');
      throw Exception('Failed to load unassigned colis - Error: $e');
    }
  }
  Future<void> assignerLivreur(int id, int idLivreur) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:9090/colis/assign'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id, 'idLivreur': idLivreur}),
    );

    if (response.statusCode == 200) {
      print('Livreur assigned successfully');
    } else {
      throw Exception('Failed to assign livreur - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error assigning livreur: $e');
    throw Exception('Failed to assign livreur - Error: $e');
  }
}
Future<List<Colis>> getColisByLivreur(int idLivreur) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:9090/colis/getColisByLivreur'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'idLivreur': idLivreur}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Colis> colisList = data.map((item) => Colis.fromJson(item)).toList();
      return colisList;
    } else {
      throw Exception('Failed to load colis by livreur - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching colis by livreur: $e');
    throw Exception('Failed to load colis by livreur - Error: $e');
  }
}

}


