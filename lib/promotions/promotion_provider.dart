import 'dart:convert';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Promotion_provider {
  Future Get_Promotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("promotions");
      final uri = Uri.parse(url);
      final Response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(Response.body);

      return resultat['data'];
    } catch (e) {
      print(e);
    }
  }
}
