import 'package:divine/screens/detailView.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'model/recipe.dart';
class SearchList extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<Recipe> names = new List();
  List<Recipe> filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search Video' );

  _SearchListState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,

      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<Recipe> tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredNames[index].name),
          onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: DetailView(filteredNames[index]))),
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search Video' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }


  void _getNames() async {
    List<Recipe> tempList = new List();
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
            tempList.add(recipe);
          });


        }
        setState(() {
          names = tempList;
          names.shuffle();
          filteredNames = names;
        });
      }
    });



  }


}
