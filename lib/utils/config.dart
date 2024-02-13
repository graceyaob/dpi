import 'package:flutter/material.dart';

class Config {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  // Utilisez un constructeur privé pour que la classe ne puisse pas être instanciée directement
  Config._();

  // Utilisez une instance statique unique de la classe Config
  static final Config instance = Config._();

  // Méthode pour initialiser les valeurs screenWidth et screenHeight
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  // Propriétés pour accéder à screenWidth et screenHeight
  static get widthSize {
    assert(screenWidth != null,
        'Veuillez appeler init() avant d\'accéder à widthSize');
    return screenWidth!;
  }

  static get heightSize {
    assert(screenHeight != null,
        'Veuillez appeler init() avant d\'accéder à heightSize');
    return screenHeight!;
  }

  static const spaceSmall = SizedBox(
    height: 25,
  );

  static final spaceMeduim = SizedBox(
    height: heightSize * 0.05,
  );

  static final spaceBig = SizedBox(
    height: heightSize * 0.08,
  );

  static const outLinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.grey),
  );

  static const focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.greenAccent),
  );

  static const errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.red),
  );

  static const couleurPrincipale = Color(0xFF2CB3E8);
  static const couleurBoutonSelectionner = Color(0xFFC3EDFD);
}

showAlertDialog(BuildContext context, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(color: Colors.black),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Attention"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
