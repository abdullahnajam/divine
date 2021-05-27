import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:divine/model/ingridents_model.dart';
import 'package:divine/model/recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class DetailView extends StatefulWidget {
  Recipe _recipe;

  DetailView(this._recipe);

  @override
  _DetailViewState createState() => _DetailViewState();
}


class _DetailViewState extends State<DetailView> {
  IconData _iconData=Icons.favorite_border;
  Color _color=Colors.white;
  YoutubePlayerController _controller;
  bool isFavourite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFavouriteFromDatabase();
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(widget._recipe.url);
    print(videoId);
    _controller = YoutubePlayerController(
      initialVideoId: videoId,

    );
  }
  Future<List<Ingredients>> getIngredients() async{
    List<Ingredients> ingredientList=[];
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("recipe").child(widget._recipe.id).child("ingridients").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Ingredients ingredients = new Ingredients(
            individualKey,
            DATA[individualKey]['title'],
            DATA[individualKey]['image'],
            DATA[individualKey]['quantity'].toString(),
          );
          ingredientList.add(ingredients);


        }
      }
    });
    return ingredientList;
  }
  checkFavouriteFromDatabase()async{
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("users").child(user.uid).child("favourites").child(widget._recipe.id).once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        setState(() {
          _iconData=Icons.favorite;
          _color=Colors.orange;
          isFavourite=true;
        });
      }
    });
  }
  checkFavourite(){
    if(isFavourite){
      removeFromFavourites();
    }
    else{
      addToFavourites();
    }
  }
  addToFavourites(){
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("users").child(user.uid).child("favourites").child(widget._recipe.id).set({
      'title': widget._recipe.name,
      'thumbnail': widget._recipe.thumbnail,
      'type': widget._recipe.type

    }).then((value) {
      setState(() {
        _iconData=Icons.favorite;
        _color=Colors.orange;
        isFavourite=true;
      });
    })
        .catchError((error, stackTrace) {
      print("inner: $error");

    });
  }
  removeFromFavourites(){
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("users").child(user.uid).child("favourites").child(widget._recipe.id).remove().then((value) {
      setState(() {
        _iconData=Icons.favorite_border;
        _color=Colors.white;
        isFavourite=false;
      });
    })
        .catchError((error, stackTrace) {
      print("inner: $error");

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              height: MediaQuery.of(context).size.height*0.45,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 60,
                width: double.maxFinite,
                color: Colors.black,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
                      IconButton(icon: Icon(_iconData,color: _color), onPressed: checkFavourite),

                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                ),
                height: MediaQuery.of(context).size.height*0.5,
                child: ListView(
                  children: [
                    Text(
                        widget._recipe.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500

                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Directions",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700

                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget._recipe.direction,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300

                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Ingredients",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700

                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<Ingredients>>(
                      future: getIngredients(),
                      builder: (context,snapshot){
                        if (snapshot.hasData) {
                          if (snapshot.data != null && snapshot.data.length>0) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context,int index){
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image: NetworkImage(snapshot.data[index].image),

                                              )
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(snapshot.data[index].title),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Text(snapshot.data[index].quantity,textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          else {
                            return new Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 100),
                                  child: Text("This recipe doesnot have any ingredients")
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
              ),
            )
          ],
        ),
      )

    );
  }
}
