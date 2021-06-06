import 'package:divine/values/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu_drawer.dart';
class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
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
                      child: Text("Contact Us",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200],width: 0.5),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.email_outlined),
                          title: Text("info@divinecookingandbaking.com"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Text("Social Media",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),

                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200],width: 0.5),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.network("https://img.icons8.com/office/16/000000/instagram-new.png",width: 20,height: 20,),
                              title: Text("DivineCookingAndBaking_"),
                            ),
                            ListTile(
                              leading: Image.network("https://img.icons8.com/officel/16/000000/youtube-play.png",width: 20,height: 20,),
                              title: Text("DivineCookingBaking"),
                            ),
                            ListTile(
                              leading: Image.network("https://img.icons8.com/ultraviolet/40/000000/facebook-new.png",width: 20,height: 20,),
                              title: Text("DivineCookingAndBaking"),
                            ),
                          ],
                        )
                      ),


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
