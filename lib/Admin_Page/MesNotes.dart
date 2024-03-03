import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MesNotes extends StatefulWidget {
  const MesNotes({super.key});

  @override
  State<MesNotes> createState() => _MesNotesState();
}

class _MesNotesState extends State<MesNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes notes'),
        actions: [Image.asset('assets/massage.png')],
      ),
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Titre('MES NOTES', 25, Colors.black),
                          SizedBox(
                            height: 5,
                          ),
                          Mytext('Mon Classement actuel', 20, Colors.black),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 13.0,
                            animation: true,
                            animationDuration: 2500,
                            percent: 0.7,
                            center: Titre('7.0', 20, Colors.black),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Titre(
                                  'La note a augmenté au cours des derniers jours.',
                                  15,
                                  Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Titre('Basé sur 30 votes', 15, Colors.black),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Titre('Les commentaires', 20, Colors.white),
                        )),
                  )
                ],
              ),
            ),
          ),
          SliverList.separated(
              separatorBuilder: (context, index) {
               return SizedBox(
                  height: 15,
                );
              },
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Titre('Avis', 20, Colors.black),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                child: Row(children: [
                              for (var i = 0; i < 5; i++)
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.amber,
                                )
                            ])),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle),
                              height: 40,
                              width: 40,
                              child:
                                  Center(child: Titre('8.1', 17, Colors.white)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Titre('COMMENTAIRE', 18, Colors.black),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              NewText(
                                  "Une expérience extraordinaire ! Le service était exceptionnel du début à la fin. L'attention portée aux détails et la qualité des produits/services étaient tout simplement remarquables. J'ai rarement eu une aussi belle expérience,",
                                  15,
                                  Colors.black)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
