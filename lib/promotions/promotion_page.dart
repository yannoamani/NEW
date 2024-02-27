import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/promotions/promotion_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Promotion_page extends StatefulWidget {
  const Promotion_page({super.key});

  @override
  State<Promotion_page> createState() => _Promotion_pageState();
}

class _Promotion_pageState extends State<Promotion_page>
    with TickerProviderStateMixin {
  Promotion_provider promotionProvider = Promotion_provider();
  List Coupons = [];
  Map Info_coupon = {};
  int taille = 0;
  bool char = false;
  List Mes_promotions = [];
  late final TabController _tabController;

  Future getPromotion() async {
    setState(() {
      promotionProvider.Get_Promotion().then((value) {
        setState(() {
          Mes_promotions = value;
          char = !char;
        });
      });
    });

    print(Mes_promotions);
  }

  // get la liste des coupons
  Future GetCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("couponsClient");
    // final url = monurl("coupons/${prefs.get('id')}");
    final uri = Uri.parse(url);
    final Response =
        await http.get(uri, headers: header(prefs.getString('token')!));

    final result = jsonDecode(Response.body);
    if (result['status']) {
      print("C'est Ok");
      setState(() {
        Coupons = result['data'];
        taille = result['nombre_coupon'];
      });
      message(context, 'Donnée trouvée', Colors.green);
    } else {
      print("Aucune donnée");
      message(context, '${result['message']}', Colors.red);
    }
    print(jsonDecode(Response.body));
  }

  Future InfoCoupon(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final Url = monurl("coupons/$id");
    final uri = Uri.parse(Url);
    final Response =
        await http.get(uri, headers: header(prefs.getString('token')!));
    setState(() {
      final result = jsonDecode(Response.body);
      Info_coupon = result['data'];
    });
    print(Info_coupon);
  }

  Future Chargement() async {
    // while (Coupons.isEmpty || Mes_promotions.isEmpty) {
    await Future.delayed(const Duration(seconds: 1));
    // }
  }

  int? mataille;
  Future Promotion_taille() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("promotions");
    // final url = monurl("coupons/${prefs.get('id')}");
    final uri = Uri.parse(url);
    final Response =
        await http.get(uri, headers: header(prefs.getString('token')!));

    final result = jsonDecode(Response.body);

    print("C'est Ok");
    setState(() {
      mataille = result['nombre_promotion'];
    });

    print(mataille);
  }

  Map Info_promotions = {};
  Future InfoPromotion(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final Url = monurl("promotions/$id");
    final uri = Uri.parse(Url);
    final Response =
        await http.get(uri, headers: header(prefs.getString('token')!));
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPromotion();
    GetCoupons();
    Promotion_taille();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: Chargement(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitCircle(
                color: Colors.blue,
              );
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue,
                    bottom: TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.blue,
                        indicatorColor: Colors.blue,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Titre('Promotions', 15, Colors.white),
                          ),
                          Tab(
                            child: Titre('Coupons', 15, Colors.white),
                          ),
                        ]),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Titre('Promotions', 25, Colors.black),
                          ),
                          SliverList.separated(
                              itemCount: Mes_promotions.length,
                              itemBuilder: (context, index) {
                                final result = Mes_promotions[index];
                                final date = result['date_debut'];
                                final date1 = result['date_fin'];
                                DateTime My = DateTime.parse(date);
                                DateTime My1 = DateTime.parse(date1);
                                String dateDeb =
                                    DateFormat.yMMMMEEEEd('fr_FR').format(My);
                                String dateFin =
                                    DateFormat.yMMMMEEEEd('fr_FR').format(My1);

                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        // isScrollControlled: true,
                                        elevation: 8,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return 
                                              Scaffold(
                                                appBar: AppBar(backgroundColor: Colors.white,),
                                                 body: 
                                               SingleChildScrollView(
                                                  child: Center(
                                                    child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                    Titre(
                                                        '${result['objet']}',
                                                        20,
                                                        Colors.black),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                   Titre('Du $dateDeb au $dateFin', 18, Colors.black, ),
                                                 
                                                    Mytext('${result['description']}', 20,
                                                        Colors.black),
                                                      
                                                                                                    
                                                                                                    ],
                                                                                              ),
                                                  ),
                                                                                          ),
                                              );
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        //  color: Colors.black,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                color: Colors.red,
                                                height: 300,
                                                width: double.infinity,
                                                child: Image.network(
                                                  ImgDB(
                                                      'public/image/${result['service']['photos'][0]['path']}'),
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      "${result['pourcentage']}%",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${result['service']['libelle']}',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${result['cost']} FCFA',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${result['service']['tarif']} FCFA',
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        decorationColor:
                                                            Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: ((context, index) => SizedBox(
                                    height: 10,
                                  )))
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Mes Coupons",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Expanded(
                              child: Coupons.isEmpty
                                  ? const Center(
                                      child: Card(
                                      color: Colors.red,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Empty",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ))
                                  : ListView.builder(
                                      itemCount: Coupons.length,
                                      itemBuilder: (context, index) {
                                        final result = Coupons[index];
                                        return GestureDetector(
                                            onTap: () async {
                                              final id = result['id'];
                                              print(id);
                                              await InfoCoupon(id);
                                              Info_coupon.isEmpty
                                                  // ignore: use_build_context_synchronously
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        );
                                                      })
                                                  // ignore: use_build_context_synchronously
                                                  : showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Scaffold(
                                                            appBar: AppBar(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              title: Titre(
                                                                  "Info sur mon coupon",
                                                                  20,
                                                                  Colors.white),
                                                            ),
                                                            body:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text.rich(
                                                                    TextSpan(
                                                                        text:
                                                                            "Le coupon avec le code",
                                                                        style: GoogleFonts.openSans(
                                                                            fontSize:
                                                                                23),
                                                                        children: [
                                                                          MySpan(
                                                                              " ${result['code']}",
                                                                              23,
                                                                              Colors.red),
                                                                          TextSpan(
                                                                              text: " offrant une réduction de "),
                                                                          MySpan(
                                                                              "${result['pourcentage']}%.",
                                                                              23,
                                                                              Colors.green),
                                                                          TextSpan(
                                                                              text: " Est actuellement  "),
                                                                          MySpan(
                                                                              "${result['status']}",
                                                                              23,
                                                                              Colors.red),
                                                                          TextSpan(
                                                                              text: ". et sa date d'expiration est "),
                                                                          MySpan(
                                                                              "${result['expiration']}.",
                                                                              23,
                                                                              Colors.red),
                                                                          TextSpan(
                                                                              text: " Continuez à suivre nos promotions \n pour d'autres opportunités de faire des économies."),
                                                                        ]),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ));
                                                      });
                                            },
                                            child: Card(
                                              color: result['flag'] == 0
                                                  ? Colors.blue[100]
                                                  : Colors.white,
                                              child: ListTile(
                                                trailing:
                                                    result['status'] == 'Expiré'
                                                        ? const Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(
                                                            Icons.done,
                                                            color: Colors.blue,
                                                          ),
                                                leading: CircleAvatar(
                                                    child: Image.asset(
                                                        'assets/coupon.jpg')),
                                                title: Text.rich(TextSpan(
                                                    text: 'Code:',
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              ' ${result['code']}',
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ])),
                                                subtitle: Text.rich(TextSpan(
                                                    text: 'expiration:',
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              ' ${result['status']}',
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ])),
                                              ),
                                            ));
                                      }))
                        ],
                      )
                    ],
                  ),
                  drawer: Drawer(
                    elevation: 20,
                    child: ListView(
                      children: [
                        Container(
                          height: 100,
                          color: Colors.blue,
                          child: const Center(
                              child: Text(
                            "Menu",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              _tabController.animateTo(0);
                              Navigator.of(context).pop();
                            },
                            child: cards("Promotions", "${mataille}",
                                'assets/promotions.png')),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              _tabController.animateTo(1);
                              Navigator.of(context).pop();
                            },
                            child: cards(
                                "Coupons", "${taille}", 'assets/coupon.jpg')),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
