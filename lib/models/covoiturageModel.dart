class Covoiturage {
  //String idCovoiturage;
  //int idCond;
  //int idUser;
  String pointDepart;
  String pointArrivee;
  String date;
  //int tarif;

  Covoiturage({
    //required this.idCovoiturage,
    //required this.idCond,
    //required this.idUser,
    required this.pointDepart,
    required this.pointArrivee,
    required this.date,
    //required this.tarif,
  });

  factory Covoiturage.fromJson(Map<String, dynamic> json) {
    return Covoiturage(
      //idCovoiturage: json['id_covoiturage'] ?? '',
      //idCond: json['id_cond'] ?? 0,
      //idUser: json['id_user'] ?? 0,
      pointDepart: json['pointDepart'] ?? '',
      pointArrivee: json['pointArrivee'] ?? '',
      date: json['date'] ?? '',
      //tarif: json['tarif'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_covoiturage': idCovoiturage,
      //'id_cond': idCond,
      //'id_user': idUser,
      'pointDepart': pointDepart,
      'pointArrivee': pointArrivee,
      'date': date,
      //'tarif': tarif,
    };
  }
}
