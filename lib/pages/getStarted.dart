import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int currentindex = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map> contents = [
      {
        "image": "assets/images/started1.svg",
        "text": RichText(
          text: TextSpan(
            text: "L'application mobile qui ",
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
            children: [
              TextSpan(
                  text: 'simplifie ',
                  style: GoogleFonts.poppins(color: Config.couleurPrincipale)),
              TextSpan(
                text: 'la vie du ',
              ),
              TextSpan(
                  text: 'patient ',
                  style: GoogleFonts.poppins(color: Config.couleurPrincipale)),
              TextSpan(
                text: 'dans les services de santé ',
              ),
              TextSpan(
                  text: '!',
                  style: GoogleFonts.poppins(
                      color: Config.couleurPrincipale,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      },
      {
        "image": "assets/images/numerique.svg",
        "text": RichText(
          text: const TextSpan(
            text: "DPI MOBILE, Du physique ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            children: [
              TextSpan(
                text: '=> ',
                style: TextStyle(
                  color: Config.couleurPrincipale,
                ),
              ),
              TextSpan(
                text: 'Au numérique ',
              ),
            ],
          ),
        ),
      },
      {
        "image": "assets/images/changement.svg",
        "text": RichText(
          text: const TextSpan(
            text: "carnet médical:  ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            children: [
              TextSpan(
                text: "c'est géré,Zoooooo ",
                style: TextStyle(
                  color: Config.couleurPrincipale,
                ),
              ),
            ],
          ),
        ),
      },
      {
        "image": "assets/images/rdv.svg",
        "text": RichText(
          text: const TextSpan(
            text: "Prise de ticket de consultation et de rendez vous oh: ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            children: [
              TextSpan(
                text: "c'est Zoo ",
                style: TextStyle(
                  color: Config.couleurPrincipale,
                ),
              ),
            ],
          ),
        ),
      },
      {
        "image": "assets/images/leger.svg",
        "text": RichText(
          text: const TextSpan(
            text: "J'effectue mes opération médical via mon application ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            children: [
              TextSpan(
                text: 'DPI MOBILE ',
                style: TextStyle(
                  color: Config.couleurPrincipale,
                ),
              ),
            ],
          ),
        ),
      },
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (int index) {
                setState(() {
                  currentindex = index;
                });
              },
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "DPI MOBILE",
                        style: GoogleFonts.poppins(
                            color: Config.couleurPrincipale,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      SvgPicture.asset(
                        contents[i]["image"],
                        height: 400,
                      ),
                      contents[i]["text"]
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(contents.length, (index) => builDot(index)),
            ),
          ),
          Container(
            margin: EdgeInsets.all(40),
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Config.couleurPrincipale), // Couleur de fond du bouton
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Style du texte du bouton

                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Bord arrondi du bouton
                    ),
                  )),
              child: Text(
                  currentindex == contents.length - 1 ? "Commencer" : "Next"),
              onPressed: () {
                if (currentindex == contents.length - 1) {
                  Navigator.of(context).pushReplacementNamed("login");
                }
                pageController.nextPage(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.bounceIn);
              },
            ),
          )
        ]),
      ),
    );
  }

  Container builDot(int index) {
    return Container(
      height: 10,
      width: currentindex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Config.couleurPrincipale),
    );
  }
}
