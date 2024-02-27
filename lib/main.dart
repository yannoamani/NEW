import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/splash_screen/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
     WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("fr_FR", null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
     
      debugShowCheckedModeBanner: false,
      title: 'Beauté express',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  splash_screen(),
      
      

    );
  }
}
