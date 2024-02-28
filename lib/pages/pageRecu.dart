import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/components/PagesCarnet/cadre.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class RecuPaiement extends StatefulWidget {
  const RecuPaiement({super.key});
  @override
  State<RecuPaiement> createState() => _RecuPaiementState();
}

class _RecuPaiementState extends State<RecuPaiement> {
  String id = '';
  List consultations = [];
  bool uneConsultation = true;

  @override
  void initState() {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                "fiche de paiement N°546772 ${service.toLowerCase()} à $centre",
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
                      "Edité${daterecupere.day}-${daterecupere.month}-${daterecupere.year} à ${daterecupere.hour}:${daterecupere.minute}"),
                  Text("Impayée")
                ],
              ),
              trailing: TextButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed("detailRecu");
                  /*await MySharedPreferences.clearData();
                  await MySharedPreferences.saveData(
                      consultation["fichepaiement"]);*/
                },
                child: Text("Voir plus"),
              ),
            ),
          ),
        );
      }
      return cards;
    }

    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Text("Liste des fiches et reçus de paiement"),
              Config.spaceSmall,
              SizedBox(
                  height: Config.heightSize * 0.45,
                  //Arevoir
                  child: uneConsultation
                      ? FutureBuilder<List<Card>>(
                          future: buildConsultationCards(consultations),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Card>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Erreur: ${snapshot.error}");
                            } else {
                              return ListView(children: snapshot.data!);
                            }
                          })
                      : Text("vous n'avez pas de consultation"))
            ]),
          ),
        ));
  }
}
