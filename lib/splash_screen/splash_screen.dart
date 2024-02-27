import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/Admin_Page/HomePageAdmin.dart';
import 'package:gestion_salon_coiffure/acceuil/acceuil.dart';
import 'package:gestion_salon_coiffure/login/inscription.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:gestion_salon_coiffure/page_view_controll/PageVewFirst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();


    Timer(Duration(seconds: 10), () async{
      final pefs= await SharedPreferences.getInstance();
      if (pefs.getString('token')==null) {
         if (pefs.getInt('id_role') == 2) {
         
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const acceuil()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home_Admin()));
        }
      //    Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           const acceuil()), 
      // );
        
      }
      else{
           Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                  TabView()), // Assuming Connexion is a widget
      );

      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  Text("Les Coulés",style: TextStyle(color: Colors.white,fontSize: 20),),
            Center(
              child: Container(
               height: 100,
                width: 100,
                color: Colors.transparent,
                child: Image.asset('assets/massage.png',fit: BoxFit.cover,),
              ),
            ),
            SizedBox(height: 10,),
            // Text('Beauté express'),
            SizedBox(
              height: 30,
            ),
            SpinKitFadingCircle(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
