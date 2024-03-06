import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

Widget champs(String libelle, TextEditingController controlle, IconData icon) {
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return TextFormField(
    controller: controlle,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) =>
        value!.isEmpty ? 'Renseignez une adresse emaiil' : null,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      suffixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(40)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      errorStyle: TextStyle(color: Colors.white),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      label: Text(
        libelle,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget mesemail(
    String libelle, TextEditingController controlle, IconData icon) {
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return TextFormField(
    controller: controlle,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => value!.isEmpty || !regex.hasMatch(value)
        ? 'Renseignez une adresse emaiil'
        : null,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      suffixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(40)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      errorStyle: TextStyle(color: Colors.white),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      label: Text(
        libelle,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget phone(String libelle, TextEditingController controlle, IconData icon) {
  return TextFormField(
    controller: controlle,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: [LengthLimitingTextInputFormatter(10)],
    validator: (value) =>
        value!.isEmpty || value!.length < 10 ? 'Numero non correct' : null,
    keyboardType: TextInputType.phone,
    style: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      suffixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(40)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      errorStyle: TextStyle(color: Colors.white),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      label: Text(
        libelle,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

dynamic password(
    bool _obscure, TextEditingController password, VoidCallback tap) {
  return TextFormField(
    obscureText: _obscure,
    controller: password,
    validator: (value) => value!.isEmpty || value!.length < 4
        ? 'The password must be at least 4 characters'
        : null,
    autovalidateMode: AutovalidateMode.always,
    style: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      suffixIcon: IconButton(
          onPressed: tap,
          icon: _obscure
              ? const Icon(
                  Icons.visibility,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.visibility_off,
                  color: Colors.white,
                )),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      errorStyle: TextStyle(color: Colors.white),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40)),
      label: const Text(
        "Password",
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget boutton(BuildContext context, bool charg, Color mycolor, String montexte,
    VoidCallback tap) {
  return Container(
      height: 50,
      
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mycolor),
              shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
          ),
          onPressed: tap,
          child: charg
              ? SpinKitCircle(
                  color: Colors.white,
                )
              :  Mytext(montexte, 15, Colors.white)
                ));
}

Widget texte(String texte) {
  return Text(
    texte,
    style: TextStyle(color: Colors.white, fontSize: 15),
  );
}

// Cette fonction concerne mon Url
String monurl(String endpoint) {
  return 'http://192.168.1.7:6060/api/$endpoint';
}

String ImgDB(String endpoint) {
  return 'http://192.168.1.7:6060/$endpoint';
}

// Cette fonction represente My header
header(String Token) {
  return {
    'Content-Type': "application/json",
    'Authorization': "Bearer $Token",
  };
}

moncontainer(String montexte, VoidCallback tap, TextEditingController name,
    void Function(String) customOnChanged) {
  return Container(
      padding: const EdgeInsets.only(top: 18, left: 8),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.blue[400]),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 30,
                width: 300,
                child: TextFormField(
                  controller: name,
                  onChanged: (value) {
                    customOnChanged(value);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      suffixIcon: Icon(
                        Icons.close,
                        color: Colors.blue,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Rechercher',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
              )
            ],
          )
        ],
      )

      // Container(
      //   height: 50,
      //   child: TextFormField(
      //     controller: name,
      //     onChanged: (value) {
      //       customOnChanged(value);
      //     },
      //     decoration: InputDecoration(
      //         prefixIcon: Icon(
      //           Icons.search,
      //           color: Colors.blue,
      //         ),
      //         suffixIcon: Icon(
      //           Icons.close,
      //           color: Colors.blue,
      //         ),
      //         floatingLabelBehavior: FloatingLabelBehavior.never,
      //         labelText: 'Rechercher',
      //         labelStyle: TextStyle(color: Colors.black),
      //         filled: true,
      //         fillColor: Colors.white,
      //         border: OutlineInputBorder(

      //             borderSide: BorderSide(color: Colors.transparent))),
      //   ),
      // )
      //],
      // )
      );
}

Widget defilement(String montexte, VoidCallback tap) {
  return GestureDetector(
    onTap: tap,
    child: Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.orange[400],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              montexte,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: 1,
        )
      ],
    ),
  );
}

Widget article(
  String texte,
  String img,
  String texte1,
) {
  return Container(
    decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(9))),
    // height: 200,
    width: 200,

    child: Column(
      children: [
        Image.network(
          img,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 4),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  texte,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '$texte1 XOF',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

gridmoncompteRes(
  String libelle,
  IconData icon,
  String taille,
) {
  return Container(
    padding: const EdgeInsets.all(1),
   decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
            spreadRadius: 5, // Étendue de l'ombre
            blurRadius: 7, // Flou de l'ombre
            offset: Offset(0, 3), // Décalage de l'ombre
          ),
        ],
        borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        Titre(libelle, 17, Colors.black),
        SizedBox(
          height: 10,
        ),
        Badge(
          label: Text(taille),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 90,
          ),
        )
      ],
    ),
  );
}

gridmoncompte(String libelle, IconData icon) {
  return Container(
     decoration: BoxDecoration(
                          color: Colors.white,
                          
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Couleur de l'ombre
                              spreadRadius: 5, // Étendue de l'ombre
                              blurRadius: 7, // Flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.all(8),
 
    child: Column(
      children: [
        Titre(libelle, 17, Colors.black),
        Icon(
          icon,
          color: Colors.grey,
          size: 90,
        ),
      ],
    ),
  );
}

Widget enseigne(String libelle, Color couleur, Color enable, IconData icon,
    bool status, TextEditingController _control) {
  return TextFormField(
    controller: _control,
    // initialValue: test,e
    validator: (value) =>
        value!.isEmpty ? 'Remplissez correctement ce champs' : null,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: TextStyle(
      fontSize: 17,
    ),
    decoration: InputDecoration(
      // enabled: status,
      suffix: Icon(icon),
      label: Text(libelle),
      labelStyle: TextStyle(color: couleur),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.orange)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.red)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.blue)),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(width: 3, color: Colors.grey),
      ),
    ),
  );
}

Widget phone_compte(String libelle, Color couleur, Color enable, IconData icon,
    bool status, TextEditingController _control) {
  return TextFormField(
    controller: _control,
    inputFormatters: [LengthLimitingTextInputFormatter(10)],
    keyboardType: TextInputType.number,
    validator: (value) => value!.isEmpty || value.length < 10
        ? 'Numéro de télephone non correct'
        : null,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: TextStyle(
      fontSize: 17,
    ),
    decoration: InputDecoration(
      // enabled: status,
      suffix: Icon(icon),
      label: Text(libelle),
      labelStyle: TextStyle(color: couleur),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.orange)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.red)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(width: 2, color: Colors.blue)),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(width: 3, color: Colors.grey),
      ),
    ),
  );
}

// Widget Mot_de_passe(String libelle, Color couleur, Color enable, bool status,
//     VoidCallback tap) {
//   return TextFormField(
//     obscureText: !status,
//     decoration: InputDecoration(
//       filled: true,
//       enabled: true,
//       suffix: IconButton(
//           onPressed: tap,
//           icon: status ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
//       label: Text(libelle),
//       labelStyle: TextStyle(color: couleur),
//       focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(width: 2, color: Colors.orange)),
//       errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(width: 2, color: Colors.red)),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(width: 2, color: enable)),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//         borderSide: BorderSide(width: 3, color: Colors.grey),
//       ),
//     ),
//   );
// }

Widget image() {
  return Container(
    width: double.infinity,
    height: 300,
    color: Colors.white,
    child: Image.asset(
      "assets/connexion.jpg",
      fit: BoxFit.cover,
    ),
  );
}

message(BuildContext context, String libelle, Color couleur) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 900),
      backgroundColor: couleur,
      content: NewBold(libelle, 15, Colors.white)));
}

// pour mon compte()
dynamic password_compte(bool _obscure, TextEditingController password,
    VoidCallback tap, String txte) {
  return TextFormField(
    obscureText: _obscure,
    controller: password,
    validator: (value) => value!.isEmpty || value!.length < 4
        ? 'The password must be at least 4 characters'
        : null,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
    decoration: InputDecoration(
      suffixIcon: IconButton(
          onPressed: tap,
          icon: _obscure
              ? const Icon(
                  Icons.visibility,
                )
              : const Icon(
                  Icons.visibility_off,
                  color: Colors.black,
                )),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(40)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(40)),
      errorStyle: TextStyle(color: Colors.red),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(40)),
      label: Text(
        txte,
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}

// les textformfield pour  les details sur les services
Widget Info_service(String libService) {
  return TextFormField(
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      initialValue: libService,
      decoration: const InputDecoration(
        enabled: false,
      ));
}

// Card des proomotion

Widget MesPromotion(
    String titre, String description, String pourcentage, VoidCallback tap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Image.asset(
                        "assets/connexion.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titre,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            pourcentage,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    TextButton(
                      onPressed: tap,
                      child: const Text(
                        "Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

// Voici le card pour la page d'acceuil
Widget Firs_page(BuildContext context) {
  return Card(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.red,
          child: Image.asset(
            "assets/connexion.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Text("Huckle the baber old",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text("Description",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
        Text("Prix"),
        Card(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: texte("Populaire"),
            ))
      ],
    ),
  );
}



Widget cards(String indice, String taille, String image) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset(image),
      ),
      title: Text(
        indice,
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500),
      ),
      trailing: Badge(
        label: Text(taille),
        child: Icon(Icons.notifications),
      ),
    ),
  );
}

// historique de mes reservations
Widget historiqueReservation(
    String NomDuService, String tarif, String Date, String heure, Color Color) {
  return Container(
    decoration: BoxDecoration(
      color: Color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Titre(NomDuService, 23.0, Colors.white),
        Mytext(Date, 22, Colors.white),
        Mytext(heure, 20, Colors.white),
        Titre(tarif, 18, Colors.white),
      ],
    ),
  );
}

// Mon liste tile pour les reservations
Widget ListeTiles(String indice, IconData icon) {
  return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Icon(
          icon,
          color: Colors.blue[900],
        ),
      ),
      trailing: Icon(
        Icons.arrow_circle_right_rounded,
        color: Colors.blue,
      ),
      title: Titre(indice, 20, Colors.black));
}

// voici le Code pour representer ma teille  de montexte
Widget Mytext(String montexte, double Size, Color couleur) {
  return Text(
    montexte,
    style: GoogleFonts.andadaPro(
      fontSize: Size,
      color: couleur,
    ),
    textAlign: TextAlign.center,
  );
}
Widget NewText(String montexte, double Size, Color couleur) {
  return Text(
    montexte,
    style: GoogleFonts.andadaPro(
      fontSize: Size,
      color: couleur,
    ),
  
  );
  
}
Widget NewBold(String montexte, double Size, Color couleur) {
  return Text(
    montexte,
    style: GoogleFonts.andadaPro(
        fontSize: Size, color: couleur, fontWeight: FontWeight.bold),
        // textAlign: TextAlign.center,
  );
}

Widget Titre(String montexte, double Size, Color couleur) {
  return Text(
    montexte,
    style: GoogleFonts.andadaPro(
        fontSize: Size, color: couleur, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
  );
}

TextSpan MySpan(String libelle, double taille, Color Color) {
  return TextSpan(
      text: libelle,
      style: TextStyle(
          fontSize: taille, color: Color, fontWeight: FontWeight.bold));
}

// Mes inputs pour la page login
Widget VraiInput( TextEditingController _controll, String Libelle,IconData Icon ) {
  return TextFormField(
    style: GoogleFonts.openSans(
      color: Color.fromARGB(255, 86, 86, 86),
      fontSize: 20,
    ),
    controller: _controll,
  
    validator: (value) =>
        value!.isEmpty ? 'Remplissez correctement ' : null,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      hintText: '$Libelle',
      hintStyle: TextStyle(
        fontSize: 20,
        color: Color.fromARGB(255, 86, 86, 86),
      ),
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1)),
      prefixIcon: Padding(
        padding: EdgeInsets.only(top: 10),
        child: FaIcon(
          Icon,
          color: Color.fromARGB(255, 86, 86, 86),
        ),
      ),
    ),
  );
}

Card cardselection(
    double large, IconData icon, String texte,String indice, Color couleur, double size) {
  return Card(
    elevation: 3,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
     height: 200,
      width: (large / 2 - 20),
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: couleur,
              child:  NewBold(indice, 15, Colors.white)
            ),
            SizedBox(height: 5,),
            Text(
              texte,
              textAlign: TextAlign.center,
              style:  GoogleFonts.openSans(
                 color: Colors.black,
                 
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
 cardreservations(BuildContext context, String days, 
 String number, 
 String mounth,
  String libelleService,
  String heure,
  String prix,
  String statut
  
  ){
  return   Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(
                                                      0.5), // Couleur de l'ombre
                                                  spreadRadius:
                                                      1, // Étendue de l'ombre
                                                  blurRadius:
                                                      7, // Flou de l'ombre
                                                  offset: Offset(0,
                                                      3), // Décalage de l'ombre
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Column(
                                                    children: [
                                                      Mytext("$days", 20,
                                                          Colors.white),
                                                      Titre("$number", 25,
                                                          Colors.white),
                                                      Mytext("$mounth", 20,
                                                          Colors.white),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      FittedBox(
                                                        // fit: BoxFit.scaleDown,
                                                        // child: Titre(
                                                        //     '${result['service']['libelle']}kjkjjkjdijdidifjiodjfosdijfosijdfsdjjkjkjk',
                                                        //     15,
                                                        //     Colors.white),
                                                        child: Text(
                                                          "$libelleService",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Mytext(
                                                          '$heure',
                                                          15,
                                                          Colors.white),
                                                      Titre(
                                                          '$prix FCFA',
                                                          15,
                                                          Colors.white),
                                                      // SizedBox(height: 5,),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          child: Mytext(
                                                              '$statut',
                                                              15,
                                                              Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
