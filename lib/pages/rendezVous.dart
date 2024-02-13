import 'package:dpi_mobile/components/buttonFacture.dart';
import 'package:dpi_mobile/components/home/welcome.dart';

import 'package:dpi_mobile/components/rendez-vous/appointListe.dart';
import 'package:dpi_mobile/components/rendez-vous/calenrier.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class AppointPage extends StatefulWidget {
  const AppointPage({super.key});

  @override
  State<AppointPage> createState() => _AppointPageState();
}

class _AppointPageState extends State<AppointPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(vertical: Config.widthSize * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Welcome(
              columnVisible: false,
              selection: true,
            ),
            Expanded(
              // Utilisez Expanded pour que TabBarView occupe tout l'espace vertical disponible
              child: Column(
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorWeight: Config.heightSize * 0.005,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Config.couleurPrincipale,
                    tabs: const [
                      Tab(
                        text: "Calendrier",
                      ),
                      Tab(text: 'Liste'),
                    ],
                  ),
                  Config.spaceSmall,
                  Expanded(
                    // Utilisez Expanded pour que TabBarView occupe tout l'espace vertical disponible
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Config.widthSize * 0.02),
                          child: const Calendrier(),
                        ),
                        const AppointListeApp(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Config.widthSize * 0.50,
                  right: Config.widthSize * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.of(context).pushNamed("prdv");
                    },
                    child: Text(
                      "+",
                      style: TextStyle(
                          fontSize: Config.widthSize * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ButtonFacture(
                    fondBouton: Config.couleurPrincipale,
                    couleurEcriture: Colors.white,
                    title: "Facture",
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
