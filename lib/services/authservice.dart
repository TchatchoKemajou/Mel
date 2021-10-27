import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
FirebaseAuth auth = FirebaseAuth.instance;


Future<User> get user async{
  //final  user = await auth.currentUser;
  if (auth.currentUser.uid != null) {
    final User user = await auth.currentUser;
  }
}

Future<bool> Signup(String email, String password) async{
  try{
    final result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    if(result != null) return true;
    return false;
  }catch(e){
    return false;
  }
}

Future<bool> Signin(String email, String password) async{
  try {
    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    if(result.user != null) return true;
    return false;
    return true;
  }catch(e){
    return false;
  }
}


Future<bool> Signout() async{
  try{
    await auth.signOut();
    return true;
  }catch(e){
    return false;
  }
}
}