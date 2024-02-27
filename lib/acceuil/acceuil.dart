import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/acceuil/compte.dart';
import 'package:gestion_salon_coiffure/acceuil/recherche.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gestion_salon_coiffure/promotions/promotion_page.dart';
import 'package:gestion_salon_coiffure/promotions/promotion_provider.dart';

import 'first_page.dart';

class acceuil extends StatefulWidget {
  const acceuil({super.key});

  @override
  State<acceuil> createState() => _acceuilState();
}

class _acceuilState extends State<acceuil> {
  List mespromotions = [];
  Promotion_provider promotionProvider = Promotion_provider();
  Future<void> GetPromotion() async {
    promotionProvider.Get_Promotion().then((value) {
      return setState(() {
        mespromotions = value;
        print(value);
      });
    });
  }

  int _currentindex = 0;
  @override
  void initState() {
    GetPromotion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentindex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: _currentindex,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home,color: Colors.white,),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.search,color: Colors.white,),
            icon: Badge(child: Icon(Icons.search)),
            label: 'Search',
          ),
          NavigationDestination(
             selectedIcon: badges.Badge(
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
              badgeContent: Text(""),
              child: Icon(Icons.notifications,color: Colors.white,),
            ),
            icon: badges.Badge(
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
              badgeContent: Text(""),
              child: Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle,color: Colors.white,),
            icon: Icon(Icons.account_circle),
            label: 'Comptes',
          ),
         
        ],
      ),
      body: _getBody(_currentindex),
    );
  }
}

Widget _getBody(int index) {
  switch (index) {
    case 0:
      return First_page();
    case 1:
      return ExploreScreen();

    case 3:
      return Compte();
    default:
      return Promotion_page();
  }
}

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chats Screen'),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Screen'),
    );
  }
}
