import 'package:flutter/material.dart';
import '../Models/Car_Model.dart';
import '/Services/CarService.dart';

class CarProvider extends ChangeNotifier {
  List<Car> _cars = [];
  bool _isLoading = false;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  Future<void> fetchCars() async {
    try {
      _isLoading = true;
      notifyListeners();

      final List<Car> fetchedCars = await CarService.fetchCars();

      _cars = fetchedCars;
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editCar(Car car) async {
    try {
      await CarService.editCar(car);

      // Assuming your CarService.editCar updates the existing car, you can update it in the local list
      final index = _cars.indexWhere((element) => element.id == car.id);
      if (index != -1) {
        _cars[index] = car;
        notifyListeners();
      }
    } catch (e) {
      print('Error in editCar: $e');
      throw Exception('Failed to edit car');
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await CarService.deleteCar(carId);

      // Remove the deleted car from the local list
      _cars.removeWhere((car) => car.id == carId);
      notifyListeners();
    } catch (e) {
      print('Error in deleteCar: $e');
      throw Exception('Failed to delete car');
    }
  }

  Future<void> addCar(Car car) async {
    try {
      await CarService.addCar(car);

      // Assuming your CarService.addCar returns the newly added car with an ID
      _cars.add(car);
      notifyListeners();
    } catch (e) {
      print('Error in addCar: $e');
      throw Exception('Failed to add car');
    }
  }
}
