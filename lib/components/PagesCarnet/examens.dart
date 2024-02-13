import 'package:flutter/material.dart';

class Examens extends StatefulWidget {
  const Examens({super.key});

  @override
  State<Examens> createState() => _ExamensState();
}

class _ExamensState extends State<Examens> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Examen"),
    );
  }
}
