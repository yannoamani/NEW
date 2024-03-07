import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Admin_Page/MesNotes.dart';
import 'package:gestion_salon_coiffure/Info_reservation/mes_reservation.dart';
import 'package:gestion_salon_coiffure/acceuil/Update_users.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:gestion_salon_coiffure/promotions_coupons/AllCoupons.dart';
import 'package:gestion_salon_coiffure/promotions_coupons/promotion_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  int? IdRole = 0;
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
      IdRole = prefs.getInt('id_role');
    });

    print(number);
    print(prenom);
    print(IdRole);
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
  List mesCoupons = [];
  Promotion_provider getAllCoupons = Promotion_provider();
  Future<void> getCoupons() async {
    getAllCoupons.getCAllCoupons().then((value) => setState(() {
          mesCoupons = value;
        }));
  }

  @override
  void initState() {
    yanno();
    ReservationAvenir();
   
    getCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Titre("Mon espace", 24, Colors.black),
          centerTitle: true,
          // backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
            future: Future.delayed(Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (IdRole == 0) {
                return Scaffold(
                  body: SpinKitCircle(
                    color: Colors.black,
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         
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
                              if (IdRole == 2)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Mes_reservations()));
                                  },
                                  child: gridmoncompteRes(
                                      "Activité",
                                      Icons.calendar_month,
                                      '${Reservation_A_V.length}'),
                                ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => details()));
                                },
                                child:
                                    gridmoncompte("Mon profil", Icons.person),
                              ),
                              if (IdRole == 3)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MesNotes()));
                                  },
                                  child: gridmoncompte(
                                      "Mes notes", FontAwesomeIcons.chartLine),
                                ),
                             if (IdRole == 2)   GestureDetector(
                                child: gridmoncompteRes(
                                    "Coupons", FontAwesomeIcons.ticket, "${mesCoupons.length}"),
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => allCOupons())),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                          "Deconnexion",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18),
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
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.remove('token');
                                                  prefs.remove('name');
                                                  prefs.remove('prenom');
                                                  prefs.remove('phone');
                                                  prefs.remove('email');
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login_page()),
                                                    (route) =>
                                                        false, // Utilisez cette fonction pour supprimer toutes les pages jusqu'à la nouvelle page
                                                  );
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
                                  gridmoncompte(
                                      'Appreciations', Icons.rate_review);
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(Compte());
}
