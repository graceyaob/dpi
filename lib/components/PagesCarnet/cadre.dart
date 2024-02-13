import 'package:dpi_mobile/components/imageProfil.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class Cadre extends StatelessWidget {
  Cadre({super.key, required this.titre});
  String titre;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        children: [
          Container(
            height: Config.heightSize * 0.3,
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: Config.heightSize * 0.25,
            decoration: const BoxDecoration(
                color: Config.couleurPrincipale,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(600),
                    bottomRight: Radius.circular(600))),
            child: Text(
              "Mon Carnet Numérique",
              style: TextStyle(
                  color: Colors.white, fontSize: Config.widthSize * 0.06),
            ),
          ),
          Positioned(
            bottom: Config.heightSize * 0.0005,
            right: Config.widthSize * 0.38,
            child: const CadrePhoto(raduis: 50),
          ),
        ],
      ),
      Config.spaceSmall,
      Text(
        titre,
        style: TextStyle(
            color: Config.couleurPrincipale,
            fontSize: Config.widthSize * 0.045),
      ),
      Config.spaceSmall
    ]);
  }
}
