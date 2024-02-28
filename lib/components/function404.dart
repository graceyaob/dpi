import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class ErrorFunction extends StatelessWidget {
  ErrorFunction({super.key, required this.message});
  String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("assets/images/recherche.jpg"),
          Config.spaceSmall,
          Text(message)
        ],
      ),
    );
  }
}
