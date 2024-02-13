import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/components/PagesCarnet/cadre.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class Prescriptions extends StatefulWidget {
  const Prescriptions({Key? key}) : super(key: key);

  @override
  State<Prescriptions> createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  String fiche = "";
  List prescriptions = [];

  @override
  void initState() {
    MySharedPreferences.loadData().then((value) {
      setState(() {
        if (value != null) {
          fiche = value;
          Api().getApi(Api.prescriptionUrl(fiche)).then((value) => {
                setState(() {
                  prescriptions = value;
                })
              });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // pacourir mes prescriptions
    Future<List<Widget>> buildPrescriptions(List prescriptions) async {
      List<Widget> ordonnance = [];
      for (int index = 0; index < prescriptions.length; index++) {
        Map prescription = prescriptions[index];
        String idmedicament = prescription["medicament"];
        String idposologie = prescription["posologie"];
        int duree = prescription["duree"];
        String quantite = prescription["quantite"];

        Map medicament = await Api().getApi(Api.medicamentUrl(idmedicament));
        Map posologie = await Api().getApi(Api.posologieUrl(idposologie));

        ordonnance.add(InstructionLine(
          medicament: medicament["libelle_produit"],
          posologie: posologie["libelle"],
          duree: duree,
          quantite: quantite,
        ));
      }
      return ordonnance;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Cadre(titre: "Prescription"),
            Expanded(
              child: Container(
                width: Config.widthSize * 0.8,
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: Config.widthSize * 1.0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: Config.heightSize * 1,
                        //la vue ordonnance
                        child: FutureBuilder<List<Widget>>(
                          future: buildPrescriptions(prescriptions),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Widget>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Erreur: ${snapshot.error}");
                            } else {
                              return Column(
                                children: snapshot.data!,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Codes des différentes blocs de mon ordonnances
class InstructionLine extends StatelessWidget {
  final String medicament;
  final String posologie;
  final int duree;
  final String quantite;

  InstructionLine({
    required this.medicament,
    required this.posologie,
    required this.duree,
    required this.quantite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Médicament: $medicament",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(
            "Posologie: $posologie",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 4.0),
          Text(
            "Durée: $duree jours",
            style: TextStyle(color: Colors.blue),
          ),
          SizedBox(height: 4.0),
          Text(
            "Quantité: $quantite",
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
