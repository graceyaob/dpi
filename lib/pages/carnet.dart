import 'package:dpi_mobile/components/function404.dart';
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
                await MySharedPreferences.clearData();
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
        SizedBox(
            height: Config.heightSize * 0.5,
            //Arevoir
            child: uneConsultation
                ? FutureBuilder<List<Card>>(
                    future: buildConsultationCards(consultations),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Card>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Erreur: ${snapshot.error}");
                      } else {
                        return ListView(children: snapshot.data!);
                      }
                    })
                : ErrorFunction(message: "Aucune consultation trouvé"))
      ]),
    ));
  }
}
