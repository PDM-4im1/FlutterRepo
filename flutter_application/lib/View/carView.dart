import 'package:flutter/material.dart';
import '/Models/CarModel.dart';
import '/Services/CarService.dart';

class CarTableView extends StatefulWidget {
  @override
  _CarTableViewState createState() => _CarTableViewState();
}

class _CarTableViewState extends State<CarTableView> {
  List<Car> cars = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  double _rowHeight = 50.0; // Adjust this value based on the actual row height

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final List<Car> fetchedCars = await CarService.fetchCars();
      setState(() {
        cars = fetchedCars;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showEditDialog(Car car) async {
    TextEditingController marqueController =
        TextEditingController(text: car.marque);
    TextEditingController typeController =
        TextEditingController(text: car.type);
    TextEditingController matriculeController =
        TextEditingController(text: car.matricule);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Car'),
          content: Column(
            children: [
              TextFormField(
                controller: marqueController,
                decoration: InputDecoration(labelText: 'Marque'),
              ),
              TextFormField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: matriculeController,
                decoration: InputDecoration(labelText: 'Matricule'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                car.marque = marqueController.text;
                car.type = typeController.text;
                car.matricule = matriculeController.text;
                try {
                  Navigator.pop(context);
                  await CarService.editCar(car);
                  setState(() {
                    isLoading = true;
                  });
                  fetchData();
                  _scrollToEditedItem(car);
                } catch (e) {
                  print('Error editing car: $e');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToEditedItem(Car car) {
    int index = cars.indexOf(car);
    _scrollController.animateTo(
      index * _rowHeight,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> showAddDialog() async {
    TextEditingController marqueController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController matriculeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Car'),
          content: Column(
            children: [
              TextFormField(
                controller: marqueController,
                decoration: InputDecoration(labelText: 'Marque'),
              ),
              TextFormField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: matriculeController,
                decoration: InputDecoration(labelText: 'Matricule'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Car newCar = Car(
                  id: '', // Assigning an empty string as the ID for a new car
                  marque: marqueController.text,
                  type: typeController.text,
                  matricule: matriculeController.text,
                );

                try {
                  await CarService.addCar(newCar);
                  Navigator.pop(context);
                  fetchData();
                  _scrollToEditedItem(newCar);
                } catch (e) {
                  print('Error adding car: $e');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteConfirmationDialog(Car car) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Car'),
          content: Text('Are you sure you want to delete this car?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await CarService.deleteCar(car.id);
                fetchData();
                Navigator.pop(context); // Close the confirmation dialog
              },
              child: Text('Delete'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
                        'Car Table View',
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
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Marque')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Matricule')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: cars
                                .map(
                                  (car) => DataRow(
                                    cells: [
                                      DataCell(Text(car.marque)),
                                      DataCell(Text(car.type)),
                                      DataCell(Text(car.matricule)),
                                      DataCell(
                                        Row(
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                await showEditDialog(car);
                                              },
                                              icon: Icon(Icons.edit),
                                              label: Text('Edit'),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.blue),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                await showDeleteConfirmationDialog(
                                                    car);
                                              },
                                              icon: Icon(Icons.delete),
                                              label: Text('Delete'),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
                SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    showAddDialog();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Car'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
