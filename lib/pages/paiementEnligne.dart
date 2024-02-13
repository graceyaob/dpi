import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Paiement extends StatefulWidget {
  const Paiement({Key? key}) : super(key: key);

  @override
  State<Paiement> createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  Image selectedOption = Image.asset("assets/images/telephone.png");
  String choix = "";
  List<String> items = [
    "assets/images/orangelogo1.png",
    "assets/images/mtn.png",
    "assets/images/moo.png",
    "assets/images/wave.png"
  ];
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payer ici"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Compte à débiter",
                      style: TextStyle(fontSize: Config.widthSize * 0.05),
                    ),
                  ],
                ),
                Config.spaceMeduim,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    elevatedIconButton(
                        "assets/images/telephone.png", "Mobile Money"),
                    elevatedIconButton(
                        "assets/images/carte.png", "Carte Bancaire"),
                  ],
                ),
                Config.spaceMeduim,
                Container(
                  height: Config.heightSize * 0.25,
                  width: Config.widthSize * 0.89,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 241, 237, 237),
                  ),
                  child: Column(
                    children: [
                      Config.spaceSmall,
                      Text("Numéro de téléphone"),
                      Config.spaceSmall,
                      Selection(
                        text1Controller: textEditingController,
                        selectedOption: selectedOption,
                        items: items,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedOption = Image.asset(
                              newValue,
                            );
                            choix = newValue;
                            print(choix);
                          });
                        },
                        textController:
                            (choix == "assets/images/orangelogo1.png")
                                ? "+22507"
                                : (choix == "assets/images/moo.png")
                                    ? "+22501"
                                    : (choix == "assets/images/mtn.png")
                                        ? "+22505"
                                        : (choix == "assets/images/wave.png")
                                            ? ""
                                            : "+22507",
                      ),
                      Config.spaceSmall,
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: (choix == "assets/images/orangelogo1.png")
                            ? Image.asset("assets/images/orangelogo1.png")
                            : (choix == "assets/images/moo.png")
                                ? Image.asset("assets/images/moo.png")
                                : (choix == "assets/images/mtn.png")
                                    ? Image.asset("assets/images/mtn.png")
                                    : (choix == "assets/images/wave.png")
                                        ? Image.asset("assets/images/wave.png")
                                        : Image.asset(
                                            "assets/images/orangelogo1.png"),
                      )
                    ],
                  ),
                ),
                Config.spaceMeduim,
                SizedBox(
                  height: 55,
                  width: Config.widthSize * 0.89,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Config
                              .couleurPrincipale), // Couleur de fond du bouton
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
                              borderRadius: BorderRadius.circular(
                                  5.0), // Bord arrondi du bouton
                            ),
                          )),
                      child: Text("Payer 1500 FCFA"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("recu");
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Selection extends StatefulWidget {
  final Image selectedOption;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String textController;
  final TextEditingController text1Controller;

  const Selection({
    required this.selectedOption,
    required this.items,
    required this.onChanged,
    required this.textController,
    required this.text1Controller,
    Key? key,
  }) : super(key: key);

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  TextEditingController testController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testController.text = widget.textController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Config.widthSize * 0.83,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle, border: Border.all(color: Colors.black87)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Config.widthSize * 0.02,
          ),
          SizedBox(
            width: Config.widthSize * 0.2,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(border: InputBorder.none),
              value: widget.items[0],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  widget.onChanged(newValue);
                }
              },
              items: widget.items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: SizedBox(
                    width: Config.widthSize * 0.7,
                    child: Row(
                      children: [
                        Image.asset(
                          item,

                          height: Config.widthSize *
                              0.1, // Ajustez la hauteur de l'image
                        ),
                        SizedBox(
                          height: Config.widthSize * 0.2,
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
              isExpanded:
                  true, // Permet au DropdownButtonFormField de s'étendre à la largeur maximale
            ),
          ),
          Row(
            children: [
              Container(
                width: Config.widthSize * 0.16,
                height: Config.heightSize * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextFormField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: testController,
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                width: Config.widthSize * 0.438,
                height: Config.heightSize * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: widget.text1Controller,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  decoration: InputDecoration(
                      border: InputBorder.none, counterText: ""),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    testController.dispose();
    super.dispose();
  }
}

Widget elevatedIconButton(String image, String text) {
  return InkWell(
    onTap: () {
      // Gérer l'événement lors du clic sur l'IconButton
      print('IconButton cliqué');
    },
    child: Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape
            .rectangle, // Utilisez BoxShape.circle pour rendre le conteneur circulaire
        color: Colors.white, // Couleur de fond du bouton
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Ombre du bouton
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // Décalage de l'ombre
          ),
        ],
      ),
      child: SizedBox(
        width: Config.heightSize * 0.15, // Largeur du conteneur
        height: Config.heightSize * 0.1, // Hauteur du conteneur

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: Config.heightSize *
                    0.06, // Taille de l'image à l'intérieur du conteneur
                color: Config.couleurPrincipale,
              ),
              Text(text)
            ],
          ),
        ),
      ),
    ),
  );
}
