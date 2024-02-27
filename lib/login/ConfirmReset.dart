import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';

class ConfrimReset extends StatefulWidget {
  const ConfrimReset({super.key});

  @override
  State<ConfrimReset> createState() => _ConfrimResetState();
}

class _ConfrimResetState extends State<ConfrimReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Container(height: 150, width: 150,
            child: Image.asset('assets/Email.png'),),
            SizedBox(height: 15,),
            Titre("Verifiez votre Email", 25, Colors.black),
            SizedBox(height: 20,),
            Mytext("Votre demande de récupération de mot de passe a été envoyée avec succès. Veuillez consulter votre boîte de réception pour les instructions sur la réinitialisation du mot de passe. Merci.",
             15, Colors.black),
             SizedBox(height: 50,),
          
             Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                          onPressed: 
                             
                               () {
                                  Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login_page()),
      );
                                 
                                },
                          child: Mytext('Suivant', 15, Colors.white)),
                    )
            
            
            ],
          ),
        ),
      ),
    );
  }
}
