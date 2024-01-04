class Colis {
  int? id; // Add the ID field if it's not already present in your Colis class
  String? idClient; // Add the ID Client field if needed
  int height;
  int width;
  int weight;
  String description;
  String? etat;
  String? idLivreur;
  String adresse;
  String destination;
  String receiverName;
  String receiverPhone;

  Colis({
    this.id,
    this.idClient,
    required this.height,
    required this.width,
    required this.weight,
    required this.description,
    this.etat,
    this.idLivreur,
    required this.adresse,
    required this.destination,
    required this.receiverName,
    required this.receiverPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      
      'idClient': idClient,
      'height': height,
      'width': width,
      'weight': weight,
      'description': description,
      'etat': etat,
      'idLivreur': idLivreur,
      'adresse': adresse,
      'destination': destination,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
    };
  }

  factory Colis.fromJson(Map<String, dynamic> json) {
    return Colis(
      id: json['id'],
      idClient: json['idClient'],
      height: json['height'],
      width: json['width'],
      weight: json['weight'],
      description: json['description'],
      etat: json['etat'],
      idLivreur: json['idLivreur'],
      adresse: json['adresse'],
      destination: json['destination'],
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
    );
  }
}
