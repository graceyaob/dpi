import 'package:dpi_mobile/data/api/api.dart';
import 'package:dpi_mobile/data/database/config.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class Calendrier extends StatefulWidget {
  const Calendrier({Key? key});

  @override
  State<Calendrier> createState() => _CalendrierState();
}

class _CalendrierState extends State<Calendrier> {
  late List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    List<Appointment> appointments = await getAppointments();
    setState(() {
      _appointments = appointments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 1,
        dataSource: AppointSource(_appointments),
        // fonction pour afficher un boite a dialogue pour rendre les details des rendez vous visible
        onTap: (CalendarTapDetails details) {
          if (details.appointments != null &&
              details.appointments!.isNotEmpty) {
            // Afficher une boîte de dialogue lorsque l'utilisateur clique sur un rendez-vous
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // Créer et retourner la boîte de dialogue
                return AlertDialog(
                  title: Text("Rendez-vous"),
                  content:
                      Text("Description: ${details.appointments![0].subject}"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Fermer la boîte de dialogue
                      },
                      child: Text('Fermer'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<List<Appointment>> getAppointments() async {
  String id = await Database().getInfoBoxPatient().then((value) => value.id);
  List rendez =
      await Api().getApi(Api.rendezVousUrl(id)).then((value) => value);

  List<Appointment> rdvs = <Appointment>[];
  for (int index = 0; index < rendez.length; index++) {
    Map unRdv = rendez[index];
    DateTime rdv = DateTime.parse('${unRdv["datePrevue"]}');

    String heureDebut = unRdv["heureDebut"];
    DateTime startime = DateFormat('HH:mm:ss').parse(heureDebut);
    startime = DateTime(rdv.year, rdv.month, rdv.day, startime.hour,
        startime.minute, startime.second);
    String heureFin = unRdv["heureFin"];
    DateTime endtime = DateFormat('HH:mm:ss').parse(heureFin);
    startime = DateTime(rdv.year, rdv.month, rdv.day, startime.hour,
        startime.minute, startime.second);
    String centre = await Api()
        .getApi(Api.centreSanteByIdUrl(unRdv["centresante"]))
        .then((value) => value["libelle"]);

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
      rdvs.add(Appointment(
          startTime: startime,
          endTime: endtime,
          subject:
              'rendez-vous en $service à $centre de $heureDebut  - $heureFin',
          color: Colors.blue));
    }
  }

  return rdvs;
}

class AppointSource extends CalendarDataSource {
  AppointSource(List<Appointment> source) {
    appointments = source;
  }
}
