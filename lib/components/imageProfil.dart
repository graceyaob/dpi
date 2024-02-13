import 'package:flutter/material.dart';

class CadrePhoto extends StatelessWidget {
  const CadrePhoto({super.key, required this.raduis});
  final double raduis;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: raduis,
      backgroundImage: const AssetImage(
        "assets/images/portrait_femme.jpg",
      ),
    );
  }
}
