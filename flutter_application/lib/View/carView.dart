import 'package:flutter/material.dart';
import 'package:flutter_application/Models/UserModel.dart';
import 'package:provider/provider.dart';
import '../Models/Car_Model.dart';
import '../Models/CarProvider.dart';

class CarTableView extends StatefulWidget {
  @override
  _CarTableViewState createState() => _CarTableViewState();
}

class _CarTableViewState extends State<CarTableView> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<CarProvider>(context, listen: false).fetchDrivers();
      Provider.of<CarProvider>(context, listen: false).fetchCars();
    });
  }

  final ScrollController _scrollController = ScrollController();
  double _rowHeight = 50.0;

  void _scrollToEditedItem(Car car) {
    int index =
        Provider.of<CarProvider>(context, listen: false).cars.indexOf(car);
    _scrollController.animateTo(
      index * _rowHeight,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> showEditDialog(Car car) async {
    TextEditingController marqueController =
        TextEditingController(text: car.marque);
    TextEditingController typeController =
        TextEditingController(text: car.type);
    TextEditingController matriculeController =
        TextEditingController(text: car.matricule);

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Car'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: marqueController,
                  decoration: InputDecoration(
                    labelText: 'Marque',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter Marque';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter Type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: matriculeController,
                  decoration: InputDecoration(
                    labelText: 'Matricule',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter Matricule';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
                if (formKey.currentState?.validate() ?? false) {
                  car.marque = marqueController.text;
                  car.type = typeController.text;
                  car.matricule = matriculeController.text;

                  Navigator.pop(context); // Close the edit dialog

                  try {
                    await Provider.of<CarProvider>(context, listen: false)
                        .editCar(car);
                    _scrollToEditedItem(car);
                  } catch (e) {
                    print('Error editing car: $e');
                  } finally {}
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAddDialog() async {
    TextEditingController marqueController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController matriculeController = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Car'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: marqueController,
                  decoration: InputDecoration(labelText: 'Marque'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter Marque';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'Type'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter Type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: matriculeController,
                  decoration: InputDecoration(labelText: 'Matricule'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter Matricule';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
                if (formKey.currentState?.validate() ?? false) {
                  Car newCar = Car(
                    id: '',
                    marque: marqueController.text,
                    type: typeController.text,
                    matricule: matriculeController.text,
                  );

                  Navigator.pop(context); // Close the add dialog

                  try {
                    await Provider.of<CarProvider>(context, listen: false)
                        .addCar(newCar);
                    _scrollToEditedItem(newCar);
                  } catch (e) {
                    print('Error adding car: $e');
                  } finally {
                    Navigator.pop(context); // Close the loading dialog
                  }
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
                Navigator.pop(context); // Close the delete confirmation dialog

                try {
                  await Provider.of<CarProvider>(context, listen: false)
                      .deleteCar(car.id);
                } catch (e) {
                  print('Error deleting car: $e');
                } finally {}
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

  Future<void> showAssignDriverDialog(List<Users> drivers) async {
    BuildContext dialogContext;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          title: Text('Assign Driver'),
          content: SingleChildScrollView(
            child: Column(
              children: drivers.map((driver) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/driver_avatar.jpg'),
                    radius: 20,
                  ),
                  title: Text('${driver.name} ${driver.firstName}'),
                  subtitle: Text(driver.email),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement the logic to assign the selected driver to the car
                      // You can use the 'driver' object for further processing
                      Navigator.of(dialogContext).pop(); // Close the dialog
                    },
                    child: Text('Assign Car'),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Car> cars = Provider.of<CarProvider>(context).cars;
    List<Users> drivers = Provider.of<CarProvider>(context).drivers;
    bool isLoading = Provider.of<CarProvider>(context).isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue,
          child: Row(
            children: [
              Text(
                'Cars Dashboard',
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
                        .asMap()
                        .entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text(entry.value.marque)),
                              DataCell(Text(entry.value.type)),
                              DataCell(Text(entry.value.matricule)),
                              DataCell(
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await showEditDialog(entry.value);
                                      },
                                      icon: Icon(Icons.edit),
                                      label: Text('Edit'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await showDeleteConfirmationDialog(
                                            entry.value);
                                      },
                                      icon: Icon(Icons.delete),
                                      label: Text('Delete'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          showAssignDriverDialog(drivers);
                                        });
                                      },
                                      icon: Icon(Icons.person),
                                      label: Text('Assign'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
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
    );
  }
}
