import 'dart:async';

import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/data/models/models_api.dart';
import 'package:dpi_mobile/data/models/models_database.dart';
import 'package:dpi_mobile/utils/chiffrer.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  Login({super.key, required this.visibility});
  bool visibility = true;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _isnController = TextEditingController();
  final _passwordController = TextEditingController();
  bool osbcurePass = true;
  bool isLoading = false;
  Map data = {};
  Map responseData = {};
  ResponseRequest sortir = ResponseRequest(status: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "DPI MOBILE",
                style: GoogleFonts.poppins(
                    color: Config.couleurPrincipale,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Container(
                margin: EdgeInsets.only(top: 80),
                padding: EdgeInsets.only(top: 50, left: 50, right: 50),
                height: 660,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Color.fromARGB(255, 241, 237, 237),
                ),
                child: Column(children: [
                  Text(
                    "Bienvenue",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Config.spaceSmall,
                  SvgPicture.asset(
                    "assets/images/login.svg",
                    height: 200,
                  ),
                  Config.spaceSmall,
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // formulaire de connexion
                          Visibility(
                            visible: widget.visibility,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: TextFormField(
                                controller: _isnController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black12,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Code Patient",
                                  labelText: "Code Patient",
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                          Config.spaceSmall,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: osbcurePass,
                              cursorColor: Colors.black12,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Mot de passe",
                                  labelText: "Mot de passe",
                                  alignLabelWithHint: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          osbcurePass = !osbcurePass;
                                        });
                                      },
                                      icon: osbcurePass
                                          ? const Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.black38,
                                            )
                                          : const Icon(
                                              Icons.visibility_outlined,
                                              color: Config.couleurPrincipale,
                                            ))),
                            ),
                          ),

                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Mot de passe,oublié?",
                              style: TextStyle(color: Config.couleurPrincipale),
                            ),
                          ),

                          Container(
                            height: 55,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(Config
                                          .couleurPrincipale), // Couleur de fond du bouton
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), // Style du texte du bouton

                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Bord arrondi du bouton
                                    ),
                                  )),
                              child: Text("Connexion"),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                data = {
                                  "username": _isnController.text,
                                  "password": _passwordController.text
                                };
                                Patient databdlocal =
                                    await Database().getInfoBoxPatient();
                                print(databdlocal.firstLogin);

                                //si first login == true alors tu appelles l'Api du back(internet)
                                if (databdlocal.firstLogin == true) {
                                  sortir = await Api()
                                      .postApiUn(Api.loginUrl(), data);
                                  if (sortir.status == 200) {
                                    responseData = sortir.data!;
                                    responseData['username'] =
                                        _isnController.text;
                                    responseData['password'] =
                                        (_passwordController.text);

                                    //j'insère les données dans la base de donnée locale
                                    await Database().insertAfterLoginBoxPatient(
                                        responseData);

                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context)
                                        .pushReplacementNamed("modifier");
                                  } else {
                                    print(data);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    // ignore: use_build_context_synchronously
                                    showAlertDialog(context, sortir.message!);
                                  }
                                } else {
                                  //connection à la base de donnée local
                                  print(databdlocal.username);

                                  print(encryptAES(_passwordController.text));
                                  // verification des champs de saisis avec les données de la base de donnée
                                  if ((_isnController.text ==
                                          databdlocal.username) &&
                                      (_passwordController.text ==
                                          databdlocal.password)) {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    //verification de la validité du token
                                    int timeDifference = Database()
                                        .calculateTimeDifference(
                                            databdlocal.timer);
                                    if (timeDifference < 20) {
                                      Navigator.of(context)
                                          .pushReplacementNamed("main");
                                    }
                                    // si token invalide appelle à l'api
                                    else {
                                      sortir = await Api()
                                          .postApiUn(Api.loginUrl(), data);
                                      if (sortir.status == 200) {
                                        responseData = sortir.data!;

                                        responseData = sortir.data!;
                                        responseData['username'] =
                                            _isnController.text;
                                        responseData['password'] =
                                            (_passwordController.text);

                                        //j'insère les données dans la base de donnée locale
                                        await Database()
                                            .insertAfterLoginBoxPatient(
                                                responseData);
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.of(context)
                                            .pushReplacementNamed("main");
                                      } else {
                                        print(data);
                                        setState(() {
                                          isLoading = false;
                                        });
                                        // ignore: use_build_context_synchronously
                                        showAlertDialog(
                                            context, sortir.message!);
                                      }
                                    }
                                  }
                                  //si tout est ok c'est qu'il y'a donc une erreur dans tes accès
                                  else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showAlertDialog(context,
                                        "l'un des identifiant est incorrecte");
                                  }
                                }
                                /*sortir =
                                    await Api().postApiUn(Api.loginUrl(), data);
                                if (sortir.status == 200) {
                                  responseData = sortir.data!;
                                  responseData['username'] =
                                      _isnController.text;
                                  responseData['password'] =
                                      encryptAES(_passwordController.text);
                                  

                                  await Database()
                                      .insertAfterLoginBoxPatient(responseData);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (responseData['first_login'] == true) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pushReplacementNamed("modifier");
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pushReplacementNamed("main");
                                  }
                                } else {
                                  print("Bonjour");
                                  print(data);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // ignore: use_build_context_synchronously
                                  showAlertDialog(context, sortir.message!);
                                }*/
                                isload:
                                isLoading;
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Inscription",
                                style:
                                    TextStyle(color: Config.couleurPrincipale),
                              ))
                        ],
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
