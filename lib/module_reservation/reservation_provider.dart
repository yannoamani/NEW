import 'dart:convert';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class info_reservation {
  DateTime? date;
  String? heure;

  info_reservation(this.date, this.heure);
}

class Reservation {
  Future<dynamic> Reserver(info_reservation info) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final url = monurl("reservations");
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        body: jsonEncode({
          'service_id': prefs.getInt('id_service'),
          'user_id': prefs.getInt('id'),
          'heure': info.heure,
          'date': info.date?.toIso8601String(),
        }),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer ${prefs.getString('token')}",
        },
      );
      final resultat = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return resultat;
      } else {
        print("Erreur de réservation: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de la réservation: ${e}");
      return null;
    }
  }

  // Le future qui nous permettra de d'afficher les informations sur ce service en questions
  Future<dynamic> getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final Url = monurl("services/${prefs.get('id_service')}");
    final uri = Uri.parse(Url);
    final response =
        await http.get(uri, headers: header(" ${prefs.getString('token')}"));
    final decode = jsonDecode(response.body);
    return decode['data'];
  }

  // Le future qui nous permet de lister les reservations
  Future GetReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("reservations");
      final uri = Uri.parse(url);
      final Response =
          await http.get(uri, headers: header(" ${prefs.getString('token')}"));
      final resultat = jsonDecode(Response.body);
      return resultat['data'];
    } catch (e) {
      print(e);
    }
  }
}
