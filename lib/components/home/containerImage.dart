import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class ContainerImage extends StatelessWidget {
  final String image;
  final String titre;
  final String valeur;
  const ContainerImage(
      {super.key,
      required this.image,
      required this.titre,
      required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        child: Container(
          width: Config.widthSize * 0.36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    spreadRadius: 5,
                    color: Colors.white,
                    offset: Offset(0, 3),
                    blurRadius: 7)
              ],
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2)),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titre,
                style: TextStyle(
                    fontSize: Config.widthSize * 0.04,
                    fontWeight: FontWeight.w400),
              ),
              Image(
                height: 50,
                image: AssetImage(image),
                color: Config.couleurPrincipale,
              ),
              Text(
                valeur,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Config.widthSize * 0.04),
              )
            ],
          ),
        ));
  }
}
