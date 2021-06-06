import 'package:divine/about.dart';
import 'package:divine/favourites.dart';
import 'package:divine/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'values/constants.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomBar>{

  int _currentIndex = 0;

  List<Widget> _children=[];



  @override
  void initState() {
    super.initState();
    _children = [
      HomePage(),
      Favourites(),
      AboutUs()


    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

  }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor:Color(0xffffce87),
        selectedItemColor: primaryColor,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home_outlined),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text("Favourite")
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person_outline),
              title: Text("About Us")
          ),


        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
