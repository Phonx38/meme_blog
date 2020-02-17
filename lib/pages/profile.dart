import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'tabbarview.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
       backgroundColor:Color.fromRGBO(239,12,95,1) ,
        title:  Text('My Profile'),
        centerTitle: true,
      ),
      body: enableProfile(),
    );
  }

  Widget enableProfile(){
    return Container(
      height:300.0,
      child: Form(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.purple[300],
              child: CircleAvatar(
                
                radius: 60.0,
                backgroundColor: Colors.grey[200],
                child:Image.asset('imageUrl',fit: BoxFit.cover,),
              ),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
             ] 
           )
            


          ],
        ),
      ),
    );
  }
}