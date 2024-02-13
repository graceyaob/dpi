import 'package:dpi_mobile/components/PagesCarnet/constantes.dart';
import 'package:dpi_mobile/components/PagesCarnet/examens.dart';
import 'package:dpi_mobile/components/PagesCarnet/interrogatoire.dart';
import 'package:dpi_mobile/components/PagesCarnet/prescriptions.dart';
import 'package:flutter/material.dart';

class ContainerCarnet extends StatefulWidget {
  const ContainerCarnet({super.key});

  @override
  State<ContainerCarnet> createState() => _ContainerCarnetState();
}

int currentPage = 0; //position des pages
PageController _pageController = PageController(); //le controlleur des pages

class _ContainerCarnetState extends State<ContainerCarnet> {
  @override
  void initState() {
    // TODO: implement initState
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
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: const [
          Constante(),
          Interrogatoire(),
          Examens(),
          Prescriptions(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan,
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _pageController.jumpToPage(page);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: buildTabIcon("assets/images/statistiques(2).png"),
            label: "Vos constantes",
          ),
          BottomNavigationBarItem(
              icon: buildTabIcon("assets/images/ordonnance(1).png"),
              label: "Symptomes-Diagnostiques"),
          BottomNavigationBarItem(
              icon: buildTabIcon("assets/images/une-analyse(1).png"),
              label: "Examens"),
          BottomNavigationBarItem(
              icon: buildTabIcon("assets/images/ordonnance(1).png"),
              label: "Prescriptions")
        ],
      ),
    );
  }

  Widget buildTabIcon(String imagePath) {
    return Container(
      //margin: EdgeInsets.only(top: 5),
      width: 30,
      height: 30,
      child: Stack(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          Center(
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
