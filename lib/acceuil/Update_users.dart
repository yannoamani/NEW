import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class details extends StatefulWidget {
  const details({super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  bool charg = false;
  bool charg1 = false;
  bool _obscure = false;
  bool _obscure1 = false;
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController emailPassword = TextEditingController();
  TextEditingController Ancienpassword = TextEditingController();
  TextEditingController Newpassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  var mynom;
  Future getinfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mynom = prefs.getInt('id');
      nom.text = prefs.getString('name').toString();
      prenom.text = prefs.getString('prenom').toString();
      email.text = prefs.getString('email').toString();
      emailPassword.text = prefs.getString('email').toString();
      phone.text = prefs.getString('phone').toString();
    });
  }

  Future<void> update() async {
    final url = monurl("users/$mynom");
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode({
          "nom": nom.text,
          "prenom": prenom.text,
          "email": email.text,
          'phone': phone.text,
          'password': password.text
        }),
        headers: Constants.contentType);
    print(response.body);
    final decode = jsonDecode(response.body);
    if (decode['status']) {
      message(context, 'Modifier avec succès', Colors.green);
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString('name', decode['user']['nom']);
      });
      email.clear();
      nom.clear();
      prenom.clear();
      phone.clear();
      setState(() {
        charg = true;
        Navigator.pop(context);
      });
    }
  }

  Future<void> Modifier_Password() async {
    final prefs = await SharedPreferences.getInstance();
    var url = monurl("modifyPassword");
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(
          {
            'email': emailPassword.text,
            'oldPassword': Ancienpassword.text,
            'password': Newpassword.text
          },
        ),
        headers: header(prefs.getString('token')!));
    print(response.body);
    final result = jsonDecode(response.body);
    if (result['status']) {
      message(context, result['message'], Colors.green);
      Navigator.pop(context);
    } else {
      message(context, "${result['message']} ressayer", Colors.red);
    }
    email.clear();
    Ancienpassword.clear();
    Newpassword.clear();
  }

  @override
  void initState() {
    getinfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
           
            Container(
              // height: 100,
              width: 200,
              decoration: BoxDecoration(
                
                  shape: BoxShape.circle, ),
              child:  Image.asset('assets/pngwing.com.png',
              fit: BoxFit.cover,
              )
            ),
           const  SizedBox(
              height: 25,
            ),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const   Text(
                  "PROFIL",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
               VraiInput(nom, "Nom", FontAwesomeIcons.user),
                const SizedBox(
                  height: 30,
                ),
                   VraiInput(prenom, "Prenom", FontAwesomeIcons.user),
                const SizedBox(
                  height: 30,
                ),
                 VraiInput(email, "Email", FontAwesomeIcons.at),
               
                const SizedBox(
                  height: 30,
                ),
                VraiInput(phone, 'Phone', FontAwesomeIcons.phone),
             
                
             const    SizedBox(
                  height: 30,
                ),
                
                boutton(context, charg, Colors.blue, "Valider", () {
                  setState(() {
                    charg = !charg;
                  });
                  getinfo();
                  update();
                }),
                 const    SizedBox(
                  height: 30,
                ),
                const Divider(height: 1,color: Colors.blue,),
                   const    SizedBox(
                  height: 30,
                ),
                 Text(
                  "MODIFIER LE MOT DE PASSE",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              const   SizedBox(
                  height: 30,
                ),
                VraiInput(emailPassword,'Email', FontAwesomeIcons.at),
                SizedBox(
                  height: 20,
                ),
                VraiInput(Ancienpassword, "Ancien mot de passe", FontAwesomeIcons.lock),
                SizedBox(
                  height: 20,
                ),
               VraiInput(Newpassword,"Nouveau Mot de passe", FontAwesomeIcons.lock),
                SizedBox(
                  height: 25,
                ),
                boutton(context, charg1, Colors.blue, " Valider", () {
                  Modifier_Password();
                })
              ],
            )),
          ],
        ),
      ),
    ));
  }
}
