import 'package:flutter/material.dart';

import 'package:meme_blog/services/auth.dart';
import 'mapping.dart';
import 'services/auth.dart';




void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memer',
      
      theme: ThemeData(fontFamily: 'Montserrat-Medium',primarySwatch: Colors.purple),
      home: Mapping(auth: AuthService(),),
    );
  }
}