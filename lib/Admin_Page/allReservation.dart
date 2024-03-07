import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class allReservation extends StatefulWidget {
  const allReservation({super.key});

  @override
  State<allReservation> createState() => _allReservationState();
}

class _allReservationState extends State<allReservation> {
  List getReservations = [];
  bool isLoading = false;
  Future<void> getreservation() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationOperateur');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));

    final resultat = jsonDecode(response.body);
    setState(() {
      getReservations = resultat['data'];
      isLoading = resultat['status'];
    });
    print(getReservations);
  }

  @override
  void initState() {
    getreservation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isLoading != true) {
            return Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Historiques"),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverList.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                          ),
                      itemCount: getReservations.length,
                      itemBuilder: (context, index) {
                        final resultats = getReservations[index];
                        final nom = resultats['user']['nom'];
                        final prenom = resultats['user']['prenom'];
                        final email = resultats['user']['email'];
                        final phone = resultats['user']['phone'];
                        String date = resultats['date'];
                        String heure = resultats['heure'];
                        final montant = resultats['montant'];

                        final status = resultats['status'];
                        DateTime Convert = DateTime.parse(date);

                        String NewDate =
                            DateFormat.yMMMEd('fr_FR').format(Convert);
                        return ListTile(
                          title: Text("$nom"),
                          subtitle: Text("$prenom"),
                          trailing: Column(
                            children: [
                              FaIcon(
                                status == "Annuler"
                                    ? FontAwesomeIcons.xmark
                                    : (status == "Valider"
                                        ? FontAwesomeIcons.circleCheck
                                        : FontAwesomeIcons.spinner),
                                size: 30,
                                color: status == "Annuler"
                                    ? Colors.red
                                    : (status == "Valider"
                                        ? Colors.green
                                        : Colors
                                            .grey), // Couleur par défaut pour le cas "spinner"
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("$status")
                            ],
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            ),
                          ),
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
                        );
                      })
                ],
              ),
            );
          }
        });
  }
}
