import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:meme_blog/shared/loading.dart';
import 'package:meme_blog/components/round_btn.dart';
import 'package:meme_blog/pages/homepage.dart';

class PhotoUpload extends StatefulWidget {
  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {

  FirebaseUser currentUser;
  bool loading = false;
  File sampleImage;
  final formKey = GlobalKey<FormState>();
  String _myValue;
  String url;

  @override
  void initState(){
  super.initState();
  _loadCurrentUser();
  }

  Future getImage() async {
    var tempImage = await  ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;

    }else{
      return false;
    }
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

  void uploadStatusImage() async {
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child('Post Images');

      var timekey = DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timekey.toString() + '.jpg').putFile(sampleImage);

      var ImageUrl =  await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();
      
      print(" Image Url =" + url);


      goToHomepage();
      saveToDatabase(url);
      

    }
  }

  void goToHomepage(){

    
    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }

  void saveToDatabase(url){
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM,d,y');
    var formatTime  =DateFormat('EEEE, hh:mm aaa');
    
    String date = formatDate.format( dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = 
    {
      "image" :url ,
      "description": _myValue,
      "date": date,
      "time": time, 
      "sender":_email()
    };

    ref.child("Posts").push().set(data);
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading():Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(239,12,95,1) ,
        title:  Text('Photo Upload'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null?Text('Select an Image'): enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child:  Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload(){
    return Container(
      child: Form(
        key: formKey,

        child:Column(
          children: <Widget>[
            Image.file(sampleImage,height: 300.0,width: 660.0,),
            
            TextFormField(
             
              decoration: InputDecoration(
                labelText: 'Description',

              ),
              validator: (val){
                return val.isEmpty ? 'Description is required': null;
              },
              onSaved: (val){
                return _myValue = val;
              },
            ),
            SizedBox(height: 15.0,),

            RoundedButton(
              title: 'Add a new post',

              onPressed:uploadStatusImage,
                
              color: Color.fromRGBO(239,12,95,1),
            )

          ],
        )
      ),
    );
  }

}

