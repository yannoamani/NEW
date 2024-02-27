


import 'package:flutter/material.dart';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/module_reservation/reservation_provider.dart';
import 'package:get/get.dart';

class moncontroller {
  String monheure = "";
  DateTime today = DateTime.now();
  Rx<info_reservation> info_reserv = info_reservation(DateTime.now(), "").obs;
  Rx<Reservation> reserv = Reservation().obs;
  RxBool status = true.obs;
  Map recup = {};
  RxMap Tab_reserv = {}.obs;
  List<dynamic> Lister_reservation = [].obs;
 Map heure = {};

  Future<void> Reserver(BuildContext context) async {
    info_reserv.value.date = today;
    info_reserv.value.heure = monheure;
    await reserv.value.Reserver(info_reserv()).then((value) {
      Tab_reserv.value = value;
    });
    status.value = Tab_reserv['status'];

    if (!status.value) {
      message(context, '${Tab_reserv['message']}', Colors.black);
    } else {
      // Get.back();
      message(context, 'Réservation effectuée avec succès!', Colors.green);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => acceuil()));
    }
    print(Tab_reserv);
  }

  Future Getservice() async {
    return reserv.value.getServices().then((value) => recup = value);
  }

  Future<void> Les_reservations() async {
    await reserv.value
        .GetReservations()
        .then((value) => Lister_reservation = value);
    // print(Lister_reservation);
  }
}
