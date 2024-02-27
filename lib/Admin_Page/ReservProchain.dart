import 'dart:convert';

import 'package:flutter/material.dart';
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
  List MesReservations = [{}];
// ignore: non_constant_identifier_names
  Future<void> GetReservation() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservations');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    final resultat = jsonDecode(response.body);
    setState(() {
      MesReservations = resultat['data'];
    });
    print(MesReservations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title:   Titre('Reservation Prochain', 25, Colors.black),),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Titre('Reservation à venir', 25, Colors.black),
                
              ],
            ),
          ),
          SliverList.separated(
              itemCount: 10,
              itemBuilder: (context, index) {
                String date = '2024-04-20';
                DateTime Convert = DateTime.parse(date);
                String NewDate = DateFormat.yMMMEd('fr_FR').format(Convert);
                return ListTile(
                  title: NewText('Anon amani beda yann ', 15, Colors.black),
                  subtitle: NewText('$NewDate à 20:00', 12, Colors.red),
                  trailing: FaIcon(FontAwesomeIcons.arrowRight),
                  onTap: () {
                    showModalBottomSheet(
                      //  backgroundColor: Colors.transparent,
        isScrollControlled: true,
        // isDismissible: true,
        elevation: 8,
                        context: context,
                        builder: (BuildContext context) {
                          return  Scaffold(
                            bottomNavigationBar:
                            DateTime.now().hour>Convert.hour?
                             BottomAppBar(
                              child: boutton(context, false,  Colors.blue, 'Confirmer', () { }),
                            ):null,
                            body: Padding(
                              padding: const EdgeInsets.only(top: 0,left: 0),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                
                                    Container(
                                      height: 200,
                                      // width: dou,
                                      child: Image.asset('assets/pngwing.com.png',
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                   
                                 Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 10),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                       Container(
                                        
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                              
                                                      child: Center(
                                                        child: Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
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
                                                                "En Attente",
                                                                20,
                                                                Colors.white),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15,),
                                      Titre('Informations sur le client', 20, Colors.black),
                                      SizedBox(height: 15,),
                                       ListTile(
                                        leading: FaIcon(FontAwesomeIcons.user),
                                        title: NewText('Anon Amni Beda Yann clarance', 15, Colors.black),),
                                    
                                     
                                          ListTile(
                                        leading: FaIcon(FontAwesomeIcons.calendar),
                                        title: NewText('$NewDate', 15, Colors.black),),
                                    
                                   
                                      
                                     ListTile(
                                        leading: FaIcon(FontAwesomeIcons.clock),
                                        title: NewText('12:10', 15, Colors.black),),
                                     ListTile(
                                        leading: FaIcon(FontAwesomeIcons.timeline),
                                        title: NewText('2h', 15, Colors.black),),
                                    ],
                                   ),
                                 )
                                  
                                  ],
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
