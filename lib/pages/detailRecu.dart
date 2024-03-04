import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class DetailRecu extends StatefulWidget {
  DetailRecu({super.key, required this.payementeffectue});
  bool payementeffectue;
  @override
  State<DetailRecu> createState() => _DetailRecuState();
}

class _DetailRecuState extends State<DetailRecu> {
  String nom = "";
  String code = "";
  DateTime date = DateTime.now();
  String id = "";
  String idPatient = "";
  Map<String, dynamic> facture = {};
  DateTime datefiche = DateTime.now();

  @override
  void initState() {
    Database().getInfoBoxPatient().then((value) {
      setState(() {
        idPatient = value.id;
        nom = "${value.nom} ${value.prenoms} ";
        code = value.username;
        date = DateTime.parse(value.dateNaissance);
      });
    });
    MySharedPreferences.loadData().then((value) {
      setState(() {
        if (value != null) {
          id = value;

          List ficheentree = [];
          if (widget.payementeffectue) {
            Api().getApi(Api.getFichePaiementValideUrl(idPatient)).then(
              (value) {
                setState(() {
                  setState(() {
                    ficheentree = value;
                    facture = fichePaiement(ficheentree, id);
                    print(" bbbb: $facture , id : $id");
                  });
                });
              },
            );
          } else {
            Api().getApi(Api.getFichePaiementNonValideUrl(idPatient)).then(
              (value) {
                setState(() {
                  ficheentree = value;
                  facture = fichePaiement(ficheentree, id);
                  print(" bbbb: $facture , id : $id");
                });
              },
            );
          }
        } else {
          print("bonjour");
        }
      });
    });
    //print("fiche: $fiche , id : $id");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (facture != null &&
        facture["motif_examens"] != null &&
        facture["motif_examens"].isNotEmpty &&
        facture["motif_examens"][0]["motif"] != null &&
        facture["motif_examens"][0]["motif"]["create_at"] != null) {
      // Accéder aux éléments de la structure de données
      setState(() {
        datefiche = DateTime.parse(
            '${facture["motif_examens"][0]["motif"]["create_at"]}');
      });
    } else {
      setState(() {
        date = DateTime.now();
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        width: Config.widthSize * 1,
        height: Config.heightSize * 0.47,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(25),
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          children: [
            Text(
              widget.payementeffectue ? "Reçu de caisse" : "fiche de paiement",
              style: TextStyle(fontSize: Config.widthSize * 0.06),
            ),
            Text("N°${facture["reference"]}"),
            Config.spaceSmall,
            Text(
                "Le ${date.day}-${date.month}-${date.year} à ${date.hour}:${date.minute}"),
            Config.spaceBig,
            monRow("Code patient : ", code, color: Config.couleurPrincipale),
            SizedBox(
              height: 10,
            ),
            monRow("Nom et Prénoms : ", nom),
            SizedBox(
              height: 10,
            ),
            monRow("Date de naissance : ",
                "${date.day}-${date.month}-${date.year}"),
            SizedBox(
              height: 10,
            ),
            monRow("Service : ", "28/01/2024"),
            SizedBox(
              height: 10,
            ),
            monRow("Numéro débité", "0749428521"),
            SizedBox(
              height: 10,
            ),
            monRow("Montant", "1500 Fcfa"),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text("Valable jusqu'au 28/01/2024")],
            )
          ],
        ),
      )),
    );
  }

  Map<String, dynamic> fichePaiement(List ficheentree, String id) {
    for (int index = 0; index < ficheentree.length; index++) {
      if (ficheentree[index]["id"] == id) {
        return ficheentree[index];
      }
    }
    return {};
  }
}

Widget monRow(String libelle, String text, {Color color = Colors.black}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        libelle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        text,
        style: TextStyle(color: color),
      ),
    ],
  );
}
