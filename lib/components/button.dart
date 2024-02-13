import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  Button(
      {super.key,
      required this.width,
      required this.title,
      required this.disable,
      required this.onPressed,
      this.isload});

  final double width;
  final String title;
  final bool disable;
  final VoidCallback onPressed;
  bool? isload;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Config.couleurPrincipale,
          borderRadius: BorderRadius.circular(30)),
      width: width,
      child: ElevatedButton(
        onPressed: disable ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Config.couleurPrincipale,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize:
              Size(Config.screenWidth! * 6, Config.screenHeight! * 0.07),
        ),
        child: isload ?? false
            ? const CupertinoActivityIndicator(
                radius: 14,
                color: Colors.white,
              )
            : Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }
}
