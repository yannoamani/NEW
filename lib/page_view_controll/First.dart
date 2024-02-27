import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:lottie/lottie.dart';

class MaPremiere extends StatefulWidget {
  const MaPremiere({super.key});

  @override
  State<MaPremiere> createState() => _MaPremiereState();
}

class _MaPremiereState extends State<MaPremiere> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              // color: Colors.red,
              height: 250,
              width: double.infinity,
              child: Lottie.asset('assets/Search.json', 
               width: double.infinity,
  height: double.infinity,
              fit: BoxFit.fill)),
       
          Titre("La Recherche du Service Idéal", 30, Colors.black),
          SizedBox(
            height: 15,
          ),
          Mytext(
              "Découvrez notre gamme variée de massages relaxants et thérapeutiques. Explorez les différentes techniques et trouvez celle qui correspond à vos besoins pour une expérience de détente ultime ",
              15,
              Colors.black),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }
}
