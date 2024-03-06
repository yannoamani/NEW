import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Info_reservation/mes_reservation.dart';
import 'package:gestion_salon_coiffure/acceuil/Info_Service.dart';
import 'package:gestion_salon_coiffure/acceuil/recherche.dart';
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/module_reservation/Update_Reservation.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:gestion_salon_coiffure/promotions_coupons/promotion_page.dart';
import 'package:gestion_salon_coiffure/promotions_coupons/promotion_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../fonction/fonction.dart';

class First_page extends StatefulWidget {
  const First_page({super.key});

  @override
  State<First_page> createState() => _First_pageState();
}

class _First_pageState extends State<First_page> {
  var nom = '';
  var token = '';
  String? Nom;
  int id = 0;
  List donne = [];
  List img = [];

  List Reservation_A_V = [];

  Future<void> ReservationAvenir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("reservationAvenir");
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${prefs.getString('token')}",
      });
      if (response.statusCode == 200) {
        final resultat = response.body;
        final json = jsonDecode(resultat);
        setState(() {
          Reservation_A_V = json['data'];
          // Nom = resultat['data']['heure'];
        });
      } else {
        print(Reservation_A_V);
      }

      // print(Reservation_A_V);
      // print("J'ai cliqué");
    } catch (e) {
      print(e);
    }
  }

  Promotion_provider promotionProvider = Promotion_provider();
  bool isloaded = false;

  Future<void> entreprise() async {
    try {
      final url = monurl('services');
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        final resultat = jsonDecode(response.body);
        setState(() {
          donne = resultat['data'];
          isloaded = !isloaded;
        });

        // print(response.body);
      } else {
        print(
            "Erreur lors de la récupération des données. Code d'état : ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de la récupération des données : $error");
    }
  }

  List mesCoupons = [];
  Future<void> getcoupons() async {
    promotionProvider.getCouponsActif().then((value) {
      setState(() {
        mesCoupons = value;
      });
      return mesCoupons;
    });
    print(mesCoupons);
  }

  Future<void> get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('name')!;
      token = prefs.getString('token')!;
    });
    entreprise();
  }

  Future<String> getdata() async {
    while (donne.isEmpty) {
      await Future.delayed(
        Duration(seconds: 1),
      );
    }
    // throw 'eroor';
    return 'super';
  }

  @override
  void initState() {
    super.initState();
    get();
    getcoupons();
    ReservationAvenir();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitCircle(
                color: Colors.blue,
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return WillPopScope(
                  onWillPop: () async {
                    message(context, 'Impossible de revenir', Colors.red);
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.grey[100],
                          title: Text.rich(TextSpan(
                              text: "Bonjour",
                              style: GoogleFonts.openSans(fontSize: 15),
                              children: [
                                TextSpan(
                                  text: ' $nom',
                                  style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                          actions: [
                            PopupMenuButton(
                                itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                          child: ListTile(
                                        leading: FaIcon(
                                            FontAwesomeIcons.rightFromBracket),
                                        title: NewText(
                                            'Deconnexion', 15, Colors.black),
                                        onTap: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.remove('token');
                                          prefs.remove('name');
                                          prefs.remove('prenom');
                                          prefs.remove('phone');
                                          prefs.remove('email');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Login_page();
                                          }));
                                        },
                                      )),
                                      PopupMenuItem(
                                          child: ListTile(
                                        leading: FaIcon(
                                          FontAwesomeIcons.gears,
                                        ),
                                        title: NewText(
                                            'Setting', 15, Colors.black),
                                      )),
                                    ])
                          ]),
                      SliverToBoxAdapter(
                        child: RefreshIndicator(
                          strokeWidth: 4,
                          color: const Color(0xFF0A345F),
                          backgroundColor: Colors.white,
                          onRefresh: () async {
                            await ReservationAvenir();
                            // get();
                          },
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Titre("Prochain rendez-vous", 15,
                                          Colors.black),
                                      Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Mes_reservations();
                                            }));
                                          },
                                          child: Mytext(
                                              'Voir plus', 15, Colors.blue))
                                    ],
                                  ),
                                  Container(
                                      height: 122,
                                      width: double.infinity,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          width: 10,
                                        ),
                                        itemCount: Reservation_A_V.length,
                                        itemBuilder: (context, index) {
                                          final result = Reservation_A_V[index];
                                          final date = result['date'];
                                          DateTime My = DateTime.parse(date);
                                          String Days = DateFormat.EEEE('fr_FR')
                                              .format(My);
                                          String Mounth =
                                              DateFormat.MMM('fr_FR')
                                                  .format(My);

                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(
                                                        0.5), // Couleur de l'ombre
                                                    spreadRadius:
                                                        1, // Étendue de l'ombre
                                                    blurRadius:
                                                        7, // Flou de l'ombre
                                                    offset: Offset(0,
                                                        3), // Décalage de l'ombre
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Mytext("$Days", 20,
                                                            Colors.white),
                                                        Titre("${My.day}", 25,
                                                            Colors.white),
                                                        Mytext("$Mounth", 20,
                                                            Colors.white),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "${result['service']['libelle']} ",
                                                             overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Mytext(
                                                            '${result['heure']}',
                                                            15,
                                                            Colors.white),
                                                        FittedBox(
                                                          child: Titre(
                                                              '${result['montant']} FCFA',
                                                              15,
                                                              Colors.white),
                                                        ),
                                                        // SizedBox(height: 5,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: Mytext(
                                                                '${result['status']}',
                                                                15,
                                                                Colors.white),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Titre("Les services", 20, Colors.black),
                                      Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UpdateReservation();
                                            }));
                                          },
                                          child: Mytext(
                                              'Voir plus', 15, Colors.blue))
                                    ],
                                  ),
                                  Container(
                                    height: 300,
                                    color: Colors.transparent,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final info = donne[index];
                                          var photos;
                                          var iden;

                                          for (var element in info['photos']) {
                                            iden = element['id'];
                                            photos = element['path'];
                                            print(photos);
                                          }

                                          return GestureDetector(
                                            child: Container(
                                              width: 300 - 60,
                                              height: 300 - 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(9))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 1,
                                                    ),
                                                    Container(
                                                      height: 200,
                                                      decoration: const BoxDecoration(
                                                          boxShadow: [],
                                                          color: Colors
                                                              .transparent,
                                                          ),
                                                      child: Image.network(
                                                        ImgDB(
                                                            "public/image/$photos"),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              '${info['libelle']} ',
                                                          
                                                              
                                                              style: GoogleFonts.openSans(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines:
                                                                  1, // Set the maximum number of lines to 1,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                       
                                                                            color: Colors.grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                child: Titre(
                                                                    '${info['tarif']} FCFA',
                                                                    15,
                                                                    Colors
                                                                        .black)),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              // Display the first six stars in grey
                                                              for (var i = 0;
                                                                  i < 6;
                                                                  i++)
                                                                FaIcon(
                                                                  FontAwesomeIcons
                                                                      .solidStar,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 15,
                                                                ),

                                                              // Display additional yellow stars based on the value of 'moyenne'
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              id = donne[index]['id'];
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                prefs.setInt('id_service', id);
                                              });
                                              print(id);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return detail_service();
                                              }));
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, _) =>
                                            SizedBox(width: 10),
                                        itemCount: donne.length),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      NewBold("Mes coupons", 20, Colors.black),
                                     
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList.builder(
                          itemCount: mesCoupons.length,
                          itemBuilder: (context, index) {
                            final result = mesCoupons[index];
                            String date = result['expiration'];
                            DateTime conver = DateTime.parse(date);
                            String newDate =
                                DateFormat.yMMMMEEEEd('fr_FR').format(conver);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ClipPath(
                                clipper: TicketClipper(),
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: result['status'] == "Utilisé"
                                          ? Colors.red[100]
                                          : Colors
                                              .green[100], // Fond jaune clair
                                      borderRadius: BorderRadius.circular(12.0),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Coupon N*${result['code']}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: result['status'] ==
                                                        "Utilisé"
                                                    ? Colors.red
                                                    : Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                '${result['status']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(
                                          'Expiration : $newDate',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(
                                          'Pourcentage : ${result['pourcentage']}%',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ));
            }
          }),
    );
  }
}
