import 'package:dpi_mobile/components/buttonFacture.dart';
import 'package:dpi_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PriseRdv extends StatefulWidget {
  const PriseRdv({super.key});

  @override
  State<PriseRdv> createState() => _PriseRdvState();
}

//enumeration du statut rendez-vous

class _PriseRdvState extends State<PriseRdv> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    super.initState();
  }

//permet de sélectionner un jour
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime.utc(2045, 12, 31),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Container(
            height: 70,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("08:00-12:00"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("14:00-16:00"),
                    ),
                  ],
                )
              ],
            ),
          ),
          Config.spaceSmall,
          ButtonFacture(
              couleurEcriture: Colors.white,
              fondBouton: Colors.blue,
              title: "                  Valider                     ",
              onPressed: () {
                Navigator.of(context).pushNamed("punrdv");
              })
        ],
      ),
    );
    /*SizedBox(
        height: Config.heightSize * 0.001,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    const Divider(
                      color: Colors.black,
                      thickness: 0.4,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Card(
                      elevation: 6,
                      child: ListTile(
                        title: const Text("Gynecologie"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Hopital General de Bingerville"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "19/10/2023",
                                  style: TextStyle(
                                    color: Config.couleurPrincipale,
                                  ),
                                ),
                                Text("10:00")
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("detail_consultation");
                        },
                      ),
                    )
                  ],
                );
              }),
        ) /*Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gynecologie",
                style: TextStyle(
                    color: Config.couleurPrincipale,
                    fontWeight: FontWeight.w700),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hopital General de Bingerville"),
                  TextButton(onPressed: () {}, child: Text("Détail"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "19/10/2023",
                    style: TextStyle(
                      color: Config.couleurPrincipale,
                    ),
                  ),
                  Text("10:00")
                ],
              )
            ],
          ),
        ),
      ),*/
        );*/
  }
}
