import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/acceuil/first_page.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/modules/login_mogule/login_page.dart';
import 'package:gestion_salon_coiffure/page_view_controll/First.dart';
import 'package:gestion_salon_coiffure/page_view_controll/second.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../acceuil/acceuil.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int Navig = 0;
  @override
  Widget build(BuildContext context) {
    final PageController control = PageController();

    return Scaffold(
      // backgroundColor: Colors.red,
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              print(value);
              setState(() {
                Navig = value;
              });
            },
            controller: control,
            children: [
              MaPremiere(),
              Second(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //           TextButton(

                //             child: Text("Passer$Navig"),
                //           ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      control.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.bounceIn);
                    },
                    child: FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.black,
                    )),
                SmoothPageIndicator(controller: control, count: 2),
                Navig < 1
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          control.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                        ))
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const Login_page()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Colors.yellow, shape: BoxShape.circle),
                          child: Text("OK",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
