class Users {
  final String id;
  String email;
  String password;
  String role;
  String name;
  String firstName;
  String id_moyen_transport;

  Users(
      {required this.id,
      required this.email,
      required this.password,
      required this.role,
      required this.name,
      required this.firstName,
      required this.id_moyen_transport});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        id: json['_id'],
        email: json['email'],
        password: json['password'],
        role: json['role'],
        name: json['name'],
        firstName: json['first_name'],
        id_moyen_transport: json['id_moyen_transport']);
  }
}
