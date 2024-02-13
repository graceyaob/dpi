import 'package:dpi_mobile/data/database/config.dart';
import 'package:flutter/material.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:ionicons/ionicons.dart';

class LoginFormProfil extends StatefulWidget {
  // Dans cette classe  les input sont par défaut insaisissable (readOnly = true) et les boutons sont invisibles

  const LoginFormProfil({
    super.key,
  });

  @override
  State<LoginFormProfil> createState() => _LoginFormProfilState();
}

class _LoginFormProfilState extends State<LoginFormProfil> {
  final _formKey = GlobalKey<FormState>();
  final _isnController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateController = TextEditingController();
  final _assuranceController = TextEditingController(text: "MCI Care");
  final _sexeController = TextEditingController();
  bool osbcurePass = true;

  @override
  void initState() {
    Database().getInfoBoxPatient().then((value) {
      setState(() {
        _isnController.text = value.username;
        _dateController.text = value.dateNaissance;
        _nomController.text = value.nom;
        _prenomController.text = value.prenoms;
        _sexeController.text = value.sexe;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // utiliser
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Config.widthSize * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // formulaire de connexion
              TextFormField(
                readOnly: true,
                controller: _isnController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black12,
                decoration: const InputDecoration(
                  labelText: "Code Patient",
                  prefixIcon: Icon(
                    Ionicons.person,
                    color: Config.couleurPrincipale,
                  ), // Utilisez l'icône de préfixe passée en paramètre
                ),
              ),
              Config.spaceSmall,
              input("Nom", Ionicons.person, _nomController),
              Config.spaceSmall,
              input("Prenom", Ionicons.person, _prenomController),
              Config.spaceSmall,
              input("Date de Naissance", Ionicons.calendar, _dateController),
              Config.spaceSmall,
              input("Assurance", Ionicons.document_text_sharp,
                  _assuranceController),
              Config.spaceSmall,
              input("Sexe", Ionicons.person, _sexeController)

              // login button
            ],
          ),
        ),
      );
    });
  }

// mon widget input
  Widget input(
      String labelText, IconData prefixIcon, TextEditingController controller) {
    return TextFormField(
      readOnly: true,
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
