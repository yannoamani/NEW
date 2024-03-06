import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Congratulations/congratulations.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/module_reservation/reservation_controller.dart';
import 'package:gestion_salon_coiffure/module_reservation/reservation_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ModifierReservation extends StatefulWidget {


  @override
  State<ModifierReservation> createState() => _ModifierReservationState();
}

class _ModifierReservationState extends State<ModifierReservation> {
  moncontroller controller = moncontroller();
  Rx<Reservation> reserv = Reservation().obs;
  DateTime? selectedTime;
  Map Liste_Service = {};
  Map reservations = {}; // L Information sur le service en question
  int duree = 30;
  String heure = '';
  bool verif = false;
  bool loading = false;
  TextEditingController _ControlCoupon = TextEditingController();
  // Lister les differents services de l'entreprise
  List Photos = [];
  Future<void> Mes_Services() async {
    // reserv.value.getServices().then((value) {
    //   setState(() {
    //     Liste_Service = value;
    // duree = Liste_Service['duree'];
    //     Photos = Liste_Service['photos'];
    //   });
    // });

    // print(Liste_Service);
  }
  List ReserServices = [];
  List TrueTimeDate = [];
  Future<void> getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("services/${prefs.get('id_service')}");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header(" ${prefs.getString('token')}"));
    final decode = jsonDecode(response.body);
    setState(() {
      Liste_Service = decode['data'];
      duree = Liste_Service['duree'];
      Photos = Liste_Service['photos'];
      ReserServices = Liste_Service['reservations'];
    });
    for (var Reserv in ReserServices) {
      String heure = Reserv['heure'];
      String date = Reserv['date'];
      // print(heure + date);
      DateTime MesDates = DateTime.parse(date);
      List<int> timeComponents = heure.split(':').map(int.parse).toList();
      TimeOfDay heures =
          TimeOfDay(hour: timeComponents[0], minute: timeComponents[1]);
      Map<String, dynamic> dateInfo = {
        'date': MesDates,
        'heure': heures,
      };
      setState(() {
        TrueTimeDate.add(dateInfo);
      });
    }
    print(response.body);
  }

  Future<dynamic> reserver() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final url = monurl("reservations");
      final uri = Uri.parse(url);

      final response = await http.post(uri,
          body: jsonEncode({
            'service_id': prefs.getInt('id_service'),
            'user_id': prefs.getInt('id'),
            'heure': heure,
            'date': '${today.toString().split(" ")[0]}',
            'coupon': _ControlCoupon.text
          }),
          headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);
      print(heure);
      print(resultat);
      if (resultat['status']) {
        // message(context, "En cours de traitement", Colors.blue);
        prefs.setInt('id_reservation', resultat['data']['id']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Congratulation()),
        );
      } else {
        message(context, '${resultat['message']}', Colors.red);
      }
    } catch (e) {
      print("Erreur lors de la réservation: ${e}");
    }
    print('Je marche');
  }

  // verificationReservation
  late bool char = false;

  Future<dynamic> verificationReservation() async {
    print(
        "${today.year.toString().split(" ")[0]}-${today.month.toString().split(" ")[0]}-${controller.today.day.toString().split(" ")[0]}");
    print(
        "${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}");
    try {
      final prefs = await SharedPreferences.getInstance();

      final url = monurl("verifieReservation");
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        body: jsonEncode(
          {
            'service_id': prefs.getInt('id_service'),
            'user_id': prefs.getInt('id'),
            'heure':
                '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}',
            'date': today.toString().split(" ")[0],
          },
        ),
        headers: header("${prefs.getString('token')}"),
      );

      final resultat = jsonDecode(response.body);
      // print(resultat);

      setState(() {
        verif = resultat['status'];
      });

      print(resultat['status']);
      if (resultat['status'] == false) {
        char = false;

        message(context, "${resultat['message']}",
            Color.fromARGB(255, 0, 140, 255));

        // ignore: use_build_context_synchronously
        DateTime convert = DateTime.parse(today.toString().split(" ")[0]);
        String Madate = DateFormat.yMMMMEEEEd('fr_FT').format(convert);
        if (char == false) {
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

                              // setState(() {
                              //   loading = !loading;
                              // });

                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: SpinKitCircle(
                                        color: Colors.black,
                                      ),
                                    );
                                  });

                              reserver();
                            },
                            child: Mytext("Valider", 15, Colors.white))
                      ],
                    ),
                  ),
                  appBar: AppBar(
                    title: Titre('Verifiez et confirmez', 20, Colors.black),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),

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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NewBold("${Liste_Service['libelle']}", 20,
                                      Colors.black),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 20),
                                  //   child: Row(
                                  //     children: [
                                  //       for (var i = 0;
                                  //           i < Liste_Service['moyenne'];
                                  //           i++)
                                  //         Icon(
                                  //           Icons.star,
                                  //           size: 20,
                                  //           color: Colors.black,
                                  //         )
                                  //     ],
                                  //   ),
                                  // ),
                                  // Mytext(
                                  //     "${Liste_Service['moyenne']} (${Liste_Service['notes'].toString().length})",
                                  //     15,
                                  //     Color.fromARGB(96, 59, 57, 57))
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
                              title: NewText('$Madate', 18,
                                  const Color.fromARGB(255, 111, 110, 110))),
                          ListTile(
                              leading: FaIcon(FontAwesomeIcons.clock),
                              title: NewText(
                                  "${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}",
                                  18,
                                  const Color.fromARGB(255, 111, 110, 110))),
                          ListTile(
                              leading: FaIcon(FontAwesomeIcons.hourglass),
                              title: NewText('${Liste_Service['duree']}h', 18,
                                  const Color.fromARGB(255, 111, 110, 110))),

                          // ListTile(
                          //     leading:Icon(Icons.event),
                          //     title: Mytext('${Liste_Service['libelle']}', 15,
                          //         const Color.fromARGB(255, 111, 110, 110))),
                          Divider(),
                          Row(
                            children: [
                              NewBold("Total", 15, Colors.black),
                              Spacer(),
                              Titre("${Liste_Service['tarif']} FCFA", 15,
                                  Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              NewBold("Payer maintenant", 15, Colors.green),
                              Spacer(),
                              NewBold("0 FCFA", 15, Colors.green),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              NewBold("Payer sur place", 15, Colors.black),
                              Spacer(),
                              NewBold("${Liste_Service['tarif']}FCFA", 15,
                                  Colors.black),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                              child:
                                  Titre("Mode de payement", 20, Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
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
                                    border: Border.all(
                                        width: 1, color: Colors.blue)),
                                child: Center(
                                    child: FaIcon(
                                  FontAwesomeIcons.store,
                                  size: 20,
                                )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              NewBold("Payer sur place", 15, Colors.black)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          NewBold("Entrez votre code coupon", 15, Colors.black),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width/2,
                                child: TextFormField(
                                  controller: _ControlCoupon,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                    ),
                                    label: Text("Code du coupon"),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        )),
                                  onPressed: (){},
                                 child: Text('Appliquer',style: TextStyle(color: Colors.black),)),
                              )
                            ],
                          ),
                          SizedBox(height: 10)

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
        }
      } else {
        setState(() {
          char = !char;
        });
        message(context, '$resultat', Colors.red);
      }
    } catch (e) {
      print("Erreur lors de la réservation: ${e}");
      return null;
    }
  }

  String Mesdates = "";
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

      DateTime Vdate = DateTime.parse(Mesdates);

      List<int> timeComponents = here.split(':').map(int.parse).toList();
      TimeOfDay heure =
          TimeOfDay(hour: timeComponents[0], minute: timeComponents[1]);

      Map<String, dynamic> dateInfo = {
        'date': Vdate,
        'heure': heure,
      };

      setState(() {
        Dates.add(dateInfo);
      });
    }

    // print(Dates);
    // print("hjk");
  }

  Future<String> Attendre() async {
    await Future.delayed(const Duration(seconds: 1));

    return '0';
  }

  bool isAnyHourAvailableForToday() {
    DateTime now = DateTime.now();

    // Logique pour vérifier si des heures sont disponibles aujourd'hui
    // Par exemple, si des heures sont disponibles entre 8h et 22h et aucune réservation pour ces heures
    for (var i = 8; i <= 22; i += duree) {
      for (var j = 0; j < 60; j += 60) {
        DateTime currentTime = DateTime(now.year, now.month, now.day, i, j);

        if (DateTime.now()
                .isBefore(DateTime(today.year, today.month, today.day, i, j)) &&
            !TrueTimeDate.any((dateInfo) =>
                isSameDay(DateTime(today.year, today.month, today.day, i, j),
                    dateInfo['date']) &&
                dateInfo['heure'] == TimeOfDay(hour: i, minute: j)) &&
            DateTime.now()
                .add(const Duration(minutes: 20))
                .isBefore(DateTime(today.year, today.month, today.day, i, j))) {
          return true;
        }
      }
    }

    return false;
  }

  List<Widget> generateCards() {
    List<Widget> cards = [];
    bool hasAtLeastOneCard = false;

    for (var i = 8; i <= 22; i += duree) {
      for (var j = 0; j < 60; j += 60) {
        if (DateTime.now()
                .isBefore(DateTime(today.year, today.month, today.day, i, j)) &&
            !TrueTimeDate.any((dateInfo) =>
                isSameDay(DateTime(today.year, today.month, today.day, i, j),
                    dateInfo['date']) &&
                dateInfo['heure'] == TimeOfDay(hour: i, minute: j)) &&
            DateTime.now()
                .add(const Duration(minutes: 20))
                .isBefore(DateTime(today.year, today.month, today.day, i, j))) {
          // Une heure est disponible
          hasAtLeastOneCard = true;
          cards.add(
            Card(
              shadowColor: Colors.black,
              child: ListTile(
                selectedColor: Colors.blue,
                splashColor: Colors.amber,
                onTap: () async {
                  setState(() {
                    selectedTime =
                        DateTime(today.year, today.month, today.day, i, j);
                    print(
                        "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}");
                    heure =
                        "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}";
                  });
                  setState(() {
                    char = !char;
                  });
                  if (char == true) {
                    await verificationReservation();
                    if (!isAnyHourAvailableForToday()) {
                      // Aucune heure disponible pour ce service
                      print("Aucune heure disponible pour ce service");
                    }
                  }
                },
                title: Text(
                  "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}",
                  style:
                      GoogleFonts.openSans(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          );
        }
      }
    }

    // Si aucune Card n'a été générée, ajouter le message approprié
    if (!hasAtLeastOneCard) {
      cards.add(
        Text(
          "Aucune heure spécifique disponible pour ce service",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return cards;
  }

  DateTime today = DateTime.now();
  @override
  void initState() {
    Attendre();
    getServices();
    Mes_Services();
    // GetReservation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Attendre(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              Liste_Service.isEmpty) {
            return Scaffold(
              body: Center(
                child: SpinKitCircle(color: Colors.black),
              ),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: FittedBox(
                  child: Text(
                    " Selectionnez l'heure",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.andadaPro(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                actions: [
                  char == true
                      ? SpinKitWave(
                          color: Colors.black,
                          size: 20,
                        )
                      : Text("")
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: ClipOval(
                              child: Image.network(
                                ImgDB(
                                    "public/image/${Liste_Service['photos'][0]['path']}"),
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                // Assure que l'image couvre complètement le cercle
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Titre("${Liste_Service['libelle']}", 20, Colors.black)
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: TableCalendar(
                          calendarFormat: CalendarFormat.month,
                          locale: 'fr_FR',
                          rowHeight: 43,
                          focusedDay: today,
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2024, 12, 31),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          headerStyle: const HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),
                          availableGestures: AvailableGestures.all,
                          onDaySelected: (selectedDay, focusedDay) async {
                            setState(() {
                              today = selectedDay;
                              GetReservation();
                            });
                            print(today);
                          },
                          selectedDayPredicate: (day) => isSameDay(day, today),
                          enabledDayPredicate: (day) {
                            return day.weekday != DateTime.sunday;
                          },
                        ),
                      ),
                      SizedBox(height: 30,),

                      // Text("$char"),

                      Column(
                        children: [
                          if (!isAnyHourAvailableForToday())
                            Center(
                              child: Container(
                                color: Colors.red,
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Titre(
                                        "OOPS AUCUNE HEURE DISPONIBLE AUJOURD'HUI",
                                        20,
                                        Colors.white)),
                              ),
                            )
                          else
                            for (var i = 8; i <= 22; i += duree)
                              for (var j = 0; j < 60; j += 60)
                                if (DateTime.now().isBefore(DateTime(today.year,
                                        today.month, today.day, i, j)) &&
                                    !TrueTimeDate.any((dateInfo) =>
                                        isSameDay(
                                            DateTime(today.year, today.month,
                                                today.day, i, j),
                                            dateInfo['date']) &&
                                        dateInfo['heure'] ==
                                            TimeOfDay(hour: i, minute: j)) &&
                                    DateTime.now()
                                        .add(const Duration(minutes: 20))
                                        .isBefore(DateTime(today.year,
                                            today.month, today.day, i, j)))
                                  Card(
                                    shadowColor: Colors.black,
                                    child: ListTile(
                                      selectedColor: Colors.blue,
                                      splashColor: Colors.amber,
                                      onTap: () async {
                                        setState(() {
                                          selectedTime = DateTime(today.year,
                                              today.month, today.day, i, j);
                                          print(
                                              "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}");
                                          //  monheure =
                                          //       "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}";
                                          heure =
                                              "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}";
                                        });
                                        setState(() {
                                          char = !char;
                                        });
                                        if (char == true) {
                                          await verificationReservation();
                                        }

                                        // verificationReservationReservation(
                                        //   "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}",
                                        //   "${today.year.toString().split(" ")[0]}-${today.month.toString().split(" ")[0]}-${controller.today.day.toString().split(" ")[0]}",
                                        // );
                                      },
                                      // leading: FaIcon(FontAwesomeIcons.clock),
                                      // trailing: FaIcon(
                                      //   FontAwesomeIcons.circleCheck,
                                      //   color: Colors.green,
                                      // ),
                                      title: Text(
                                        "${i.toString().padLeft(2, "0")}:${j.toString().padLeft(2, "0")}",
                                        style: GoogleFonts.openSans(
                                            color: Colors.black, fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),

                          // Text("$TrueTimeDate")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // floatingActionButton: FloatingActionButton(
              //   backgroundColor: Colors.white,
              //   onPressed: selectedTime == null || verif == true
              //       ? null
              //       : () async {
              //           if (selectedTime == null) {
              //             message(
              //                 context, 'Selectionner une heure ', Colors.red);
              //           } else {
              //             if (verif == false) {
              //               showModalBottomSheet(
              //                   // isDismissible: false,
              //                   context: context,
              //                   builder: (BuildContext context) {
              //                     return Scaffold(
              //                       appBar: AppBar(
              //                         backgroundColor: Colors.blue,
              //                         title: Titre(
              //                             'CONFIRMATION', 18, Colors.white),
              //                         centerTitle: true,
              //                         actions: [
              //                           TextButton(
              //                               onPressed: () {
              //                                 Reserver();
              //                               },
              //                               child: Mytext(
              //                                   'Valider', 15, Colors.white))
              //                         ],
              //                       ),
              //                       body: SingleChildScrollView(
              //                         child: Padding(
              //                           padding: const EdgeInsets.all(8.0),
              //                           child: Column(
              //                             children: [
              //                               Titre("Résumé de la réservation",
              //                                   20, Colors.black),
              //                               SizedBox(
              //                                 height: 10,
              //                               ),
              //                               Text.rich(TextSpan(
              //                                   text: "Cliquer sur",
              //                                   style: GoogleFonts.openSans(
              //                                       fontSize: 15),
              //                                   children: [
              //                                     TextSpan(
              //                                         text: " 'Valider' ",
              //                                         style:
              //                                             GoogleFonts.openSans(
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .bold,
              //                                                 fontSize: 15)),
              //                                     TextSpan(
              //                                         text:
              //                                             " si vous êtes  d'accord avec les informations de votre reservation.",
              //                                         style:
              //                                             GoogleFonts.openSans(
              //                                                 fontSize: 15))
              //                                   ])),
              //                               Center(
              //                                   child: Titre(
              //                                       "Prenez le temps de bien  vérifier les informations avant de 'Valider'",
              //                                       15,
              //                                       Colors.red)),
              //                               SizedBox(
              //                                 height: 10,
              //                               ),
              //                               TextFormField(
              //                                 controller: _ControlCoupon,
              //                                 decoration: InputDecoration(
              //                                   border: OutlineInputBorder(),
              //                                   label: Text("Code du coupon"),
              //                                 ),
              //                               ),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               ListTile(
              //                                   leading: Text("Service"),
              //                                   title: Titre(
              //                                       '${Liste_Service['libelle']}',
              //                                       15,
              //                                       Colors.red)),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               SizedBox(
              //                                 height: 10,
              //                               ),
              //                               Info_service(
              //                                   'Desription ${Liste_Service['description']}'),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               Info_service(
              //                                   'Duree ${Liste_Service['duree']}'),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               Info_service(
              //                                   'Date  ${today.toString().split(" ")[0]}'),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               Info_service(
              //                                 'Heure :${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}',
              //                               ),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               Info_service(
              //                                 'Tarif ${Liste_Service['tarif']}',
              //                               ),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   });
              //             } else {
              //               message(context, "Impossible changer d'heure",
              //                   Colors.red);
              //             }

              //             print(selectedTime);
              //           }

              //           //
              //           // controller.controller().then((value) => print(value));
              //           controller.Getservice();

              //           setState(() {
              //             reserv.value
              //                 .getServices()
              //                 .then((value) => Liste_Service = value);
              //           });
              //           print(Liste_Service['libelle']);
              //         },
              //   child: Icon(Icons.phone),
              // ),
            );
          }
        });
  }
}

