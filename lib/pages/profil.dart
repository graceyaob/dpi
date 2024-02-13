import 'package:dpi_mobile/components/profil/choixPhoto.dart';
import 'package:dpi_mobile/components/profil/login_form_profil.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({
    super.key,
  });

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool isObscurePassword = true;
  String textAppbar = "Profil";
  bool write = false;
  bool visibilite = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              textAppbar,
              style: TextStyle(
                  color: Config.couleurPrincipale,
                  fontSize: Config.widthSize * 0.05),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Mettez ici le code à exécuter lorsque l'élément du menu est sélectionné
                if (value == "Mdp") {
                  Navigator.of(context).pushNamed("modifier");
                } else {
                  Navigator.of(context).pushNamed("modifInfo");
                }
                print('Élément sélectionné: $value');
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'ModifInfo',
                    child: Text('Modifier les infos'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Mdp',
                    child: Text('Modifier le mot de passe'),
                  ),
                  // Ajoutez d'autres éléments de menu au besoin
                ];
              },
              icon: const Icon(
                Icons.settings,
                color: Config.couleurPrincipale,
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/images/portrait_femme.jpg")),
                        )),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Config.couleurPrincipale),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => const ChoixPhoto()));
                            },
                          ),
                        ))
                  ],
                ),
              ),
              LoginFormProfil(),
            ],
          ),
        )));
  }
}
