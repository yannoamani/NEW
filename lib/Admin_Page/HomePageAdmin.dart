import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:gestion_salon_coiffure/Admin_Page/ReservEnCours.dart';
import 'package:gestion_salon_coiffure/Admin_Page/ReservProchain.dart';
import 'package:gestion_salon_coiffure/Admin_Page/RservTraite.dart';
import 'package:gestion_salon_coiffure/acceuil/Update_users.dart';
import 'package:gestion_salon_coiffure/acceuil/compte.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Admin extends StatefulWidget {
  const Home_Admin({super.key});

  @override
  State<Home_Admin> createState() => _Home_AdminState();
}

class _Home_AdminState extends State<Home_Admin> {
  late String? nom = '';
  int num = 0;
  Future<void> GetInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('nom');
    });
    print(nom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.black,
          onDestinationSelected: (int index) {
            setState(() {
              num = index;
            });
          },
          selectedIndex: num,
          destinations: [
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.home,
                  color: Colors.blue,
                ),
                label: 'Home'),
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.hourglass,
                  color: Colors.red,
                ),
                label: 'en cours'),
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: Colors.orangeAccent,
                ),
                label: 'Prochain'),
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.check,
                  color: Colors.green,
                ),
                label: 'Traité'),
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Compte',
            ),
          ]),
      // appBar: AppBar(
      //   backgroundColor: Colors.blue[100],
      //   title: Mytext('$nom', 20, Colors.black),
      //   actions: [
      //     PopupMenuButton(
      //         itemBuilder: (BuildContext index) => [
      //               PopupMenuItem(child: Text('Déconnexion')),
      //               PopupMenuItem(child: Text('Settings')),
      //             ])
      //   ],
      // ),
      body: navig(num),
    );
  }
}

Widget navig(int index) {
  switch (index) {
    case 0:
      return const firstPage();
    case 1:
      return ReservationEnCours();
    case 2:
      return ReservationProchain();
    case 4:
      return Compte();

    default:
      return ReservationTraite();
  }
}

class firstPage extends StatefulWidget {
  const firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: NewBold('Dashboard', 25, Colors.black),
        actions: [Icon(Icons.more_vert)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NewBold(
                          'Anon Amani Beada Yann Clarance', 15, Colors.white),
                      SizedBox(
                        height: 5,
                      ),
                      NewText('Masseur rofessionnelle', 15, Colors.white),
                      SizedBox(
                        height: 5,
                      ),
                      NewText('AmaniYann500@gmail.com', 15, Colors.white),
                      SizedBox(
                        height: 5,
                      ),
                      NewText('08125403', 15, Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.count(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Couleur de l'ombre
                              spreadRadius: 5, // Étendue de l'ombre
                              blurRadius: 7, // Flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Titre(
                          //   '60',
                          //   20,
                          //   Colors.white,
                          // ),
                          Container(
                            child: Expanded(
                              child: CircularPercentIndicator(
                                radius: 45.0,
                                lineWidth: 4.0,
                                percent: 0.90,
                                animation: true,
                                animationDuration: 1200,
                                center: Text(
                                  "75%",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                progressColor: Colors.orange,
                                footer: NewBold(
                                    "Réservations du jour", 15, Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Couleur de l'ombre
                              spreadRadius: 5, // Étendue de l'ombre
                              blurRadius: 7, // Flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            NewText("Non traité aujourd'hui", 15, Colors.black),
                            NewBold('120', 20, Colors.black),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.red[50],
                                    child: FaIcon(
                                      FontAwesomeIcons.arrowDown,
                                      color: Colors.red,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                NewBold('-0.2%', 15, Colors.red),
                               
                              ],
                            ),
                             NewText('Attention', 15, Colors.grey)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Couleur de l'ombre
                              spreadRadius: 5, // Étendue de l'ombre
                              blurRadius: 7, // Flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        
                            // Titre('29', 20, Colors.black),
                             Expanded(
                            child: CircularPercentIndicator(
                              radius: 45.0,
                              lineWidth: 4.0,
                              percent: 1,
                              animation: true,
                              animationDuration: 1200,
                              center: Text(
                                "100",
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              progressColor: Colors.green,
                              footer: NewBold(
                                  "Réservations Traité", 15, Colors.black),
                            ),
                          ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Couleur de l'ombre
                              spreadRadius: 5, // Étendue de l'ombre
                              blurRadius: 7, // Flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Titre('Reservations prochaines', 15, Colors.black),
                              ],
                            ),
                            Titre('120', 20, Colors.black),
                            SizedBox(height: 5,),
                             Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.blue[50],
                                    child: FaIcon(
                                      FontAwesomeIcons.arrowUp,
                                      color: Colors.blue,
                                    )),

                                    SizedBox(width: 5,),                 
                                    NewBold('3.0%', 15, Colors.blue),
                                
                                    
                                    ]),
                                        NewText('Super', 15, Colors.grey)
                          ],
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ),
              
            
        
            ],
          ),
        ),
      ),
    );
  }
}

// Reservation à venir
