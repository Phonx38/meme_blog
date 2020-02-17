import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meme_blog/pages/photoUpload.dart';
import 'package:meme_blog/services/auth.dart';
import 'package:meme_blog/pages/profile.dart';

import 'package:meme_blog/models/Posts.dart';


class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  HomePage({
    this.auth,
    this.onSignedOut
  });
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 
 FirebaseUser currentUser;
 List<Posts> postsList = [];


@override
void initState(){
  super.initState();
  _loadCurrentUser();

  DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

  postsRef.once().then((DataSnapshot snap){
    var KEYS = snap.value.keys;
    var DATA = snap.value;

    postsList.clear();


    for(var individualKey in KEYS)
    {
      Posts posts = new Posts(
        DATA[individualKey]['image'],
        DATA[individualKey]['description'],
        DATA[individualKey]['date'],
        DATA[individualKey]['time'],
        DATA[individualKey]['sender'],
        );

        postsList.add(posts);

        setState(() {
          print('Length:  ${postsList.length}');
        });
      
    }
  });
}

void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }

void _logoutUser()async {

  try
  { 
    await widget.auth.signOut();
    widget.onSignedOut();
  }
  catch(e)
  {
    print(e.toString());

  }
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('MemeStar'),
        backgroundColor:  Color.fromRGBO(239,12,95,1),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: _logoutUser,
            child: Text('logout',style: TextStyle(color: Colors.white),),
          )
        ],
        
      ),
      body: Container(
        child:StreamBuilder<Object>(
          stream: FirebaseDatabase.instance.reference().child("Posts").onChildChanged,
          builder: (BuildContext context, snapshot) {
             
            return new ListView.builder(
              shrinkWrap: true,
              itemCount: postsList.length,
              itemBuilder: (_, index){
                return PostsUI(postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time,postsList[index].sender);
              },
            );
          }
        ),
        
      ),
      bottomNavigationBar: new BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          margin: EdgeInsets.only(left:20,right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile()));
                },
                icon:Icon(Icons.person),
                iconSize: 30.0,
                color: Color.fromRGBO(239,12,95,1),
              ),
              
              IconButton(
                onPressed: (){},
                icon:Icon(Icons.settings),
                iconSize: 30.0,
                color: Color.fromRGBO(239,12,95,1),
              ),
              
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        mini: true,
        elevation: 0.0,
      backgroundColor:  Color.fromRGBO(239,12,95,1),
      child: Icon(Icons.add,color: Colors.white), onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoUpload()));
      },
    ),
    floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget PostsUI(String image,String description ,String date,String time,String sender){
    
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(14.0),

      child: Container(
        padding: EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  sender ?? 'sender',
                  style: TextStyle(color: Colors.purple[300],fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  
                ),
              ],
           ),
           SizedBox(height: 5.0,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,

                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                  
                ),
                
                
              ],
            ),

            SizedBox(height: 10.0,),

            Image.network(image,fit:BoxFit.cover),

             SizedBox(height: 10.0,),
            
            Text(
                  description,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,
                  
                ),
            

          ],

        ),
      ),
    );
  
  }
}