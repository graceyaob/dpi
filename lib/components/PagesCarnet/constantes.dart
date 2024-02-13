import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class Constante extends StatefulWidget {
  const Constante({super.key});

  @override
  State<Constante> createState() => _ConstanteState();
}

class _ConstanteState extends State<Constante> {
  Map constantes = {};
  String fichePaiement = "";
  double poids = 0.0;
  double temperature = 0;
  double taille = 0;
  double imc = 0;
  double tensionArterielle = 0;
  double pouls = 0;
  @override
  void initState() {
    MySharedPreferences.loadData().then((value) {
      setState(() {
        if (value != null) {
          fichePaiement = value;
          Api().getApi(Api.constanteAcceuilUrl(fichePaiement)).then((value) {
            setState(() {
              constantes = value[0];
              poids = constantes["poids"];
              temperature = constantes["temperature"];
              taille = constantes["taille"];
              imc = constantes["imc"];
              tensionArterielle = constantes["tension_arteriel_systolique"];
              pouls = constantes["pouls"];
            });
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: BoxDecoration(border: Border.all()),
          margin: EdgeInsets.only(
              left: Config.widthSize * 0.02, right: Config.widthSize * 0.02),
          child: Column(
            children: [
              Card(
                color: Color(0xFFE9F7FF),
                child: ListTile(
                  title: Text(
                    "Constante",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                        fontSize: Config.widthSize * 0.05),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("Température"), Text("$temperature °")],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("Poids"), Text("$poids Kg")],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("Taille"), Text("$taille cm")],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("IMC"), Text("$imc Kg/m²")],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Tension Arterielle"),
                  Text("$tensionArterielle mmHg"),
                ],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("Pouls"), Text("$pouls Btt/mn")],
              ),
            ],
          ),
        ));
  }
}
