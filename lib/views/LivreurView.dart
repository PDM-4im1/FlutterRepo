import 'package:flutter/material.dart';
import '../model/colis.dart';
import '../services/colis_service.dart';
import '../views/unassignedView.dart';
import '../views/colis_list.dart';
import '../services/colis_provider.dart';


class LivreurView extends StatefulWidget {
  @override
  _LivreurViewState createState() => _LivreurViewState();
}




class _LivreurViewState extends State<LivreurView> {
  late Future<List<Colis>> futureColisByLivreur;
  final ColisProvider colisProvider = ColisProvider();
  TextEditingController idLivreurController = TextEditingController();
  int _selectedIndex = 2; // Set Livreur as default

  @override
  void initState() {
    super.initState();
    futureColisByLivreur = Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel Assigned to Livreur'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ToggleButtons(
              children: [
                Text('Colis'),
                Text('Unassigned'),
                Text('Livreur'),
              ],
              isSelected: [
                _selectedIndex == 0,
                _selectedIndex == 1,
                _selectedIndex == 2,
              ],
              onPressed: (int newIndex) {
                setState(() {
                  _selectedIndex = newIndex;
                });
                _onSegmentTapped(newIndex);
              },
              selectedColor: Colors.blue,
              color: Colors.black,
              fillColor: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child:  _selectedIndex == 1 ? UnassignedView() : _buildLivreurAssignedColis(),
          ),
        ],
      ),
    );
  }

  /*Widget _buildColisList() {
    // Your code to build Colis list
  }*/

  Widget _buildLivreurAssignedColis() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: idLivreurController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Livreur ID',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (idLivreurController.text.isNotEmpty) {
                setState(() {
                  futureColisByLivreur =
                      colisProvider.getColisByLivreur(int.parse(idLivreurController.text));
                });
              }
            },
            child: Text('Fetch Colis'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Colis>>(
              future: futureColisByLivreur,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No colis found for this livreur'));
                  } else {
                     return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final colis = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              colis.receiverName ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Destination: ${colis.destination ?? ''}',
                                ),
                                Text(
                                  'Adresse: ${colis.adresse ?? ''}',
                                ),
                              ],
                            ),
                            // Add more details if needed
                          ),
                        );
                      },
                    );
                  }
                // Your existing FutureBuilder code
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSegmentTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ColisList()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnassignedView()),
        );
        break;
      case 2:
        // Handle Livreur segment, no action needed as it's already in LivreurView
        break;
    }
  }

  @override
  void dispose() {
    idLivreurController.dispose();
    super.dispose();
  }
}


