import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class historique extends StatefulWidget {
  const historique({super.key});

  @override
  State<historique> createState() => _historiqueState();
}

class _historiqueState extends State<historique> {
  List reservationAnnuler = [];
  bool isLoading = false;
// ignore: non_constant_identifier_names
  Future<void> resercationfailed() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationAdminAnnule');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationAnnuler = resultat['data'];
      isLoading = resultat['status'];
    });
    print(reservationAnnuler);
  }

  @override
  void initState() {
    // TODO: implement initState
    resercationfailed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isLoading == false) {
            return Scaffold(
              body: SpinKitCircle(
                color: Colors.black,
              ),
            );
          }
          else{
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    // backgroundColor: Colors.blue,
                    centerTitle: true,
                    title: FittedBox(
                        child:
                            Titre("Reservations annulées", 25, Colors.black)),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Titre('Reservation à venir', 25, Colors.black),
                      ],
                    ),
                  ),
             reservationAnnuler.isEmpty
                      ? aucunRdv()
                      :     SliverList.separated(
                      itemCount: reservationAnnuler.length,
                      itemBuilder: (context, index) {
                        final resultats = reservationAnnuler[index];
                        final nom = resultats['user']['nom'];
                        final prenom = resultats['user']['prenom'];
                        final email = resultats['user']['email'];
                        final phone = resultats['user']['phone'];
                        String date = resultats['date'];
                        String heure = resultats['heure'];
                        // final date = "2024-02-01";
                        // final heure = "13:00";
                        // final nom = "Anon";
                        // final prenom = "Amani Beda Yann ";
                        final status = resultats['status'];
                        DateTime Convert = DateTime.parse(date);
                        // final nom = 'Anon';
                        // final prenom = 'Amani Beada yann Clarance';
                        // final status = "Attente";

                        // String date = "2024-03-02";
                        // DateTime Convert = DateTime.parse(date);
                        String NewDate =
                            DateFormat.yMMMEd('fr_FR').format(Convert);
                        return ListTile(
                          title: NewText('$nom  $prenom', 15, Colors.black),
                          subtitle: NewBold('$NewDate ', 15, Colors.red),
                          trailing: FaIcon(FontAwesomeIcons.arrowRight),
                          onTap: () async {
                            // print("${resultats['id']}");
                            // final prefs = await SharedPreferences.getInstance();
                            // setState(() {
                            //   prefs.setInt('id_valid_reservation', resultats['id']);
                            // });
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
                                                height: 150,
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
                                                color: Colors.red,
                                                child: ListTile(
                                                  title: Center(
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons.xmark,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      NewBold('$status', 25,
                                                          Colors.white),
                                                    ],
                                                  )),
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
                                                leading: circlefailed(
                                                    FontAwesomeIcons.user),
                                                title: NewText(
                                                    '$nom ', 15, Colors.black),
                                                subtitle: NewText('$prenom ',
                                                    15, Colors.black),
                                              ),
                                              Divider(),
                                              ListTile(
                                                leading: circlefailed(
                                                    FontAwesomeIcons.envelope),
                                                title: NewText(
                                                    '$email', 15, Colors.black),
                                              ),
                                              Divider(),
                                              ListTile(
                                                leading: circlefailed(
                                                    FontAwesomeIcons.phone),
                                                title: NewText(
                                                    '$phone', 15, Colors.black),
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Center(
                                                  child: Titre(
                                                      "Informations sur la reservation",
                                                      20,
                                                      Colors.black)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ListTile(
                                                leading: circlefailed(
                                                    FontAwesomeIcons.briefcase),
                                                title: NewText(
                                                    '${resultats['service']['libelle']}',
                                                    15,
                                                    Colors.black),
                                              ),
                                              Divider(),
                                              ListTile(
                                                leading: circlefailed(
                                                    FontAwesomeIcons.hourglass),
                                                title: NewText(
                                                    '${resultats['service']['duree']}h',
                                                    15,
                                                    Colors.black),
                                              ),
                                              Divider(),
                                              ListTile(
                                                leading: circlefailed(
                                                    FontAwesomeIcons
                                                        .calendarWeek),
                                                title: NewText('$NewDate', 15,
                                                    Colors.black),
                                              ),
                                              Divider(),
                                              ListTile(
                                                leading: circlefailed(
                                                    FontAwesomeIcons.clock),
                                                title: NewText(
                                                    '$heure', 15, Colors.black),
                                              ),
                                              Divider(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    NewText("Total", 20,
                                                        Colors.black),
                                                    NewBold(
                                                        "${resultats['montant']} CFA",
                                                        23,
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
        });
  }

}
