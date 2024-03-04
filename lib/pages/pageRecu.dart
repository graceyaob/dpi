import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class RecuPaiement extends StatefulWidget {
  const RecuPaiement({Key? key}) : super(key: key);

  @override
  State<RecuPaiement> createState() => _RecuPaiementState();
}

class _RecuPaiementState extends State<RecuPaiement> {
  String id = '';
  List<Map<String, dynamic>> fiches = [];
  bool unefichePaiement = true;

  @override
  void initState() {
    super.initState();
    Database().getInfoBoxPatient().then((value) {
      setState(() {
        id = value.id;
      });
      MySharedPreferences.saveData('0');

      Api().getApi(Api.getFichePaiementValideUrl(id)).then((value) {
        setState(() {
          if (value == 404) {
            unefichePaiement = false;
          } else {
            fiches.addAll(value.map<Map<String, dynamic>>((fiche) {
              return {
                "id": fiche["id"],
                "reference": fiche["reference"],
                "date": DateTime.parse('${fiche["create_at"]}'),
                "validation": '${fiche["validation"]}',
              };
            }));
          }
        });
      });

      Api().getApi(Api.getFichePaiementNonValideUrl(id)).then((value) {
        setState(() {
          if (value == 404) {
            unefichePaiement = false;
          } else {
            fiches.addAll(value.map<Map<String, dynamic>>((fiche) {
              return {
                "id": fiche["id"],
                "reference": fiche["reference"],
                "date": DateTime.parse('${fiche["create_at"]}'),
                "validation": '${fiche["validation"]}',
              };
            }));
            fiches.sort((a, b) => b["date"].compareTo(a["date"]));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Liste des fiches et reçus de paiement"),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: constraints.maxHeight * 0.8,
                      child: unefichePaiement
                          ? FutureBuilder<List<Card>>(
                              future: buildFichePaiementCards(fiches),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Card>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text("Erreur: ${snapshot.error}");
                                } else {
                                  return ListView(children: snapshot.data!);
                                }
                              },
                            )
                          : const Text("Vous n'avez pas de fiche de paiement"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Card>> buildFichePaiementCards(
      List<Map<String, dynamic>> fiches) async {
    List<Card> cards = [];
    for (int index = 0; index < fiches.length; index++) {
      Map<String, dynamic> fichePaiement = fiches[index];

      DateTime date = fichePaiement["date"];
      String reference = fichePaiement["reference"];
      String validation = fichePaiement["validation"];

      cards.add(
        Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              validation == "false"
                  ? "Fiche de paiement N° $reference"
                  : "Reçu de paiement N° $reference",
              style: const TextStyle(
                  color: Config.couleurPrincipale, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            subtitle: RichText(
              text: TextSpan(
                text:
                    "Edité le ${date.day}-${date.month}-${date.year} à ${date.hour}:${date.minute}",
                children: [
                  TextSpan(
                    text: validation == "false"
                        ? " Statut: Impayée"
                        : " Statut : Payée",
                  )
                ],
                style: TextStyle(color: Colors.black),
              ),
            ),
            trailing: TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed("detailRecu", arguments: validation);
                await MySharedPreferences.clearData();
                await MySharedPreferences.saveData(fichePaiement["id"]);
              },
              child: const Text("Voir plus"),
            ),
          ),
        ),
      );
    }
    return cards;
  }
}
