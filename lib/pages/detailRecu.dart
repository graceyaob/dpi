import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class DetailRecu extends StatefulWidget {
  const DetailRecu({super.key});

  @override
  State<DetailRecu> createState() => _DetailRecuState();
}

class _DetailRecuState extends State<DetailRecu> {
  String nom = "";
  String code = "";
  DateTime date = DateTime.now();
  @override
  void initState() {
    Database().getInfoBoxPatient().then((value) {
      setState(() {
        nom = "${value.nom} ${value.prenoms} ";
        code = value.username;
        date = DateTime.parse(value.dateNaissance);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              "Ticket de caisse",
              style: TextStyle(fontSize: Config.widthSize * 0.06),
            ),
            Text("N°250653RY"),
            Config.spaceSmall,
            Text("Le 14/11/2024"),
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
