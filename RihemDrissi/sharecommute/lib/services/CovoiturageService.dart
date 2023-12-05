import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/covoiturageModel.dart';

class CovoiturageService {
  Future<List<Covoiturage>> show() async {
    final response = await http.get(
      Uri.parse("http://localhost:9090/moyenDeTransport/findAllCovoiturages"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse.map((data) => Covoiturage.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load covoiturages');
    }
  }

  Future<Covoiturage> editCovoiturage(Covoiturage updatedCovoiturage) async {
    final response = await http.put(
      Uri.parse(
          "http://localhost:9090/covoiturage/edit/${updatedCovoiturage.idCovoiturage}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedCovoiturage.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      return Covoiturage.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to edit covoiturage');
    }
  }

  Future<void> deleteOnce(String covoiturageId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:9090/covoiturage/delete/${covoiturageId}'),
      body: {'groupId': covoiturageId},
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'message' key
    } else {
      throw Exception(
          'Failed to delete covoiturage. Status code: ${response.statusCode}');
    }
  }
}
