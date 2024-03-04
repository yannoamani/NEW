import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/promotions_coupons/promotion_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class allCOupons extends StatefulWidget {
  const allCOupons({super.key});

  @override
  State<allCOupons> createState() => _allCOuponsState();
}

class _allCOuponsState extends State<allCOupons> {
  List Coupons = [];
  List Info_coupon = [];
  Future dataSreen() async {
    promotionprovider.getCAllCoupons().then((value) => setState(() {
          Coupons = value;
        }));
        
    print(Coupons);
  }

  @override
  void initState() {
    // TODO: implement initState
    dataSreen();
    super.initState();
  }

  Promotion_provider promotionprovider = Promotion_provider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
        const   SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
              
                  Text(
                    "Mes Coupons",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList.separated(
            itemCount: Coupons.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, index) {
              final result = Coupons[index];
              String date = result['expiration'];
              DateTime conver = DateTime.parse(date);
              String newDate = DateFormat.yMMMMEEEEd('fr_FR').format(conver);
              return GestureDetector(
                onTap: () {
               
                  () async {
                    final id = result['id'];

                    print(id);
                    // await InfoCoupon(id);
                    Info_coupon.isEmpty
                        // ignore: use_build_context_synchronously
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                              );
                            })
                        // ignore: use_build_context_synchronously
                        : showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.blue,
                                    title: Titre("Info sur mon coupon", 20,
                                        Colors.white),
                                  ),
                                  body: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                              text: "Le coupon avec le code",
                                              style: GoogleFonts.openSans(
                                                  fontSize: 23),
                                              children: [
                                                MySpan(" ${result['code']}", 23,
                                                    Colors.red),
                                                TextSpan(
                                                    text:
                                                        " offrant une réduction de "),
                                                MySpan(
                                                    "${result['pourcentage']}%.",
                                                    23,
                                                    Colors.green),
                                                TextSpan(
                                                    text:
                                                        " Est actuellement  "),
                                                MySpan("${result['status']}",
                                                    23, Colors.red),
                                                TextSpan(
                                                    text:
                                                        ". et sa date d'expiration est "),
                                                MySpan(
                                                    "${result['expiration']}.",
                                                    23,
                                                    Colors.red),
                                                TextSpan(
                                                    text:
                                                        " Continuez à suivre nos promotions \n pour d'autres opportunités de faire des économies."),
                                              ]),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                  };
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipPath(
                    clipper: TicketClipper(),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          color: result['status'] == "Utilisé"
                              ? Colors.red[100]
                              : Colors.green[100], // Fond jaune clair
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: result['status'] == "Utilisé"
                                        ? Colors.red
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${result['status']}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
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
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
