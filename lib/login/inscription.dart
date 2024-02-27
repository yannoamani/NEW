import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class inscription extends StatefulWidget {
  const inscription({super.key});

  @override
  State<inscription> createState() => _inscriptionState();
}

class _inscriptionState extends State<inscription> {
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController VerifPassword = TextEditingController();
  TextEditingController number = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscure = false;
  bool charg = false;
  var test = '';
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  
  Future<void> add_users() async {
    var url = monurl('users');
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: jsonEncode(
            {
              'nom': nom.text,
              'prenom': prenom.text,
              'email': email.text,
              'password': Password.text,
              'phone': number.text,
              'role_id': 2
            },
          ),
          headers: Constants.contentType);
      print(response.body);
      final result = jsonDecode(response.body);
      if (result['status']) {
        message(context, 'Inscription reussie', Colors.blue);
        email.clear();
        nom.clear();
        prenom.clear();
        Password.clear();
        number.clear();
        Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => const Login_page())));
        setState(() {
          charg = false;
        });
      } else {
        message(context, "${result['message']}", Colors.red);
        setState(() {
          charg = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/massage.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Titre('Inscription', 30, Colors.black)),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: GoogleFonts.openSans(
                          color: Color.fromARGB(255, 86, 86, 86),
                          fontSize: 20,
                        ),
                        controller: nom,
                        validator: (value) => value!.isEmpty
                            ? 'Renseignez correctement ce champs'
                            : null,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Nom',
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
                              FontAwesomeIcons.user,
                              color: Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                      ),
                      // champs("Nom", nom, Icons.person),
                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        style: GoogleFonts.openSans(
                          color: Color.fromARGB(255, 86, 86, 86),
                          fontSize: 20,
                        ),
                        controller: prenom,
                        validator: (value) => value!.isEmpty
                            ? 'Renseignez correctement ce champs'
                            : null,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Prenom',
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
                              FontAwesomeIcons.user,
                              color: Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.openSans(
                          color: Color.fromARGB(255, 86, 86, 86),
                          fontSize: 20,
                        ),
                        controller: number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10)
                        ],
                        validator: (value) =>
                            value!.isEmpty && value.length < 10
                                ? 'Contact non correct'
                                : null,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Contact',
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
                              FontAwesomeIcons.phone,
                              color: Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                      // phone("Numero de téléphone", number, Icons.numbers),
                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        style: GoogleFonts.openSans(
                          color: Color.fromARGB(255, 86, 86, 86),
                          fontSize: 20,
                        ),
                        controller: VerifPassword,
                        onChanged: (value) =>  setState(() {test = value;}),
                        validator: (value) => value!.isEmpty || value.length < 4
                            ? 'Mot de passe trop court'
                            : null,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Mot de passe',
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
                      SizedBox(height: 20,),
                      TextFormField(
                        style: GoogleFonts.openSans(
                          color: Color.fromARGB(255, 86, 86, 86),
                          fontSize: 20,
                        ),
                        controller: Password,
                        
                        validator: (value) => value!.isEmpty || value!=test|| value.length < 4
                            ? 'Mot de passe non conforme'
                            : null,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "Confirmation du mot de passe",
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
                      SizedBox(height: 20,),
                      
                      
                    
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blue,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                            onPressed: () {
                              print("object");
                              if (formKey.currentState!.validate()) {
                                // setState(() {
                                //   charg == true;
                                // });
                                add_users();
                              }
                            },
                            child: charg == true
                                ? SpinKitCircle(
                                    color: Colors.white,
                                  )
                                : Mytext("M'inscrire", 15, Colors.white)),
                      ),
                      // boutton(context, charg, Colors.red, "S'inscrire", () {
                      //   if (formKey.currentState!.validate()) {
                      //     // setState(() {
                      //     //   charg = true;
                      //     // });
                      //     add_users();
                      //   }
                      // }),
                    ],
                  )),
              Row(
                children: [
                 Mytext("J'ai un compte", 15, Colors.black),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const Login_page()));
                      },
                      child: Titre("Cliquez ici", 15, Colors.blue),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
