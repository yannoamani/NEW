import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/constants.dart';
import 'package:gestion_salon_coiffure/splash_screen/model.dart';

class TesterUser {
  String Nom;
  String Prenom;
  Bool charg ;

  TesterUser(this.Nom, this.Prenom,this.charg);
}

class LoginProvider {
  Future<dynamic> login(BuildContext context, TesterUser lib) async {
    if (lib.Nom.isEmpty) {
      return ' Tu es connecter à internet';
    } else {
      if (lib.Nom.isNotEmpty || lib.Prenom.isNotEmpty) {
        return Text('data');
      }
    }
  }
}
