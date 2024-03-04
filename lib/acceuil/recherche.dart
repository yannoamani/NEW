import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/acceuil/Info_Service.dart';
import 'package:gestion_salon_coiffure/promotions_coupons/promotion_page.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController search = TextEditingController();
  bool tester = true;
  int id = 0;
  bool isConnected = false;
  CarouselController carousel=CarouselController();
  Future connection() async {
    final result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() {
        tester = false;
      });
    } else {
      setState(() {
        tester = true;
      });
    }
  }

  String token = "";

  List getService = [];
  List Fountservice = [];

  Future<void> Get_Service() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      Fountservice = getService;
    });
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
          getService = resultat['data'];
          Fountservice = getService;

          if (Fountservice.isNotEmpty) {
            setState(() {
              isConnected = !isConnected;
            });
          }
        });

        print(response.body);
      } else {
        print(
            "Erreur lors de la récupération des données. Code d'état : ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de la récupération des données : $error");
    }
  }

  // La liste de tous les ervices

  Future<String> getdate() async {
    while (getService.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }

    return 'Error';
  }

  int rating = 0;

  @override
  void initState() {
    super.initState();
    connection();
    Get_Service();
  }

  void filter(String indice) {
    List result = [];
    if (indice.trim().isEmpty) {
      result = getService;
    } else {
      result = getService
          .where((element) =>
              element.toString().toLowerCase().contains(indice.toLowerCase()))
          .toList();
      setState(() {
        Fountservice = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getdate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SpinKitCircle(
                color: Colors.blue,
              ),
            );
            //  Image.asset(
            //   'assets/promotions.png',
            //   height: 90,
            //   width: 90,
            // );
          }
          if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  moncontainer("", () {}, search, filter), Au cas où je nn'arrive pas

                  Container(
                    height: 150,
                    color: Colors.blue,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 220,
                                    child: TextFormField(
                                      controller: search,
                                      onChanged: (value) {
                                        // filter(value);
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.blue,
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                search.clear();
                                              },
                                              icon: Icon(Icons.close)),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText: 'Rechercher',
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue))),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          filter(search.text);
                                        });
                                      },
                                      child:
                                          Mytext("Recherche", 15, Colors.blue))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                height: 40,
                                // color: Colors.yellow,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 10,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.white)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Mytext(
                                            '${getService[index]['libelle']}',
                                            15,
                                            Colors.white),
                                      )),
                                    );
                                  },
                                  itemCount: getService.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: ListView.separated(
                          separatorBuilder: (context, _) => SizedBox(
                                height: 20,
                              ),
                          itemCount: Fountservice.length,
                          itemBuilder: (context, index) {
                            final resulat = Fountservice[index];
                            final List photos = resulat['photos'];

                            // final promotion = resulat['promotions'];
                            var photo;
                            for (var img in photos) {
                              photo = img['path'];
                              print(photo);
                            }

                            return GestureDetector(
                              onTap: () async {
                                id = resulat['id'];
                                final prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  prefs.setInt('id_service', id);
                                });
                                print(id);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const detail_service();
                                }));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                 decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.5), // Couleur de l'ombre
                                          spreadRadius: 5, // Étendue de l'ombre
                                          blurRadius: 7, // Flou de l'ombre
                                          offset: Offset(
                                              0, 3), // Décalage de l'ombre
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: 
                                          Container( child: 
                                            // height: 300,
                                            // width: double.infinity,
                                            // child: Image.network(
                                            //   ImgDB("public/image/${photo}"),
                                            //   fit: BoxFit.cover,
                                            //   filterQuality: FilterQuality.high,
                                            // ),
                                         CarouselSlider(
                                          carouselController: carousel ,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          
                          
                          autoPlay: true, height: 300.0,),
                        items: photos.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              String imagePath =
                                  ImgDB("public/image/${i['path']}");
                              return GestureDetector(
                                 onTap: () {
               
              },
                              
                                child: Stack(
                                  children: [
                                        Container(
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
                                      
                                      ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        // Divider(),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(),
                                                Titre('${resulat['libelle']}', 20,
                                                    Colors.black),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                // Mytext(
                                                //     '${resulat['description']}',
                                                //     15,
                                                //     const Color.fromARGB(
                                                //         255, 141, 141, 141)),
                                    
                                                Text(
                                                  "${resulat['tarif']} FCFA",
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                    
                                                // Row(
                                                //   children: [
                                                //     for (var i = 0;
                                                //         i < resulat['moyenne'];
                                                //         i++)
                                                //     const    Icon(
                                                //         Icons.star,
                                                //         color: Colors.yellow,
                                                //         size: 15,
                                                //       ),
                                                //    const   SizedBox(width: 5,),
                                                //       Text("(${resulat['moyenne']})")
                                                //   ],
                                                // )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )

                  //  SizedBox(height: 30,),

                  // Container(
                  //   height: 270,
                  //   width: double.infinity,
                  //   decoration:
                  //       BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  //   child: Image.asset(
                  //     "assets/connexion.jpg",
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // Card(
                  //   color: Colors.orange,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(.0),
                  //     child: texte("Populaire"),
                  //   ),
                  // ),
                  // const Row(
                  //   children: [
                  //     Text("Massage"),
                  //     Spacer(),
                  //     Text("20K"),
                  //   ],
                  // ),

                  // const Text("Très fiable  relaxant , très Doux"),
                  // const Text("10 Minute"),
                  // TextButton(
                  //     onPressed: () {
                  //       Get_Service();
                  //     },
                  //     child: Text("Voir Plus")),

                  // const Divider(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
