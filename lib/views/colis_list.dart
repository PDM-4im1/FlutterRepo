import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/colis.dart';
import '../services/colis_service.dart';
import 'package:flutter/services.dart';
import '../views/ColisDetails.dart';
import '../views/unassignedView.dart';
import '../views/LivreurView.dart';
import '../services/colis_provider.dart';




import 'package:http/http.dart' as http;


class ColisList extends StatefulWidget {
  @override
  _ColisListState createState() => _ColisListState();
}

class _ColisListState extends State<ColisList> {
  
  final ColisService colisService = ColisService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    var colisProvider = Provider.of<ColisProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel List'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Colis>>(
                future: colisProvider.fetchColis(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(
                              'Receiver Name: ${snapshot.data![index].receiverName}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Receiver Phone: ${snapshot.data![index].receiverPhone}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showDestinationPopup(snapshot.data![index]);
                                  },
                                 color: Colors.green,
                                  
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteColis(snapshot.data![index]);
                                  },
                                  color: Colors.red,
                                  
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ColisDetails(snapshot.data![index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
             ElevatedButton(
              onPressed: () {
                _showAddColisPopup();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Text('Add New Parcel'),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ),
            ),


          ],
        ),
      ),
    );
  }
  void _onSegmentTapped(int index) {
    switch (index) {
      case 0:
        // Handle Colis segment
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnassignedView()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LivreurView()),
        );
        break;
    }
  }

  /////here
  //////here
  ///

void _showDestinationPopup(Colis colis) {
  TextEditingController destinationController = TextEditingController(text: colis.destination);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modify Destination'),
        content: TextField(
          controller: destinationController,
          decoration: InputDecoration(hintText: 'Enter new destination'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String newDestination = destinationController.text;
              Colis updatedColis = Colis(
                id:colis.id,
                adresse: colis.adresse,
                destination: newDestination,
                description: colis.description,
                height: colis.height,
                width: colis.width,
                weight: colis.weight,
                receiverName: colis.receiverName,
                receiverPhone: colis.receiverPhone,
                etat:colis.etat,
                idLivreur:colis.idLivreur,
              );
              try {
                Colis updatedData = await colisService.updateColis(updatedColis);
                setState(() {
                 //  futureColis = colisService.fetchColis();
                 });
                // Optionally, you can do something with the updatedData
                Navigator.of(context).pop();
              } catch (e) {
                // Handle error
                print('Error: $e');
              }
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}
 Widget _buildSegmentWidget(int segmentIndex) {
    switch (segmentIndex) {
      case 0:
        return Container(); // Your Colis content here
      case 1:
        return UnassignedView(); // Your UnassignedView implementation here
      case 2:
        return LivreurView(); // Your LivreurView implementation here
      default:
        return Container();
    }
  }
 Future<void> _deleteColis(Colis colis) async {
    try {
      // Call the deleteColis method from the service to delete the colis
      await colisService.deleteColis(colis.id!); // Replace 'id' with the actual identifier to delete the colis
      // Refresh the UI or handle any other necessary updates after deletion
      setState(() {
      //  futureColis = colisService.fetchColis();
      });
    } catch (e) {
      // Handle error
      print('Error deleting colis: $e');
    }
  }
  void _showAddColisPopup() {
    TextEditingController receiverNameController = TextEditingController();
    TextEditingController receiverPhoneController = TextEditingController();
    TextEditingController adresseController = TextEditingController();
    TextEditingController destinationController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    TextEditingController widthController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Parcel'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: receiverNameController,
                  decoration: InputDecoration(labelText: 'Receiver Name'),
                 inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                ),
                TextField(
                  controller: receiverPhoneController,
                decoration: InputDecoration(labelText: 'Receiver Phone'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(8),
                ],
                ),
                TextField(
                  controller: adresseController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: destinationController,
                  decoration: InputDecoration(labelText: 'Destination'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: 'Height'),
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                ),
                TextField(
                  controller: widthController,
                  decoration: InputDecoration(labelText: 'Width'),
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                ),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
             TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                String receiverName = receiverNameController.text;
                String receiverPhone = receiverPhoneController.text;
                String adresse = adresseController.text;
                String destination = destinationController.text;
                String description = descriptionController.text;
                int height = int.parse(heightController.text);
                int width = int.parse(widthController.text);
                int weight = int.parse(weightController.text);

                Colis newColis = Colis(
                  receiverName: receiverName,
                  receiverPhone: receiverPhone,
                  adresse: adresse,
                  destination: destination,
                  description: description,
                  height: height,
                  width: width,
                  weight: weight,
                );

                try {
                  Colis createdColis = await colisService.postColis(newColis);
                  print('dddd');
                  setState(() {
               //    futureColis = colisService.fetchColis();
                 });
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  // Handle error
                      if (e is http.Response) {
                print('Error creating colis: HTTP Status Code: ${e.statusCode}');
               print('Response body: ${e.body}');
  } else {
    print('Error creating colis: $e');
  }
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

}

class ModifyColisScreen extends StatelessWidget {
  final Colis colis;

  ModifyColisScreen({required this.colis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Parcel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Receiver Name: ${colis.receiverName}'),
            Text('Receiver Phone: ${colis.receiverPhone}'),
            // Add fields to modify the colis attributes
          ],
        ),
      ),
    );
  }
}









