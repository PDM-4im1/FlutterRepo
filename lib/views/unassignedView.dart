import 'package:flutter/material.dart';
import '../model/colis.dart';
import '../services/colis_service.dart';
import '../views/LivreurView.dart';
import '../views/colis_list.dart';
import 'package:provider/provider.dart';
import '../services/colis_provider.dart';


class UnassignedView extends StatefulWidget {
  @override
  _UnassignedViewState createState() => _UnassignedViewState();
}




class _UnassignedViewState extends State<UnassignedView> {
  late Future<List<Colis>> futureUnassignedColis;
   late ColisProvider colisProvider;
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    colisProvider = Provider.of<ColisProvider>(context, listen: false);
     futureUnassignedColis = colisProvider.findUnassignedColis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unassigned Parcel'),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: _selectedIndex == 1 ? _buildUnassignedColisList() : LivreurView(),
          ),
        ],
      ),
    );
  }

  Widget _buildUnassignedColisList() {
    return FutureBuilder<List<Colis>>(
      future: futureUnassignedColis,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No unassigned colis found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final colis = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(colis.receiverName ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(colis.destination ?? ''),
                        Text(colis.adresse ?? ''),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        assignLivreurToColis(colis.id!,); // Call function to assign livreur
                      },
                      child: Text('Assign Livreur'),
                    ),
                  ),
                );
              },
            );
          }
        // ... Your existing FutureBuilder code
      },
    );
  }

  void _onSegmentTapped(int index) {
    switch (index) {
      case 0:
        // Handle Colis segment
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ColisList()),
        );
        break;
        break;
      case 1:
        
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LivreurView()),
        );
        break;
    }

    // Handle the toggle actions between Unassigned and Livreur views if needed
    // Implement logic here to switch between segments if necessary
  }

  // Function to assign a livreur to a colis
  void assignLivreurToColis(int colisId) async {
     try {
      // Replace 123 with the livreur ID you want to assign
      await colisProvider.assignerLivreur(colisId, 123);

      // Refresh the colis list after assigning livreur
      setState(() {
        futureUnassignedColis = colisProvider.findUnassignedColis();
      });
      
      // Show a success message or handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livreur assigned to colis')),
      );
    } catch (e) {
      // Handle error
      print('Error assigning livreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign livreur')),
      );
    }
    // Your existing assignLivreurToColis method remains unchanged
  }
}

