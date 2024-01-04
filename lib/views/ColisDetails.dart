import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/colis.dart';
import '../services/colis_service.dart';
import 'colis_list.dart'; 
import '../services/colis_provider.dart';

class ColisDetails extends StatefulWidget {
  final Colis colis;

  ColisDetails(this.colis);

  @override
  _ColisDetailsState createState() => _ColisDetailsState();
}

class _ColisDetailsState extends State<ColisDetails> {
  late String selectedEtat = '';
  late ColisService colisService;
  @override
  void initState() {
    super.initState();
    selectedEtat = widget.colis.etat ?? '';
    colisService = Provider.of<ColisService>(context, listen: false);
  }

  Future<void> _changeEtat(String newEtat) async {
    try {
      await colisService.changeEtatColis(widget.colis.id, newEtat);
     setState(() {
        selectedEtat = newEtat; // Update the selectedEtat value
      });
    } catch (e) {
      print('Error changing etat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDetailRow('Receiver Name', widget.colis.receiverName ?? ''),
                buildDetailRow('Receiver Phone', widget.colis.receiverPhone ?? ''),
                buildDetailRow('Address', widget.colis.adresse ?? ''),
                buildDetailRow('Destination', widget.colis.destination ?? ''),
                buildDetailRow('Description', widget.colis.description ?? ''),
                buildDetailRow('Height', widget.colis.height.toString()),
                buildDetailRow('Width', widget.colis.width.toString()),
                buildDetailRow('Weight', widget.colis.weight.toString()),
                SizedBox(height: 16),
                Text(
                  'Etat:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
  value: selectedEtat,
  items: [
    DropdownMenuItem<String>(
      value: 'non Livree',
      child: Text('Non Livree'),
    ),
    DropdownMenuItem<String>(
      value: 'en route',
      child: Text('En route'),
    ),
    DropdownMenuItem<String>(
      value: 'Livree',
      child: Text('Livree'),
    ),
  ],
  onChanged: (newValue) {
    setState(() {
      selectedEtat = newValue!;
      _changeEtat(newValue);
    });
  },
),

              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to ColisList view when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ColisList()), // Replace 'ColisList' with your actual ColisList view
            );
          },
          child: Text('Back to List'),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
