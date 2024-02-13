import 'package:dpi_mobile/components/connexion/modifier_MDP.dart';
import 'package:dpi_mobile/components/rendez-vous/priseRDV.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:dpi_mobile/components/PagesCarnet/containerCarnet.dart';
import 'package:dpi_mobile/pages/consultation.dart';
import 'package:dpi_mobile/pages/containerApp.dart';
import 'package:dpi_mobile/pages/detailRecu.dart';
import 'package:dpi_mobile/pages/getStarted.dart';
import 'package:dpi_mobile/pages/login.dart';
import 'package:dpi_mobile/pages/modifInfo.dart';
import 'package:dpi_mobile/pages/pageRecu.dart';
import 'package:dpi_mobile/pages/paiementEnligne.dart';
import 'package:dpi_mobile/pages/rendezVous.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

int? islogged;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Database().initDatabase();
  int test = await Database().isLoggedBoxPatient();
  islogged = test;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Config.instance.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DPI MOBILE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Config.couleurPrincipale,
            selectedItemColor: Colors.white,
            showSelectedLabels: false,
            unselectedItemColor: Colors.black54,
            elevation: 10,
            type: BottomNavigationBarType.fixed),
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.couleurPrincipale,
            floatingLabelStyle: TextStyle(color: Config.couleurPrincipale)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Config.couleurPrincipale,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GetStarted(),
        "login": (context) => Login(
              visibility: true,
            ),
        'main': (context) => const ContainerApp(),
        'modifier': (context) => const LoginModif(),
        'modifInfo': (context) => const ModiInfo(),
        'prdv': (context) => const PriseRdv(),
        'consultation': (context) => const ConsultationPage(),
        'rdv': (context) => const AppointPage(),
        "baseCarnet": (context) => const ContainerCarnet(),
        "paiement": (context) => const Paiement(),
        "recu": (context) => const RecuPaiement(),
        "detailRecu": (context) => const DetailRecu()
      },
    );
  }
}
