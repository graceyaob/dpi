import 'package:flutter/material.dart';
import 'package:dpi_mobile/utils/config.dart';

class ButtonIcon extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback onPressed;
  final Color colorFond;
  final Color colorText;

  const ButtonIcon(
      {super.key,
      required this.icon,
      required this.title,
      required this.onPressed,
      required this.colorFond,
      required this.colorText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFond,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            icon,
            SizedBox(
              width: Config.widthSize * 0.03,
            ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Config.widthSize! * 0.04,
                  color: colorText),
            )
          ],
        ));
  }
}
