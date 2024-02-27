import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Info_reservation/mes_reservation.dart';
import 'package:gestion_salon_coiffure/acceuil/Info_Service.dart';
import 'package:gestion_salon_coiffure/acceuil/recherche.dart';
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/module_reservation/Update_Reservation.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:gestion_salon_coiffure/promotions/promotion_page.dart';
import 'package:gestion_salon_coiffure/promotions/promotion_provider.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationAvenir");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      Reservation_A_V = resultat['data'];
      // Nom = resultat['data']['heure'];
    });
    // print(Reservation_A_V);
    print("J'ai cliqué");
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

  List mespromotions = [];
  // Future<void> GetPromotion() async {
  //   promotionProvider.Get_Promotion().then((value) {
  //     return setState(() {
  //       mespromotions = value;
  //     });
  //   });
  //   // print(mespromotions);
  // }

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
    // GetPromotion();
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
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.grey[100],
                    title: Text.rich(TextSpan(
                        text: "Bonjour",
                        style: GoogleFonts.openSans(fontSize: 15),
                        children: [
                          TextSpan(
                            text: ' $nom',
                            style: GoogleFonts.openSans(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ])),
                    actions: [
                      PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                    child: ListTile(
                                  leading:FaIcon(FontAwesomeIcons.rightFromBracket),
                                  title: NewText('Deconnexion', 15, Colors.black),
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
                                  title: NewText('Setting', 15, Colors.black),
                                )),
                              ])
                      // CircleAvatar(
                      //   child: Text(
                      //       "${nom.toString().substring(0, 2).toUpperCase()}"),
                      // )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Reservation_A_V.isEmpty
                              ? Text('')
                              : Row(
                                  children: [
                                    Titre("Prochain rendez-vous", 18,
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
                          SizedBox(
                            height: 10,
                          ),
                          Reservation_A_V.isEmpty
                              ? Text('')
                              : Container(
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
                                      String Days =
                                          DateFormat.EEEE('fr_FR').format(My);
                                      String Mounth =
                                          DateFormat.MMM('fr_FR').format(My);
                                    

                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width:
                                            MediaQuery.of(context).size.width*0.8,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
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
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    FittedBox(
                                                      // fit: BoxFit.scaleDown,
                                                      // child: Titre(
                                                      //     '${result['service']['libelle']}kjkjjkjdijdidifjiodjfosdijfosijdfsdjjkjkjk',
                                                      //     15,
                                                      //     Colors.white),
                                                      child: Text(
                                                        "${result['service']['libelle']} ",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Mytext('${result['heure']}',
                                                        15, Colors.white),
                                                    Titre(
                                                        '${result['montant']} FCFA',
                                                        15,
                                                        Colors.white),
                                                    // SizedBox(height: 5,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9)),
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
                              Titre("Les services", 18, Colors.black),
                              Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return UpdateReservation();
                                    }));
                                  },
                                  child: Mytext('Voir plus', 15, Colors.blue))
                            ],
                          ),
                          Container(
                            height: 320,
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
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(9))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 9),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              
                                              height: 200,
                                              decoration:  BoxDecoration(
                                                boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                  color: Colors.transparent,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Colors.black),
                                                  )),
                                              child: Image.network(
                                                ImgDB("public/image/$photos"),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Titre('${info['libelle']}', 20,
                                                Colors.black),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1),
                                                 
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Titre(
                                                      '${info['tarif']} FCFA',
                                                      20,
                                                      Colors.black)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                for (var i = 0;
                                                    i < info['moyenne'];
                                                    i++)
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.amber,
                                                  )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      id = donne[index]['id'];
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        prefs.setInt('id_service', id);
                                      });
                                      print(id);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return detail_service();
                                      }));
                                    },
                                  );
                                },
                                separatorBuilder: (context, _) =>
                                    SizedBox(width: 10),
                                itemCount: donne.length),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
      decoration: BoxDecoration(
        color: Colors.yellow[100], // Fond jaune clair
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.orange, width: 2.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
               "ghjk",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'fghjkl',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Text(
            'Date:223-32',
            style: TextStyle(fontSize: 16, color: Colors.purple),
          ),
          SizedBox(height: 12.0),
          Text(
            'Lieu: htgrf',
            style: TextStyle(fontSize: 16, color: Colors.purple),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Numéro de siège: fff',
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
              Text(
                'Prix: 345678',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Promototions",
                          //       style: TextStyle(
                          //           fontSize: 20, fontWeight: FontWeight.bold),
                          //     ),
                          //     Spacer(),
                          //     TextButton(
                          //       onPressed: () {
                          //         Navigator.of(context).push(MaterialPageRoute(
                          //             builder: (context) => Promotion_page()));
                          //       },
                          //       child: const Text(
                          //         "Voir plus",
                          //         style:
                          //             TextStyle(color: Colors.blue, fontSize: 15),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // const SizedBox(height: 25),
                          // ListView.separated(
                          //   separatorBuilder: (context, index) => SizedBox(
                          //     height: 10,
                          //   ),
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   itemCount: mespromotions.length,
                          //   itemBuilder: (context, index) {
                          //     return GestureDetector(
                          //       onTap: () {
                          //         showModalBottomSheet(
                          //             context: context,
                          //             builder: (BuildContext context) {
                          //               return Scaffold(
                          //                 appBar: AppBar(
                          //                   backgroundColor: Colors.orange,
                          //                   title: Text(
                          //                       "${mespromotions[index]['objet']}"),
                          //                   centerTitle: true,
                          //                 ),
                          //                 body: Stepper(currentStep: 0, steps: [
                          //                   Step(
                          //                     title: Text.rich(TextSpan(
                          //                         text: 'Service :',
                          //                         children: [
                          //                           TextSpan(
                          //                               text:
                          //                                   "${mespromotions[index]['service']['libelle']} ",
                          //                               style: TextStyle(
                          //                                   fontWeight:
                          //                                       FontWeight.bold))
                          //                         ])),
                          //                     subtitle: Text(""),
                          //                     content: Container(),
                          //                     isActive: true,
                          //                   ),
                          //                   Step(
                          //                     title: Text.rich(TextSpan(
                          //                         text: 'Coût :',
                          //                         children: [
                          //                           TextSpan(
                          //                               text:
                          //                                   "${mespromotions[index]['service']['tarif']}XOF ",
                          //                               style: TextStyle(
                          //                                   fontWeight:
                          //                                       FontWeight.bold))
                          //                         ])),
                          //                     subtitle: Text(""),
                          //                     content: Container(),
                          //                     isActive: true,
                          //                   ),
                          //                   Step(
                          //                     title: Text.rich(TextSpan(
                          //                         text: 'Description :',
                          //                         children: [
                          //                           TextSpan(
                          //                               text: "",
                          //                               style: TextStyle(
                          //                                   fontWeight:
                          //                                       FontWeight.bold))
                          //                         ])),
                          //                     subtitle: Text(
                          //                         " ${mespromotions[index]['description']}"),
                          //                     content: Container(),
                          //                     isActive: true,
                          //                   ),
                          //                   Step(
                          //                     title: Text.rich(TextSpan(
                          //                         text:
                          //                             'Date de Debut et Date de fin :',
                          //                         children: [
                          //                           TextSpan(
                          //                               text: "",
                          //                               style: TextStyle(
                          //                                   fontWeight:
                          //                                       FontWeight.bold))
                          //                         ])),
                          //                     subtitle: Text(
                          //                         " ${mespromotions[index]['date_debut']}- ${mespromotions[index]['date_fin']}"),
                          //                     content: Container(),
                          //                     isActive: true,
                          //                   ),
                          //                 ]),
                          //               );
                          //             });
                          //       },
                          //       child: Card(
                          //         color: Colors.white,
                          //         elevation: 8,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Container(
                          //               decoration: BoxDecoration(
                          //                   color: Colors.white,
                          //                   border: Border.all(
                          //                       color: Colors.black, width: 1)),
                          //               height: 200,
                          //               width: double.infinity,
                          //               child: Image.asset(
                          //                 "assets/promotions.png",
                          //                 fit: BoxFit.cover,
                          //               ),
                          //             ),
                          //             Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Row(
                          //                 children: [
                          //                   Text(
                          //                     "${mespromotions[index]['objet']}",
                          //                     style: TextStyle(
                          //                         fontSize: 20,
                          //                         fontWeight: FontWeight.bold,
                          //                         color: Colors.red),
                          //                   ),
                          //                   Spacer(),
                          //                   Text(
                          //                     "${mespromotions[index]['pourcentage']}%",
                          //                     style: TextStyle(
                          //                         fontSize: 20,
                          //                         fontWeight: FontWeight.bold,
                          //                         color: Colors.orangeAccent),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //             TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context).push(
                          //                       MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               Promotion_page()));
                          //                 },
                          //                 child: Text("Voir Plus"))
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
