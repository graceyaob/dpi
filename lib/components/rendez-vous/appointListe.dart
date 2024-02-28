import 'package:dpi_mobile/components/function404.dart';
import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:flutter/material.dart';

class AppointListeApp extends StatefulWidget {
  const AppointListeApp({super.key});

  @override
  State<AppointListeApp> createState() => _AppointListeAppState();
}

class _AppointListeAppState extends State<AppointListeApp> {
  String id = "";
  List rdv = [];
  bool unrdv = true;

  @override
  void initState() {
    Database().getInfoBoxPatient().then((value) {
      setState(() {
        id = value.id;
        Api().getApi(Api.rendezVousUrl(id)).then((value) {
          setState(() {
            if (value == 404) {
              unrdv = false;
            } else {
              rdv = value;
            }

            print(rdv);
          });
        });
      });
    });

    super.initState();
  }

  Future<List<DataRow>> buildrdvRows(List rdv) async {
    List<DataRow> rows = [];

    for (int index = 0; index < rdv.length; index++) {
      Map unRdv = rdv[index];
      DateTime date = DateTime.parse('${unRdv["datePrevue"]}');
      String centre = await Api()
          .getApi(Api.centreSanteByIdUrl(unRdv["centresante"]))
          .then((value) => value["libelle"]);
      String heureDebut = unRdv["heureDebut"];
      String heureFin = unRdv["heureFin"];
      var servicerecupere = unRdv["service"];
      String service = "";

      if (servicerecupere == null || service.isEmpty) {
        service = "Medecine Génerale";
      } else {
        service = await Api()
            .getApi(Api.serviceByIdUrl(servicerecupere))
            .then((value) => value["libelle"]);
      }

      if (unRdv["rendezvous"] == false && unRdv["annuler"] == false) {
        rows.add(DataRow(
          cells: [
            DataCell(Text('${date.day}-${date.month}-${date.year}')),
            DataCell(Text('$service')),
            DataCell(Text('$centre')),
            DataCell(Text('$heureDebut - $heureFin')),
          ],
        ));
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: unrdv
            ? FutureBuilder<List<DataRow>>(
                future: buildrdvRows(rdv),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DataRow>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur: ${snapshot.error}"));
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text("service")),
                          DataColumn(label: Text('Centre')),
                          DataColumn(label: Text('Heure')),
                        ],
                        rows: snapshot.data!,
                      ),
                    );
                  }
                },
              )
            : ErrorFunction(message: "Aucun rendez-vous trouvé"),
      ),
    );
  }
}
