import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dpi_mobile/data/models/models_database.dart';

import '../database/config.dart';
import '../models/models_api.dart';

Dio dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 10)));
Map<String, dynamic> data = Map();
String access = "";
String refresh = "";
int heureConnexionenMinutes = 0;

class Api {
  static String messageErreur =
      "Nous n'avons pu traiter votre demande car une erreur est survenue.";
  static String messageAutreLogin =
      "Nous avons détecté une nouvelle connexion sur un nouveau téléphone. Veuillez vous déconnecter. Si ce n'est pas vous, veuillez informer le service client.";
  static String messageErreurInterne = "Une erreur est survenue.";
  static String messageInternet =
      "Veuillez vérifier votre connexion internet. Un problème de réseau est survenue.";
//http://192.168.1.162:8000 pour le bureau
//http://192.168.1.11:8000 pour la maison
  static const baseUrl = 'http://192.168.1.145:8000';
  static String loginUrl() => "$baseUrl/users/v1/login_patients/";
  static String centreSanteUrl(String idVille) =>
      "$baseUrl/accueils/v1/centresantes/get_centresante_by_ville/$idVille/";
  static String villesUrl() => "$baseUrl/accueils/v1/villes/";
  static String serviceUrl(String idcentre) =>
      "$baseUrl/accueils/v1/services/get_sercice_by_centreSante/$idcentre/";

  static String modifierMdpUrl(String codePatient) =>
      "$baseUrl/patients/v1/info/modifier/$codePatient/";
  static String modifierInfoUrl(String codePatient) =>
      "$baseUrl/patients/v1/info/modifierInfo/$codePatient/";
  static String consultationUrl(String idPatient) =>
      "$baseUrl/patients/v1/consultations/get_consultation_patient/$idPatient/";
  static String consultationfichePaiementUrl(String fichePaiement) =>
      "$baseUrl/patients/v1/consultations/get_consultation_fiche_paiement/$fichePaiement/";
  static String serviceByIdUrl(String idService) =>
      "$baseUrl/patients/v1/service/get_service_by_id/$idService/";
  static String centreSanteByIdUrl(String idCentre) =>
      "$baseUrl/patients/v1/centreSante/get_centre_by_id/$idCentre/";
  static String constanteAcceuilUrl(String fiche) =>
      "$baseUrl/patients/v1/constante/prise_constante_accueil/$fiche/";
  static String prescriptionUrl(String fiche) =>
      "$baseUrl/patients/v1/prescription/prescription/$fiche/";
  static String medicamentUrl(String idmedicament) =>
      "$baseUrl/patients/v1/medicament/medicament/$idmedicament/";
  static String posologieUrl(String idposologie) =>
      "$baseUrl/patients/v1/posologie/posologie/$idposologie/";
  static String rendezVousUrl(String idPatient) =>
      "$baseUrl/patients/v1/rdv/rendez_vous_patient/$idPatient/";
  static String prestationUrl(String idService) =>
      "$baseUrl/patients/v1/prestation/prestation/$idService/";
  static String fichePaiementUrl() =>
      "$baseUrl/patients/v1/fichepaiements/creationfichepaiements/";
  static String getFichePaiementNonValideUrl(String idPatient) =>
      "$baseUrl/patients/v1/fichepaiements/get_fiche_by_patient_non_validees/$idPatient/";
  static String getFichePaiementValideUrl(String idPatient) =>
      "$baseUrl/patients/v1/fichepaiements/get_fiche_by_patient_validees/$idPatient/";

  // 1er type de POST sans utiliser de token
  Future<ResponseRequest> postApiUn(String url, Map data) async {
    try {
      final response = await Dio().post(
        url,
        data: data,
        options: Options(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            persistentConnection: false,
            followRedirects: false,
            validateStatus: (status) => true,
            //responseType: ResponseType.plain,
            headers: {
              'access-control-allow-origin': '*',
              'allow': 'OPTIONS,POST, GET',
              'content-type': 'application/json',
            }),
      );
      if (response.statusCode == 200) {
        return ResponseRequest(
          status: 200,
          data: response.data,
        );
      } else {
        try {
          if (response.data["erreur"] == null) {
            return ResponseRequest(status: 300, message: messageErreur);
          } else {
            return ResponseRequest(
                status: 300, message: response.data["erreur"]);
          }
        } catch (e) {
          print(e);
          return ResponseRequest(status: 300, message: messageErreur);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.error is SocketException) {
        return ResponseRequest(status: 300, message: messageInternet);
      } else {
        return ResponseRequest(status: 300, message: messageErreurInterne);
      }
    } catch (e) {
      return ResponseRequest(status: 300, message: messageErreurInterne);
    }
  }

  // 2ème type de POST avec utilisation de token
  Future<ResponseRequest> postApiDeux(String url, Map data) async {
    try {
      print("body ${data}");
      Patient patient = await Database().getInfoBoxPatient();
      final response = await Dio().post(
        url,
        data: data,
        options: Options(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            followRedirects: false,
            validateStatus: (status) => true,
            //responseType: ResponseType.plain,
            headers: {
              'access-control-allow-origin': '*',
              'allow': 'OPTIONS,POST, GET',
              'content-type': 'application/json',
              'Authorization': 'Bearer ${patient.access}'
            }),
      );
      print("response.data ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseRequest(
          status: 200,
          data: response.data,
        );
      } else {
        // Si le statut de la réponse n'est pas 200 ou 201, il y a eu une erreur
        print("hamilton");
        // Tentative de récupération du message d'erreur depuis les données de la réponse
        String errorMessage = response.data['erreur'] ?? 'Erreur inconnue';
        print("je suis dans ${response.data}");

        // Retour d'un objet ResponseRequest avec un statut de 300 et le message d'erreur
        return ResponseRequest(status: 300, message: errorMessage);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.error is SocketException) {
        return ResponseRequest(status: 300, message: "erreur de connexion");
      } else {
        return ResponseRequest(status: 300, message: "erreur interne 1");
      }
    } catch (e) {
      print(e);
      return ResponseRequest(status: 300, message: "erreur interne 2");
    }
  }

  //post avec token mais avec status de réussite 201

// requete get avec token
  Future getApi(String url) async {
    try {
      Patient patient = await Database().getInfoBoxPatient();
      Response response = await dio.get(url,
          options: Options(
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              followRedirects: false,
              validateStatus: (status) => true,
              //responseType: ResponseType.plain,
              headers: {
                'access-control-allow-origin': '*',
                'allow': 'OPTIONS,POST, GET',
                'content-type': 'application/json',
                'Authorization': 'Bearer ${patient.access}'
              }));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }
}
