import 'dart:ui';
import 'package:divine/values/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu_drawer.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    void _openDrawer () {
      _drawerKey.currentState.openDrawer();
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _drawerKey,
        drawer: MenuDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                  ),

                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.menu,color: primaryColor,)
                      ),
                      onTap: ()=>_openDrawer(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("About Us",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        child:
                        Image.asset('assets/images/logo.png',width: 200,height: 200,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Text('Divine - Cooking & Baking',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
                      ),

                      SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('Divine Cooking & Baking is here to provide you recipes and help you cook delicious food with less stress and more joy. Will help you with a variety of recipes ranging from Pakistani, Indian & Continental food, Veg & Non , hot and cold drinks etc.We also offer recipes and cooking advice.'),
                      ),

                      SizedBox(height: 10,),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xfffe734c),
                          ),
                          padding: EdgeInsets.all(10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Contact Us",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,color: Colors.white),
                                  SizedBox(width: 10,),
                                  Text("info@divinecookingandbaking.com",style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              
                              SizedBox(height: 5,),

                            ],
                          )
                      )

                    ],
                  ),
                ),
              ),

            ],
          ),
        )

    );
  }
}
