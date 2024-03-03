import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Admin_Page/Historique.dart';

import 'package:gestion_salon_coiffure/Admin_Page/reservationToday.dart';
import 'package:gestion_salon_coiffure/Admin_Page/ReservProchain.dart';
import 'package:gestion_salon_coiffure/Admin_Page/RservTraite.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/acceuil/compte.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
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
  void initState() {
    // TODO: implement initState

    // mesReservationPourAjourdui();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          elevation: 9,
          onDestinationSelected: (int index) {
            setState(() {
              num = index;
            });
          },
          selectedIndex: num,
          destinations: const [
            NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.dashboard,
                color: Colors.black,
              ),
              label: 'Dashboard',
            ),
          
           
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.history,
                  color: Colors.black,
                ),
                label: 'Historiques'),
            NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
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
      return historique();
    
    case 2:
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
  List reservationPourAjourdhui = [];
  Future<void> mesReservationPourAjourdui() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("reservationOdui");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.get('token')}'));
    print(response.body);
    final result = jsonDecode(response.body);
    setState(() {
      reservationPourAjourdhui = result['data'];
    });
  }

  List mesreservationsValider = [];
  Future<void> mesReservationValider() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("reservationClientValide");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.get('token')}'));
    print(response.body);
    final result = jsonDecode(response.body);
    setState(() {
      mesreservationsValider = result['data'];
    });
  }

  List mesReservationAvenir = [];
  Future<void> mesReservationsAvenir() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("reservationAvenir");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.get('token')}'));
    print(response.body);
    final result = jsonDecode(response.body);
    setState(() {
      mesReservationAvenir = result['data'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    mesReservationPourAjourdui();
    mesReservationsAvenir();
    mesReservationValider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        message(context, 'Impossible de revenir', Colors.red);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: NewBold('Dashboard', 25, Colors.black),
          actions: [
            PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.rightFromBracket),
                        title: NewText('Deconnexion', 15, Colors.black),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.remove('token');
                          prefs.remove('name');
                          prefs.remove('prenom');
                          prefs.remove('phone');
                          prefs.remove('email');
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
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
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
              mesReservationPourAjourdui();
            mesReservationsAvenir();
            mesReservationValider();
            
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                
                  Container(
                    width: double.infinity,
                   
                    decoration: BoxDecoration(
                       color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)
                    ),
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
                          NewText('Employé', 15, Colors.white),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ReservationEnCours()));

                        },
                        child: cardselection(
                            MediaQuery.of(context).size.width,
                            Icons.padding,
                            "Reservations pour aujourd'hui",
                            "${reservationPourAjourdhui.length}",
                            Colors.blue,
                            15),
                      ),
                      GestureDetector(
                        onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReservationTraite()));
                          
                        },
                        child: cardselection(
                            MediaQuery.of(context).size.width,
                            Icons.padding,
                            "Reservations traitées",
                            "${mesreservationsValider.length}",
                            Colors.green,
                            15),
                      ),
                     
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                       GestureDetector(
                        onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReservationProchain()));

                        },
                        child: cardselection(
                            MediaQuery.of(context).size.width,
                            Icons.padding,
                            "Reservations à venir",
                            '${mesReservationAvenir.length}',
                            Colors.orange,
                            15),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reservation à venir
