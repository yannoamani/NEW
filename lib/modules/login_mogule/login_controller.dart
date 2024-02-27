// import 'package:flutter/material.dart';
// import 'package:gestion_salon_coiffure/acceuil/acceuil.dart';
// import 'package:gestion_salon_coiffure/modules/login_mogule/login_provider.dart';
// import 'package:gestion_salon_coiffure/splash_screen/model.dart';
// import 'package:get/state_manager.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginController {
//   final LoginProvider provider = LoginProvider();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final RxBool obscure = false.obs;
//   final RxBool charg = false.obs;
//   final RxString message = "".obs;

//   Future<void> setData(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, value);
//   }

//   Future<void> login(BuildContext context) async {
//     final User user = User(
//         email: emailController.value.text,
//         password: passwordController.value.text);

//     await provider.login(user).then((value) {
//       if (value['status']) {
//         setData('token', value['access_token']);
//         setData('id', value['data']['id'].toString());
//         setData('nom', value['data']['nom']);
//         setData('prenom', value['data']['prenom']);
//         setData('email', value['data']['email']);
//         setData('phone', value['data']['phone'].toString());
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => const acceuil()));
//       } else {
//         message.value = value['message'];
//       }
//     });
//   }
// }
// // Ca marche, il y avait un soucis au niveau de l'url
// // Mais quand il se connecte, tu lances un fonction pour récup les services, ça génère une erreur
// // Je vais me coucher demain on va checker
// // amaniyann5500@gmail.com
// // 08125403