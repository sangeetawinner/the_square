import 'package:flutter/material.dart';
import 'package:the_square/poster.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Api Filter list Demo',
      theme: new ThemeData(
        //primarySwatch: MaterialColor.,
      ),
      home: new PosterPage(),
    );
  }
}
