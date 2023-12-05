import 'package:flutter/material.dart';
import '../models/covoiturageModel.dart';
import '../services/covoiturageService.dart';

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

  Future<void> _editCovoiturage(Covoiturage covoiturage) async {
    // Create a TextEditingController for each field
    TextEditingController departController =
        TextEditingController(text: covoiturage.pointDepart);
    TextEditingController arriveeController =
        TextEditingController(text: covoiturage.pointArrivee);
    TextEditingController tarifController =
        TextEditingController(text: covoiturage.tarif.toString());

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Covoiturage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: departController,
                    decoration: InputDecoration(labelText: 'Departure'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: arriveeController,
                    decoration: InputDecoration(labelText: 'Arrival'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: tarifController,
                    decoration: InputDecoration(labelText: 'Tarif'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Create an updated Covoiturage object
                          Covoiturage updatedCovoiturage = Covoiturage(
                            idCovoiturage: covoiturage.idCovoiturage,
                            pointDepart: departController.text,
                            pointArrivee: arriveeController.text,
                            tarif: int.parse(tarifController.text),
                          );

                          // Call the editCovoiturage function
                          await _covoiturageService
                              .editCovoiturage(updatedCovoiturage);

                          // Refresh the data after editing
                          setState(() {
                            _covoiturages = _covoiturageService.show();
                          });

                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteCovoiturage(String covoiturageId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Covoiturage'),
          content: Text('Are you sure you want to delete this covoiturage?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User did not confirm
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _covoiturageService.deleteOnce(covoiturageId);
        // Refresh the data after deleting
        setState(() {
          _covoiturages = _covoiturageService.show();
        });
        print('Covoiturage with ID $covoiturageId deleted successfully.');
      } catch (e) {
        print('Error deleting covoiturage: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Admin Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      Text(
                        'Covoiturages',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(),
                    body: FutureBuilder<List<Covoiturage>>(
                      future: _covoiturages,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No covoiturages available.'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Covoiturage covoiturage = snapshot.data![index];

                              return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    '${covoiturage.pointDepart} - ${covoiturage.pointArrivee}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('Tarif: ${covoiturage.tarif}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteCovoiturage(
                                              covoiturage.idCovoiturage);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.update),
                                        onPressed: () {
                                          _editCovoiturage(covoiturage);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
