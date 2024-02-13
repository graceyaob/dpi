import 'package:dpi_mobile/utils/chiffrer.dart';

class Patient {
  String id;
  String nom;
  String prenoms;
  String sexe;
  String dateNaissance;
  String access;
  String refresh;
  String username;
  String password;
  String timer;
  bool firstLogin = true;
  int? logged;

  Patient(
      {required this.id,
      required this.nom,
      required this.prenoms,
      required this.sexe,
      required this.dateNaissance,
      required this.access,
      required this.refresh,
      required this.username,
      required this.password,
      required this.timer,
      required this.firstLogin,
      this.logged});

  // creation d'une instance à partir de Map
  factory Patient.fromMap(Map json) => Patient(
        id: json['id'],
        nom: json['nom'],
        prenoms: json['prenoms'],
        sexe: json['sexe'],
        dateNaissance: json['date_naissance'],
        access: json['access'],
        refresh: json['refresh'],
        firstLogin: json['firstLogin'],
        timer: '',
        username: '',
        password: '',
      );

  factory Patient.fromDataBase(Map json) => Patient(
        id: json['id'],
        nom: json['nom'],
        prenoms: json['prenoms'],
        sexe: json['sexe'],
        dateNaissance: json['date_naissance'],
        access: json['access'],
        refresh: json['refresh'],
        timer: json['timer'],
        username: json['username'],
        password: json['password'],
        firstLogin: json['firstLogin'] ?? true,
      );

  Map<String, dynamic> toMapInit() {
    return {
      'id': id,
      'nom': nom,
      'prenoms': prenoms,
      'sexe': sexe,
      'timer': timer,
      'date_naissance': dateNaissance,
      'access': access,
      'refresh': refresh,
      'username': username,
      'password': password,
      'firstLogin': firstLogin,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenoms': prenoms,
      'sexe': sexe,
      'timer': timer,
      'dateNaissance': dateNaissance,
      'access': access,
      'refresh': refresh,
      'username': username,
      'password': encryptAES(password),
      'firstLogin': firstLogin,
    };
  }
}
