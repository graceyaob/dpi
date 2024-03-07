import 'package:dpi_mobile/components/function404.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/components/PagesCarnet/cadre.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class Carnet extends StatefulWidget {
  const Carnet({super.key});
  @override
  State<Carnet> createState() => _CarnetState();
}

class _CarnetState extends State<Carnet> {
  String id = '';
  List consultations = [];
  bool uneConsultation = true;
  StreamController<ConnectivityResult> connectivityStream =
      StreamController<ConnectivityResult>();

  @override
  void initState() {
    checkInternetConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityStream.add(result);
    });
    super.initState();
  }

  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        uneConsultation = true;
      });
    } else {
      callApi();
    }
  }

  void callApi() {
    Database().getInfoBoxPatient().then((value) {
      setState(
        () {
          id = value.id;
        },
      );
      MySharedPreferences.saveData('0');

      Api().getApi(Api.consultationUrl(id)).then((value) {
        setState(() {
          if (value == 404) {
            uneConsultation = false;
          } else {
            consultations = value;
          }
        });
      });
    });
  }

  //fonction pour recuperer les consultations
  Future<List<Card>> buildConsultationCards(List consultations) async {
    List<Card> cards = [];
    for (int index = 0; index < consultations.length; index++) {
      Map consultation = consultations[index];
      DateTime daterecupere =
          DateTime.parse('${consultation["date_consultation"]}');
      String service = await Api()
          .getApi(Api.serviceByIdUrl(consultation["service"]))
          .then((value) => value["libelle"]);
      String centre = await Api()
          .getApi(Api.centreSanteByIdUrl(consultation["centresante"]))
          .then((value) => value["libelle"]);

      cards.add(
        Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              "Consultation ${service.toLowerCase()} à $centre",
              style: const TextStyle(
                color: Config.couleurPrincipale,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1, //tenir sur une ligne
              overflow: TextOverflow.ellipsis, //tronquer le text
              softWrap: false, //desactiver le retour à la ligne
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${daterecupere.day}-${daterecupere.month}-${daterecupere.year}"),
                Text("${daterecupere.hour}:${daterecupere.minute}")
              ],
            ),
            trailing: TextButton(
              onPressed: () async {
                Navigator.of(context).pushNamed("baseCarnet");
                //supprimer ma base de donnée tempoeaire
                await MySharedPreferences.clearData();
                // sauvegarder les inforamtion de la fiche de paiement
                await MySharedPreferences.saveData(
                    consultation["fichepaiement"]);
              },
              child: Text("Détail"),
            ),
          ),
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Cadre(titre: "Ma liste de Consultations"),
        StreamBuilder(
          stream: connectivityStream.stream,
          builder: (context, snapshot) {
            //quand la connection est active
            if (snapshot.connectionState == ConnectionState.active) {
              var result = snapshot.data;
              //quand la connexion se désactive
              if (result == ConnectivityResult.none) {
                return carnet();
              } else {
                callApi();
                return carnet();
              }
            }
            //quand il n'y a pas connexion

            else {
              return carnet();
            }
          },
        ),
      ]),
    ));
  }

  Widget carnet() {
    return SizedBox(
        height: Config.heightSize * 0.5,
        //Arevoir
        child: uneConsultation
            ? FutureBuilder<List<Card>>(
                future: buildConsultationCards(consultations),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Card>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Erreur: ${snapshot.error}");
                  } else {
                    return ListView(children: snapshot.data!);
                  }
                })
            : ErrorFunction(
                message: "Aucune consultation trouvé",
                height: Config.heightSize * 0.43,
              ));
  }
}
