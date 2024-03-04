import 'package:dpi_mobile/components/buttonFacture.dart';
import 'package:dpi_mobile/components/function404.dart';
import 'package:dpi_mobile/components/home/containerImage.dart';
import 'package:dpi_mobile/components/home/welcome.dart';
import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool uneConsultation = true;
  String id = '';
  List consultations = [];
  Map constantes = {};

  @override
  void initState() {
    super.initState();
    Database().getInfoBoxPatient().then((value) {
      if (mounted) {
        setState(() {
          id = value.id;
        });
      }

      Api().getApi(Api.consultationUrl(id)).then((value) {
        if (mounted) {
          setState(() {
            if (value == 404) {
              uneConsultation = false;
            } else {
              consultations = value;
              Map consultation = consultations[consultations.length - 1];

              String fichePaiement = consultation['fichepaiement'];
              print(fichePaiement);
              Api()
                  .getApi(Api.constanteAcceuilUrl(fichePaiement))
                  .then((value) {
                if (mounted) {
                  setState(() {
                    constantes = value[0];
                  });

                  print(constantes);
                }
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Config.widthSize * 0.005,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Welcome(
                columnVisible: true,
                selection: false,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Config.widthSize * 0.05,
                      vertical: Config.widthSize * 0.05),
                  child: uneConsultation
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Mes dernières constantes",
                              style: TextStyle(
                                  color: const Color(0xFF655F5F),
                                  fontSize: Config.widthSize * 0.04,
                                  fontWeight: FontWeight.w500),
                            ),
                            Config.spaceMeduim,
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Config.widthSize * 0.05),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ContainerImage(
                                            image: "assets/images/haltere.png",
                                            titre: "Mon poids",
                                            valeur:
                                                "${constantes['poids']} kg"),
                                        ContainerImage(
                                            image: "assets/images/taille.png",
                                            titre: "Ma taille",
                                            valeur:
                                                "${constantes['taille']} cm")
                                      ],
                                    ),
                                    Config.spaceMeduim,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ContainerImage(
                                            image:
                                                "assets/images/formegros.png",
                                            titre: "IMC",
                                            valeur:
                                                "${constantes['imc']} kg/m²"),
                                        ContainerImage(
                                            image: "assets/images/sucre.png",
                                            titre: "Diabétique",
                                            valeur:
                                                constantes['glycemie'] == null
                                                    ? "Non"
                                                    : "Oui")
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        )
                      : ErrorFunction(
                          message: "Aucuns parametres enregistrés",
                          height: Config.heightSize * 0.4,
                        )),
              Config.spaceSmall,
              Padding(
                padding: EdgeInsets.only(left: Config.widthSize * 0.70),
                child: ButtonFacture(
                  fondBouton: Config.couleurPrincipale,
                  couleurEcriture: Colors.white,
                  title: "Facture",
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
