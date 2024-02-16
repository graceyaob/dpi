import 'package:dpi_mobile/data/models/models_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  // Nom de la collection
  String oneDatabase = "patient_db";

  // Initialiser la base de données lors du lancement de l'application
  initDatabase() async {
    // Obtenir la collection
    var box = await Hive.openBox(oneDatabase);

    // Verifier si la collection est vide
    if (box.isEmpty) {
      var mapData = Patient(
        id: '',
        nom: '',
        prenoms: '',
        sexe: '',
        dateNaissance: '',
        access: '',
        refresh: '',
        username: '',
        password: '',
        firstLogin: true,
        timer: '',
        logged: 0,
      ).toMapInit();

      //Création de la collection
      await box.add(mapData);
    } else {}
  }

  // Vérifier s'il y'a un compte connecté de la collection Patient
  Future<int> isLoggedBoxPatient() async {
    // Obtenir la collection
    var box = await Hive.openBox(oneDatabase);

    // Récupérer le 1er élément
    Map rui = box.getAt(0);

    if (rui["logged"] == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  /// Insérer les données dans la collection Patient après connexion
  Future insertAfterLoginBoxPatient(Map data) async {
    var box = await Hive.openBox(oneDatabase);
    DateTime now = DateTime.now();
    data['timer'] =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
    print("In insert");
    print(data);
    await box.put(0, data);
  }

  /// Modifier les données de la collection Patient
  Future updateBoxPatient(Map data) async {
    var box = await Hive.openBox(oneDatabase);
    await box.put(0, data);
  }

  /// Récupérer les éléments de la collection Patient
  Future<Patient> getInfoBoxPatient() async {
    var box = await Hive.openBox(oneDatabase);
    var graceMap = box.getAt(0);

    print(graceMap);
    Patient patient = Patient.fromDataBase(graceMap);
    return patient;
  }

  int calculateTimeDifference(String timerString) {
    // Vérifier si la chaîne de date est vide ou null
    if (timerString == null || timerString.isEmpty) {
      // Gérer le cas où la chaîne de date est invalide
      print("Chaîne de date invalide.");
      return 0;
    }

    // Convertir la chaîne de caractères en objet DateTime
    DateTime timer;
    try {
      // Séparer la chaîne en date et heure
      List<String> dateTimeParts = timerString.split(' ');
      List<String> dateParts = dateTimeParts[0].split('-');
      List<String> timeParts = dateTimeParts[1].split(':');

      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      int second = int.parse(timeParts[2]);

      timer = DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      print("Erreur lors de la conversion de la date : $e");
      return 0;
    }

    // Obtenir la date et l'heure actuelles
    DateTime now = DateTime.now();

    // Calculer la différence entre les deux dates
    Duration difference = now.difference(timer);

    print(
        "Différence : ${difference.inHours} heures, ${difference.inMinutes % 60} minutes");

    return difference.inHours;
  }
}

//utilisation de Shared_Preference
class MySharedPreferences {
  static const String key = 'id';

  static Future<void> saveData(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }

  static Future<String?> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
