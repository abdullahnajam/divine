import 'package:divine/model/favourite.dart';
import 'package:divine/values/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  Future<List<FavouriteModel>> getRecipeList() async {
    List<FavouriteModel> favour=[];
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("users").child(user.uid).child("favourites").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          FavouriteModel recipe = new FavouriteModel(
            individualKey,
            DATA[individualKey]['title'],
            DATA[individualKey]['type'],
            DATA[individualKey]['thumbnail'],
          );
          setState(() {
            favour.add(recipe);
          });


        }
      }
    });
    return favour;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                    child: Icon(Icons.arrow_back,color: primaryColor,),
                  ),
                  onTap: ()=>Navigator.pop(context),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Favorites",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),


              ],
            ),
          ),
          SizedBox(height: 20,),
          FutureBuilder<List<FavouriteModel>>(
            future: getRecipeList(),
            builder: (context,snapshot){
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data.length>0) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                      return ListTile(
                        leading: Image.network(snapshot.data[index].thumbnail),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].type),
                      );
                    },
                  );
                }
                else {
                  return new Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Text("You don't have any favorites")
                    ),
                  );
                }
              }
              else if (snapshot.hasError) {
                return Text('Error : ${snapshot.error}');
              } else {
                return new Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),

        ],
      ),
    );
  }
}
