import 'package:dpi_mobile/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dpi_mobile/utils/config.dart';

class ButtonFacture extends StatelessWidget {
  final Color fondBouton;
  final Color couleurEcriture;
  final String title;
  final VoidCallback onPressed;
  final bool? isload;
  const ButtonFacture(
      {super.key,
      required this.couleurEcriture,
      required this.fondBouton,
      required this.title,
      required this.onPressed,
      this.isload});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation:
              MaterialStateProperty.all<double>(8.0), // Élévation du bouton
          backgroundColor: MaterialStateProperty.all<Color>(
              fondBouton), // Couleur de fond du bouton
          foregroundColor: MaterialStateProperty.all<Color>(
              couleurEcriture), // Couleur du texte du bouton
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Rayon du bouton
            ),
          ),
        ),
        onPressed: onPressed,
        child: isload ?? false
            ? const CupertinoActivityIndicator(
                radius: 14,
                color: Colors.white,
              )
            : Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Config.widthSize! * 0.04),
              ));
  }
}
