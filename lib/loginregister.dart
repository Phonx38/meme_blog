import 'package:flutter/material.dart';
import 'shared/constants.dart';
import 'components/round_btn.dart';
import 'services/auth.dart';
import 'package:meme_blog/shared/loading.dart';
import 'shared/dialogBox.dart';
class LoginRegister extends StatefulWidget {
  LoginRegister({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}


enum FormType
{
  login,
  register
}

class _LoginRegisterState extends State<LoginRegister> {

  DialogBox dialogBox = DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';
  String _password = '';
  bool loading = false;

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }


  void validateAndSubmit() async {

    if(validateAndSave())
    {
      try{
        if(_formType == FormType.login)
        {
          setState(() {
            loading = true;
          });
          String userId = await widget.auth.signInWithEmail(_email, _password);
          dialogBox.information(context, "Success", "Login Successful");
          print('login userid =' + userId );
        }else{
           setState(() {
            loading = true;
          });
          String userId = await widget.auth.signUpWithEmail(_email, _password);
          dialogBox.information(context, "Success", "Account is created successfully.");
          print('Register userid =' + userId );
        }
        widget.onSignedIn();

      }catch(e){
        setState(() {
            loading = false;
          });
        dialogBox.information(context, "Error", e.toString());
        print(e.toString());
        
      }
    }
  }
  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return loading ? Loading():Scaffold(
      resizeToAvoidBottomPadding: false,
      body:Container(
        decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:Alignment.bottomCenter,
            colors: [Colors.purple[600],Colors.pink[300]]
          )),
        child: Container(
          
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      )
      
    );
  }

  List<Widget> createInputs()
  {
    return 
    [
      SizedBox(height: 10.0,),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        validator:validateEmail,
        decoration: textInputDeco,
        onSaved: (val){
          setState(() {
            _email = val;
          });
        },
      ),
      SizedBox(
        height: 20.0,
      ),

      TextFormField(
        obscureText: true,
        validator: (val)=> val.length < 6 ? 'Password should have atleast 6 char.':null,
        decoration:  textInputDeco.copyWith(hintText: 'Enter your password'),
        onSaved: (val){
          setState(() {
            _password = val;
          });
        },

      ),
    ];
  }

  Widget logo(){
    return Hero(
       tag: 'logo',
          child: CircleAvatar(
            radius: 80.0,
            backgroundColor: Colors.grey[200],
            child: Text('Memestar'),
          ),
    );
  }

  List<Widget> createButtons(){
    if(_formType == FormType.login){
      return 
        [
          SizedBox(height: 15.0,),

          RoundedButton(
            onPressed: validateAndSubmit,
            title: 'Log In',
            color: Color.fromRGBO(239,12,95,1),
          ),

          SizedBox(height: 15.0,),
            FlatButton(
              child: Text('Dont have an account yet ? Sign Up !',textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontSize: 14.0),),
              onPressed: moveToRegister,
            ),
        ];
    }
    else{
       return 
        [
          SizedBox(height: 15.0,),

          RoundedButton(
            onPressed: validateAndSubmit,
            title: 'Register',
            color: Color.fromRGBO(239,12,95,1),
          ),

          SizedBox(height: 15.0,),
            FlatButton(
              child: Text('Already have an account ? Sign In !',textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontSize: 14.0),),
              onPressed: moveToLogin,
            ),
        ];
    }
  }
}

String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }