import 'package:dpi_mobile/components/champsSelection.dart';
import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/data/models/models_api.dart';
import 'package:dpi_mobile/data/models/models_database.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:dpi_mobile/components/buttonFacture.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ModiInfo extends StatefulWidget {
  const ModiInfo({
    super.key,
  });

  @override
  State<ModiInfo> createState() => _ModiInfoState();
}

class _ModiInfoState extends State<ModiInfo> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateController = TextEditingController();
  final _sexeController = TextEditingController();
  String textAppbar = "Profil";
  String dateNaissance = "";
  String id = "";
  String sexe = "";
  String prenoms = "";
  bool readOnly = true;
  bool isLoading = false;
  ResponseRequest sortir = ResponseRequest(status: 0);
  Map data = {};

  @override
  void initState() {
    Database().getInfoBoxPatient().then((value) => setState(() {
          _nomController.text = value.nom;
          _prenomController.text = value.prenoms;
          _dateController.text = value.dateNaissance;
          _sexeController.text = value.sexe;
          sexe = value.sexe;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: readOnly
            ? AppBar(
                title: Center(
                  child: Text(
                    textAppbar,
                    style: TextStyle(fontSize: Config.widthSize * 0.05),
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          readOnly = !readOnly;

                          textAppbar = "Modifiez vos informations";
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Config.couleurPrincipale,
                      ))
                ],
              )
            : AppBar(
                title: Center(
                  child: Text(
                    textAppbar,
                    style: TextStyle(fontSize: Config.widthSize * 0.05),
                  ),
                ),
              ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Config.widthSize * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // formulaire de connexion

                input("Nom", Ionicons.person, _nomController, readOnly),
                Config.spaceSmall,
                input("Prenom", Ionicons.person, _prenomController, readOnly),
                Config.spaceSmall,
                input("Date de Naissance", Ionicons.calendar, _dateController,
                    readOnly),

                Config.spaceSmall,
                ChampSelect(
                  items: ["feminin", "masculin"],
                  libelle: "Sexe",
                  readOnly: readOnly,
                  formulaireConsultation: false,
                  onValueChanged: (selectedValue) {
                    _sexeController.text = readOnly ? sexe : "$selectedValue";
                  },
                ),
                Config.spaceSmall,

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonFacture(
                      couleurEcriture: Colors.white,
                      fondBouton: Config.couleurPrincipale,
                      title: readOnly ? "Valider" : "Modifier",
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        data = {
                          "nom": _nomController.text,
                          "prenoms": _prenomController.text,
                          "dateNaissance": _dateController.text,
                          "sexe": _sexeController.text,
                        };
                        //enregistrer les mises à jour
                        Patient patient = await Database().getInfoBoxPatient();
                        sortir = await Api().postApiDeux(
                            Api.modifierInfoUrl(patient.username), data);

                        if (sortir.status == 200) {
                          patient.nom = _nomController.text;
                          patient.prenoms = _prenomController.text;
                          patient.dateNaissance = _dateController.text;
                          patient.sexe = _sexeController.text;
                          patient.firstLogin = false;

                          await Database()
                              .updateBoxPatient(patient.toMapInit());
                          print(patient);
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).pushReplacementNamed("main");
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          showAlertDialog(context, sortir.message!);
                        }
                      },
                      isload: isLoading,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  // mon widget input
  Widget input(String labelText, IconData prefixIcon,
      TextEditingController controller, bool readOnly) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      keyboardType: TextInputType.text,
      cursorColor: Colors.black12,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          color: Config.couleurPrincipale,
        ), // Utilisez l'icône de préfixe passée en paramètre
      ),
    );
  }
}
