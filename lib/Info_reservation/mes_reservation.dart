import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mes_reservations extends StatefulWidget {
  const Mes_reservations({super.key});

  @override
  State<Mes_reservations> createState() => _Mes_reservationsState();
}

class _Mes_reservationsState extends State<Mes_reservations> {
  List Reservation_A_V = [];
  List Reservation_Deja_passer = [];
  Future<void> ReservationAvenir() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationAvenir");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      Reservation_A_V = resultat['data'];
    });
    print(Reservation_A_V);
  }

  Future<void> ReservationDejaPasser() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationPasser");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      Reservation_Deja_passer = resultat['data'];
    });
    print(Reservation_Deja_passer);
  }

  Future<String> Getdata() async {
    while (Reservation_A_V.isEmpty && Reservation_Deja_passer.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }
    return 'thow';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReservationAvenir();
    ReservationDejaPasser();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
            child: SpinKitCircle(color: Colors.blue),
          ));
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Titre("Rendez-vous", 25, Colors.black),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                              text: 'A Venir',
                              style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                              children: [
                                TextSpan(
                                    text: ' ${Reservation_A_V.length}',
                                    style: GoogleFonts.openSans(
                                        color: Colors.blue))
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                  // Cette liste est pour la liste des  renddez-vus pass"
                  SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final result = Reservation_A_V[index];
                      final date = result['date'];
                      DateTime _date = DateTime.parse(date);
                      String madate =
                          DateFormat.yMMMMEEEEd('fr_FR').format(_date);

                      List photos = result['service']['photos'];
                      final result1 = photos.isEmpty
                          ? ''
                          : result['service']['photos'][0]['path'];
                      final Mydate = result['date'];
                      DateTime My = DateTime.parse(Mydate);
                      String Days = DateFormat.EEEE('fr_FR').format(My);
                      String Mounth = DateFormat.MMM('fr_FR').format(My);
                      String years = DateFormat.y('fr_Fr').format(My);

                      return GestureDetector(
                          onTap: () {
                            //  Ce qui se passe une fois que je clique une reservation
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Scaffold(
                                        body: CustomScrollView(
                                      slivers: [
                                        SliverAppBar(
                                          expandedHeight: 300,
                                          pinned: true,
                                          floating: true,
                                          flexibleSpace: FlexibleSpaceBar(
                                              background: Stack(
                                            children: [
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(
                                                      0.6), // Ajustez l'opacité selon votre besoin
                                                  BlendMode.darken,
                                                ),
                                                child: Image.network(
                                                  ImgDB(
                                                      'public/image/${result1}'),
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Titre(
                                                      "${result['service']['libelle']} ",
                                                      25,
                                                      Colors.white))
                                            ],
                                          )),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, right: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // SizedBox(
                                                //   height: 20,),
                                                Container(
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .circleCheck,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Mytext(
                                                            "${result['status']}",
                                                            20,
                                                            Colors.white),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Titre(
                                                    "$madate à ${result['heure']}",
                                                    18,
                                                    Colors.black),

                                                Mytext(
                                                    "Durée:${result['service']['duree']}h",
                                                    15,
                                                    const Color.fromARGB(
                                                        255, 78, 77, 77)),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: ListTile(
                                                    leading: FaIcon(
                                                        FontAwesomeIcons
                                                            .calendarDay),
                                                    title: Mytext(
                                                        'Gerer votre rendez-vous',
                                                        15,
                                                        Colors.black),
                                                    subtitle: Mytext(
                                                        'Reprogrammez ou annulez votre rendez-vous',
                                                        13,
                                                        Colors.grey),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  children: [
                                                    Titre('Total', 20,
                                                        Colors.black),
                                                    Spacer(),
                                                    Titre(
                                                        '${result['montant']} FCFA',
                                                        20,
                                                        Colors.black),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                        //  SingleChildScrollView(
                                        //   child: Column(
                                        //     children: [
                                        //       ListeTiles('${result['service']['libelle']}',
                                        //           Icons.local_hospital),
                                        //       Divider(),
                                        //       ListeTiles(
                                        //           'Le ${result['date']} à ${result['heure']}',
                                        //           Icons.access_time),
                                        //       Divider(),
                                        //       ListeTiles('${result['service']['duree']}h',
                                        //           Icons.timer),
                                        //       Divider(),
                                        //       ListeTiles('${result['montant']} FCFA',
                                        //           Icons.money),
                                        //       Divider(),
                                        //       ListeTiles(
                                        //           '${result['status']}', Icons.money),
                                        //       Divider(),
                                        //       GestureDetector(
                                        //           onTap: () {
                                        //             print('Ok');
                                        //             showCupertinoDialog(
                                        //                 context: context,
                                        //                 builder: (BuildContext context) {
                                        //                   return CupertinoAlertDialog(
                                        //                     content: Text(
                                        //                         "êtes vous sûr d'annuler cette reservation?"),
                                        //                     actions: [
                                        //                       TextButton(
                                        //                           onPressed: () {},
                                        //                           child: Text('Oui')),
                                        //                       TextButton(
                                        //                           onPressed: () {},
                                        //                           child: Text('Non')),
                                        //                     ],
                                        //                   );
                                        //                 });
                                        //           },
                                        //           child: ListeTiles(
                                        //               'Annuler ma reservation',
                                        //               Icons.error))
                                        //     ],
                                        //   ),
                                        // ),
                                        ),
                                  );
                                });
                          },
                          // Voici le card de la liste des reservation à venir
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Mytext("$Days", 20, Colors.white),
                                        Titre("${My.day}", 25, Colors.white),
                                        Mytext("$Mounth", 20, Colors.white),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            "${result['service']['libelle']} ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Mytext('${result['heure']}', 15,
                                            Colors.white),
                                        Titre('${result['montant']}FCFA', 15,
                                            Colors.white),
                                        Container(
                                          decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.white)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Titre('${result['status']}', 15,
                                                Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                    itemCount: Reservation_A_V.length,
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.blue,
                        ),
                        Text.rich(
                          TextSpan(
                              text: 'Passé',
                              style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                              children: [
                                TextSpan(
                                    text: ' ${Reservation_Deja_passer.length}',
                                    style: GoogleFonts.openSans(
                                        color: Colors.grey))
                              ]),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )),
                  SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final resultat = Reservation_Deja_passer[index];
                      return historiqueReservation(
                          '${resultat['service']['libelle']}',
                          '${resultat['service']['tarif']}',
                          '${resultat['date']}',
                          '${resultat['heure']}',
                          Colors.grey);
                    },
                    itemCount: Reservation_Deja_passer.length,
                  )
                ],
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [

                //       Container(
                //         child: Expanded(
                //           child: ListView.separated(
                //               separatorBuilder: (context, index) {
                //                 return const Divider(height: 8);
                //               },
                //                 itemCount: 3,
                //                 itemBuilder: (context, index) {
                //             return Container(

                // decoration: BoxDecoration(
                //     color: Color.fromARGB(255, 2, 40, 254),
                //     borderRadius: BorderRadius.circular(10)),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: const Column(
                //                     crossAxisAlignment: CrossAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         "Soin de beauté",
                //                         style: TextStyle(
                //                             fontSize: 23,
                //                             fontWeight: FontWeight.bold,
                //                             color: Colors.white),
                //                       ),
                //                       Text(
                //                         "12-04-2024",
                //                         style: TextStyle(
                //                             fontSize: 22,
                //                             fontWeight: FontWeight.bold,
                //                             color: Colors.white),
                //                       ),
                //                       Text(
                //                         "10:00",
                //                         style: TextStyle(
                //                             fontSize: 20,
                //                             fontWeight: FontWeight.bold,
                //                             color: Colors.white),
                //                       ),
                //                     ],
                //                   ),
                //                 ));
                //           }),
                //   ),
                // ),
                //       Expanded(child: Container(child: Text("HUY"),))

                //   ],
                // ),
              ),
            ),
          );
        }
      },
    );
  }
}
