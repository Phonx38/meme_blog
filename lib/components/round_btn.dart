import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.color,
    this.title,
    @required this.onPressed

  });

  final Color color;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius:  BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
        child: MaterialButton(
          
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style:TextStyle( fontWeight:FontWeight.bold,fontSize: 16.0,letterSpacing: 1.0,color: Colors.white,fontFamily: 'Montserrat-Medium'),
          ),
        ),
      ),
    );
  }
}
