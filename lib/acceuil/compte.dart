import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gestion_salon_coiffure/Info_reservation/mes_reservation.dart';
import 'package:gestion_salon_coiffure/acceuil/Update_users.dart';
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Compte extends StatefulWidget {
  const Compte({super.key});

  @override
  State<Compte> createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  String nom = '';
  String prenom = '';
  String email = '';
  String number = "";
  String token = "";
  int rating = 0;
  TextEditingController _controlCommentaire = TextEditingController();

  Future yanno() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nom = prefs.get('name').toString();
      prenom = prefs.get('prenom').toString();
      email = prefs.get('email').toString();
      number = prefs.get('phone').toString();
      token = prefs.get('token').toString();
    });

    print(number);
    print(prenom);
    print(email);
  }

  Future Logout() async {
    var url = monurl('logout');
    var uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer ${token}",
        'Content-Type': 'application/json'
      },
    );

    print(response.body);
  }

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
    });
    // print(Reservation_A_V);
  }

  List service = [];
  Future<void> GetService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl('services');
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header('${prefs.get('token')}'));

      if (response.statusCode == 200) {
        final resultat = jsonDecode(response.body);
        setState(() {
          service = resultat['data'];
        });

        print(response.body);
      } else {
        print(
            "Erreur lors de la récupération des données. Code d'état : ${response.body}");
      }
    } catch (error) {
      print("Erreur lors de la récupération des données : $error");
    }
  }

  Future<void> Noter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var Url = monurl('notes');
      final uri = Uri.parse(Url);
      final response = await http.post(uri,
          body: jsonEncode({
            'service_id': recup,
            'rate': rating,
            'user_id': prefs.get('id'),
            'commentaire': _controlCommentaire.text
          }),
          headers: header("${prefs.get('token')}"));
      final result = jsonDecode(response.body);

      if (result['status'] == 'true') {
        message(context, 'Note envoyé avec succès ', Colors.green);
        rating = 0;
        Future.delayed(Duration(milliseconds: 1000));
        {
          Navigator.of(context).pop();
        }
        _controlCommentaire.clear();
      } else {
        message(context, "${result['mesage']}", Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  int? recup;

  @override
  void initState() {
    yanno();
    ReservationAvenir();
    GetService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Titre("Mon espace", 24, Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ElevatedButton(
                //     onPressed: () {
                //       yanno();
                //     },
                //     child: Text("$token")),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 138, 138, 138),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Titre(nom, 20, Colors.white),
                          Mytext(
                            email,
                            15,
                            Colors.white,
                          ),
                          Mytext(number, 15, Colors.white),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mes_reservations()));
                      },
                      child: gridmoncompteRes("Mes reservations",
                          Icons.calendar_month, '${Reservation_A_V.length}'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => details()));
                      },
                      child: gridmoncompte("Mon profil", Icons.person),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                "Deconnexion",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                              ),
                              content: const Text(
                                "êtes vous sur de quitter ?",
                                style: TextStyle(fontSize: 20),
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    ReservationAvenir();
                                  },
                                  child: Text("Non"),
                                ),
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: TextButton(
                                      onPressed: () async {
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
                                      child: Text("Oui")),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: gridmoncompte("Logout", Icons.logout),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Voter");
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Colors.blue,
                                  title: Mytext("Evaluer une presation", 20,
                                      Colors.white),
                                      centerTitle: true,
                                ),
                                body: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(height: 200,width:double.infinity,
                                          child: Image.asset('assets/Rate.png'),
                                          ),
                                      
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: NewBold(
                                                "SELECTIONNER LE SERVICE",
                                                20,
                                                Colors.black),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1)),
                                            ),
                                            items: service.map((e) {
                                              return DropdownMenuItem(
                                                child: Mytext(e['libelle'], 15,
                                                    Colors.blue),
                                                value: e['id'],
                                              );
                                            }).toList(),
                                            onChanged: (selectedValue) {
                                              print("Selected: $selectedValue");

                                              setState(() {
                                                recup = selectedValue as int?;
                                              });
                                            },
                                            value: recup,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: NewBold(
                                                "Cliquez sur l'emoji commencer une évaluation", 20, Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Align(
                                          //   alignment: Alignment.topLeft,
                                          //   child: RatingBar.builder(
                                          //       initialRating: 1,
                                          //       itemSize: 40,
                                          //       minRating: 0,
                                          //       itemBuilder: (context, _) =>
                                          //           Icon(
                                          //             Icons.star,
                                          //             color: Colors.yellow,
                                          //           ),
                                          //       onRatingUpdate: (ratig) =>
                                          //           setState(() {
                                          //             rating = ratig.toInt();
                                          //             print(rating);
                                          //           })),
                                          // ),
                                          EmojiFeedback(
                                        animDuration: const Duration(milliseconds: 300),
                                        curve: Curves.bounceIn,
                                        inactiveElementScale: .5,
                                        onChanged: (value) {
                                          setState(() {
                                            rating=value;
                                          });
                                        },
                                      ),
                                       SizedBox(
                                            height: 5,
                                          ),
                                         
                                          TextFormField(
                                            controller: _controlCommentaire,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              hintText: 'Laisse un commentaire',
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1)),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          boutton(context, false, Colors.blue,
                                              'Soumettre', () {
                                            Noter();
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: gridmoncompte(
                        "Evaluation",
                        Icons.star,
                      ),
                    ),
                  ],
                ),
                // DropdownButtonFormField(
                //   decoration: InputDecoration(
                //     focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: BorderSide(color: Colors.blue, width: 1)),
                //     enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: BorderSide(color: Colors.blue, width: 1)),
                //   ),
                //   items: service.map((e) {
                //     return DropdownMenuItem(
                //       child: Mytext(e['libelle'], 15, Colors.blue),
                //       value: e['id'],
                //     );
                //   }).toList(),
                //   onChanged: (selectedValue) {
                //     print("Selected: $selectedValue");

                //     setState(() {
                //       recup = selectedValue as int?;
                //     });
                //   },
                //   value: recup,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(Compte());
}
