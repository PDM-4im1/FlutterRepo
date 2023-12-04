import 'package:flutter/material.dart';
import '../models/covoiturageModel.dart'; // Update with your actual import path
import '../services/covoiturageService.dart'; // Update with your actual import path

class CovoituragePage extends StatefulWidget {
  @override
  _CovoituragePageState createState() => _CovoituragePageState();
}

class _CovoituragePageState extends State<CovoituragePage> {
  final CovoiturageService _covoiturageService = CovoiturageService();
  late Future<List<Covoiturage>> _covoiturages;

  @override
  void initState() {
    super.initState();
    _covoiturages = _covoiturageService.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covoiturages'),
      ),
      body: FutureBuilder<List<Covoiturage>>(
        future: _covoiturages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No covoiturages available.'),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Depart')),
                  DataColumn(label: Text('Arrivee')),
                  DataColumn(label: Text('Date')),
                  // DataColumn(label: Text('Tarif')),
                ],
                rows: snapshot.data!
                    .map((covoiturage) => DataRow(
                          cells: [
                            DataCell(Text(covoiturage.pointDepart)),
                            DataCell(Text(covoiturage.pointArrivee)),
                            DataCell(Text(covoiturage.date)),
                            //   DataCell(Text('${covoiturage.tarif}')),
                          ],
                        ))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
