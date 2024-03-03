import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Admin_Page/HomePageAdmin.dart';
import 'package:gestion_salon_coiffure/acceuil/acceuil.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/login/forgot_password.dart';
import 'package:gestion_salon_coiffure/login/inscription.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_provider.dart';
import 'package:gestion_salon_coiffure/splash_screen/model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key, this.label});
  final String? label;

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  bool _obscure = true;
  bool charg = false;
  TextEditingController email = TextEditingController();
  TextEditingController Password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  String _Email = '';

  // Custome _custome = Custome();
  // Rx<User> users = User("", "").obs;
  // TesterUser LOgin = TesterUser('', '', true as Bool);
  // LoginProvider loginProvider = LoginProvider();

  Future<void> login() async {
    try {
      final Vemail = email.text;
      final Vpassword = Password.text;
      var url = monurl("login");
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          body: jsonEncode({"email": Vemail, "password": Vpassword}),
          headers: header(""));
      final decode = jsonDecode(response.body);
      // print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          charg = false;
        });

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('name', '${decode['data']['nom']}');
        prefs.setString('prenom', '${decode['data']['prenom']}');
        prefs.setString('token', '${decode['access_token']}');
        prefs.setInt('id', decode['data']['id']);
        prefs.setString('phone', '${decode['data']['phone']}');
        prefs.setString('email', '${decode['data']['email']}');
            prefs.setInt('id_role', decode['data']['role']['id']);

        print("Je suis" + prefs.getString('token')!);
        print("Je suis" + prefs.getString('name')!);
        print(prefs.getInt('id'));
        print("Je suis" + prefs.getString('phone')!);

        print('${decode['data']['role']['id']}');
        if (decode['data']['role']['id'] == 2) {
          prefs.setInt('id_role', decode['data']['role']['id']);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const acceuil()));
        } else {
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home_Admin()));
        }

        message(context, 'Connecter avec succès', Colors.green);
      } else {
        setState(() {
          charg = false;
        });
        message(context, '${decode['message']}', Colors.red);
      }
    } catch (e) {
      setState(() {
        charg = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    // color: Colors.red,
                    child: Image.asset(
                      "assets/massage.png",
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Titre('Connexion', 30, Colors.black)),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          style: GoogleFonts.openSans(
                            color: Color.fromARGB(255, 86, 86, 86),
                            fontSize: 20,
                          ),
                          controller: email,
                          onChanged: (value) => setState(() {
                            _Email = value;
                          }),
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
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FaIcon(
                                FontAwesomeIcons.at,
                                color: Color.fromARGB(255, 86, 86, 86),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          style: GoogleFonts.openSans(
                            color: Color.fromARGB(255, 86, 86, 86),
                            fontSize: 20,
                          ),
                          controller: Password,
                          validator: (value) =>
                              value!.length < 4 || value.isEmpty
                                  ? 'Mot de passe trop court'
                                  : null,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 86, 86, 86),
                            ),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FaIcon(
                                FontAwesomeIcons.lock,
                                color: Color.fromARGB(255, 86, 86, 86),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => forgot_password()));
                        },
                        child: Titre('Mot de passe oublié ?', 15, Colors.blue))
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                           charg == false ? Colors.blue : Color(0xFF0A345F),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                      onPressed: _Email.isEmpty
                          ? null
                          : () {
                              print("object");
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  charg = !charg;
                                });
                                print("object");
                                login();
                              }
                            },
                      child: charg == true
                          ?  Mytext('Connexion en cours...', 15, Colors.white)
                          : Mytext('Se connecter', 15, Colors.white)),
                ),
                SizedBox(
                  height: 5,
                ),
                Mytext("Vous n’avez pas de compte ?", 15, Colors.black),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => inscription()));
                  },
                  child: Titre("Inscrivez-vous ici !", 15, Colors.blue),
                ),

                // Row(
                //   children: [
                //     Mytext(" Vous n’avez pas de compte ?", 15, Colors.black),

                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                SizedBox(height: 60),
                      Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Beauté Express © ${DateTime.now().year}$charg",
                            style: const TextStyle(
                                color: Color(0xFF0A345F),
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                          )),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       height: 50,
                //       width: 60,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           border: Border.all(color: Colors.grey)),
                //       child: Center(child: FaIcon(FontAwesomeIcons.google)),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Container(
                //       height: 50,
                //       width: 60,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           border: Border.all(color: Colors.grey)),
                //       child: Center(child: FaIcon(FontAwesomeIcons.facebook)),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Container(
                //       height: 50,
                //       width: 60,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           border: Border.all(
                //             color: Colors.grey,
                //           )),
                //       child: Center(child: FaIcon(FontAwesomeIcons.apple)),
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
