class Car {
  final String id;
  String marque;
  String type;
  String matricule;

  Car({
    required this.id,
    required this.marque,
    required this.type,
    required this.matricule,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'],
      marque: json['marque'],
      type: json['type'],
      matricule: json['matricule'],
    );
  }

  void updateValues({
    required String newMarque,
    required String newType,
    required String newMatricule,
  }) {
    marque = newMarque;
    type = newType;
    matricule = newMatricule;
  }
}
