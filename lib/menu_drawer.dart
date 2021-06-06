import 'package:divine/about.dart';
import 'package:divine/auth/login.dart';
import 'package:divine/contact_us.dart';
import 'package:divine/favourites.dart';
import 'package:divine/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:divine/data/img.dart';
import 'package:divine/data/my_colors.dart';
import 'package:divine/widget/my_text.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {


  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }




  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => HomePage()));
            },
            child: Container(
              alignment: Alignment.center,
              child: Image.asset("assets/images/logo.png",height: 150,),
            ),
          ),

          InkWell(onTap: (){
            Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => Favourites()));
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.favorite_border, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Favourites", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(onTap: (){
            Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) => ContactUs()));
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.contact_mail_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Contact Us", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(onTap: (){
            Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) => AboutUs()));
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.person_outline, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("About Us", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(height: 10),
          InkWell(onTap: () async{
            await FirebaseAuth.instance.signOut().whenComplete((){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (BuildContext context) => Login()));
            });
          },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.power_settings_new, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("Logout", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text("Social Media",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
            
          ),
          Container(
            height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Image.network("https://img.icons8.com/office/16/000000/instagram-new.png",width: 20,height: 20,),
                Container(width: 20),
                Expanded(child: Text("DivineCookingAndBaking_", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
              ],
            ),
          ),
          Container(
            height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Image.network("https://img.icons8.com/officel/16/000000/youtube-play.png",width: 20,height: 20,),
                Container(width: 20),
                Expanded(child: Text("DivineCookingBaking", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
              ],
            ),
          ),
          Container(
            height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Image.network("https://img.icons8.com/ultraviolet/40/000000/facebook-new.png",width: 20,height: 20,),
                Container(width: 20),
                Expanded(child: Text("DivineCookingAndBaking", style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
