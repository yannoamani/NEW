import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/module_reservation/Modifier_ma_reservation.dart';
import 'package:gestion_salon_coiffure/module_reservation/Passer_Une_Reservation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mes_reservations extends StatefulWidget {
  const Mes_reservations({super.key});

  @override
  State<Mes_reservations> createState() => _Mes_reservationsState();
}

class _Mes_reservationsState extends State<Mes_reservations>
    with TickerProviderStateMixin {
  List Reservation_A_V = [];
  List reservationDejaPasser = [];
  List reservattionTerminer = [];
  int rating = 0;
  bool Rating = false;
  Future<void> reservationsfinish() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationClientValide");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    if (response.statusCode == 200) {
      final resultat = jsonDecode(response.body);
      setState(() {
        reservattionTerminer = resultat['data'];
      });
    } else {
      print(response.body);
    }
  }

  Future<void> reservationAvenir() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationAvenir");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      Reservation_A_V = resultat['data'];
    });
    print(Reservation_A_V);
  }

  Future<void> ReservationDejaPasser() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationPasser");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationDejaPasser = resultat['data'];
    });
    print(reservationDejaPasser);
  }

  Future<String> Getdata() async {
    await Future.delayed(Duration(seconds: 1));

    return 'thow';
  }

  TextEditingController _controlCommentaire = TextEditingController();

  Future<void> noter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var Url = monurl('notes');
      final uri = Uri.parse(Url);
      final response = await http.post(uri,
          body: jsonEncode({
            'reservation_id': 183,
            'rate': rating,
            'user_id': prefs.get('id'),
            'commentaire': _controlCommentaire.text
          }),
          headers: header("${prefs.get('token')}"));
      final result = jsonDecode(response.body);
      print(response.body);

      if (result['status'] == 'true') {
        message(context, 'Note envoyé avec succès ', Colors.green);
        rating = 0;
        Future.delayed(Duration(milliseconds: 1000));
        {
          Navigator.of(context).pop();
        }
        _controlCommentaire.clear();
      } else {
        message(context, "${result['message']}", Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationAvenir();
    reservationsfinish();
    _tabController = TabController(length: 3, vsync: this);
    ReservationDejaPasser();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Title(
                color: Colors.black,
                child: Titre('Reservations', 15, Colors.black)),
            bottom: TabBar(controller: _tabController, tabs: [
              Tab(
                child: Mytext('Termineés', 15, Colors.black),
              ),
              Tab(
                child: Mytext('A venir', 15, Colors.black),
              ),
              Tab(
                child: Mytext('Passées', 15, Colors.black),
              ),
            ]),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await reservationAvenir();
              await reservationsfinish();
              await ReservationDejaPasser();
            },
            child: TabBarView(controller: _tabController, children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.circleCheck,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Titre("Reservations validées", 15,
                                      Colors.white),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final result = reservattionTerminer[index];
                      final date = result['date'];
                      DateTime _date = DateTime.parse(date);
                      String madate =
                          DateFormat.yMMMMEEEEd('fr_FR').format(_date);

                      List photos = result['service']['photos'];
                      final result1 = photos.isEmpty
                          ? ''
                          : result['service']['photos'][0]['path'];
                      final Mydate = result['date'];
                      DateTime My = DateTime.parse(Mydate);
                      String Days = DateFormat.EEEE('fr_FR').format(My);
                      String Mounth = DateFormat.MMM('fr_FR').format(My);
                      String years = DateFormat.y('fr_Fr').format(My);

                      return GestureDetector(
                          onTap: () async {
                            //  Ce qui se passe une fois que je clique une reservation
                            final prefs = await SharedPreferences.getInstance();
                            setState(() {
                              prefs.setInt('id_reservation', result["id"]);
                            });

                            print(prefs.get('id_reservation'));
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Scaffold(
                                        body: CustomScrollView(
                                      slivers: [
                                        SliverAppBar(
                                          expandedHeight: 300,
                                          pinned: true,
                                          floating: true,
                                          flexibleSpace: FlexibleSpaceBar(
                                              background: Stack(
                                            children: [
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(
                                                      0.6), // Ajustez l'opacité selon votre besoin
                                                  BlendMode.darken,
                                                ),
                                                child: Image.network(
                                                  ImgDB(
                                                      'public/image/${result1}'),
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Titre(
                                                      "${result['service']['libelle']} ",
                                                      25,
                                                      Colors.white))
                                            ],
                                          )),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, right: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // SizedBox(
                                                //   height: 20,),
                                                Container(
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
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
                                                            "${result['status']}",
                                                            20,
                                                            Colors.white),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Titre(
                                                    "$madate à ${result['heure']}",
                                                    18,
                                                    Colors.black),

                                                Mytext(
                                                    "Durée:${result['service']['duree']}h",
                                                    15,
                                                    const Color.fromARGB(
                                                        255, 78, 77, 77)),
                                                SizedBox(
                                                  height: 30,
                                                ),

                                                ListTile(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        // isScrollControlled: true,
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                      setState) =>
                                                                  Scaffold(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    body:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            16),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Titre('Comment avez-vous rouvé la qualité de cette prestation?', 15, Colors.black),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Mytext("Votre reponse est anonyme.Elle permet à l'entrprise d'ameliorer votre expérience$Rating", 12, const Color.fromARGB(255, 66, 65, 65)),
                                                                              EmojiFeedback(
                                                                                animDuration: const Duration(milliseconds: 300),
                                                                                curve: Curves.bounceIn,
                                                                                inactiveElementScale: .5,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    rating = value;
                                                                                  });
                                                                                  if (rating < 3) {
                                                                                    setState(() {
                                                                                      Rating = true;
                                                                                    });
                                                                                  }
                                                                                  print(Rating);
                                                                                },
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              // ignore: unrelated_type_equality_checks
                                                                              rating < 4
                                                                                  ? TextFormField(
                                                                                      controller: _controlCommentaire,
                                                                                      maxLines: 2,
                                                                                      decoration: InputDecoration(
                                                                                        hintText: 'Laisse un commentaire$rating',
                                                                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue, width: 1)),
                                                                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, width: 1)),
                                                                                      ),
                                                                                    )
                                                                                  : Text(""),
                                                                              SizedBox(
                                                                                height: 25,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                      style: ButtonStyle(
                                                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                            RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                          )),
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Mytext('Pas maintenant', 15, Colors.blue)),
                                                                                  ElevatedButton(
                                                                                      style: ButtonStyle(
                                                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                            RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                          )),
                                                                                      onPressed: () {
                                                                                        noter();
                                                                                      },
                                                                                      child: Mytext('Envoyer', 15, Colors.white))
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ));
                                                        });
                                                  },
                                                  title: NewBold(
                                                      'Evaluer la prestation',
                                                      15,
                                                      Colors.black),
                                                  subtitle: Mytext(
                                                      "Vôtre réponse est anonyme , Elle permet au service de s'ameliorer.",
                                                      13,
                                                      Colors.grey),
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.amber[100],
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .solidStar,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Titre("Récapitulatif", 15,
                                                    Colors.black),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    Titre('Total', 15,
                                                        Colors.black),
                                                    Spacer(),
                                                    Titre(
                                                        '${result['montant']} FCFA',
                                                        20,
                                                        Colors.black),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Center(
                                                  child: Text.rich(TextSpan(
                                                      text:
                                                          "Réference du rendez-vous",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                " ${result['id']}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ])),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                  );
                                });
                          },
                          // Voici le card de la liste des reservation à venir
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Couleur de l'ombre
                                      spreadRadius: 5, // Étendue de l'ombre
                                      blurRadius: 7, // Flou de l'ombre
                                      offset:
                                          Offset(0, 3), // Décalage de l'ombre
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          Mytext("$Days", 20, Colors.black),
                                          Titre("${My.day}", 25, Colors.black),
                                          Mytext("$Mounth", 20, Colors.black),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              "${result['service']['libelle']} ",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Mytext('${result['heure']}', 15,
                                              Colors.black),
                                          FittedBox(
                                            child: Titre(
                                                '${result['montant']}FCFA',
                                                15,
                                                Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.circleCheck,
                                      color: Colors.green,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                    itemCount: reservattionTerminer.length,
                  ),
                ],
              ),

              // Le Deuxieme container
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.circleCheck,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Titre("Reservations  à venir ", 15,
                                      Colors.white),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final result = Reservation_A_V[index];
                      final date = result['date'];
                      DateTime _date = DateTime.parse(date);
                      String madate =
                          DateFormat.yMMMMEEEEd('fr_FR').format(_date);

                      List photos = result['service']['photos'];
                      final result1 = photos.isEmpty
                          ? ''
                          : result['service']['photos'][0]['path'];
                      final Mydate = result['date'];
                      DateTime My = DateTime.parse(Mydate);
                      String Days = DateFormat.EEEE('fr_FR').format(My);
                      String Mounth = DateFormat.MMM('fr_FR').format(My);
                      String years = DateFormat.y('fr_Fr').format(My);

                      return GestureDetector(
                          onTap: () {
                            //  Ce qui se passe une fois que je clique une reservation
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Scaffold(
                                        body: CustomScrollView(
                                      slivers: [
                                        SliverAppBar(
                                          expandedHeight: 300,
                                          pinned: true,
                                          floating: true,
                                          flexibleSpace: FlexibleSpaceBar(
                                              background: Stack(
                                            children: [
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(
                                                      0.6), // Ajustez l'opacité selon votre besoin
                                                  BlendMode.darken,
                                                ),
                                                child: Image.network(
                                                  ImgDB(
                                                      'public/image/${result1}'),
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Titre(
                                                      "${result['service']['libelle']} ",
                                                      25,
                                                      Colors.white))
                                            ],
                                          )),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, right: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // SizedBox(
                                                //   height: 20,),
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
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .spinner,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Mytext(
                                                            "${result['status']}",
                                                            20,
                                                            Colors.white),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Titre(
                                                    "$madate à ${result['heure']}",
                                                    18,
                                                    Colors.black),

                                                Mytext(
                                                    "Durée:${result['service']['duree']}h",
                                                    15,
                                                    const Color.fromARGB(
                                                        255, 78, 77, 77)),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ListTile(
                                                  onTap: () {},
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.indigo[100],
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .calendarDay,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  title: NewBold(
                                                      'Gerer votre rendez-vous',
                                                      15,
                                                      Colors.black),
                                                  subtitle: Mytext(
                                                      'Reprogrammez ou annulez votre rendez-vous',
                                                      13,
                                                      Colors.grey),
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                NewBold("Recapitulatif", 15,
                                                    Colors.black),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Titre('Total', 15,
                                                        Colors.black),
                                                    Spacer(),
                                                    Titre(
                                                        '${result['montant']} F CFA',
                                                        18,
                                                        Colors.black),
                                                  ],
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                NewBold(
                                                    "Politique d'annulation",
                                                    15,
                                                    Colors.black),
                                                SizedBox(
                                                  height: 6,
                                                ),

                                                Center(
                                                  child: Text.rich(TextSpan(
                                                      text:
                                                          "Veuillez éviter d'annuler  dans un delais de 12 heures avant votre rendez-vous",
                                                      style:
                                                          GoogleFonts.andadaPro(
                                                              color:
                                                                  Colors.grey),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                " ${result['id']}",
                                                            style: GoogleFonts
                                                                .andadaPro(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                      ])),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                  );
                                });
                          },
                          // Voici le card de la liste des reservation à venir
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Couleur de l'ombre
                                      spreadRadius: 5, // Étendue de l'ombre
                                      blurRadius: 7, // Flou de l'ombre
                                      offset:
                                          Offset(0, 3), // Décalage de l'ombre
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          Mytext("$Days", 20, Colors.black),
                                          Titre("${My.day}", 25, Colors.black),
                                          Mytext("$Mounth", 20, Colors.black),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              "${result['service']['libelle']}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Mytext('${result['heure']}', 15,
                                              Colors.black),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            child: Text(
                                              "${result['montant']}FCFA",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.spinner,
                                      color: Colors.orange,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                    itemCount: Reservation_A_V.length,
                  ),
                ],
              ),

              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.compass,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Titre("Historiques ", 15, Colors.white),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final result = reservationDejaPasser[index];
                      final date = result['date'];
                      DateTime _date = DateTime.parse(date);
                      String madate =
                          DateFormat.yMMMMEEEEd('fr_FR').format(_date);

                      List photos = result['service']['photos'];
                      final result1 = photos.isEmpty
                          ? ''
                          : result['service']['photos'][0]['path'];
                      final Mydate = result['date'];
                      DateTime My = DateTime.parse(Mydate);
                      String Days = DateFormat.EEEE('fr_FR').format(My);
                      String Mounth = DateFormat.MMM('fr_FR').format(My);
                      String years = DateFormat.y('fr_Fr').format(My);

                      return GestureDetector(
                          onTap: () {
                            //  Ce qui se passe une fois que je clique une reservation
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Scaffold(
                                        body: CustomScrollView(
                                      slivers: [
                                        SliverAppBar(
                                          expandedHeight: 300,
                                          pinned: true,
                                          floating: true,
                                          flexibleSpace: FlexibleSpaceBar(
                                              background: Stack(
                                            children: [
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(
                                                      0.6), // Ajustez l'opacité selon votre besoin
                                                  BlendMode.darken,
                                                ),
                                                child: Image.network(
                                                  ImgDB(
                                                      'public/image/${result1}'),
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Titre(
                                                      "${result['service']['libelle']} ",
                                                      25,
                                                      Colors.white))
                                            ],
                                          )),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, right: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // SizedBox(
                                                //   height: 20,),
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
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .spinner,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Mytext(
                                                            "${result['status']}",
                                                            20,
                                                            Colors.white),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Titre(
                                                    "$madate à ${result['heure']}",
                                                    18,
                                                    Colors.black),

                                                Mytext(
                                                    "Durée:${result['service']['duree']}h",
                                                    15,
                                                    const Color.fromARGB(
                                                        255, 78, 77, 77)),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.indigo[100],
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .calendarDay,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  title: NewBold(
                                                      'Gerer votre rendez-vous',
                                                      15,
                                                      Colors.black),
                                                  subtitle: Mytext(
                                                      'Reprogrammez la reservation',
                                                      13,
                                                      Colors.grey),
                                                  onTap: () async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setInt(
                                                        'idReservation',
                                                        result['id']);
                                                    prefs.setInt('id_service',
                                                        result['service_id']);
                                                    print(prefs
                                                        .get("idReservation"));
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                            builder: (context) =>
                                                                ModifierReservation()));
                                                  },
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                NewBold("Recapitulatif", 15,
                                                    Colors.black),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Titre('Total', 15,
                                                        Colors.black),
                                                    Spacer(),
                                                    Titre(
                                                        '${result['montant']} F CFA',
                                                        18,
                                                        Colors.black),
                                                  ],
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                NewBold(
                                                    "Politique d'annulation",
                                                    15,
                                                    Colors.black),
                                                SizedBox(
                                                  height: 6,
                                                ),

                                                Center(
                                                  child: Text.rich(TextSpan(
                                                      text:
                                                          "Veuillez éviter d'annuler  dans un delais de ",
                                                      style:
                                                          GoogleFonts.andadaPro(
                                                              color:
                                                                  Colors.grey),
                                                      children: [
                                                        TextSpan(
                                                          text: " 12 heures",
                                                          style: GoogleFonts
                                                              .andadaPro(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              "  avant votre rendez-vous",
                                                          style: GoogleFonts
                                                              .andadaPro(
                                                                  color: Colors
                                                                      .grey),
                                                        )
                                                      ])),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                  );
                                });
                          },
                          // Voici le card de la liste des reservation à venir
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Couleur de l'ombre
                                      spreadRadius: 5, // Étendue de l'ombre
                                      blurRadius: 7, // Flou de l'ombre
                                      offset:
                                          Offset(0, 3), // Décalage de l'ombre
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          Mytext("$Days", 20, Colors.black),
                                          Titre("${My.day}", 25, Colors.black),
                                          Mytext("$Mounth", 20, Colors.black),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              "${result['service']['libelle']} ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Mytext('${result['heure']}', 15,
                                              Colors.black),
                                          FittedBox(
                                            child: Titre(
                                                '${result['montant']}FCFA',
                                                15,
                                                Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                    itemCount: reservationDejaPasser.length,
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}
