import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class noteProvider {
  Future getnotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("notes");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);

      return resultat['data'];
    } catch (e) {
      print("$e");
    }
  }
}
