import 'package:dpi_mobile/pages/carnet.dart';
import 'package:dpi_mobile/pages/consultation.dart';
import 'package:dpi_mobile/pages/home.dart';
import 'package:dpi_mobile/pages/pageRecu.dart';
import 'package:dpi_mobile/pages/profil.dart';
import 'package:dpi_mobile/pages/rendezVous.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContainerApp extends StatefulWidget {
  const ContainerApp({Key? key}) : super(key: key);

  @override
  State<ContainerApp> createState() => _ContainerAppState();
}

class _ContainerAppState extends State<ContainerApp> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: const [
          HomePage(),
          ConsultationPage(),
          AppointPage(),
          Profil(),
          Carnet(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          try {
            _pageController.jumpToPage(page);
          } catch (e) {
            debugPrint('Error navigating to page: $e');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.document_text_outline),
            label: 'Consultation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.calendar_outline),
            label: 'Rendez-vous',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.person_outline),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.book_outline),
            label: 'Carnet',
          ),
        ],
      ),
    );
  }
}
