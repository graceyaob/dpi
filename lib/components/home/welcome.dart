import 'package:dpi_mobile/components/home/buttonIcon.dart';
import 'package:dpi_mobile/components/imageProfil.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:dpi_mobile/data/database/config.dart';

class Welcome extends StatefulWidget {
  const Welcome(
      {super.key, required this.columnVisible, required this.selection});
  final bool columnVisible;
  final bool selection;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String nom = "";
  String prenom = "";

  @override
  void initState() {
    Database().getInfoBoxPatient().then((value) {
      if (mounted) {
        setState(() {
          nom = value.nom + " " + value.prenoms;
          prenom = value.prenoms;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
            color: Colors.grey.withOpacity(0.05),
            border: Border.all(color: Colors.white, width: 2)),
        height: widget.columnVisible
            ? Config.heightSize * 0.30
            : Config.heightSize * 0.20,
        width: constraints.maxWidth,
        child: Column(
          children: [
            //ligne des notifications
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // image et nom
                  Row(
                    children: [
                      const CadrePhoto(raduis: 30),
                      text(Colors.black, nom)
                    ],
                  ),
                  //icone notification
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                  )
                ],
              ),
            ),

            //groupe sanguin
            Container(
              width: 68,
              height: 35,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(75), right: Radius.circular(75)),
                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white)]),
              child: Row(
                children: [
                  Image.asset("assets/images/goutte-de-sang.png"),
                  text(const Color(0xFFED0010), "O+")
                ],
              ),
            ),

            //Mot de bienvenue
            Visibility(
              visible: widget.columnVisible,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(const Color(0xFF655F5F),
                      "Comment-Allez vous Aujourd'hui"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(Config.couleurPrincipale, prenom),
                      text(const Color(0xFF655F5F), "?")
                    ],
                  ),
                ],
              ),
            ),
            Config.spaceSmall,
            //bloc bouton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonIcon(
                  icon: Icon(
                    Ionicons.calendar_outline,
                  ),
                  title: "RDV",
                  onPressed: () {
                    Navigator.of(context).pushNamed("rdv");
                  },
                  colorFond: widget.selection
                      ? Config.couleurBoutonSelectionner
                      : Config.couleurPrincipale,
                  colorText: widget.selection
                      ? Config.couleurPrincipale
                      : Colors.white,
                ),
                ButtonIcon(
                  icon: const Icon(Ionicons.document_text_outline),
                  title: "Consultation",
                  onPressed: () {
                    Navigator.of(context).pushNamed("consultation");
                  },
                  colorFond: Config.couleurPrincipale,
                  colorText: Colors.white,
                )
              ],
            )
          ],
        ),
      );
    });
  }

  Widget text(
    Color couleur,
    String text,
  ) {
    return Text(
      text,
      style: TextStyle(
          color: couleur,
          fontSize: Config.widthSize * 0.04,
          fontWeight: FontWeight.bold),
    );
  }
}
