import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class UpdateReservation extends StatefulWidget {
  const UpdateReservation({super.key});

  @override
  State<UpdateReservation> createState() => _UpdateReservationState();
}

class _UpdateReservationState extends State<UpdateReservation> {
  DateTime? selectedTime;
  Map Liste_Service = {};
  Map reservations = {}; // L Information sur le service en question
  int duree = 30;
  String heure = '';
  bool verif = false;
  bool loading = false;
  DateTime today = DateTime.now();
  TextEditingController _ControlCoupon = TextEditingController();
  // Lister les differents services de l'entreprise
  List Photos = [];

  Future<dynamic> Verification() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final url = monurl("verifieReservation");
      final uri = Uri.parse(url);

      final response = await http.post(uri,
          body: jsonEncode({
            'service_id': prefs.getInt('id_service'),
            'user_id': prefs.getInt('id'),
            'heure': heure,
            'date':
                "${today.year.toString().split(" ")[0]}-${today.month.toString().split(" ")[0]}-${today.day.toString().split(" ")[0]}",
          }),
          headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);
      // print(resultat);
      setState(() {
        verif = resultat['status'];
      });
      print(verif);
      if (!resultat['status']) {
        message(context, "Heure disponible",
            const Color.fromARGB(255, 205, 229, 249));
        // ignore: use_build_context_synchronously
        showModalBottomSheet(
            // isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Scaffold(
                bottomNavigationBar: BottomAppBar(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Titre("${Liste_Service['tarif']} FCFA", 15,
                              Colors.black),
                          Titre(
                              "${Liste_Service['libelle']}(${Liste_Service['duree']}h) ",
                              12,
                              Colors.black),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () {
                            print("object");
                            setState(() {
                              loading = !loading;
                            });

                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: SpinKitCircle(
                                      color: Colors.black,
                                    ),
                                  );
                                });

                            // Reserver();
                          },
                          child: Mytext("Valider", 15, Colors.white))
                    ],
                  ),
                ),
                appBar: AppBar(
                  title: Titre('Verifiez et confirmez', 18, Colors.black),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Center(
                        //     child: Titre(
                        //         "Verifiez et confirmez", 25, Colors.black)),
                        const SizedBox(
                          height: 10,
                        ),
                        // Text.rich(TextSpan(
                        //     text: "Cliquer sur",
                        //     style: GoogleFonts.openSans(fontSize: 15),
                        //     children: [
                        //       TextSpan(
                        //           text: " 'Valider' ",
                        //           style: GoogleFonts.openSans(
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 15)),
                        //       TextSpan(
                        //           text:
                        //               " si vous êtes  d'accord avec les informations de votre reservation.",
                        //           style: GoogleFonts.openSans(fontSize: 15))
                        //     ])),
                        // Center(
                        //     child: Titre(
                        //         "Prenez le temps de bien  vérifier les informations avant de 'Valider'",
                        //         15,
                        //         Colors.red)),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(children: [
                            Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.network(
                                  Photos.isEmpty
                                      ? 'https://via.placeholder.com/200'
                                      : ImgDB(
                                          "public/image/${Liste_Service['photos'][0]['path']}",
                                        ),
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Titre("${Liste_Service['libelle']}", 18,
                                    Colors.black),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      for (var i = 0;
                                          i < Liste_Service['moyenne'];
                                          i++)
                                        Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Colors.black,
                                        )
                                    ],
                                  ),
                                ),
                                Mytext(
                                    "${Liste_Service['moyenne']} (${Liste_Service['notes'].toString().length})",
                                    15,
                                    Color.fromARGB(96, 59, 57, 57))
                              ],
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.calendarDays,
                              color: const Color.fromARGB(255, 111, 110, 110),
                            ),
                            title: Mytext('${today.toString().split(" ")[0]}',
                                15, const Color.fromARGB(255, 111, 110, 110))),
                        ListTile(
                            leading: FaIcon(FontAwesomeIcons.clock),
                            title: Mytext(
                                "${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}",
                                15,
                                const Color.fromARGB(255, 111, 110, 110))),
                        ListTile(
                            leading: FaIcon(FontAwesomeIcons.hourglass),
                            title: Titre('${Liste_Service['duree']}h', 15,
                                const Color.fromARGB(255, 111, 110, 110))),

                        // ListTile(
                        //     leading:Icon(Icons.event),
                        //     title: Mytext('${Liste_Service['libelle']}', 15,
                        //         const Color.fromARGB(255, 111, 110, 110))),
                        Divider(),
                        Row(
                          children: [
                            Mytext("Total", 15, Colors.black),
                            Spacer(),
                            Titre("${Liste_Service['tarif']} FCFA", 18,
                                Colors.black),
                          ],
                        ),
                        Row(
                          children: [
                            Mytext("Payer maintenant", 15, Colors.green),
                            Spacer(),
                            Mytext("0 FCFA", 18, Colors.green),
                          ],
                        ),
                        Row(
                          children: [
                            Mytext("Payer sur place", 15, Colors.black),
                            Spacer(),
                            Mytext("${Liste_Service['tarif']}FCFA", 18,
                                Colors.black),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Titre("Mode de payement", 20, Colors.black),
                        Mytext(
                            "Le reglement s'effectuera sur place à la fin  de votre rendez-vous",
                            15,
                            Colors.black),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border:
                                      Border.all(width: 1, color: Colors.blue)),
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.store,
                                size: 20,
                              )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Mytext("Payer sur place", 15, Colors.black)
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Mytext("Entrez votre code coupon", 15, Colors.black),
                        TextFormField(
                          controller: _ControlCoupon,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Code du coupon"),
                          ),
                        ),

                        // Card(
                        //   color: Colors.white,
                        //   child: ListTile(
                        //       leading: Mytext("Tarif : ", 18, Colors.black),
                        //       title: Titre('${Liste_Service['tarif']} FCFA', 20,
                        //           Colors.red)),
                        // ),
                        // Card(
                        //   color: Colors.white,
                        //   child: ListTile(
                        //       leading: Mytext("Duree: ", 18, Colors.black),
                        //       title: Titre('${Liste_Service['duree']}H', 20,
                        //           Colors.red)),
                        // ),
                        // Card(
                        //   color: Colors.white,
                        //   child: ListTile(
                        //       leading: Mytext("Date :", 18, Colors.black),
                        //       title: Titre(
                        //           ' ${controller.today.toString().split(" ")[0]}',
                        //           20,
                        //           Colors.red)),
                        // ),
                        // Card(
                        //   color: Colors.white,
                        //   child: ListTile(
                        //       leading: Mytext("Heure : ", 18, Colors.black),
                        //       title: Titre('${""}', 20, Colors.red)),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        message(context, 'Heure  déja pris par un autre', Colors.red);
      }
    } catch (e) {
      print("Erreur lors de la réservation: ${e}");
      return null;
    }
  }

  String Mesdates = "";
  String here = "";
  List Dates = [];
  List<DateTime> disabledDaysList = [];
  Future<void> GetReservation() async {
    final prefs = await SharedPreferences.getInstance();
    var url = monurl("reservations");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header("${prefs.get('token')}"));
    final result = jsonDecode(response.body);
    final data = result['data'];

    for (var element in data) {
      String Mesdates = element['date'];
      String here = element['heure'];

      // Convertir la date au format 'yyyy-MM-dd' en objet DateTime
      DateTime Vdate = DateTime.parse(Mesdates);

      // Convertir l'heure au format 'HH:mm:ss' en objet TimeOfDay
      List<int> timeComponents = here.split(':').map(int.parse).toList();
      TimeOfDay heure =
          TimeOfDay(hour: timeComponents[0], minute: timeComponents[1]);

      Map<String, dynamic> dateInfo = {
        'date': Vdate,
        'heure': heure,
      };

      Dates.add(dateInfo);
    }

    print(Dates);

    print(Dates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Titre("Selectionnez l'heure", 25, Colors.black),
              SizedBox(
                height: 30,
              ),
              Container(
                // height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[100],
                ),
                child: 
                TableCalendar(
                  locale: 'fr_FR',
                  focusedDay: today,
                  firstDay: DateTime.now(),
                  
                  lastDay: DateTime.utc(2024, 12, 31),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableGestures: AvailableGestures.all,
                  onDaySelected: (selectedDay, focusedDay) async {
                    setState(() {
                      today = selectedDay;
                    });
                  },
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  enabledDayPredicate: (DateTime day) {
                    // Liste de jours à désactiver

                    // Vérifie si le jour actuel est dans la liste des jours désactivés
                    return day.weekday != DateTime.sunday;
                  },
                ),
              ),
              Text(DateFormat.yMMMd('fr_FR').format(today)),
              SizedBox(
                height: 20,
              ),
              
              ElevatedButton(
                  onPressed: () {
                    GetReservation();
                  },
                  child: texte("texte")),
              Column(
                children: [
                  for (var i = 8; i < 21; i += 1)
                    for (var j = 0; j < 60; j += 20)
                      if (DateTime.now().isBefore(DateTime(
                              today.year, today.month, today.day, i, j)) &&
                          !Dates.any((dateInfo) =>
                              isSameDay(
                                  DateTime(
                                      today.year, today.month, today.day, i, j),
                                  dateInfo['date']) &&
                              dateInfo['heure'] ==
                                  TimeOfDay(hour: i, minute: j))&& DateTime.now().add(const Duration(minutes: 20)).isBefore(DateTime( today.year,today.month, today.day, i, j)))
                       
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTime = DateTime(
                                  today.year, today.month, today.day, i, j);
                              print(
                                  "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}");
                              //  monheure =
                              //       "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}";
                              heure =
                                  "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}";
                              Verification();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                 "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}",
                                 style: GoogleFonts.openSans(color: Colors.black,
                                 fontSize: 20
                                 )
                                                                ),
                              ),
                              SizedBox(height: 15,),
                              Divider(),
                               SizedBox(height: 15,),
                            ],
                          ),
                                                      
                            ),
                      
                        
                  Text("$Dates")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
