import 'package:dpi_mobile/components/button.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/api/api.dart';
import '../../data/database/config.dart';
import '../../data/models/models_api.dart';
import '../../data/models/models_database.dart';
import '../../utils/chiffrer.dart';

class LoginModif extends StatefulWidget {
  const LoginModif({super.key});

  @override
  State<LoginModif> createState() => _LoginModifState();
}

class _LoginModifState extends State<LoginModif> {
  final _formKey = GlobalKey<FormState>();
  final _nouveauPasswordController = TextEditingController();

  final _configPasswordController = TextEditingController();
  bool osbcurePass = true;
  bool isLoading = false;
  Map data = {};
  ResponseRequest sortir = ResponseRequest(status: 0);

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Modification du mot de passe"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: largeur * 0.05),
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/securite.svg",
                  height: Config.heightSize * 0.28,
                ),
                Config.spaceSmall,
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // formulaire de connexion
                      Text(
                        "Saisissez votre nouveau mot de passe ",
                        style: TextStyle(fontSize: Config.widthSize * 0.06),
                      ),

                      Config.spaceSmall,
                      password(
                        _nouveauPasswordController,
                        "Nouveau mot de passe",
                        "Entrer le nouveau mot de passe",
                      ),
                      Config.spaceSmall,
                      password(
                        _configPasswordController,
                        "Confirmation du mot de passe",
                        "Confirmer le mot de passe",
                      ),
                      Config.spaceMeduim,

                      // login button

                      Button(
                        width: double.infinity,
                        title: "Confirmation",
                        disable: false,
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          // ignore: unrelated_type_equality_checks
                          if (_configPasswordController.text !=
                              _nouveauPasswordController.text) {
                            setState(() {
                              isLoading = false;
                            });
                            showAlertDialog(
                                context, "Les mots de passe sont différents.");
                          } /*else if (_nouveauPasswordController.text ==
                              decryptAES(patient.password)) {
                            showAlertDialog(context,
                                "Le nouveau mot de passe doit etre different de l'ancien mot de passe");
                          } */
                          else {
                            Patient patient =
                                await Database().getInfoBoxPatient();
                            data = {
                              "password": _nouveauPasswordController.text
                            };
                            //Récupérer le code patient pour l'ajouter URL

                            print(patient.username);
                            sortir = await Api().postApiDeux(
                                Api.modifierMdpUrl(patient.username), data);

                            if (sortir.status == 200) {
                              // Modifier le mot de passe en local
                              patient.password =
                                  _nouveauPasswordController.text;
                              await Database()
                                  .updateBoxPatient(patient.toMapInit());

                              setState(() {
                                isLoading = false;
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                  .pushReplacementNamed("modifInfo");
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              // ignore: use_build_context_synchronously
                              showAlertDialog(context, sortir.message!);
                            }
                            //Navigator.of(context).pushNamed("modifInfo");
                          }
                        },
                        isload: isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Widget password(
      TextEditingController controller, String label, String hintText) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: osbcurePass,
        cursorColor: Colors.black12,
        decoration: InputDecoration(
          border: Config.outLinedBorder,
          focusedBorder: Config.focusBorder,
          errorBorder: Config.errorBorder,
          enabledBorder: Config.outLinedBorder,
          hintText: hintText,
          labelText: label,
          alignLabelWithHint: true,
        ));
  }
}
