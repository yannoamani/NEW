import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/module_reservation/Passer_Une_Reservation.dart';
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/module_reservation/reservation_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class detail_service extends StatefulWidget {
  const detail_service({super.key});

  @override
  State<detail_service> createState() => _detail_serviceState();
}

class _detail_serviceState extends State<detail_service> {
  bool ic = false;
  var id = 0;
  var token = "";
  bool _isCharged = false;
  DateTime today = DateTime.now();
  // Mon future Async qui va me  permettre de recuprer le details sur le Rdv
  Map<String, dynamic> info_servie = {};
  List img = [];
  Map mespath = {};

  // Information sur le service()
  List note = [];

  Future<void> get_info_service() async {
    final url = monurl('services/$id');
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        setState(() {
          final decode = jsonDecode(response.body);
          info_servie = decode['data'];
          img = info_servie['photos'];
          note = info_servie['notes'];
        });
        if (info_servie.isNotEmpty) {
          setState(() {
            _isCharged = !_isCharged;
          });
        }
        print(info_servie);
      } else {
        // Gérez les erreurs ici
        print(
            "Erreur lors de la récupération des informations du service. Code d'état : ${response.statusCode}");
      }
    } catch (error) {
      print(
          "Erreur lors de la récupération des informations du service : $error.");
    }
  }

  getid_service() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id_service')!;
      token = prefs.getString('token')!;
    });
    get_info_service();
  }

  Future getdata() async {
    while (info_servie.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }
    return "error";
  }

  @override
  void initState() {
    super.initState();

    getid_service();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SpinKitCircle(
                color: Colors.blue,
              ),
            ); 
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return Scaffold(
             
              bottomNavigationBar: BottomAppBar(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return prise_rdv();
                      }));
                    },
                    child: Text(
                      "Reserver dès maintenant",
                      style: TextStyle(),
                    )),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Titre("${info_servie['libelle']}", 20, Colors.black),
                    actions: [Icon(Icons.monitor_heart)],
                    pinned: true,
                    floating: true,
                    expandedHeight: 300,
                    
                    
                    flexibleSpace: FlexibleSpaceBar(
                      background: CarouselSlider(
                        options: CarouselOptions(autoPlay: true, height: 300.0,),
                        items: img.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              String imagePath =
                                  ImgDB("public/image/${i['path']}");
                              return GestureDetector(
                                 onTap: () {
               
              },
                              
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Image.network(
                                      i['path'] == null
                                          ? 'https://via.placeholder.com/200'
                                          : imagePath,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.grey[100],
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "Populaire ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Mytext('${info_servie['libelle']}', 23,
                                    Colors.black),
                                const SizedBox(
                                  height: 10,
                                ),
                                Titre('${info_servie['tarif']} FCFA', 23,
                                    Colors.black),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text.rich(TextSpan(
                                    text: 'Durée : ',
                                    style: GoogleFonts.openSans(
                                        fontSize: 16, color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: '${info_servie['duree']}h',
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w700))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Description",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                Text(info_servie["description"],style: TextStyle(color: Colors.black),)
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Titre("Avis", 15, Colors.black),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < info_servie['moyenne'];
                                          i++)
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 35,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text: '${info_servie['moyenne']}',
                                        children: [
                                          TextSpan(
                                              text:
                                                  '  (${note.length}) vote(s)',
                                              style:
                                                  TextStyle(color: Colors.blue))
                                        ]),
                                  ),
                                  Divider(
                                    color: const Color.fromARGB(
                                        255, 160, 159, 159),
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverList.builder(
                      itemCount: note.length,
                      itemBuilder: (context, index) {
                        final result = note[index];
                        return Container(
                          color: Colors.grey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                      "${result['user']['nom'].toString().substring(0, 1)}${result['user']['prenom'].toString().substring(0, 1).toUpperCase()}"),
                                ),
                                title: NewText(
                                    "${result['user']['nom']},${result['user']['prenom'].toString().substring(0, 1).toUpperCase()}",
                                    18,
                                    Colors.black),
                                subtitle: NewText("${result['created_at']}", 15,
                                    Colors.black38),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    for (var i = 0; i < result['rate']; i++)
                                      Icon(
                                        Icons.star,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Mytext("${result['commentaire']}", 15,
                                    Colors.black),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        );
                      })
                ],
              ));
        }
      },
    );
  }
}
