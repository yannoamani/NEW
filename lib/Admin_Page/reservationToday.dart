import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReservationEnCours extends StatefulWidget {
  const ReservationEnCours({super.key});

  @override
  State<ReservationEnCours> createState() => _ReservationEnCoursState();
}

class _ReservationEnCoursState extends State<ReservationEnCours> {
  List reservationToday = [];
// ignore: non_constant_identifier_names
  Future<void> reservationsToday() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationOdui');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationToday = resultat['data'];
    });
    print(reservationToday);
  }

// Voici le code pour pour valider une reservation
  Future<void> validerReservation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var url = monurl("reservationsvalider/$id");
    final uri = Uri.parse(url);
    final reponse = await http.post(uri,
        body: jsonEncode({'status': "Valider"}),
        headers: header('${prefs.get('token')}'));
    if (reponse.statusCode == 200) {
      final resultat = jsonDecode(reponse.body);
      if (resultat['status'] == false) {
        message(context, "${resultat['message']}", Colors.red);
        reservationsToday();
        Navigator.of(context).pop();
      }
      if (resultat['status']) {
        message(context, "", Colors.green);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> annulerReservation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var url = monurl("reservationsvalider/$id");
      final uri = Uri.parse(url);
      final reponse = await http.post(uri,
          body: jsonEncode({'status': "Annuler"}),
          headers: header('${prefs.get('token')}'));
      if (reponse.statusCode == 200) {
        final resultat = jsonDecode(reponse.body);
        if (resultat['status'] == false) {
          message(context, "${resultat['message']}", Colors.red);
          Navigator.of(context).pop();
        }
        if (resultat['status']) {
          reservationsToday();
          message(context, "Annuler avec succèss", Colors.green);
          Navigator.of(context).pop();
        }
      }
      print(reponse.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    reservationsToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // backgroundColor: Colors.blue,
            centerTitle: true,
            title: FittedBox(
                child:
                    Titre("Reservations pour aujourd'hui", 25, Colors.black)),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Titre('Reservation à venir', 25, Colors.black),
              ],
            ),
          ),
          SliverList.separated(
              itemCount: reservationToday.length,
              itemBuilder: (context, index) {
                final resultats = reservationToday[index];
                final nom = resultats['user']['nom'];
                final prenom = resultats['user']['prenom'];
                final montant = resultats['montant'];
                // final nom = 'Anon';
                // final prenom = 'Amani Beada yann Clarance';
                final status = resultats['status'];
                final duree = resultats['service']["duree"];
                final heure = resultats['heure'];
                String date = resultats['date'];
                DateTime Convert = DateTime.parse(date);
                String NewDate = DateFormat.yMMMEd('fr_FR').format(Convert);
                return ListTile(
                  title: NewText('$nom  $prenom', 15, Colors.black),
                  subtitle: NewBold('$NewDate ', 15, Colors.red),
                  trailing: FaIcon(FontAwesomeIcons.arrowRight),
                  onTap: () async {
                    print("${resultats['id']}");
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setInt('id_valid_reservation', resultats['id']);
                    });
                    showModalBottomSheet(

                        //  backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        // isDismissible: true,
                        elevation: 8,
                        context: context,
                        builder: (BuildContext context) {
                          return Scaffold(
                            bottomNavigationBar: BottomAppBar(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )),
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          int? id;
                                          id = prefs.get('id_valid_reservation')
                                              as int?;
                                          annulerReservation(id!);
                                        },
                                        child:
                                            Titre('Annuler', 15, Colors.white)),
                                  ),
                                  Container(
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.blue),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )),
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();

                                          print(
                                              "${prefs.get('id_valid_reservation')}");
                                          validerReservation(prefs.getInt('id_valid_reservation')!);
                                        },
                                        child: Mytext(
                                            'Traiter', 15, Colors.white)),
                                  )
                                ],
                              ),
                            ),
                            body: Padding(
                              padding: const EdgeInsets.only(top: 0, left: 0),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 200,
                                        // width: dou,
                                        child: Image.asset(
                                          'assets/pngwing.com.png',
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Card(
                                        color: status == 'En Attente'
                                            ? Colors.orange
                                            : Colors.green,
                                        child: ListTile(
                                          leading: status == 'En Attente'
                                              ? FaIcon(
                                                  FontAwesomeIcons.xmark,
                                                  color: Colors.white,
                                                )
                                              : FaIcon(
                                                  FontAwesomeIcons.circleCheck),
                                          title: Center(
                                              child: NewBold(
                                                  '$status', 15, Colors.white)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Center(
                                        child: Titre(
                                            'Informations sur le client',
                                            20,
                                            Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ListTile(
                                        leading: FaIcon(FontAwesomeIcons.user),
                                        title:
                                            NewText('$nom ', 15, Colors.black),
                                        subtitle: NewText(
                                            '$prenom ', 15, Colors.black),
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading:
                                            FaIcon(FontAwesomeIcons.calendar),
                                        title: NewText(
                                            '$NewDate', 20, Colors.black),
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: FaIcon(FontAwesomeIcons.clock),
                                        title:
                                            NewText('$heure', 20, Colors.black),
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading:
                                            FaIcon(FontAwesomeIcons.hourglass),
                                        title: NewText(
                                            '$duree h', 20, Colors.black),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Center(
                                          child: NewBold(
                                              "Informations sur la reservation",
                                              20,
                                              Colors.black)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            NewText("Total", 18, Colors.black),
                                            NewBold("$montant FCFA", 23,
                                                Colors.red),
                                          ],
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider())
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: 15));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 15));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
