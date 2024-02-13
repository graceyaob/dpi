import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class Interrogatoire extends StatefulWidget {
  const Interrogatoire({super.key});

  @override
  State<Interrogatoire> createState() => _InterrogatoireState();
}

class _InterrogatoireState extends State<Interrogatoire> {
  int boutonSelectionne = 0;
  int indice = 0;
  List text = [
    'Histoire de la maladie',
    "Antecedents médicaux",
    "Antecedents chirurgicaux",
    "Antecedents gynecologiques",
    "Antecedents familiaux"
  ];
  List histoire = [""];

  String idfichepaiement = "";
  List consultation = [];
  bool chargement = false;
  @override
  void initState() {
    loadFichePaiementId();
    super.initState();
  }

  Future<void> loadFichePaiementId() async {
    String? id = await MySharedPreferences.loadData();
    if (id != null) {
      setState(() {
        idfichepaiement = id;
      });

      //utilisation de la idfichepaiement pour recupérer les données
      await fetchConsultationData();
    }
  }

  Future<void> fetchConsultationData() async {
    Api()
        .getApi(Api.consultationfichePaiementUrl(idfichepaiement))
        .then((value) {
      setState(() {
        consultation = value;
        chargement = true;

        histoire = [
          consultation[0]["motif"],
          consultation[0]["autres_antecedents_medicaux"],
          consultation[0]["autres_antecedents_chirurgicaux"],
          consultation[0]["autres_antecedents_gyneco_obstetricaux"],
          "demander à MAMADy",
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Config.spaceSmall,
              Row(
                children: [
                  Container(
                    width: Config.widthSize * 0.44,
                    height: Config.heightSize * 0.86,
                    decoration: BoxDecoration(
                      color: Color(0xFFEAF7FF), // Couleur du conteneur

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Couleur de l'ombre
                          blurRadius: 5.0, // Rayon de flou de l'ombre
                          offset: Offset(0,
                              3), // Décalage de l'ombre par rapport au conteneur
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.blueAccent,
                            )),
                        Center(
                          child: Image.asset(
                            "assets/images/point-dinterrogation.png",
                            width: 70,
                            height: 70,
                          ),
                        ),
                        buildBouton(0, "Histoire de la maladie"),
                        buildBouton(1, "Antécédents médicaux"),
                        buildBouton(2, "Antécédents chirurgicaux"),
                        buildBouton(3, "Antécédents gynecologiques"),
                        buildBouton(4, "Antécédents familiaux")
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    height: Config.heightSize * 0.8157,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Interrogatoires",
                          style: TextStyle(
                              color: const Color(0xFF3B82F6),
                              fontWeight: FontWeight.bold,
                              fontSize: Config.widthSize * 0.04),
                        ),
                        Text(
                          "      ${text[indice]}",
                          style: TextStyle(
                              color: Color(0xFF3B82F6).withOpacity(0.8),
                              fontSize: Config.widthSize * 0.03),
                        ),
                        Config.spaceSmall,
                        Container(
                          margin: EdgeInsets.all(
                              5.0), // Ajoutez des marges de 10.0 tout autour

                          width: Config.widthSize * 0.5256,
                          height: Config.heightSize * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Text(histoire[indice]),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  TextButton buildBouton(int index, String libelle) {
    return TextButton(
        onPressed: () {
          setState(() {
            boutonSelectionne = index;
            indice = index;
          });
        },
        child: Text(
          libelle,
          style: TextStyle(
              color: boutonSelectionne == index
                  ? Color(0xFF3B82F6).withOpacity(0.8)
                  : Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w500),
        ));
  }
}
