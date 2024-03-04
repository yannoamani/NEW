// import 'package:flutter/material.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//                   appBar: AppBar(
//                     automaticallyImplyLeading: false,
//                     backgroundColor: Colors.grey[100],
//                     title: Text.rich(TextSpan(
//                         text: "Bonjour",
//                         style: GoogleFonts.openSans(fontSize: 15),
//                         children: [
//                           TextSpan(
//                             text: ' $nom',
//                             style: GoogleFonts.openSans(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           )
//                         ])),
//                     actions: [
//                       PopupMenuButton(
//                           itemBuilder: (BuildContext context) => [
//                                 PopupMenuItem(
//                                     child: ListTile(
//                                   leading:
//                                       FaIcon(FontAwesomeIcons.rightFromBracket),
//                                   title:
//                                       NewText('Deconnexion', 15, Colors.black),
//                                   onTap: () async {
//                                     final prefs =
//                                         await SharedPreferences.getInstance();
//                                     prefs.remove('token');
//                                     prefs.remove('name');
//                                     prefs.remove('prenom');
//                                     prefs.remove('phone');
//                                     prefs.remove('email');
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(builder: (context) {
//                                       return Login_page();
//                                     }));
//                                   },
//                                 )),
//                                 PopupMenuItem(
//                                     child: ListTile(
//                                   leading: FaIcon(
//                                     FontAwesomeIcons.gears,
//                                   ),
//                                   title: NewText('Setting', 15, Colors.black),
//                                 )),
//                               ])
//                       // CircleAvatar(
//                       //   child: Text(
//                       //       "${nom.toString().substring(0, 2).toUpperCase()}"),
//                       // )
//                     ],
//                   ),
//                   body: RefreshIndicator(
//                     strokeWidth: 4,
//                     color: const Color(0xFF0A345F),
//                     backgroundColor: Colors.white,
//                     onRefresh: () async {
//                       await ReservationAvenir();
//                       // get();
//                     },
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 Titre("Prochain rendez-vous", 20, Colors.black),
//                                 Spacer(),
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(builder: (context) {
//                                         return Mes_reservations();
//                                       }));
//                                     },
//                                     child: Mytext('Voir plus', 15, Colors.blue))
//                               ],
//                             ),
//                             Container(
//                                 height: 122,
//                                 width: double.infinity,
//                                 child: ListView.separated(
//                                   separatorBuilder: (context, index) =>
//                                       const SizedBox(
//                                     width: 10,
//                                   ),
//                                   itemCount: Reservation_A_V.length,
//                                   itemBuilder: (context, index) {
//                                     final result = Reservation_A_V[index];
//                                     final date = result['date'];
//                                     DateTime My = DateTime.parse(date);
//                                     String Days =
//                                         DateFormat.EEEE('fr_FR').format(My);
//                                     String Mounth =
//                                         DateFormat.MMM('fr_FR').format(My);

//                                     return Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.blue,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey.withOpacity(
//                                                   0.5), // Couleur de l'ombre
//                                               spreadRadius:
//                                                   1, // Étendue de l'ombre
//                                               blurRadius: 7, // Flou de l'ombre
//                                               offset: Offset(
//                                                   0, 3), // Décalage de l'ombre
//                                             ),
//                                           ],
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       width: MediaQuery.of(context).size.width *
//                                           0.8,
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 10, horizontal: 15),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Center(
//                                               child: Column(
//                                                 children: [
//                                                   Mytext("$Days", 20,
//                                                       Colors.white),
//                                                   Titre("${My.day}", 25,
//                                                       Colors.white),
//                                                   Mytext("$Mounth", 20,
//                                                       Colors.white),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 40,
//                                             ),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   FittedBox(
//                                                     // fit: BoxFit.scaleDown,
//                                                     // child: Titre(
//                                                     //     '${result['service']['libelle']}kjkjjkjdijdidifjiodjfosdijfosijdfsdjjkjkjk',
//                                                     //     15,
//                                                     //     Colors.white),
//                                                     child: Text(
//                                                       "${result['service']['libelle']} ",
//                                                       style: TextStyle(
//                                                           fontSize: 20,
//                                                           color: Colors.white),
//                                                     ),
//                                                   ),
//                                                   Mytext('${result['heure']}',
//                                                       15, Colors.white),
//                                                   Titre(
//                                                       '${result['montant']} FCFA',
//                                                       15,
//                                                       Colors.white),
//                                                   // SizedBox(height: 5,),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                         border: Border.all(
//                                                             width: 1,
//                                                             color:
//                                                                 Colors.white),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(9)),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               2),
//                                                       child: Mytext(
//                                                           '${result['status']}',
//                                                           15,
//                                                           Colors.white),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   scrollDirection: Axis.horizontal,
//                                 )),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 Titre("Les services", 20, Colors.black),
//                                 Spacer(),
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(builder: (context) {
//                                         return UpdateReservation();
//                                       }));
//                                     },
//                                     child: Mytext('Voir plus', 15, Colors.blue))
//                               ],
//                             ),
//                             Container(
//                               height: 300,
//                               color: Colors.transparent,
//                               child: ListView.separated(
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index) {
//                                     final info = donne[index];
//                                     var photos;
//                                     var iden;

//                                     for (var element in info['photos']) {
//                                       iden = element['id'];
//                                       photos = element['path'];
//                                       print(photos);
//                                     }

//                                     return GestureDetector(
//                                       child: Container(
//                                         width: 300 - 60,
//                                         height: 300 - 20,
//                                         decoration: BoxDecoration(
//                                             color: Colors.transparent,
//                                             border: Border.all(
//                                                 width: 1, color: Colors.black),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(9))),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 0),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               SizedBox(
//                                                 height: 1,
//                                               ),
//                                               Container(
//                                                 height: 200,
//                                                 decoration: BoxDecoration(
//                                                     boxShadow: [],
//                                                     color: Colors.transparent,
//                                                     border: Border(
//                                                       bottom: BorderSide(
//                                                           width: 1,
//                                                           color: Colors.black),
//                                                     )),
//                                                 child: Image.network(
//                                                   ImgDB("public/image/$photos"),
//                                                   fit: BoxFit.cover,
//                                                   width: double.infinity,
//                                                   height: double.infinity,
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                           '${info['libelle']}',
//                                                           style: GoogleFonts
//                                                               .openSans(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: 15,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           maxLines:
//                                                               1, // Set the maximum number of lines to 1,
//                                                         )
//                                                       ],
//                                                     ),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(
//                                                               width: 1),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10)),
//                                                       child: Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   2.0),
//                                                           child: Titre(
//                                                               '${info['tarif']} FCFA',
//                                                               15,
//                                                               Colors.black)),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         // Display the first six stars in grey
//                                                         for (var i = 0;
//                                                             i < 6;
//                                                             i++)
//                                                           FaIcon(
//                                                             FontAwesomeIcons
//                                                                 .solidStar,
//                                                             color: Colors.amber,
//                                                             size: 15,
//                                                           ),

//                                                         // Display additional yellow stars based on the value of 'moyenne'
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       onTap: () async {
//                                         id = donne[index]['id'];
//                                         final prefs = await SharedPreferences
//                                             .getInstance();
//                                         setState(() {
//                                           prefs.setInt('id_service', id);
//                                         });
//                                         print(id);
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                           return detail_service();
//                                         }));
//                                       },
//                                     );
//                                   },
//                                   separatorBuilder: (context, _) =>
//                                       SizedBox(width: 10),
//                                   itemCount: donne.length),
//                             ),
//                             const SizedBox(
//                               height: 25,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 NewBold("Mes coupons", 20, Colors.black),

//                               ],
//                             ),
                         
                           
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//   }
// }