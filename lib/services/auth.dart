
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meme_blog/models/userModel.dart';

abstract class AuthImplementation{
  Future<String> signUpWithEmail(String email,String password);
  Future<String> signInWithEmail(String email,String password);
  Future<void> signOut();
  Future<String> getCurrentUser();
}
class AuthService implements AuthImplementation{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User _userFromFirebaseUser(FirebaseUser user){
  //   return user != null ? User(uid : user.uid): null;
  // }

  // Stream<User> get user{
  //   return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  // }


  Future<String> signUpWithEmail(String email,String password) async {
    
      AuthResult result = await _auth.createUserWithEmailAndPassword(email:  email,password: password);
      FirebaseUser user = result.user;
      return user.uid;

  }

  Future<String> signInWithEmail(String email,String password) async {

      AuthResult result = await _auth.signInWithEmailAndPassword(email: email,password: password);
      FirebaseUser user = result.user;
      return user.uid;

  }

  Future<void> signOut()async {

      await _auth.signOut();

  }
  Future<String> getCurrentUser() async {
    FirebaseUser user= await _auth.currentUser();
    return user.uid;
    
  }
}