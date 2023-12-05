class Covoiturage {
  final String idCovoiturage;
  //int idCond;
  //int idUser;
  String pointDepart;
  String pointArrivee;

  int tarif;

  Covoiturage({
    required this.idCovoiturage,
    //required this.idCond,
    //required this.idUser,
    required this.pointDepart,
    required this.pointArrivee,
    required this.tarif,
  });

  factory Covoiturage.fromJson(Map<String, dynamic> json) {
    return Covoiturage(
      idCovoiturage: json['_id'].toString() ?? '',
      pointDepart: json['pointDepart'].toString() ?? '',
      pointArrivee: json['pointArrivee'].toString() ?? '',
      tarif: json['Tarif'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': idCovoiturage,
      //'id_cond': idCond,
      //'id_user': idUser,
      'pointDepart': pointDepart,
      'pointArrivee': pointArrivee,
      'Tarif': tarif,
    };
  }
}
