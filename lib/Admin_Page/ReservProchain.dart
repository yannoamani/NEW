import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReservationProchain extends StatefulWidget {
  const ReservationProchain({super.key});

  @override
  State<ReservationProchain> createState() => _ReservationProchainState();
}

class _ReservationProchainState extends State<ReservationProchain> {
  List MesReservations = [];
// ignore: non_constant_identifier_names
  bool isLoading = false;
  Future<void> reservationProchaine() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationAdminAvenir');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    final resultat = jsonDecode(response.body);
    setState(() {
      MesReservations = resultat['data'];
      isLoading = resultat['status'];
    });
    print(MesReservations);
  }

  @override
  void initState() {
    // TODO: implement initState
    reservationProchaine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 11)),
        builder: (context, snapshot) {
          if (isLoading == false ) {
            return Scaffold(
              body: SpinKitCircle(
                color: Colors.black,
              ),
            );
          } else {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    // backgroundColor: Colors.blue,
                    centerTitle: true,
                    title: Titre('Reservation à venir', 15, Colors.black),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Titre('Reservation à venir', 25, Colors.black),
                      ],
                    ),
                  ),
               MesReservations.isEmpty
                      ? aucunRdv()
                      :    SliverList.separated(
                      itemCount: MesReservations.length,
                      itemBuilder: (context, index) {
                        final resultats = MesReservations[index];
                        final nom = resultats['user']['nom'];
                        final prenom = resultats['user']['prenom'];
                        final phone = resultats['user']['phone'];
                        final email = resultats['user']['email'];
                        String date = resultats['date'];
                        String heure = resultats['heure'];
                        String montant = resultats['montant'];
                        // final duree = resultats['service'];

                        final status = resultats['status'];
                        DateTime Convert = DateTime.parse(date);
                        String NewDate =
                            DateFormat.yMMMEd('fr_FR').format(Convert);
                        return ListTile(
                          title: NewText('$nom', 15, Colors.black),
                          subtitle: NewBold('$NewDate à 20:00', 12, Colors.red),
                          trailing: FaIcon(FontAwesomeIcons.spinner,color: Colors.orange,),
                          onTap: () {
                            showModalBottomSheet(
                                //  backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                // isDismissible: true,
                                elevation: 8,
                                context: context,
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    body: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .spinner,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Mytext(
                                                                  "$status",
                                                                  20,
                                                                  Colors.white),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Center(
                                                        child: Titre(
                                                            'Informations sur le client',
                                                            20,
                                                            Colors.black)),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .user),
                                                      title: NewText('$nom ',
                                                          15, Colors.black),
                                                      subtitle: NewText(
                                                          '$prenom',
                                                          15,
                                                          Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .envelope),
                                                      title: NewText('$email',
                                                          15, Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .phone),
                                                      title: NewText('$phone',
                                                          15, Colors.black),
                                                    ),
                                                    Divider(),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Center(
                                                        child: Titre(
                                                            "Informations sur la reservation",
                                                            20,
                                                            Colors.black)),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .briefcase),
                                                      title: NewText(
                                                          '${resultats['service']['libelle']}',
                                                          15,
                                                          Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .calendarDay),
                                                      title: NewText('$NewDate',
                                                          15, Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .hourglass),
                                                      title: NewText('$heure',
                                                          15, Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .moneyBill),
                                                      title: NewBold(
                                                          '${montant} FCFA',
                                                          20,
                                                          Colors.black),
                                                    ),
                                                    Divider(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          leading:  CircleAvatar(
                            backgroundColor: Colors.orange[100],
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider())
                ],
              ),
            );
          }
        });
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
