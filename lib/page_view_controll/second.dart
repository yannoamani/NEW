import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:lottie/lottie.dart';
class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 300, width: double.infinity, 
          child:Lottie.asset('assets/Reservation.json')
           ),
          SizedBox(
            height: 20,
          ),
          Titre("Planifier votre Rendez-vous Personnalisé", 30, Colors.black),
          SizedBox(
            height: 15,
          ),
          Mytext(
              " Choisissez le créneau horaire qui s'adapte à votre emploi du temps et planifiez votre rendez-vous en quelques clics",
              15,
              Colors.black),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
    ;
  }
}
