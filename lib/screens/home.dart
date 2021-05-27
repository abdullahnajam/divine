import 'package:divine/model/category.dart';
import 'package:divine/model/recipe.dart';
import 'package:divine/screens/detailView.dart';
import 'package:divine/search_list.dart';
import 'package:divine/values/constants.dart';
import 'package:divine/video/screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../menu_drawer.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category="";
  List<Category> categoryList=[];
  List<Recipe> recipeList=[];

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }

  getCategoryList() async {

    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("category").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Category category = new Category(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['image'],
          );
          setState(() {
            categoryList.add(category);
          });


        }
      }
    });
  }
  getSelectedRecipeList(String id) async {
    List<Recipe> selectedList=[];
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("recipe").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Recipe recipe = new Recipe(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['type'],
            DATA[individualKey]['direction'],
            DATA[individualKey]['thumbnail'],
            DATA[individualKey]['url'],
          );
          if(recipe.type==id)
            selectedList.add(recipe);



        }
      }
    });
    setState(() {
      recipeList=selectedList;
    });
  }
  getRecipeList() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("recipe").once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Recipe recipe = new Recipe(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['type'],
            DATA[individualKey]['direction'],
            DATA[individualKey]['thumbnail'],
            DATA[individualKey]['url'],
          );
          setState(() {
            recipeList.add(recipe);
          });


        }
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Category category=new Category("0", "All Videos", "https://icon-library.com/images/all-icon/all-icon-0.jpg");
    categoryList.add(category);
    getRecipeList();

    getCategoryList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        drawer: MenuDrawer(),
      body: Container(
        child:Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.35,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50)
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu,color: Colors.white,), onPressed: _openDrawer),
                      Text("Divine - Cooking & Baking",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),

                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text("What do you want to cook today?",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SearchList()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 50,
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,color: primaryColor,),
                          SizedBox(width: 10,),
                          Text("Search a recipe",style: TextStyle(color: Colors.grey[600],fontSize: 18),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(),
            SizedBox(height: 30,),
            Expanded(
              child: Container(
                child: Row(
                  children: [

                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                        itemCount: categoryList.length,
                        itemBuilder: (BuildContext context,index){
                          return GestureDetector(
                            onTap: (){
                              if(index==0){
                                getRecipeList();
                              }
                              else{
                                getSelectedRecipeList(categoryList[index].id);
                              }
                              setState(() {
                                category=categoryList[index].name;
                              });
                            },
                            child: Container(
                              height: 70,
                              margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                              child: Image.network(categoryList[index].image),

                              decoration: BoxDecoration(
                                  color: backgroundColorLight,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          );
                        },
                      )
                    ),

                    Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: backgroundColorLight,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40)
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20,top: 20),
                                child: Text(category,style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                                ),),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: recipeList.length,

                                  itemBuilder: (BuildContext context,index){
                                    return GestureDetector(
                                      onTap: ()=>Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: DetailView(recipeList[index]))),
                                      child: Container(
                                        height: 80,
                                        margin: EdgeInsets.only(left: 20,right: 20,bottom: 15),
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(recipeList[index].thumbnail),
                                                    fit: BoxFit.cover
                                                  )
                                                ),
                                              )
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Text(recipeList[index].name,style: TextStyle(fontSize: 16),),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              )
                            ],
                          )
                        )
                    )
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
