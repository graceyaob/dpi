import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class ErrorFunction extends StatelessWidget {
  ErrorFunction({super.key, required this.message, required this.height});
  String message;
  double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/images/recherche.jpg",
            height: height,
          ),
          Config.spaceSmall,
          Text(message)
        ],
      ),
    );
  }
}
