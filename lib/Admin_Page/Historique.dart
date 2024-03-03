import 'package:flutter/material.dart';

class historique extends StatefulWidget {
  const historique({super.key});

  @override
  State<historique> createState() => _historiqueState();
}

class _historiqueState extends State<historique> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            
          )
        ],
      ),
    );
  }
}
