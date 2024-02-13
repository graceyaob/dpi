import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChoixPhoto extends StatefulWidget {
  //final Function(XFile?) onImagePicked; // Ajout de la fonction de rappel

  const ChoixPhoto({
    Key? key,
    /*required this.onImagePicked*/
  }) : super(key: key);

  @override
  State<ChoixPhoto> createState() => _ChoixPhotoState();
}

class _ChoixPhotoState extends State<ChoixPhoto> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.heightSize * 0.12,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        vertical: Config.widthSize * 0.02,
        horizontal: Config.widthSize * 0.05,
      ),
      child: Column(
        children: [
          Text(
            "Choisir la photo de profil",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  changerImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  changerImage(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Galerie"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void changerImage(ImageSource source) async {
    final XFile? pickerFile = await imagePicker.pickImage(source: source);

    if (pickerFile != null) {
      setState(() {
        _pickedFile = pickerFile;
      });

      // Utilisez la fonction de rappel pour passer le fichier sélectionné à l'écran précédent
      //widget.onImagePicked(_pickedFile);
    }
  }
}
