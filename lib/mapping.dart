import 'package:flutter/material.dart';
import 'package:meme_blog/services/auth.dart';
import 'pages/homepage.dart';

import 'loginregister.dart';

class Mapping extends StatefulWidget {
  final AuthImplementation auth;

  Mapping({
    this.auth,
  });
  @override
  _MappingState createState() => _MappingState();
}

enum AuthStatus
{
  notSignedIn,
  signedIn
}

class _MappingState extends State<Mapping> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState(){
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId){
        setState(() {
          authStatus = firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        });
    });
  }

  void _signedIn()
  {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut()
  {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus)
    {
      case AuthStatus.notSignedIn:
      return LoginRegister(
        auth:widget.auth,
        onSignedIn : _signedIn,
      );

       case AuthStatus.signedIn:
      return HomePage  (
        auth:widget.auth,
        onSignedOut : _signOut,
      );
    }
    return  null;
  }
}