import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/login/ConfirmReset.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  bool test = false;
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final GlobalKey<FormState> _MyKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  Future<void> resetPassword() async {
    final url = monurl("password");
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: header('Token'),
      body: jsonEncode(
        {'email': email.text},
      ),
    );
    final result = jsonDecode(response.body);
    print(response.body);
    if (result['status']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ConfrimReset()),
      );
    } else {
      message(context, "${result['message']}", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/oublie.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Titre("Mot de passe oublié ?", 30, Colors.black)),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Veuillez entrer votre adresse e-mail ci-dessous et cliquer sur le bouton 'Renitialiser' pour recevoir votre nouveau mot de passe.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 15),
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Form(
                  key: _MyKey,
                  child: TextFormField(
                    style: GoogleFonts.openSans(
                      color: Color.fromARGB(255, 86, 86, 86),
                      fontSize: 20,
                    ),
                    controller: email,
                    validator: (value) =>
                        value!.isEmpty || !regex.hasMatch(value)
                            ? 'Email non correct'
                            : null,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Email ID',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 86, 86, 86),
                      ),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1)),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: FaIcon(
                          FontAwesomeIcons.at,
                          color: Color.fromARGB(255, 86, 86, 86),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                      onPressed: () {
                        if (_MyKey.currentState!.validate()) {
                          resetPassword();
                        }
                      },
                      child:
                          // charg == true
                          //     ? SpinKitCircle(
                          //         color: Colors.white,
                          //       )
                          Titre("Renitialiser", 25, Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
