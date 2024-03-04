import 'dart:convert';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Promotion_provider {
  // ignore: non_constant_identifier_names
  Future get_Promotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("promotions");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);
     
        return resultat['data'];
      
    } catch (e) {
      print(e);
    }
  }

  Future getCAllCoupons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("couponsClient");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);

      return resultat['data'];
    } catch (e) {
      print(e);
    }
  }

  Future getCouponsActif() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("couponsClientActif");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);

      return resultat['data'];
    } catch (e) {}
  }
}
