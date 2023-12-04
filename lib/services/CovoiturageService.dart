import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/covoiturageModel.dart';

class CovoiturageService {
  Future<List<Covoiturage>> show() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/covoiturage/'),
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'communities' key
      if (jsonResponse['covoiturages'] != null) {
        final List<dynamic> covoiturageList = jsonResponse['covoiturages'];
        return covoiturageList
            .map((data) => Covoiturage.fromJson(data))
            .toList();
      } else {
        throw Exception('No "covoiturages" key found in the response.');
      }
    } else {
      throw Exception('Failed to load communities');
    }
  }

  /*Future<void> deleteOnce(int covoiturageId) async {
    final response = await http.post(
      Uri.parse('http://localhost:9090/covoiturage/delete/:id'),
      body: {'groupId': covoiturageId.toString()},
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'message' key
      if (jsonResponse['message'] == 'covoiturage deleted') {
        print('Covoiturage with ID $covoiturageId deleted successfully.');
      } else {
        throw Exception(
            'Failed to delete covoiturage. Server response: $jsonResponse');
      }
    } else {
      throw Exception(
          'Failed to delete covoiturage. Status code: ${response.statusCode}');
    }
  }*/
}
