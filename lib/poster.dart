
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PosterPage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _PosterPageState createState() => new _PosterPageState();
}

class _PosterPageState extends State<PosterPage> {

  final TextEditingController _filter = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List pathname =new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Map<String, dynamic> formData;
  List<String> searchhints = [
    'The Birds',
    'Rear Window',
    'Family Pot',
    'Rear Window',
  ];

  Widget _appBarTitle = new Text( 'Search Example' );

  _PosterPageState() {
    formData = {
      'Search': 'The Birds',
    };
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
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      int lengthText = _searchText.length;
      if (lengthText >= 3) {
        for (int i = 0; i < filteredNames.length; i++) {
          if (filteredNames[i].toLowerCase().contains(
              _searchText.toLowerCase())) {
            tempList.add(filteredNames[i]);
          }
        }
        filteredNames = tempList;
      }
    }

    return Scaffold(
      backgroundColor:Colors.black87,
      appBar: _buildBar(context),
      body: OrientationBuilder(
        builder: (context, orientation) {

          return GridView.count(
            // Create a grid with 2 columns in portrait mode, or 3 columns in
            // landscape mode.
            crossAxisCount: orientation == Orientation.portrait ? 3: 5,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(names == null ? 0 : filteredNames.length, (index) {
              var syncpath='assets/slices/'+pathname[index];

              final assetImage = Image.asset('assets/slices/'+pathname[index],

                fit: BoxFit.fill,
                color: Colors.blueAccent.withOpacity(1.0),
                colorBlendMode: BlendMode.softLight,
                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                  return  Image.asset('assets/slices/placeholder_for_missing_posters.png',
                    fit: BoxFit.fill,
                    color: Colors.blueAccent.withOpacity(1.0),
                    colorBlendMode: BlendMode.softLight,
                    width:120,
                    height: 100,
                  );
                },
                width:120,
                height: 100,);
              return IntrinsicHeight(
                child:Column(
                  children:[
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 05),
                      //   height: 120.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      child: assetImage,
                    ),
                    Container(
                        height: 20,
                        child: Text("${filteredNames[index]}",style: TextStyle(color: Colors.white60),)),
                  ],
                ),
                // SizedBox(height: 10.0,),
              );



            }),
          );
        },
      ),

      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black38,
      elevation: 1.0,
      centerTitle: true,
      title: _appBarTitle,

      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );

  }


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new  TextField(
          style: TextStyle(color: Colors.white),
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search,color: Colors.white,),
              hintText: 'Search...',
              helperText: 'hello',
              fillColor: Colors.white10, filled: true
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search Example' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    final String response1 = await rootBundle.loadString('assets/api/contentlisting-page1.json');
    final data1 = await json.decode(response1);
    final String response2 = await rootBundle.loadString('assets/api/contentlisting-page2.json');
    final data2 = await json.decode(response2);
    final String response3 = await rootBundle.loadString('assets/api/contentlisting-page3.json');
    final data3 = await json.decode(response3);

    print(data1['page']['content-items']['content'][0]['name']);
    List tempList = new List();
    List tempList1=new List();
    for (int i = 0; i < data1['page']['content-items']['content'].length; i++) {
      tempList.add(data1['page']['content-items']['content'][i]['name']);
      tempList1.add(data1['page']['content-items']['content'][i]['poster-image']);
    }
    for (int i = 0; i < data2['page']['content-items']['content'].length; i++) {
      tempList.add(data2['page']['content-items']['content'][i]['name']);
      tempList1.add(data2['page']['content-items']['content'][i]['poster-image']);
    }
    for (int i = 0; i < data3['page']['content-items']['content'].length; i++) {
      tempList.add(data3['page']['content-items']['content'][i]['name']);
      tempList1.add(data3['page']['content-items']['content'][i]['poster-image']);
    }

    print(tempList.length);
    setState(() {
      names = tempList;
      pathname=tempList1;
      // names.shuffle();
      filteredNames = names;

    });
  }

}
